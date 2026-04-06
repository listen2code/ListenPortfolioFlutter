import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/constants/app_constants.dart';
import '../../../../../shared/i18n/translations_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'architecture_intent.dart';
import 'architecture_state.dart';

part 'architecture_view_model.g.dart';

@riverpod
class ArchitectureViewModel extends _$ArchitectureViewModel
    with ViewModelMixin<ArchitectureState, ArchitectureIntent> {
  @override
  ArchitectureState build() => const ArchitectureState();

  @override
  void onVisible() {
    super.onVisible();
    if (!state.isInitialLoaded) {
      handleIntent(const ArchitectureIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(ArchitectureIntent intent) {
    return intent.when<FutureOr<void>>(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true, type: LoadingType.page));

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    final sections = [
      ArchitectureSection(
        title: I18nKeys.cleanMVITitle.tr,
        icon: Icons.layers_outlined,
        content:
            'The app follows Clean Architecture principles to separate concerns into Data, Domain, and Presentation layers. '
            'On the Presentation layer, the MVI (Model-View-Intent) pattern ensures unidirectional data flow.',
      ),
      ArchitectureSection(
        title: I18nKeys.coreLibrariesTitle.tr,
        icon: Icons.library_books_outlined,
        content: '', // Container for libs
        libs: const [
          ArchitectureLibItem(name: 'Riverpod', desc: 'State management & DI'),
          ArchitectureLibItem(name: 'Freezed', desc: 'Code generation for immutable states'),
          ArchitectureLibItem(name: 'Dio & Retrofit', desc: 'Type-safe networking'),
          ArchitectureLibItem(name: 'Fpdart', desc: 'Functional programming (Either/Option)'),
        ],
      ),
      ArchitectureSection(
        title: I18nKeys.openSourceTitle.tr,
        icon: Icons.code_rounded,
        content: I18nKeys.openSourceDesc.tr,
        linkLabel: 'github.com/listen2code',
        linkUrl: AppConstants.github,
      ),
      ArchitectureSection(
        title: I18nKeys.backendDevOpsTitle.tr,
        icon: Icons.cloud_done_outlined,
        content:
            'The backend services are deployed on AWS using a serverless approach. Key services include Lambda, API Gateway, and DynamoDB.',
      ),
    ];

    updateState(
      state.copyWith(header: I18nKeys.architectureHeader.tr, sections: sections, isInitialLoaded: true),
    );

    emitEffect(LoadingEffect(false));
  }
}
