// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fault_injection_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FaultInjectionViewModel)
final faultInjectionViewModelProvider = FaultInjectionViewModelProvider._();

final class FaultInjectionViewModelProvider
    extends $NotifierProvider<FaultInjectionViewModel, FaultInjectionState> {
  FaultInjectionViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'faultInjectionViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$faultInjectionViewModelHash();

  @$internal
  @override
  FaultInjectionViewModel create() => FaultInjectionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FaultInjectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FaultInjectionState>(value),
    );
  }
}

String _$faultInjectionViewModelHash() =>
    r'68dae05f26a910b722f9c6885e07b6637198cb4d';

abstract class _$FaultInjectionViewModel
    extends $Notifier<FaultInjectionState> {
  FaultInjectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FaultInjectionState, FaultInjectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FaultInjectionState, FaultInjectionState>,
              FaultInjectionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
