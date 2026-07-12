import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listen_core/core.dart';

import '../../shared.dart';
import 'firebase_options.dart';

/// Concrete implementation of INotificationService using Firebase Cloud Messaging (FCM)
/// and flutter_local_notifications.
class FirebaseNotificationServiceImpl implements INotificationService {
  /// Timeout for Firebase core initialization.
  static const Duration _kInitTimeout = Duration(seconds: 10);

  /// Timeout for local configuration calls (foreground options, initial message query).
  static const Duration _kConfigTimeout = Duration(seconds: 5);

  /// Timeout for FCM network operations (getToken, subscribe/unsubscribe topic).
  static const Duration _kNetworkTimeout = Duration(seconds: 10);

  /// Timeout for system permission dialog (user interaction required).
  static const Duration _kPermissionTimeout = Duration(seconds: 5);

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  final StreamController<NotificationPayload> _messageReceivedController =
      StreamController<NotificationPayload>.broadcast();
  final StreamController<NotificationPayload> _messageOpenedController =
      StreamController<NotificationPayload>.broadcast();

  bool _isFirebaseInitialized = false;

  @override
  Future<void> initialize() async {
    try {
      // 1. Initialize Firebase Core
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).timeout(
          _kInitTimeout,
          onTimeout: () {
            appLogger.e('FirebaseNotificationService: Firebase.initializeApp timed out after $_kInitTimeout');
            throw TimeoutException('Firebase.initializeApp', _kInitTimeout);
          },
        );
      }
      _isFirebaseInitialized = true;
      appLogger.i('FirebaseNotificationService: Firebase initialized successfully.');
    } catch (e) {
      appLogger.w(
        'FirebaseNotificationService: Firebase initialization failed. '
        'Push notifications will fall back to mock/disabled mode. Error: $e',
      );
      _isFirebaseInitialized = false;
    }

    // Initialize Local Notifications regardless of Firebase state
    try {
      await _initLocalNotifications();
      appLogger.i('FirebaseNotificationService: initLocalNotifications successfully.');
    } catch (e) {
      appLogger.w('FirebaseNotificationService: Local notification initialization failed. Error: $e');
    }

    if (!_isFirebaseInitialized) return;

    try {
      // 2. Configure Android high-importance channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        AppConstants.notificationChannelId,
        AppConstants.notificationChannelName,
        description: AppConstants.notificationChannelDescription,
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      appLogger.i('FirebaseNotificationService: createNotificationChannel successfully.');

      // 3. Configure iOS foreground presentation settings
      await _fcm
          .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true)
          .timeout(
            _kConfigTimeout,
            onTimeout: () {
              appLogger.e(
                'FirebaseNotificationService: setForegroundNotificationPresentationOptions timed out after $_kConfigTimeout',
              );
              throw TimeoutException('setForegroundNotificationPresentationOptions', _kConfigTimeout);
            },
          );
      appLogger.i('FirebaseNotificationService: setForegroundNotificationPresentationOptions successfully.');

      // 4. Listen to foreground FCM messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Discard if notifications are disabled in settings
        if (!SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) return;

        final payload = _convertMessage(message);
        _messageReceivedController.add(payload);
        appLogger.i('FirebaseNotificationService: onMessage=$payload');

        // Show local banner for Android in foreground
        if (message.notification != null) {
          _showLocalNotification(message, channel);
        }
      });

      // 5. Listen to background click wakeup events
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Discard if notifications are disabled in settings
        if (!SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) return;

        final payload = _convertMessage(message);
        _messageOpenedController.add(payload);
        appLogger.i('FirebaseNotificationService: onMessageOpenedApp=$payload');
        _handleNotificationNavigation(payload);
      });

      // 6. Handle terminated startup click
      final initialMessage = await _fcm.getInitialMessage().timeout(
        _kConfigTimeout,
        onTimeout: () {
          appLogger.e('FirebaseNotificationService: getInitialMessage timed out after $_kConfigTimeout');
          return null;
        },
      );
      appLogger.i('FirebaseNotificationService: getInitialMessage=$initialMessage');
      if (initialMessage != null) {
        // Discard if notifications are disabled in settings
        if (SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) {
          final payload = _convertMessage(initialMessage);
          _messageOpenedController.add(payload);
          _handleNotificationNavigation(payload);
        }
      }

      // 7. Sync subscription to the version updates topic based on settings
      final isEnabled = SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true);
      appLogger.i('FirebaseNotificationService: subscribeToTopic=$isEnabled');
      if (isEnabled) {
        await subscribeToTopic(AppConstants.versionUpdatesTopic).timeout(
          _kNetworkTimeout,
          onTimeout: () {
            appLogger.e(
              'FirebaseNotificationService: subscribeToTopic timed out during initialize after $_kNetworkTimeout',
            );
          },
        );
      } else {
        await unsubscribeFromTopic(AppConstants.versionUpdatesTopic).timeout(
          _kNetworkTimeout,
          onTimeout: () {
            appLogger.e(
              'FirebaseNotificationService: unsubscribeFromTopic timed out during initialize after $_kNetworkTimeout',
            );
          },
        );
      }
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to setup FCM handlers: $e');
    }
  }

  /// Unified handler for notification click navigation routing.
  /// Called from both terminated launch (getInitialMessage) and background wakeup (onMessageOpenedApp).
  void _handleNotificationNavigation(NotificationPayload payload) {
    appLogger.i('FirebaseNotificationService: _handleNotificationNavigation=$payload');
    final data = payload.data;

    // Bring HomePage back to the front by popping sub-routes (e.g. SettingsPage)
    AppNavConfig.navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == Routes.home || route.isFirst;
    });

    // Check for direct deep link redirection
    if (data.containsKey(AppConstants.notificationParamLink)) {
      final linkStr = data[AppConstants.notificationParamLink] as String;
      final uri = Uri.tryParse(linkStr);
      if (uri != null) {
        eventBus.fire(
          CommonEvent<Uri>(
            DeepLinkManager.deepLinkEventKey,
            data: uri,
            sticky: true,
            autoClear: true,
          ),
        );
        return;
      }
    }
  }

  Future<void> _initLocalNotifications() async {
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(AppConstants.defaultNotificationIcon),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle local notification click
        final payloadData = response.payload;
        if (payloadData != null) {
          try {
            final decoded = jsonDecode(payloadData) as Map<String, dynamic>;
            final title = decoded['title'] as String? ?? '';
            final body = decoded['body'] as String? ?? '';
            final data = Map<String, String>.from((decoded['data'] as Map?) ?? {});
            final payload = NotificationPayload(title: title, body: body, data: data);

            _messageOpenedController.add(payload);
            _handleNotificationNavigation(payload);
          } catch (e) {
            appLogger.e('FirebaseNotificationService: Failed to parse local notification click payload: $e');
          }
        }
      },
    );
  }

  @override
  Future<bool> requestPermission() async {
    if (!_isFirebaseInitialized) return false;
    try {
      final settings = await _fcm
          .requestPermission(alert: true, badge: true, sound: true)
          .timeout(
            _kPermissionTimeout,
            onTimeout: () {
              appLogger.e(
                'FirebaseNotificationService: requestPermission timed out after $_kPermissionTimeout',
              );
              throw TimeoutException('requestPermission', _kPermissionTimeout);
            },
          );
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      appLogger.w('FirebaseNotificationService: Failed to request push permission: $e');
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    if (!_isFirebaseInitialized) return null;
    try {
      return await _fcm.getToken().timeout(
        _kNetworkTimeout,
        onTimeout: () {
          appLogger.e('FirebaseNotificationService: getToken timed out after $_kNetworkTimeout');
          return null;
        },
      );
    } catch (e) {
      appLogger.w('FirebaseNotificationService: Failed to get push token: $e');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh {
    if (!_isFirebaseInitialized) return const Stream.empty();
    return _fcm.onTokenRefresh;
  }

  @override
  Stream<NotificationPayload> get onMessageReceived => _messageReceivedController.stream;

  @override
  Stream<NotificationPayload> get onMessageOpenedApp => _messageOpenedController.stream;

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (!_isFirebaseInitialized) return;
    try {
      appLogger.i('FirebaseNotificationService: subscribeToTopic start...');
      await _fcm
          .subscribeToTopic(topic)
          .timeout(
            _kNetworkTimeout,
            onTimeout: () {
              appLogger.e(
                'FirebaseNotificationService: subscribeToTopic("$topic") timed out after $_kNetworkTimeout',
              );
              throw TimeoutException('subscribeToTopic', _kNetworkTimeout);
            },
          );
      appLogger.i('FirebaseNotificationService: Subscribed to topic "$topic".');
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to subscribe to topic "$topic": $e');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isFirebaseInitialized) return;
    try {
      appLogger.i('FirebaseNotificationService: unsubscribeFromTopic start...');
      await _fcm
          .unsubscribeFromTopic(topic)
          .timeout(
            _kNetworkTimeout,
            onTimeout: () {
              appLogger.e(
                'FirebaseNotificationService: unsubscribeFromTopic("$topic") timed out after $_kNetworkTimeout',
              );
              throw TimeoutException('unsubscribeFromTopic', _kNetworkTimeout);
            },
          );
      appLogger.i('FirebaseNotificationService: Unsubscribed from topic "$topic".');
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to unsubscribe from topic "$topic": $e');
    }
  }

  // --- Helper methods ---

  NotificationPayload _convertMessage(RemoteMessage message) {
    return NotificationPayload(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      data: message.data,
    );
  }

  void _showLocalNotification(RemoteMessage message, AndroidNotificationChannel channel) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: AppConstants.defaultNotificationIcon,
        ),
      ),
      payload: jsonEncode({
        'title': notification.title ?? '',
        'body': notification.body ?? '',
        'data': message.data,
      }),
    );
  }

  // --- Simulation helper (Only used in Developer settings simulator) ---

  /// Simulates receiving a notification in the foreground
  void simulateMessageReceived(NotificationPayload payload) {
    // Discard if notifications are disabled in settings
    if (!SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) return;

    _messageReceivedController.add(payload);
    // Show a local notification banner
    _localNotifications.show(
      id: payload.hashCode,
      title: payload.title,
      body: payload.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.notificationChannelId,
          AppConstants.notificationChannelName,
          channelDescription: AppConstants.notificationChannelDescription,
          icon: AppConstants.defaultNotificationIcon,
        ),
      ),
      payload: jsonEncode({'title': payload.title, 'body': payload.body, 'data': payload.data}),
    );
  }
}

INotificationService notificationService = FirebaseNotificationServiceImpl();
