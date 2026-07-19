// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OverviewViewModel)
final overviewViewModelProvider = OverviewViewModelProvider._();

final class OverviewViewModelProvider
    extends $NotifierProvider<OverviewViewModel, OverviewState> {
  OverviewViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewViewModelHash();

  @$internal
  @override
  OverviewViewModel create() => OverviewViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverviewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverviewState>(value),
    );
  }
}

String _$overviewViewModelHash() => r'f15114361c68db320f99253063a4d1f488993273';

abstract class _$OverviewViewModel extends $Notifier<OverviewState> {
  OverviewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OverviewState, OverviewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OverviewState, OverviewState>,
              OverviewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
