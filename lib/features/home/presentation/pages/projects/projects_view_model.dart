import 'dart:async';

import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/project_model.dart';
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
    return intent.when<FutureOr<void>>(refresh: () => _onRefresh());
  }

  Future<void> _onRefresh() async {
    emitEffect(LoadingEffect(true, type: LoadingType.page));

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // In a real app, this would come from a Repository/UseCase via ref.execute
    final mockProjects = [
      const ProjectModel(
        title: 'lPortfolio',
        subtitle: 'Current App',
        desc:
            'This portfolio app! Built with Clean Architecture, MVI pattern, and Riverpod to demonstrate modern Flutter development practices.',
      ),
      const ProjectModel(
        title: 'AI Chatbot',
        subtitle: 'Dart & OpenAI',
        desc:
            'An intelligent conversational agent powered by GPT-4, supporting voice input and multi-language support.',
      ),
      const ProjectModel(
        title: 'Portfolio Web',
        subtitle: 'Flutter Web',
        desc:
            'A responsive personal website built with Flutter Web, showcasing projects and experience with smooth animations.',
      ),
      const ProjectModel(
        title: 'Android Perf Toolkit',
        subtitle: 'Optimization',
        desc:
            'An Android project focused on advanced profiling, memory leak detection, and rendering optimization tools for complex Android apps.',
      ),
      const ProjectModel(
        title: 'Flutter Gallery Pro',
        subtitle: 'UI/UX Showcases',
        desc:
            'A dedicated showcase app demonstrating complex animations, custom painters, and modern UI components for rapid prototyping.',
      ),
      const ProjectModel(
        title: 'Listen Core Plugin',
        subtitle: 'Architecture',
        desc:
            'Foundation plugin providing base classes, network wrappers, and utilities. Planned for release on pub.dev as an infrastructure base.',
      ),
      const ProjectModel(
        title: 'Listen UI Kit',
        subtitle: 'Common Widgets',
        desc:
            'A reusable widget library designed to speed up development and ensure design consistency across multiple Flutter projects.',
      ),
      const ProjectModel(
        title: 'English Learning App',
        subtitle: 'TODO',
        desc:
            'A comprehensive language learning platform featuring spaced repetition, AI speech recognition, and interactive lessons.',
      ),
      const ProjectModel(
        title: 'Video Player App',
        subtitle: 'TODO',
        desc:
            'A high-performance media player supporting local/network streaming, background playback, and picture-in-picture mode.',
      ),
    ];

    updateState(state.copyWith(projects: mockProjects, isInitialLoaded: true));

    emitEffect(LoadingEffect(false));
  }
}
