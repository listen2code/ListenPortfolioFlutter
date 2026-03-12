// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectsRemoteDataSource)
final projectsRemoteDataSourceProvider = ProjectsRemoteDataSourceProvider._();

final class ProjectsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ProjectsRemoteDataSource,
          ProjectsRemoteDataSource,
          ProjectsRemoteDataSource
        >
    with $Provider<ProjectsRemoteDataSource> {
  ProjectsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProjectsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectsRemoteDataSource create(Ref ref) {
    return projectsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectsRemoteDataSource>(value),
    );
  }
}

String _$projectsRemoteDataSourceHash() =>
    r'64ba84727c6bb59fc7617448ef80ea53abbf9ed6';

@ProviderFor(projectsLocalDataSource)
final projectsLocalDataSourceProvider = ProjectsLocalDataSourceProvider._();

final class ProjectsLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ProjectsLocalDataSource,
          ProjectsLocalDataSource,
          ProjectsLocalDataSource
        >
    with $Provider<ProjectsLocalDataSource> {
  ProjectsLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProjectsLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectsLocalDataSource create(Ref ref) {
    return projectsLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectsLocalDataSource>(value),
    );
  }
}

String _$projectsLocalDataSourceHash() =>
    r'032840cc81a2e05b6febe6f7e47c15bd434437c3';

@ProviderFor(projectsRepository)
final projectsRepositoryProvider = ProjectsRepositoryProvider._();

final class ProjectsRepositoryProvider
    extends
        $FunctionalProvider<
          ProjectsRepository,
          ProjectsRepository,
          ProjectsRepository
        >
    with $Provider<ProjectsRepository> {
  ProjectsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProjectsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProjectsRepository create(Ref ref) {
    return projectsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectsRepository>(value),
    );
  }
}

String _$projectsRepositoryHash() =>
    r'6467ecf8f1a33db8ba59f10b9f4a37026b07d257';

/// Define as Future to support ref.execute extension

@ProviderFor(getProjectsUseCase)
final getProjectsUseCaseProvider = GetProjectsUseCaseProvider._();

/// Define as Future to support ref.execute extension

final class GetProjectsUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetProjectsUseCase>,
          GetProjectsUseCase,
          FutureOr<GetProjectsUseCase>
        >
    with
        $FutureModifier<GetProjectsUseCase>,
        $FutureProvider<GetProjectsUseCase> {
  /// Define as Future to support ref.execute extension
  GetProjectsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getProjectsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getProjectsUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetProjectsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetProjectsUseCase> create(Ref ref) {
    return getProjectsUseCase(ref);
  }
}

String _$getProjectsUseCaseHash() =>
    r'28c5005405fafcd14fa62d613d22705b519c71ec';
