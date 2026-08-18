import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_step.dart';
import 'package:listen_portfolio_flutter/shared/base/action_sheet_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/coffee_purchase_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/color_picker_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/confirm_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/crop_avatar_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/launch_url_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/loading_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/log_overlay_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/logout_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/message_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/navigation_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/open_app_settings_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/pick_image_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/play_tape_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/preview_image_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/print_pdf_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/rate_app_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/scroll_to_project_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/share_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/show_licenses_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/show_tape_details_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/switch_dialog_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/base/view_log_provider_impl.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    settingManager.loadSettings();
  });

  group('Shared Base Providers Unit Tests', () {
    test('ConfirmEffect and ConfirmProviderImpl structure', () {
      bool callbackResult = false;
      final effect = ConfirmEffect(
        title: 'Delete Item',
        message: 'Are you sure?',
        okText: 'OK',
        cancelText: 'Cancel',
        okColor: Colors.red,
        barrierDismissible: true,
        onResult: (confirmed) => callbackResult = confirmed,
      );

      expect(effect.title, 'Delete Item');
      expect(effect.message, 'Are you sure?');
      expect(effect.okColor, Colors.red);
      expect(effect.barrierDismissible, isTrue);

      effect.onResult(true);
      expect(callbackResult, isTrue);

      const provider = ConfirmProviderImpl();
      expect(provider, isNotNull);
    });

    test('ColorPickerEffect and ColorPickerProviderImpl structure', () {
      Color pickedColor = Colors.black;
      final effect = ColorPickerEffect(
        initialColor: Colors.blue,
        onColorSelected: (c) => pickedColor = c,
      );

      expect(effect.initialColor, Colors.blue);
      effect.onColorSelected(Colors.red);
      expect(pickedColor, Colors.red);

      const provider = ColorPickerProviderImpl();
      expect(provider, isNotNull);
    });

    test('ActionSheetEffect and ActionSheetProviderImpl structure', () {
      bool tapped = false;
      final option = ActionSheetOption(
        label: 'Edit',
        icon: Icons.edit,
        color: Colors.blue,
        visible: true,
        onTap: () => tapped = true,
      );
      final effect = ActionSheetEffect(options: [option]);

      expect(effect.options.length, 1);
      expect(effect.options.first.label, 'Edit');
      expect(effect.options.first.icon, Icons.edit);
      expect(effect.options.first.color, Colors.blue);
      expect(effect.options.first.visible, isTrue);

      option.onTap();
      expect(tapped, isTrue);

      const provider = ActionSheetProviderImpl();
      expect(provider, isNotNull);
    });

    test('CoffeePurchaseEffect and CoffeePurchaseProviderImpl structure', () {
      final effect = CoffeePurchaseEffect();
      expect(effect, isNotNull);

      const provider = CoffeePurchaseProviderImpl();
      expect(provider, isNotNull);
    });

    test('CropAvatarEffect and CropAvatarProviderImpl structure', () {
      File? cropped;
      final effect = CropAvatarEffect(
        imageFile: File('test.png'),
        onResult: (f) => cropped = f,
      );

      expect(effect.imageFile.path, 'test.png');
      effect.onResult?.call(File('cropped.png'));
      expect(cropped?.path, 'cropped.png');

      const provider = CropAvatarProviderImpl();
      expect(provider, isNotNull);
    });

    test('LaunchUrlEffect and LaunchUrlProviderImpl structure', () {
      final effect = LaunchUrlEffect('https://listen2code.com');
      expect(effect.url, 'https://listen2code.com');

      const provider = LaunchUrlProviderImpl();
      expect(provider, isNotNull);
    });

    test('LoadingEffect and LoadingProviderImpl structure', () {
      final effect = LoadingEffect(true, message: 'Processing...', type: LoadingType.dialog);
      expect(effect.show, isTrue);
      expect(effect.message, 'Processing...');
      expect(effect.type, LoadingType.dialog);

      const provider = LoadingProviderImpl();
      expect(provider, isNotNull);
    });

    test('LogOverlayEffect and LogOverlayProviderImpl structure', () {
      final effect = LogOverlayEffect(true);
      expect(effect.show, isTrue);

      const provider = LogOverlayProviderImpl();
      expect(provider, isNotNull);
    });

    test('LogoutEffect and LogoutProviderImpl structure', () {
      final container = ProviderContainer();
      final effect = LogoutEffect(message: 'Expired');
      expect(effect.message, 'Expired');

      final provider = LogoutProviderImpl(container);
      expect(provider, isNotNull);
      container.dispose();
    });

    test('MessageEffect and MessageProviderImpl structure', () {
      final infoEffect = MessageEffect.info('Info message');
      final errorEffect = MessageEffect.error('Error message');

      expect(infoEffect.message, 'Info message');
      expect(infoEffect.type, MessageType.info);
      expect(errorEffect.message, 'Error message');
      expect(errorEffect.type, MessageType.error);

      const provider = MessageProviderImpl();
      expect(provider, isNotNull);
    });

    test('NavigationEffect and NavigationProviderImpl structure', () {
      final effect = NavigationEffect<String>(
        target: '/home',
        isReplace: false,
        isReplaceAll: true,
        isBack: false,
        arguments: 'arg1',
      );

      expect(effect.target, '/home');
      expect(effect.isReplace, isFalse);
      expect(effect.isReplaceAll, isTrue);
      expect(effect.isBack, isFalse);
      expect(effect.arguments, 'arg1');

      const provider = NavigationProviderImpl();
      expect(provider, isNotNull);
    });

    test('OpenAppSettingsEffect and OpenAppSettingsProviderImpl structure', () {
      final effect = OpenAppSettingsEffect();
      expect(effect, isNotNull);

      const provider = OpenAppSettingsProviderImpl();
      expect(provider, isNotNull);
    });

    test('PickImageEffect and PickImageProviderImpl structure', () {
      File? picked;
      final effect = PickImageEffect(
        source: ImageSource.gallery,
        onResult: (f) => picked = f,
      );

      expect(effect.source, ImageSource.gallery);
      effect.onResult?.call(File('picked.png'));
      expect(picked?.path, 'picked.png');

      const provider = PickImageProviderImpl();
      expect(provider, isNotNull);
    });

    test('PlayTapeEffect and PlayTapeProviderImpl structure', () {
      final effect = PlayTapeEffect(
        'tape_1',
        [
          const PlaybackStep(type: PlaybackStep.intent, viewModelTag: 'VM', name: 'login()', timestamp: 100),
        ],
      );

      expect(effect.tapeKey, 'tape_1');
      expect(effect.steps.length, 1);

      const provider = PlayTapeProviderImpl();
      expect(provider, isNotNull);
    });

    test('PreviewImageEffect and PreviewImageProviderImpl structure', () {
      final effect = PreviewImageEffect(
        imageUrl: 'https://example.com/image.png',
        heroTag: 'tag1',
      );

      expect(effect.imageUrl, 'https://example.com/image.png');
      expect(effect.heroTag, 'tag1');

      const provider = PreviewImageProviderImpl();
      expect(provider, isNotNull);
    });

    test('PrintPdfEffect and PrintPdfProviderImpl structure', () {
      final effect = PrintPdfEffect(htmlContent: '<h1>Title</h1>', fileName: 'doc.pdf');
      expect(effect.htmlContent, '<h1>Title</h1>');
      expect(effect.fileName, 'doc.pdf');

      const provider = PrintPdfProviderImpl();
      expect(provider, isNotNull);
    });

    test('RateAppEffect and RateAppProviderImpl structure', () {
      final effect = RateAppEffect();
      expect(effect, isNotNull);

      const provider = RateAppProviderImpl();
      expect(provider, isNotNull);
    });

    test('ScrollToProjectEffect structure', () {
      final effect = ScrollToProjectEffect(index: 2, businessId: 'proj_1');
      expect(effect.index, 2);
      expect(effect.businessId, 'proj_1');
    });

    test('ShareEffect and ShareProviderImpl structure', () {
      final effect = ShareEffect(
        text: 'Listen app is amazing!',
        subject: 'Listen App',
      );

      expect(effect.text, 'Listen app is amazing!');
      expect(effect.subject, 'Listen App');

      const provider = ShareProviderImpl();
      expect(provider, isNotNull);
    });

    test('ShowLicensesEffect and ShowLicensesProviderImpl structure', () {
      final effect = ShowLicensesEffect();
      expect(effect, isNotNull);

      const provider = ShowLicensesProviderImpl();
      expect(provider, isNotNull);
    });

    test('ShowTapeDetailsEffect and ShowTapeDetailsProviderImpl structure', () {
      final effect = ShowTapeDetailsEffect(
        [
          const PlaybackStep(type: PlaybackStep.intent, viewModelTag: 'VM', name: 'init()', timestamp: 100),
          const PlaybackStep(type: PlaybackStep.effect, viewModelTag: 'VM', name: 'Loading', timestamp: 200),
        ],
        'Login Tape',
      );

      expect(effect.name, 'Login Tape');
      expect(effect.steps.length, 2);

      const provider = ShowTapeDetailsProviderImpl();
      expect(provider, isNotNull);
    });

    test('SwitchDialogEffect and SwitchDialogProviderImpl structure', () {
      final effect = SwitchDialogEffect(
        title: 'Switch Environment',
        options: const [
          SwitchDialogOption(label: 'Production', value: 'prod', isSelected: true),
          SwitchDialogOption(label: 'Staging', value: 'stage', isSelected: false),
        ],
        onChanged: (val) {},
      );

      expect(effect.title, 'Switch Environment');
      expect(effect.options.length, 2);

      const provider = SwitchDialogProviderImpl();
      expect(provider, isNotNull);
    });

    test('ViewLogEffect and ViewLogProviderImpl structure', () {
      final effect = ViewLogEffect(File('log.txt'));
      expect(effect.file.path, 'log.txt');

      const provider = ViewLogProviderImpl();
      expect(provider, isNotNull);
    });
  });

  group('Shared Base Providers handleEffect Execution in UI Tree', () {
    testWidgets('handleEffect execution for UI dialogs and sheets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: AppNavConfig.navigatorKey,
          home: const Scaffold(
            body: Center(child: Text('Base Providers Container')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. ConfirmProviderImpl
      const confirmProvider = ConfirmProviderImpl();
      confirmProvider.handleEffect(ConfirmEffect(
        title: 'Confirm Title',
        message: 'Confirm Content',
        onResult: (_) {},
      ));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Title'), findsOneWidget);
      AppNav.back<void>();
      await tester.pumpAndSettle();

      // 2. ShowTapeDetailsProviderImpl
      const tapeDetailsProvider = ShowTapeDetailsProviderImpl();
      tapeDetailsProvider.handleEffect(ShowTapeDetailsEffect(
        [const PlaybackStep(type: PlaybackStep.intent, viewModelTag: 'VM', name: 'testStep', timestamp: 100)],
        'Tape Header',
      ));
      await tester.pumpAndSettle();
      expect(find.text('Tape Header'), findsOneWidget);
      AppNav.back<void>();
      await tester.pumpAndSettle();

      // 3. ColorPickerProviderImpl
      const colorPickerProvider = ColorPickerProviderImpl();
      colorPickerProvider.handleEffect(ColorPickerEffect(
        initialColor: Colors.blue,
        onColorSelected: (_) {},
      ));
      await tester.pumpAndSettle();
      expect(find.text(I18nKeys.selectColor.tr), findsOneWidget);
      AppNav.back<void>();
      await tester.pumpAndSettle();

      // 4. ActionSheetProviderImpl
      const actionSheetProvider = ActionSheetProviderImpl();
      actionSheetProvider.handleEffect(ActionSheetEffect(
        options: [
          ActionSheetOption(label: 'Action 1', icon: Icons.star, onTap: () {}),
        ],
      ));
      await tester.pumpAndSettle();
      expect(find.text('Action 1'), findsOneWidget);
      AppNav.back<void>();
      await tester.pumpAndSettle();

      // 5. SwitchDialogProviderImpl
      const switchDialogProvider = SwitchDialogProviderImpl();
      switchDialogProvider.handleEffect(SwitchDialogEffect(
        title: 'Choose Option',
        options: const [
          SwitchDialogOption(label: 'Opt1', value: 'opt1', isSelected: true),
        ],
        onChanged: (_) {},
      ));
      await tester.pumpAndSettle();
      expect(find.text('Choose Option'), findsOneWidget);
      AppNav.back<void>();
      await tester.pumpAndSettle();
    });
  });
}
