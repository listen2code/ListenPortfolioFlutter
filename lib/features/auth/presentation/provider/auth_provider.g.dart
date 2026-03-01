// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides Connectivity instance

@ProviderFor(connectivity)
final connectivityProvider = ConnectivityProvider._();

/// Provides Connectivity instance

final class ConnectivityProvider
    extends $FunctionalProvider<Connectivity, Connectivity, Connectivity>
    with $Provider<Connectivity> {
  /// Provides Connectivity instance
  ConnectivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityHash();

  @$internal
  @override
  $ProviderElement<Connectivity> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Connectivity create(Ref ref) {
    return connectivity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Connectivity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Connectivity>(value),
    );
  }
}

String _$connectivityHash() => r'6d67af0ea4110f6ee0246dd332f90f8901380eda';

/// Provides NetworkInfo instance

@ProviderFor(networkInfo)
final networkInfoProvider = NetworkInfoProvider._();

/// Provides NetworkInfo instance

final class NetworkInfoProvider
    extends $FunctionalProvider<NetworkInfo, NetworkInfo, NetworkInfo>
    with $Provider<NetworkInfo> {
  /// Provides NetworkInfo instance
  NetworkInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkInfoHash();

  @$internal
  @override
  $ProviderElement<NetworkInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkInfo create(Ref ref) {
    return networkInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkInfo>(value),
    );
  }
}

String _$networkInfoHash() => r'ff5904d9b92850789e49524fa786994adf155a46';

/// Provides AuthRemoteDataSource instance

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Provides AuthRemoteDataSource instance

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  /// Provides AuthRemoteDataSource instance
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'5243947b53bc9f9e13f388db97404083da7c618a';

/// Provides AuthLocalDataSource instance

@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider = AuthLocalDataSourceProvider._();

/// Provides AuthLocalDataSource instance

final class AuthLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AuthLocalDataSource,
          AuthLocalDataSource,
          AuthLocalDataSource
        >
    with $Provider<AuthLocalDataSource> {
  /// Provides AuthLocalDataSource instance
  AuthLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthLocalDataSource create(Ref ref) {
    return authLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthLocalDataSource>(value),
    );
  }
}

String _$authLocalDataSourceHash() =>
    r'051022609ef7f695fb79c429f69b9ed36fb15c57';

/// Provides AuthRepository instance

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Provides AuthRepository instance

final class AuthRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthRepository>,
          AuthRepository,
          FutureOr<AuthRepository>
        >
    with $FutureModifier<AuthRepository>, $FutureProvider<AuthRepository> {
  /// Provides AuthRepository instance
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AuthRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthRepository> create(Ref ref) {
    return authRepository(ref);
  }
}

String _$authRepositoryHash() => r'7f372f81091dce0d3f461b0fa38dec4c421dbc29';

/// Provides LoginUseCase instance

@ProviderFor(loginUseCase)
final loginUseCaseProvider = LoginUseCaseProvider._();

/// Provides LoginUseCase instance

final class LoginUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoginUseCase>,
          LoginUseCase,
          FutureOr<LoginUseCase>
        >
    with $FutureModifier<LoginUseCase>, $FutureProvider<LoginUseCase> {
  /// Provides LoginUseCase instance
  LoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<LoginUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoginUseCase> create(Ref ref) {
    return loginUseCase(ref);
  }
}

String _$loginUseCaseHash() => r'c2181e2bdc5e5daad91364700bacf4f904222209';

/// Provides SignupUseCase instance

@ProviderFor(signupUseCase)
final signupUseCaseProvider = SignupUseCaseProvider._();

/// Provides SignupUseCase instance

final class SignupUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SignupUseCase>,
          SignupUseCase,
          FutureOr<SignupUseCase>
        >
    with $FutureModifier<SignupUseCase>, $FutureProvider<SignupUseCase> {
  /// Provides SignupUseCase instance
  SignupUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<SignupUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SignupUseCase> create(Ref ref) {
    return signupUseCase(ref);
  }
}

String _$signupUseCaseHash() => r'5e1835d31b185193fab8613542ecffe6967c5b1a';

/// Provides LogoutUseCase instance

@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = LogoutUseCaseProvider._();

/// Provides LogoutUseCase instance

final class LogoutUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<LogoutUseCase>,
          LogoutUseCase,
          FutureOr<LogoutUseCase>
        >
    with $FutureModifier<LogoutUseCase>, $FutureProvider<LogoutUseCase> {
  /// Provides LogoutUseCase instance
  LogoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<LogoutUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LogoutUseCase> create(Ref ref) {
    return logoutUseCase(ref);
  }
}

String _$logoutUseCaseHash() => r'c2f70f215323b3aac11ccdc866fe03376d9247e5';

/// Provides ForgotPasswordUseCase instance

@ProviderFor(forgotPasswordUseCase)
final forgotPasswordUseCaseProvider = ForgotPasswordUseCaseProvider._();

/// Provides ForgotPasswordUseCase instance

final class ForgotPasswordUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<ForgotPasswordUseCase>,
          ForgotPasswordUseCase,
          FutureOr<ForgotPasswordUseCase>
        >
    with
        $FutureModifier<ForgotPasswordUseCase>,
        $FutureProvider<ForgotPasswordUseCase> {
  /// Provides ForgotPasswordUseCase instance
  ForgotPasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<ForgotPasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ForgotPasswordUseCase> create(Ref ref) {
    return forgotPasswordUseCase(ref);
  }
}

String _$forgotPasswordUseCaseHash() =>
    r'2f1e121d8ffd5fef9c26db8aa8ffad2bb7777a9f';

/// Provides ChangePasswordUseCase instance

@ProviderFor(changePasswordUseCase)
final changePasswordUseCaseProvider = ChangePasswordUseCaseProvider._();

/// Provides ChangePasswordUseCase instance

final class ChangePasswordUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChangePasswordUseCase>,
          ChangePasswordUseCase,
          FutureOr<ChangePasswordUseCase>
        >
    with
        $FutureModifier<ChangePasswordUseCase>,
        $FutureProvider<ChangePasswordUseCase> {
  /// Provides ChangePasswordUseCase instance
  ChangePasswordUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<ChangePasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChangePasswordUseCase> create(Ref ref) {
    return changePasswordUseCase(ref);
  }
}

String _$changePasswordUseCaseHash() =>
    r'e325c24a80cc16aa279822656c3ccf70e68557b8';

/// Provides GetCurrentUserUseCase instance

@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider = GetCurrentUserUseCaseProvider._();

/// Provides GetCurrentUserUseCase instance

final class GetCurrentUserUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetCurrentUserUseCase>,
          GetCurrentUserUseCase,
          FutureOr<GetCurrentUserUseCase>
        >
    with
        $FutureModifier<GetCurrentUserUseCase>,
        $FutureProvider<GetCurrentUserUseCase> {
  /// Provides GetCurrentUserUseCase instance
  GetCurrentUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentUserUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentUserUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetCurrentUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetCurrentUserUseCase> create(Ref ref) {
    return getCurrentUserUseCase(ref);
  }
}

String _$getCurrentUserUseCaseHash() =>
    r'5befefa06ce2b648b012af5ebb103d66dc61ab65';
