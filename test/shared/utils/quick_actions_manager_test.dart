import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_portfolio_flutter/shared/i18n/app_language.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/utils/quick_actions_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> quickActionsCalls = [];

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init(prefix: 'test_');
    settingManager.loadSettings();

    // Mock platform channel for quick_actions
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/quick_actions'),
          (MethodCall call) async {
            quickActionsCalls.add(call);
            return null;
          },
        );
  });

  setUp(() {
    quickActionsCalls.clear();
  });

  group('QuickActionsManager Unit Tests', () {
    test('init and updateShortcuts register quick action items with platform channel', () {
      QuickActionsManager.init();

      expect(quickActionsCalls.isNotEmpty, isTrue);

      final setShortcutCalls = quickActionsCalls.where((call) => call.method == 'setShortcutItems').toList();
      expect(setShortcutCalls.isNotEmpty, isTrue);

      final List<dynamic> shortcutItems = setShortcutCalls.last.arguments as List<dynamic>;
      expect(shortcutItems.length, equals(2));

      final firstShortcut = shortcutItems[0] as Map<dynamic, dynamic>;
      final secondShortcut = shortcutItems[1] as Map<dynamic, dynamic>;

      expect(firstShortcut['type'], equals('action_settings'));
      expect(secondShortcut['type'], equals('action_contact'));
    });

    test('updateShortcuts responds to settingManager language changes', () {
      QuickActionsManager.init();
      quickActionsCalls.clear();

      settingManager.setLanguage(AppLanguage.english);

      final setShortcutCalls = quickActionsCalls.where((call) => call.method == 'setShortcutItems').toList();
      expect(setShortcutCalls.isNotEmpty, isTrue);
    });
  });
}
