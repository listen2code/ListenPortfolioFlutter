import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/user_model.dart';
import 'package:listen_portfolio_flutter/features/auth/data/models/login_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/about_me_model.dart';
import 'package:listen_portfolio_flutter/features/home/data/models/project_model.dart';
import 'package:listen_portfolio_flutter/features/ai_chat/data/models/ai_preset_qa_response_model.dart';

void main() {
  group('Mock Data Consistency Tests', () {
    // Helper to read JSON file from assets
    Map<String, dynamic> readJsonFile(String path) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: 'File $path should exist');
      final jsonStr = file.readAsStringSync();
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    }

    test('v1/get/user.json matches UserModel spec', () {
      final jsonMap = readJsonFile('assets/mock/v1/get/user.json');
      final response = BaseResponseModel<UserModel>.fromJson(
        jsonMap,
        (body) => UserModel.fromJson(body as Map<String, dynamic>),
      );

      expect(response.result, equals('0'));
      expect(response.body, isNotNull);
      expect(response.body!.id, equals('1'));
      expect(response.body!.name, equals('Listen'));
    });

    test('v1/get/projects.json matches List<ProjectModel> spec', () {
      final jsonMap = readJsonFile('assets/mock/v1/get/projects.json');
      final response = BaseResponseModel<List<ProjectModel>>.fromJson(
        jsonMap,
        (body) => (body as List)
            .map((item) => ProjectModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      expect(response.result, equals('0'));
      expect(response.body, isNotNull);
      expect(response.body!.length, greaterThan(0));
      expect(response.body![0].businessId, equals('lportfolio-flutter'));
    });

    test('v1/get/aboutMe.json matches AboutMeModel spec', () {
      final jsonMap = readJsonFile('assets/mock/v1/get/aboutMe.json');
      final response = BaseResponseModel<AboutMeModel>.fromJson(
        jsonMap,
        (body) => AboutMeModel.fromJson(body as Map<String, dynamic>),
      );

      expect(response.result, equals('0'));
      expect(response.body, isNotNull);
      expect(response.body!.status, equals('available'));
      expect(response.body!.experiences.length, greaterThan(0));
      expect(response.body!.skills[0].id, equals('1')); // Verifying the added skill IDs
    });

    test('v1/get/preset-qa.json matches AiPresetQaResponseModel spec', () {
      final jsonMap = readJsonFile('assets/mock/v1/get/preset-qa.json');
      final response = BaseResponseModel<AiPresetQaResponseModel>.fromJson(
        jsonMap,
        (body) => AiPresetQaResponseModel.fromJson(body as Map<String, dynamic>),
      );

      expect(response.result, equals('0'));
      expect(response.body, isNotNull);
      expect(response.body!.qas.containsKey('global'), isTrue);
    });

    test('v1/post/auth/login.json matches LoginModel spec', () {
      final jsonMap = readJsonFile('assets/mock/v1/post/auth/login.json');
      final response = BaseResponseModel<LoginModel>.fromJson(
        jsonMap,
        (body) => LoginModel.fromJson(body as Map<String, dynamic>),
      );

      expect(response.result, equals('0'));
      expect(response.body, isNotNull);
      expect(response.body!.userId, equals('1')); // ToStringConverter maps int 1 to String "1"
      expect(response.body!.token, isNotEmpty);
    });

    test('v1/post/auth/refresh.json matches LoginModel spec', () {
      final jsonMap = readJsonFile('assets/mock/v1/post/auth/refresh.json');
      final response = BaseResponseModel<LoginModel>.fromJson(
        jsonMap,
        (body) => LoginModel.fromJson(body as Map<String, dynamic>),
      );

      expect(response.result, equals('0'));
      expect(response.body, isNotNull);
      expect(response.body!.userId, equals('1'));
      expect(response.body!.token, isNotEmpty);
    });
  });
}
