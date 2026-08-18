// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseAiService)
final firebaseAiServiceProvider = FirebaseAiServiceProvider._();

final class FirebaseAiServiceProvider
    extends
        $FunctionalProvider<
          FirebaseAiService,
          FirebaseAiService,
          FirebaseAiService
        >
    with $Provider<FirebaseAiService> {
  FirebaseAiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAiServiceHash();

  @$internal
  @override
  $ProviderElement<FirebaseAiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseAiService create(Ref ref) {
    return firebaseAiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAiService>(value),
    );
  }
}

String _$firebaseAiServiceHash() => r'65f95eafe1a6cbd8dd5d40ed0e1695683e63ec95';

@ProviderFor(aiChatRemoteDataSource)
final aiChatRemoteDataSourceProvider = AiChatRemoteDataSourceProvider._();

final class AiChatRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AiChatRemoteDataSource,
          AiChatRemoteDataSource,
          AiChatRemoteDataSource
        >
    with $Provider<AiChatRemoteDataSource> {
  AiChatRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AiChatRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiChatRemoteDataSource create(Ref ref) {
    return aiChatRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatRemoteDataSource>(value),
    );
  }
}

String _$aiChatRemoteDataSourceHash() =>
    r'842c74de6ab3bf237c80562205d477c987fb7643';

@ProviderFor(aiChatLocalDataSource)
final aiChatLocalDataSourceProvider = AiChatLocalDataSourceProvider._();

final class AiChatLocalDataSourceProvider
    extends
        $FunctionalProvider<
          AiChatLocalDataSource,
          AiChatLocalDataSource,
          AiChatLocalDataSource
        >
    with $Provider<AiChatLocalDataSource> {
  AiChatLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<AiChatLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiChatLocalDataSource create(Ref ref) {
    return aiChatLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatLocalDataSource>(value),
    );
  }
}

String _$aiChatLocalDataSourceHash() =>
    r'b9af256707ac00983895aa97f5904f38138d23d3';

@ProviderFor(aiChatRepository)
final aiChatRepositoryProvider = AiChatRepositoryProvider._();

final class AiChatRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AiChatRepository>,
          AiChatRepository,
          FutureOr<AiChatRepository>
        >
    with $FutureModifier<AiChatRepository>, $FutureProvider<AiChatRepository> {
  AiChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AiChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AiChatRepository> create(Ref ref) {
    return aiChatRepository(ref);
  }
}

String _$aiChatRepositoryHash() => r'bd6ff4f617b39a38d01217c313890dc5ffa2a2db';

@ProviderFor(sendChatMessageUseCase)
final sendChatMessageUseCaseProvider = SendChatMessageUseCaseProvider._();

final class SendChatMessageUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SendChatMessageUseCase>,
          SendChatMessageUseCase,
          FutureOr<SendChatMessageUseCase>
        >
    with
        $FutureModifier<SendChatMessageUseCase>,
        $FutureProvider<SendChatMessageUseCase> {
  SendChatMessageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendChatMessageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendChatMessageUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<SendChatMessageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SendChatMessageUseCase> create(Ref ref) {
    return sendChatMessageUseCase(ref);
  }
}

String _$sendChatMessageUseCaseHash() =>
    r'fd4bfb1eb6f2981783acecc8e93644ad0504e68c';

@ProviderFor(getPresetQaUseCase)
final getPresetQaUseCaseProvider = GetPresetQaUseCaseProvider._();

final class GetPresetQaUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetPresetQaUseCase>,
          GetPresetQaUseCase,
          FutureOr<GetPresetQaUseCase>
        >
    with
        $FutureModifier<GetPresetQaUseCase>,
        $FutureProvider<GetPresetQaUseCase> {
  GetPresetQaUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPresetQaUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPresetQaUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetPresetQaUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetPresetQaUseCase> create(Ref ref) {
    return getPresetQaUseCase(ref);
  }
}

String _$getPresetQaUseCaseHash() =>
    r'845797473118a3f40040533fd6ed980d677727d4';
