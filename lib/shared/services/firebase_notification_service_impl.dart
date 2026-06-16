import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../features/home/presentation/pages/home_state.dart';
import '../shared.dart';
import 'firebase_options.dart';

/// Concrete implementation of INotificationService using Firebase Cloud Messaging (FCM)
/// and flutter_local_notifications.
class FirebaseNotificationServiceImpl implements INotificationService {
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
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ).timeout(const Duration(seconds: 3));
      }
      _isFirebaseInitialized = true;
      appLogger.i('FirebaseNotificationService: Firebase initialized successfully.');
    } catch (e) {
      appLogger.w(
        'FirebaseNotificationService: Firebase initialization failed or timed out. '
        'Push notifications will fall back to mock/disabled mode. Error: $e',
      );
      _isFirebaseInitialized = false;
    }

    // Initialize Local Notifications regardless of Firebase state
    try {
      await _initLocalNotifications().timeout(const Duration(seconds: 2));
    } catch (e) {
      appLogger.w(
        'FirebaseNotificationService: Local notification initialization failed or timed out. Error: $e',
      );
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

      // 3. Configure iOS foreground presentation settings
      await _fcm
          .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true)
          .timeout(const Duration(seconds: 2));

      // 4. Listen to foreground FCM messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Discard if notifications are disabled in settings
        if (!SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) return;

        final payload = _convertMessage(message);
        _messageReceivedController.add(payload);

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
        _handleNotificationNavigation(payload);
      });

      // 6. Handle terminated startup click
      final initialMessage = await _fcm.getInitialMessage().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          appLogger.w('FirebaseNotificationService: getInitialMessage timed out.');
          return null;
        },
      );
      if (initialMessage != null) {
        // Discard if notifications are disabled in settings
        if (SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) {
          final payload = _convertMessage(initialMessage);
          _messageOpenedController.add(payload);
          _handleNotificationNavigation(payload);
        }
      }

      // 7. Request notification permission (required for APNs token on iOS before topic subscription)
      await requestPermission();

      // 8. Sync subscription to the version updates topic based on settings
      final isEnabled = SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true);
      if (isEnabled) {
        await subscribeToTopic(AppConstants.versionUpdatesTopic);
      } else {
        await unsubscribeFromTopic(AppConstants.versionUpdatesTopic);
      }
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to setup FCM handlers: $e');
    }
  }

  /// Unified handler for notification click navigation routing.
  /// Called from both terminated launch (getInitialMessage) and background wakeup (onMessageOpenedApp).
  void _handleNotificationNavigation(NotificationPayload payload) {
    final data = payload.data;

    // Bring HomePage back to the front by popping sub-routes (e.g. SettingsPage)
    AppNavConfig.navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == Routes.home || route.isFirst;
    });

    // Check for tab redirection
    if (data.containsKey('tab')) {
      final tabStr = data['tab'] as String;
      if (tabStr == 'settings') {
        // Dispatch a sticky event to handle Settings page navigation inside HomeViewModel
        eventBus.fire(
          const CommonEvent<String>(
            AppConstants.routeChangedEvent,
            data: Routes.settings,
            sticky: true,
            autoClear: true,
          ),
        );
      } else {
        HomeTab? targetTab;
        switch (tabStr) {
          case 'overview':
            targetTab = HomeTab.overview;
            break;
          case 'aboutMe':
            targetTab = HomeTab.aboutMe;
            break;
          case 'projects':
            targetTab = HomeTab.projects;
            break;
          case 'architecture':
            targetTab = HomeTab.architecture;
            break;
        }

        if (targetTab != null) {
          eventBus.fire(CommonEvent<HomeTab>(AppConstants.tabChangedEvent, data: targetTab));
        }
      }
    }

    // Check for project deep link
    if (data.containsKey('projectId')) {
      final projectId = data['projectId'] as String;
      eventBus.fire(const CommonEvent<HomeTab>(AppConstants.tabChangedEvent, data: HomeTab.projects));
      CommonToast.show('Deep Link Triggered: Project ID $projectId');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle local notification click
        final payloadData = response.payload;
        if (payloadData != null) {
          // Typically we would parse json from payload string
          appLogger.i('FirebaseNotificationService: Local notification click payload: $payloadData');
        }
      },
    );
  }

  @override
  Future<bool> requestPermission() async {
    if (!_isFirebaseInitialized) return false;
    try {
      final settings = await _fcm.requestPermission(alert: true, badge: true, sound: true);
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
      return await _fcm.getToken();
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
      await _fcm
          .subscribeToTopic(topic)
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () {
              appLogger.w('FirebaseNotificationService: subscribeToTopic($topic) timed out.');
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
      await _fcm
          .unsubscribeFromTopic(topic)
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () {
              appLogger.w('FirebaseNotificationService: unsubscribeFromTopic($topic) timed out.');
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
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data.toString(),
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
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: payload.data.toString(),
    );
  }
}

final notificationService = FirebaseNotificationServiceImpl();
