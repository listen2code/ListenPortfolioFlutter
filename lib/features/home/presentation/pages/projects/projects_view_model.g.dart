// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProjectsViewModel)
final projectsViewModelProvider = ProjectsViewModelProvider._();

final class ProjectsViewModelProvider
    extends $NotifierProvider<ProjectsViewModel, ProjectsState> {
  ProjectsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsViewModelHash();

  @$internal
  @override
  ProjectsViewModel create() => ProjectsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectsState>(value),
    );
  }
}

String _$projectsViewModelHash() => r'af3808c2c12e4d9b2ed35bb672b14b43a9f0a0b8';

abstract class _$ProjectsViewModel extends $Notifier<ProjectsState> {
  ProjectsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProjectsState, ProjectsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProjectsState, ProjectsState>,
              ProjectsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
