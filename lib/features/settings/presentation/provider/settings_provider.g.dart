// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRemoteDataSource)
final settingsRemoteDataSourceProvider = SettingsRemoteDataSourceProvider._();

final class SettingsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SettingsRemoteDataSource,
          SettingsRemoteDataSource,
          SettingsRemoteDataSource
        >
    with $Provider<SettingsRemoteDataSource> {
  SettingsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SettingsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRemoteDataSource create(Ref ref) {
    return settingsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRemoteDataSource>(value),
    );
  }
}

String _$settingsRemoteDataSourceHash() =>
    r'bf145193b55e146b4ca2d08e0572b85e50354451';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'3561b50b50da6edb14d5a8a92ec99dd7ac123c20';

@ProviderFor(checkUpdatesUseCase)
final checkUpdatesUseCaseProvider = CheckUpdatesUseCaseProvider._();

final class CheckUpdatesUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<CheckUpdatesUseCase>,
          CheckUpdatesUseCase,
          FutureOr<CheckUpdatesUseCase>
        >
    with
        $FutureModifier<CheckUpdatesUseCase>,
        $FutureProvider<CheckUpdatesUseCase> {
  CheckUpdatesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkUpdatesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkUpdatesUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<CheckUpdatesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CheckUpdatesUseCase> create(Ref ref) {
    return checkUpdatesUseCase(ref);
  }
}

String _$checkUpdatesUseCaseHash() =>
    r'7623f81be4cf680e6a9ee2533f44c8821683da5f';
