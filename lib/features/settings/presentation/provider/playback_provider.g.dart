// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(playbackTapeRepository)
final playbackTapeRepositoryProvider = PlaybackTapeRepositoryProvider._();

final class PlaybackTapeRepositoryProvider
    extends
        $FunctionalProvider<
          PlaybackTapeRepository,
          PlaybackTapeRepository,
          PlaybackTapeRepository
        >
    with $Provider<PlaybackTapeRepository> {
  PlaybackTapeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackTapeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackTapeRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlaybackTapeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlaybackTapeRepository create(Ref ref) {
    return playbackTapeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackTapeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackTapeRepository>(value),
    );
  }
}

String _$playbackTapeRepositoryHash() =>
    r'40ac34994afa816ebd8b3a1158452a8d4bcb8639';

@ProviderFor(getPlaybackTapesUseCase)
final getPlaybackTapesUseCaseProvider = GetPlaybackTapesUseCaseProvider._();

final class GetPlaybackTapesUseCaseProvider
    extends
        $FunctionalProvider<
          GetPlaybackTapesUseCase,
          GetPlaybackTapesUseCase,
          GetPlaybackTapesUseCase
        >
    with $Provider<GetPlaybackTapesUseCase> {
  GetPlaybackTapesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPlaybackTapesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPlaybackTapesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPlaybackTapesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPlaybackTapesUseCase create(Ref ref) {
    return getPlaybackTapesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPlaybackTapesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPlaybackTapesUseCase>(value),
    );
  }
}

String _$getPlaybackTapesUseCaseHash() =>
    r'aaf2a35a0553b9439fe9bdf403b5526b96489bc4';

@ProviderFor(getPlaybackTapeStepsUseCase)
final getPlaybackTapeStepsUseCaseProvider =
    GetPlaybackTapeStepsUseCaseProvider._();

final class GetPlaybackTapeStepsUseCaseProvider
    extends
        $FunctionalProvider<
          GetPlaybackTapeStepsUseCase,
          GetPlaybackTapeStepsUseCase,
          GetPlaybackTapeStepsUseCase
        >
    with $Provider<GetPlaybackTapeStepsUseCase> {
  GetPlaybackTapeStepsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPlaybackTapeStepsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPlaybackTapeStepsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPlaybackTapeStepsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPlaybackTapeStepsUseCase create(Ref ref) {
    return getPlaybackTapeStepsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPlaybackTapeStepsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPlaybackTapeStepsUseCase>(value),
    );
  }
}

String _$getPlaybackTapeStepsUseCaseHash() =>
    r'25f0691c06960877c89fd6cf46f9120b9f097c84';

@ProviderFor(deletePlaybackTapeUseCase)
final deletePlaybackTapeUseCaseProvider = DeletePlaybackTapeUseCaseProvider._();

final class DeletePlaybackTapeUseCaseProvider
    extends
        $FunctionalProvider<
          DeletePlaybackTapeUseCase,
          DeletePlaybackTapeUseCase,
          DeletePlaybackTapeUseCase
        >
    with $Provider<DeletePlaybackTapeUseCase> {
  DeletePlaybackTapeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletePlaybackTapeUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletePlaybackTapeUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeletePlaybackTapeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeletePlaybackTapeUseCase create(Ref ref) {
    return deletePlaybackTapeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeletePlaybackTapeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeletePlaybackTapeUseCase>(value),
    );
  }
}

String _$deletePlaybackTapeUseCaseHash() =>
    r'379bbdf3d80e96c372b824c5a994beb84362a600';
