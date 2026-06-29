import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_core/core.dart';
import 'package:listen_core/base/base_view_model.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';

import 'package:listen_portfolio_flutter/shared/utils/playback_registry_init.dart';
import 'package:listen_portfolio_flutter/features/settings/domain/repositories/playback_tape_repository.dart';
import 'package:listen_portfolio_flutter/features/settings/data/repositories/playback_tape_repository_impl.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_tape_metadata.dart';
import 'package:listen_portfolio_flutter/features/settings/data/models/playback_step.dart';

// 定义一个专门用于测试的 FakeViewModel 和 State/Intent
class TestState extends BaseState {
  final String val;
  const TestState(this.val);
}

class FakeTestViewModel extends BaseViewModel<LoginIntent> with ViewModelMixin<TestState, LoginIntent> {
  LoginIntent? lastHandledIntent;

  @override
  TestState get state => const TestState('test');

  @override
  set state(TestState value) {}

  @override
  String get tag => 'FakeTestViewModel';

  @override
  FutureOr<void> onIntent(LoginIntent intent) {
    lastHandledIntent = intent;
  }
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init();
    initMviPlaybackRegistry();
    MviPlaybackPlayer.stepDelay = Duration.zero;

    // Wire up saveTapeDelegate in test setup using settings repository
    MviPlaybackRecorder.saveTapeDelegate = (tapeKey, steps, name, timestamp) async {
      const repository = PlaybackTapeRepositoryImpl();
      final metadata = PlaybackTapeMetadata(
        key: tapeKey,
        name: name,
        timestamp: timestamp,
        steps: steps.length,
      );
      await repository.saveTape(tapeKey, steps, metadata);
    };
  });

  group('MVI Playback Recorder & Player Tests', () {
    test('Should successfully record intents and save to SharedPreferences', () async {
      final recorder = MviPlaybackRecorder.instance;

      // 开启录制
      recorder.startRecording();
      expect(recorder.isRecording, isTrue);

      // 创建 ViewModel 并派发 Intent
      final viewModel = FakeTestViewModel();
      viewModel.onInit(); // 会自动向 ActiveViewModels 注册

      const testIntent = LoginIntent.usernameChanged('listen2code');
      await viewModel.handleIntent(testIntent);

      // 验证已被拦截录像
      expect(recorder.recordedSteps.length, equals(1));
      expect(recorder.recordedSteps.first.type, equals(PlaybackStep.intent));
      expect(recorder.recordedSteps.first.viewModelTag, equals('FakeTestViewModel'));
      expect(recorder.recordedSteps.first.name, contains('LoginIntent.usernameChanged'));

      // 停止录制
      final savedName = await recorder.stopRecording('测试账号输入录制');
      expect(recorder.isRecording, isFalse);
      expect(savedName, equals('测试账号输入录制'));

      // 检查本地 SP 缓存
      final sp = await SharedPreferences.getInstance();
      final listJson = sp.getString('playback_tapes_list');
      expect(listJson, isNotNull);
      expect(listJson, contains('测试账号输入录制'));
    });

    test('MviPlaybackRegistry should deserialize Freezed intents correctly', () {
      // 1. 测试有参数的构造函数
      const intentWithArg = LoginIntent.usernameChanged('listen2code');
      final intentStr = intentWithArg.toString(); // "LoginIntent.usernameChanged(username: listen2code)"

      final parsedIntent = MviPlaybackRegistry.parseAndDeserialize(intentStr);
      expect(parsedIntent, isNotNull);
      expect(parsedIntent, isA<LoginIntent>());

      (parsedIntent as LoginIntent).map(
        usernameChanged: (val) => expect(val.username, equals('listen2code')),
        passwordChanged: (_) => fail('Incorrect intent subtype'),
        togglePasswordVisibility: (_) => fail('Incorrect intent subtype'),
        toggleRememberMe: (_) => fail('Incorrect intent subtype'),
        submitLogin: (_) => fail('Incorrect intent subtype'),
        navigateToSignup: (_) => fail('Incorrect intent subtype'),
        navigateToForgotPassword: (_) => fail('Incorrect intent subtype'),
        skipLogin: (_) => fail('Incorrect intent subtype'),
      );

      // 2. 测试无参数的构造函数
      const intentNoArg = LoginIntent.submitLogin();
      final intentStrNoArg = intentNoArg.toString(); // "LoginIntent.submitLogin()"

      final parsedIntentNoArg = MviPlaybackRegistry.parseAndDeserialize(intentStrNoArg);
      expect(parsedIntentNoArg, isNotNull);
      expect(parsedIntentNoArg, isA<LoginIntent>());
    });

    test('MviPlaybackPlayer should replay tape and dispatch to active viewmodel', () async {
      // 准备录像步骤
      final sp = await SharedPreferences.getInstance();
      final mockSteps = [
        {
          'type': PlaybackStep.intent,
          'viewModelTag': 'FakeTestViewModel',
          'name': 'LoginIntent.usernameChanged(username: test_user)',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      ];
      await sp.setString('playback_tape_test_key', jsonEncode(mockSteps));

      // 挂载 FakeViewModel
      final viewModel = FakeTestViewModel();
      viewModel.onInit(); // 自动在 ActiveViewModels 中注册该活跃的 ViewModel

      // 验证当前还没触发
      expect(viewModel.lastHandledIntent, isNull);

      // 执行回放 (异步执行)
      final playFuture = MviPlaybackPlayer.instance.play('playback_tape_test_key');

      // 等待回放的第一帧派发（微任务和模拟延迟）
      await Future.delayed(const Duration(milliseconds: 100));

      // 验证 ViewModel 成功收到了被回放的 Intent，且参数正确！
      expect(viewModel.lastHandledIntent, isNotNull);
      expect(viewModel.lastHandledIntent, isA<LoginIntent>());

      (viewModel.lastHandledIntent as LoginIntent).map(
        usernameChanged: (val) => expect(val.username, equals('test_user')),
        passwordChanged: (_) => fail('Incorrect intent subtype'),
        togglePasswordVisibility: (_) => fail('Incorrect intent subtype'),
        toggleRememberMe: (_) => fail('Incorrect intent subtype'),
        submitLogin: (_) => fail('Incorrect intent subtype'),
        navigateToSignup: (_) => fail('Incorrect intent subtype'),
        navigateToForgotPassword: (_) => fail('Incorrect intent subtype'),
        skipLogin: (_) => fail('Incorrect intent subtype'),
      );

      // 等待回放任务全部结束
      await playFuture;
    });

    test('All Intent union cases must be registered in MviPlaybackRegistry', () {
      final directory = Directory('lib');
      final intentFiles = directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('_intent.dart'));

      final registered = MviPlaybackRegistry.registeredKeys;

      for (final file in intentFiles) {
        final content = file.readAsStringSync();
        
        // Find class name, e.g. "class LoginIntent"
        final classRegex = RegExp(r'class\s+([a-zA-Z0-9_]+)\s+extends\s+BaseIntent');
        final classMatch = classRegex.firstMatch(content);
        if (classMatch == null) continue;
        final className = classMatch.group(1)!;

        // Skip PlaybackTapeListIntent as it doesn't need playback recording/replaying
        if (className == 'PlaybackTapeListIntent') continue;

        // Find all union constructors, e.g. "const factory LoginIntent.usernameChanged("
        final constructorRegex = RegExp(
          'const\\s+factory\\s+' + className + '\\.([a-zA-Z0-9_]+)\\(',
        );
        final matches = constructorRegex.allMatches(content);
        
        final registeredConstructors = registered[className] ?? {};

        for (final match in matches) {
          final constructorName = match.group(1)!;
          
          expect(
            registeredConstructors.contains(constructorName),
            isTrue,
            reason: 'Constructor "$className.$constructorName" is not registered in MviPlaybackRegistry! '
                'Please add it to the registerPlayback() method of $className.',
          );
        }
      }
    });
  });
}
