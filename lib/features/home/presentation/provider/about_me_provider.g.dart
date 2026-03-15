// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_me_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aboutMeRemoteDataSource)
final aboutMeRemoteDataSourceProvider = AboutMeRemoteDataSourceProvider._();

final class AboutMeRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AboutMeRemoteDataSource,
          AboutMeRemoteDataSource,
          AboutMeRemoteDataSource
        >
    with $Provider<AboutMeRemoteDataSource> {
  AboutMeRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutMeRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutMeRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AboutMeRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AboutMeRemoteDataSource create(Ref ref) {
    return aboutMeRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutMeRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutMeRemoteDataSource>(value),
    );
  }
}

String _$aboutMeRemoteDataSourceHash() =>
    r'f3fea75a1ac8ad6d6b182df5a9f71c6ef9ff3fb1';

@ProviderFor(aboutMeLocalDataSource)
final aboutMeLocalDataSourceProvider = AboutMeLocalDataSourceProvider._();

final class AboutMeLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AboutMeLocalDataSource,
          AboutMeLocalDataSource,
          AboutMeLocalDataSource
        >
    with $Provider<AboutMeLocalDataSource> {
  AboutMeLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutMeLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutMeLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AboutMeLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AboutMeLocalDataSource create(Ref ref) {
    return aboutMeLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutMeLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutMeLocalDataSource>(value),
    );
  }
}

String _$aboutMeLocalDataSourceHash() =>
    r'023b7b56356300df4213f4d9c01c9fe0a92ca1f0';

@ProviderFor(aboutMeRepository)
final aboutMeRepositoryProvider = AboutMeRepositoryProvider._();

final class AboutMeRepositoryProvider
    extends
        $FunctionalProvider<
          AboutMeRepository,
          AboutMeRepository,
          AboutMeRepository
        >
    with $Provider<AboutMeRepository> {
  AboutMeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutMeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutMeRepositoryHash();

  @$internal
  @override
  $ProviderElement<AboutMeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AboutMeRepository create(Ref ref) {
    return aboutMeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutMeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutMeRepository>(value),
    );
  }
}

String _$aboutMeRepositoryHash() => r'a9f225d174267a9806323e620558170ab1ebab8f';

@ProviderFor(getAboutMeUseCase)
final getAboutMeUseCaseProvider = GetAboutMeUseCaseProvider._();

final class GetAboutMeUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetAboutMeUseCase>,
          GetAboutMeUseCase,
          FutureOr<GetAboutMeUseCase>
        >
    with
        $FutureModifier<GetAboutMeUseCase>,
        $FutureProvider<GetAboutMeUseCase> {
  GetAboutMeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAboutMeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAboutMeUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetAboutMeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetAboutMeUseCase> create(Ref ref) {
    return getAboutMeUseCase(ref);
  }
}

String _$getAboutMeUseCaseHash() => r'c3e1c912c51cf8c8a98cf770db619547861958bb';
