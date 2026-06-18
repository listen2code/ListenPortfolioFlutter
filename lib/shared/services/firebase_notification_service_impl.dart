import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:listen_core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../../features/home/presentation/pages/home_state.dart';
import '../shared.dart';
import 'firebase_options.dart';

const MethodChannel _nativeLogChannel = MethodChannel('com.listen/native_logging');

Future<void> _nativeLog(String tag, String message, [Object? error, StackTrace? st]) async {
  final time = DateTime.now().toIso8601String();
  var text = '[$time] $tag: $message';
  if (error != null) text += '\nError: $error';
  if (st != null) text += '\nStack: $st';
  // Console output always
  try {
    // keep console prints for debug builds
    // ignore: avoid_print
    print(text);
  } catch (_) {}

  // Try to send to native log via MethodChannel, but skip on web and swallow any exceptions.
  if (!kIsWeb) {
    try {
      await _nativeLogChannel.invokeMethod('nativeLog', {'tag': tag, 'message': text});
    } catch (_) {
      // ignore errors from native logging - must not affect initialization
    }
  }
}

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
    appLogger.i('FirebaseNotificationService: initialize() - start');
    await _nativeLog('LISTEN_NATIVE', 'initialize START');

    // 1. Initialize Firebase Core
    try {
      appLogger.d('FirebaseNotificationService: initialize() - initializing Firebase Core...');
      if (Firebase.apps.isEmpty) {
        appLogger.d(
          'FirebaseNotificationService: initialize() - Firebase.apps is empty, calling Firebase.initializeApp',
        );
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        await _nativeLog('LISTEN_NATIVE', 'Firebase.initializeApp DONE');
      } else {
        appLogger.d(
          'FirebaseNotificationService: initialize() - Firebase.apps is not empty, skipping Firebase.initializeApp',
        );
      }
      _isFirebaseInitialized = true;
      appLogger.i('FirebaseNotificationService: Firebase initialized successfully.');
      await _nativeLog('LISTEN_NATIVE', 'Firebase initialized successfully');
    } catch (e, stackTrace) {
      appLogger.w(
        'FirebaseNotificationService: Firebase initialization failed. '
        'Push notifications will fall back to mock/disabled mode. Error: $e',
        error: e,
        stackTrace: stackTrace,
      );
      _isFirebaseInitialized = false;
      await _nativeLog('LISTEN_NATIVE', 'Firebase initialization FAILED', e, stackTrace);
    }

    // Initialize Local Notifications regardless of Firebase state
    appLogger.d('FirebaseNotificationService: initialize() - initializing local notifications...');
    try {
      await _initLocalNotifications();
      appLogger.i('FirebaseNotificationService: Local notifications initialized successfully.');
      await _nativeLog('LISTEN_NATIVE', 'Local notifications initialized successfully');
    } catch (e) {
      appLogger.w('FirebaseNotificationService: Local notification initialization failed. Error: $e');
      await _nativeLog('LISTEN_NATIVE', 'Local notifications init FAILED: $e');
    }

    if (!_isFirebaseInitialized) {
      appLogger.i(
        'FirebaseNotificationService: initialize() - Firebase not initialized, skipping FCM setup and returning.',
      );
      await _nativeLog('LISTEN_NATIVE', 'initialize EXIT - firebase not initialized');
      return;
    }

    try {
      appLogger.d('FirebaseNotificationService: initialize() - configuring Android notification channel...');
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

      appLogger
        ..i('FirebaseNotificationService: Android notification channel configured.')
        // 3. Configure iOS foreground presentation settings
        ..d('FirebaseNotificationService: initialize() - setting iOS foreground presentation options...');
      await _fcm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      await _nativeLog('LISTEN_NATIVE', 'setForegroundNotificationPresentationOptions DONE');
      appLogger
        ..i('FirebaseNotificationService: iOS foreground presentation options set.')
        // 4. Listen to foreground FCM messages
        ..d('FirebaseNotificationService: initialize() - attaching onMessage listener...');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        appLogger.d('FirebaseNotificationService: onMessage received: ${message.messageId ?? "<no-id>"}');
        try {
          _nativeLog(
            'LISTEN_NATIVE',
            'onMessage received id=${message.messageId ?? "<no-id>"} data=${message.data}',
          );
        } catch (_) {}
        // Discard if notifications are disabled in settings
        if (!SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) {
          appLogger.d(
            'FirebaseNotificationService: onMessage discarded because notifications are disabled in settings.',
          );
          return;
        }

        final payload = _convertMessage(message);
        _messageReceivedController.add(payload);
        appLogger.i('FirebaseNotificationService: onMessage -> messageReceivedController.add.');

        // Show local banner for Android in foreground
        if (message.notification != null) {
          appLogger.d(
            'FirebaseNotificationService: onMessage -> showing local notification for message ${message.messageId ?? "<no-id>"}.',
          );
          _showLocalNotification(message, channel);
        }
      });
      appLogger
        ..i('FirebaseNotificationService: onMessage listener attached.')
        // 5. Listen to background click wakeup events
        ..d('FirebaseNotificationService: initialize() - attaching onMessageOpenedApp listener...');
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        appLogger.d(
          'FirebaseNotificationService: onMessageOpenedApp received: ${message.messageId ?? "<no-id>"}',
        );
        try {
          _nativeLog(
            'LISTEN_NATIVE',
            'onMessageOpenedApp id=${message.messageId ?? "<no-id>"} data=${message.data}',
          );
        } catch (_) {}
        // Discard if notifications are disabled in settings
        if (!SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) {
          appLogger.d(
            'FirebaseNotificationService: onMessageOpenedApp discarded because notifications are disabled in settings.',
          );
          return;
        }

        final payload = _convertMessage(message);
        _messageOpenedController.add(payload);
        appLogger.i('FirebaseNotificationService: onMessageOpenedApp -> messageOpenedController.add.');
        _handleNotificationNavigation(payload);
        appLogger.d('FirebaseNotificationService: onMessageOpenedApp -> navigation handled.');
      });
      appLogger
        ..i('FirebaseNotificationService: onMessageOpenedApp listener attached.')
        ..d('FirebaseNotificationService: initialize() - requesting permissions...');
      try {
        final permStart = DateTime.now();
        final permResult = await requestPermission();
        final permDuration = DateTime.now().difference(permStart);
        appLogger.i(
          'FirebaseNotificationService: requestPermission completed. result=$permResult duration=${permDuration.inMilliseconds}ms',
        );
        await _nativeLog(
          'LISTEN_NATIVE',
          'requestPermission result=$permResult duration=${permDuration.inMilliseconds}ms',
        );
      } catch (e, stackTrace) {
        appLogger.e(
          'FirebaseNotificationService: requestPermission threw an exception: $e',
          error: e,
          stackTrace: stackTrace,
        );
        await _nativeLog('LISTEN_NATIVE', 'requestPermission threw', e, stackTrace);
      }
      // 6. Handle terminated startup click
      appLogger.d(
        'FirebaseNotificationService: initialize() - checking for initial message (getInitialMessage)...',
      );
      try {
        final initMsgStart = DateTime.now();
        final initialMessage = await _fcm.getInitialMessage();
        final initMsgDuration = DateTime.now().difference(initMsgStart);
        appLogger.d(
          'FirebaseNotificationService: getInitialMessage duration=${initMsgDuration.inMilliseconds}ms',
        );
        await _nativeLog('LISTEN_NATIVE', 'getInitialMessage duration=${initMsgDuration.inMilliseconds}ms');
        if (initialMessage != null) {
          appLogger.d(
            'FirebaseNotificationService: getInitialMessage returned a message: ${initialMessage.messageId ?? "<no-id>"}',
          );
          await _nativeLog(
            'LISTEN_NATIVE',
            'getInitialMessage returned id=${initialMessage.messageId ?? "<no-id>"} data=${initialMessage.data}',
          );
          // Discard if notifications are disabled in settings
          if (SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true)) {
            final payload = _convertMessage(initialMessage);
            _messageOpenedController.add(payload);
            appLogger.i('FirebaseNotificationService: initialMessage -> messageOpenedController.add.');
            _handleNotificationNavigation(payload);
            appLogger.d('FirebaseNotificationService: initialMessage -> navigation handled.');
          } else {
            appLogger.d(
              'FirebaseNotificationService: initialMessage ignored because notifications are disabled in settings.',
            );
          }
        } else {
          appLogger.d('FirebaseNotificationService: getInitialMessage returned null.');
        }
      } catch (e, stackTrace) {
        appLogger.e(
          'FirebaseNotificationService: getInitialMessage threw: $e',
          error: e,
          stackTrace: stackTrace,
        );
        await _nativeLog('LISTEN_NATIVE', 'getInitialMessage threw', e, stackTrace);
      }

      // 7. Sync subscription to the version updates topic based on settings
      appLogger.d(
        'FirebaseNotificationService: initialize() - syncing topic subscription based on settings...',
      );
      final isEnabled = SpUtil.getBool(AppConstants.notificationsKey, defaultValue: true);
      if (isEnabled) {
        appLogger.d(
          'FirebaseNotificationService: Notifications enabled in settings; subscribing to topic ${AppConstants.versionUpdatesTopic}',
        );
        await subscribeToTopic(AppConstants.versionUpdatesTopic);
        appLogger.i('FirebaseNotificationService: Subscribed to version updates topic.');
        await _nativeLog('LISTEN_NATIVE', 'Subscribed to topic ${AppConstants.versionUpdatesTopic}');
      } else {
        appLogger.d(
          'FirebaseNotificationService: Notifications disabled in settings; unsubscribing from topic ${AppConstants.versionUpdatesTopic}',
        );
        await unsubscribeFromTopic(AppConstants.versionUpdatesTopic);
        appLogger.i('FirebaseNotificationService: Unsubscribed from version updates topic.');
        await _nativeLog('LISTEN_NATIVE', 'Unsubscribed from topic ${AppConstants.versionUpdatesTopic}');
      }
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to setup FCM handlers: $e');
      await _nativeLog('LISTEN_NATIVE', 'Failed to setup FCM handlers: $e');
    }

    // Optionally try to log token for easier diagnosis in release builds
    try {
      final t = await _fcm.getToken();
      await _nativeLog('LISTEN_NATIVE', 'fcm_token:$t');
    } catch (e, st) {
      await _nativeLog('LISTEN_NATIVE', 'getToken during init failed', e, st);
    }

    appLogger.i('FirebaseNotificationService: initialize() - completed');
    await _nativeLog('LISTEN_NATIVE', 'initialize COMPLETE');
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
    if (data.containsKey(AppConstants.notificationParamTab)) {
      final tabStr = data[AppConstants.notificationParamTab] as String;
      if (tabStr == AppConstants.notificationTabSettings) {
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
        final targetTab = HomeTab.values.firstWhereOrNull((tab) => tab.name == tabStr);
        if (targetTab != null) {
          eventBus.fire(
            CommonEvent<HomeTab>(
              AppConstants.tabChangedEvent,
              data: targetTab,
              sticky: true,
              autoClear: true,
            ),
          );
        }
      }
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
      AppConstants.defaultNotificationIcon,
    );
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
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
            // Native log for local notification click handling
            _nativeLog('LISTEN_NATIVE', 'localNotificationClick data=$data');
          } catch (e) {
            appLogger.e('FirebaseNotificationService: Failed to parse local notification click payload: $e');
            _nativeLog('LISTEN_NATIVE', 'localNotificationClick parse FAILED: $e');
          }
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
      await _nativeLog('LISTEN_NATIVE', 'requestPermission FAILED: $e');
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    if (!_isFirebaseInitialized) return null;
    try {
      final token = await _fcm.getToken();
      try {
        await _nativeLog('LISTEN_NATIVE', 'getToken returned:$token');
      } catch (_) {}
      return token;
    } catch (e) {
      appLogger.w('FirebaseNotificationService: Failed to get push token: $e');
      await _nativeLog('LISTEN_NATIVE', 'getToken FAILED: $e');
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
      await _fcm.subscribeToTopic(topic);
      appLogger.i('FirebaseNotificationService: Subscribed to topic "$topic".');
      await _nativeLog('LISTEN_NATIVE', 'subscribeToTopic:$topic');
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to subscribe to topic "$topic": $e');
      await _nativeLog('LISTEN_NATIVE', 'subscribeToTopic FAILED:$topic error:$e');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_isFirebaseInitialized) return;
    try {
      await _fcm.unsubscribeFromTopic(topic);
      appLogger.i('FirebaseNotificationService: Unsubscribed from topic "$topic".');
      await _nativeLog('LISTEN_NATIVE', 'unsubscribeFromTopic:$topic');
    } catch (e) {
      appLogger.e('FirebaseNotificationService: Failed to unsubscribe from topic "$topic": $e');
      await _nativeLog('LISTEN_NATIVE', 'unsubscribeFromTopic FAILED:$topic error:$e');
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
