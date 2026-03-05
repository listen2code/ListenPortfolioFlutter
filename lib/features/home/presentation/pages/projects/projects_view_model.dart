import 'dart:async';

import 'package:flutter/material.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'projects_intent.dart';
import 'projects_state.dart';

part 'projects_view_model.g.dart';

@riverpod
class ProjectsViewModel extends _$ProjectsViewModel with ViewModelMixin<ProjectsState, ProjectsIntent> {
  @override
  ProjectsState build() => const ProjectsState();

  @override
  void onVisible() {
    super.onVisible();
    if (!state.isInitialLoaded) {
      handleIntent(const ProjectsIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(ProjectsIntent intent) {
    intent.when(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true));

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final mockProjects = [
      {
        'title': 'Listen Portfolio',
        'subtitle': 'Flutter',
        'desc': 'A professional portfolio showcasing clean architecture and MVI.',
        'color': Colors.blue,
      },
      {
        'title': 'Next Big Thing',
        'subtitle': 'TODO',
        'desc': 'Exciting new project coming soon using AI and Cloud technology.',
        'color': Colors.green,
      },
    ];

    updateState(state.copyWith(projects: mockProjects, isInitialLoaded: true));

    emitEffect(LoadingEffect(false));
  }
}
