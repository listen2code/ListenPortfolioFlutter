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
          AsyncValue<GetPlaybackTapesUseCase>,
          GetPlaybackTapesUseCase,
          FutureOr<GetPlaybackTapesUseCase>
        >
    with
        $FutureModifier<GetPlaybackTapesUseCase>,
        $FutureProvider<GetPlaybackTapesUseCase> {
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
  $FutureProviderElement<GetPlaybackTapesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetPlaybackTapesUseCase> create(Ref ref) {
    return getPlaybackTapesUseCase(ref);
  }
}

String _$getPlaybackTapesUseCaseHash() =>
    r'0b47847eaa49bf26afff2c1a0f362e1229b8b23d';

@ProviderFor(getPlaybackTapeStepsUseCase)
final getPlaybackTapeStepsUseCaseProvider =
    GetPlaybackTapeStepsUseCaseProvider._();

final class GetPlaybackTapeStepsUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetPlaybackTapeStepsUseCase>,
          GetPlaybackTapeStepsUseCase,
          FutureOr<GetPlaybackTapeStepsUseCase>
        >
    with
        $FutureModifier<GetPlaybackTapeStepsUseCase>,
        $FutureProvider<GetPlaybackTapeStepsUseCase> {
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
  $FutureProviderElement<GetPlaybackTapeStepsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetPlaybackTapeStepsUseCase> create(Ref ref) {
    return getPlaybackTapeStepsUseCase(ref);
  }
}

String _$getPlaybackTapeStepsUseCaseHash() =>
    r'6f19db152a6e2da2dcd29c90771b32307b7bf132';

@ProviderFor(deletePlaybackTapeUseCase)
final deletePlaybackTapeUseCaseProvider = DeletePlaybackTapeUseCaseProvider._();

final class DeletePlaybackTapeUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeletePlaybackTapeUseCase>,
          DeletePlaybackTapeUseCase,
          FutureOr<DeletePlaybackTapeUseCase>
        >
    with
        $FutureModifier<DeletePlaybackTapeUseCase>,
        $FutureProvider<DeletePlaybackTapeUseCase> {
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
  $FutureProviderElement<DeletePlaybackTapeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeletePlaybackTapeUseCase> create(Ref ref) {
    return deletePlaybackTapeUseCase(ref);
  }
}

String _$deletePlaybackTapeUseCaseHash() =>
    r'f255f8a10941cea323748b45f9092d15bf7a3923';
