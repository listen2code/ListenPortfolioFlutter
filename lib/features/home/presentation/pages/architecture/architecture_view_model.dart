import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import '../../../../../shared/shared.dart';
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
    return intent.when<FutureOr<void>>(
      refresh: () => _onRefresh(),
      launchURL: (url) => emitEffect(LaunchUrlEffect(url)),
    );
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true, type: LoadingType.page));

    // Simulate loading delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final sections = [
      ArchitectureSection(
        title: I18nKeys.cleanMVITitle.tr,
        icon: Icons.layers_outlined,
        content: I18nKeys.cleanMviDesc.tr,
      ),
      ArchitectureSection(
        title: I18nKeys.coreLibrariesTitle.tr,
        icon: Icons.library_books_outlined,
        content: '', // Container for libs
        libs: [
          ArchitectureLibItem(name: 'Riverpod', desc: I18nKeys.descRiverpod.tr),
          ArchitectureLibItem(name: 'Freezed', desc: I18nKeys.descFreezed.tr),
          ArchitectureLibItem(name: 'Dio & Retrofit', desc: I18nKeys.descDioRetrofit.tr),
          ArchitectureLibItem(name: 'Fpdart', desc: I18nKeys.descFpdart.tr),
        ],
      ),
      ArchitectureSection(
        title: I18nKeys.openSourceTitle.tr,
        icon: Icons.code_rounded,
        content: I18nKeys.openSourceDesc.tr,
        linkLabel: AppConstants.github,
        linkUrl: AppConstants.github,
      ),
      ArchitectureSection(
        title: I18nKeys.backendDevOpsTitle.tr,
        icon: Icons.cloud_done_outlined,
        content: I18nKeys.backendDevOpsDesc.tr,
      ),
    ];

    updateState(
      state.copyWith(header: I18nKeys.architectureHeader.tr, sections: sections, isInitialLoaded: true),
    );

    emitEffect(LoadingEffect(false));
  }
}
