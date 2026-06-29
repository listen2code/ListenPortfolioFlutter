// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_tape_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlaybackTapeListViewModel)
final playbackTapeListViewModelProvider = PlaybackTapeListViewModelProvider._();

final class PlaybackTapeListViewModelProvider
    extends
        $NotifierProvider<PlaybackTapeListViewModel, PlaybackTapeListState> {
  PlaybackTapeListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playbackTapeListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackTapeListViewModelHash();

  @$internal
  @override
  PlaybackTapeListViewModel create() => PlaybackTapeListViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackTapeListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaybackTapeListState>(value),
    );
  }
}

String _$playbackTapeListViewModelHash() =>
    r'722322011e676cfc1e52c214a355b5ec524795e2';

abstract class _$PlaybackTapeListViewModel
    extends $Notifier<PlaybackTapeListState> {
  PlaybackTapeListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlaybackTapeListState, PlaybackTapeListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlaybackTapeListState, PlaybackTapeListState>,
              PlaybackTapeListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
