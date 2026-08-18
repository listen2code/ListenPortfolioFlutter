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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('SwitchDialogEffect and SwitchDialogProviderImpl structure', () {
      dynamic selectedValue;
      final effect = SwitchDialogEffect(
        title: 'Select Language',
        options: const [
          SwitchDialogOption(label: 'English', value: 'en', isSelected: true),
          SwitchDialogOption(label: 'Chinese', subtitle: '中文', value: 'zh', isSelected: false),
        ],
        showConfirmButton: false,
        onChanged: (val) => selectedValue = val,
      );

      expect(effect.title, 'Select Language');
      expect(effect.options.length, 2);
      expect(effect.options[0].isSelected, isTrue);
      expect(effect.options[1].subtitle, '中文');
      expect(effect.showConfirmButton, isFalse);

      effect.onChanged('zh');
      expect(selectedValue, 'zh');

      const provider = SwitchDialogProviderImpl();
      expect(provider, isNotNull);
    });

    test('ActionSheetEffect and ActionSheetOption structure', () {
      bool tapExecuted = false;
      final option = ActionSheetOption(
        label: 'Camera',
        icon: Icons.camera_alt,
        color: Colors.blue,
        onTap: () => tapExecuted = true,
      );

      expect(option.label, 'Camera');
      expect(option.icon, Icons.camera_alt);
      expect(option.color, Colors.blue);
      expect(option.visible, isTrue);

      option.onTap();
      expect(tapExecuted, isTrue);

      final effect = ActionSheetEffect(options: [option]);
      expect(effect.options.length, 1);

      const provider = ActionSheetProviderImpl();
      expect(provider, isNotNull);
    });

    test('ColorPickerEffect and ColorPickerProviderImpl structure', () {
      Color? pickedColor;
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

    test('LaunchUrlEffect structure and toString', () {
      final effect = LaunchUrlEffect('https://flutter.dev');
      expect(effect.url, 'https://flutter.dev');
      expect(effect.toString(), contains('https://flutter.dev'));

      const provider = LaunchUrlProviderImpl();
      expect(provider, isNotNull);
    });

    test('CropAvatarEffect and CropAvatarProviderImpl structure', () {
      final file = File('/path/avatar.png');
      File? resultFile;
      final effect = CropAvatarEffect(
        imageFile: file,
        onResult: (res) => resultFile = res,
      );

      expect(effect.imageFile.path, file.path);
      expect(effect.toString(), contains('CropAvatarEffect'));

      effect.onResult?.call(file);
      expect(resultFile?.path, file.path);

      const provider = CropAvatarProviderImpl();
      expect(provider, isNotNull);
    });

    test('LogoutEffect and LogoutProviderImpl structure', () {
      final effect = LogoutEffect();
      expect(effect, isNotNull);

      final container = ProviderContainer();
      final provider = LogoutProviderImpl(container);
      expect(provider, isNotNull);
      container.dispose();
    });

    test('CoffeePurchaseEffect and CoffeePurchaseProviderImpl', () {
      final effect = CoffeePurchaseEffect();
      expect(effect, isNotNull);

      const provider = CoffeePurchaseProviderImpl();
      expect(provider, isNotNull);
    });

    test('LogOverlayEffect and LogOverlayProviderImpl', () {
      final effect = LogOverlayEffect(true);
      expect(effect.show, isTrue);

      const provider = LogOverlayProviderImpl();
      expect(provider, isNotNull);
    });

    test('NavigationEffect structure and parameters', () {
      final effect = NavigationEffect<String>(
        target: '/profile',
        arguments: 'user123',
        isReplace: true,
      );

      expect(effect.target, '/profile');
      expect(effect.arguments, 'user123');
      expect(effect.isReplace, isTrue);

      const provider = NavigationProviderImpl();
      expect(provider, isNotNull);
    });

    test('OpenAppSettingsEffect and OpenAppSettingsProviderImpl', () {
      final effect = OpenAppSettingsEffect();
      expect(effect, isNotNull);

      const provider = OpenAppSettingsProviderImpl();
      expect(provider, isNotNull);
    });

    test('PickImageEffect structure', () {
      final effect = PickImageEffect(
        source: ImageSource.gallery,
        onResult: (f) {},
      );
      expect(effect.source, ImageSource.gallery);
      expect(effect.onResult, isNotNull);

      const provider = PickImageProviderImpl();
      expect(provider, isNotNull);
    });

    test('PlayTapeEffect and ShowTapeDetailsEffect structure', () {
      final steps = <PlaybackStep>[
        const PlaybackStep(type: PlaybackStep.intent, viewModelTag: 'LoginVM', name: 'login()', timestamp: 100),
      ];
      final playEffect = PlayTapeEffect('tape_123', steps);
      expect(playEffect.tapeKey, 'tape_123');
      expect(playEffect.steps.length, 1);

      const playProvider = PlayTapeProviderImpl();
      expect(playProvider, isNotNull);

      final detailsEffect = ShowTapeDetailsEffect(steps, 'Sample Tape');
      expect(detailsEffect.name, 'Sample Tape');
      expect(detailsEffect.steps.length, 1);

      const detailsProvider = ShowTapeDetailsProviderImpl();
      expect(detailsProvider, isNotNull);
    });

    test('PreviewImageEffect and PrintPdfEffect structure', () {
      final previewEffect = PreviewImageEffect(
        imageUrl: 'https://example.com/img.png',
      );
      expect(previewEffect.imageUrl, 'https://example.com/img.png');

      const previewProvider = PreviewImageProviderImpl();
      expect(previewProvider, isNotNull);

      final pdfEffect = PrintPdfEffect(
        htmlContent: '<h1>Resume</h1>',
        fileName: 'Resume.pdf',
      );
      expect(pdfEffect.fileName, 'Resume.pdf');
      expect(pdfEffect.htmlContent, '<h1>Resume</h1>');

      const pdfProvider = PrintPdfProviderImpl();
      expect(pdfProvider, isNotNull);
    });

    test('RateAppEffect and ShareEffect structure', () {
      final rateEffect = RateAppEffect();
      expect(rateEffect, isNotNull);

      const rateProvider = RateAppProviderImpl();
      expect(rateProvider, isNotNull);

      final shareEffect = ShareEffect(
        text: 'Check out this app!',
        subject: 'Listen Portfolio',
      );
      expect(shareEffect.subject, 'Listen Portfolio');
      expect(shareEffect.text, 'Check out this app!');

      const shareProvider = ShareProviderImpl();
      expect(shareProvider, isNotNull);
    });

    test('ShowLicensesEffect and ViewLogEffect structure', () {
      final licensesEffect = ShowLicensesEffect();
      expect(licensesEffect, isNotNull);

      const licensesProvider = ShowLicensesProviderImpl();
      expect(licensesProvider, isNotNull);

      final logFile = File('/path/log.txt');
      final logEffect = ViewLogEffect(logFile);
      expect(logEffect.file.path, logFile.path);

      const logProvider = ViewLogProviderImpl();
      expect(logProvider, isNotNull);
    });

    test('ScrollToProjectEffect and LoadingEffect and MessageEffect', () {
      final scrollEffect = ScrollToProjectEffect(index: 0, businessId: 'proj_1');
      expect(scrollEffect.index, 0);
      expect(scrollEffect.businessId, 'proj_1');
      expect(scrollEffect.toString(), contains('ScrollToProjectEffect'));

      final showLoading = LoadingEffect(true, message: 'Loading...');
      expect(showLoading.show, isTrue);
      expect(showLoading.message, 'Loading...');

      final hideLoading = LoadingEffect(false);
      expect(hideLoading.show, isFalse);

      const loadingProvider = LoadingProviderImpl();
      expect(loadingProvider, isNotNull);

      final msgEffect = MessageEffect.info('Operation succeeded');
      expect(msgEffect.message, 'Operation succeeded');
      expect(msgEffect.type, MessageType.info);

      const msgProvider = MessageProviderImpl();
      expect(msgProvider, isNotNull);
    });
  });
}
