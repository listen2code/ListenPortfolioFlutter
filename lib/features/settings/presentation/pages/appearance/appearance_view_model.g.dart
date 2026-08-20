// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppearanceViewModel)
final appearanceViewModelProvider = AppearanceViewModelProvider._();

final class AppearanceViewModelProvider
    extends $NotifierProvider<AppearanceViewModel, AppearanceState> {
  AppearanceViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appearanceViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appearanceViewModelHash();

  @$internal
  @override
  AppearanceViewModel create() => AppearanceViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppearanceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppearanceState>(value),
    );
  }
}

String _$appearanceViewModelHash() =>
    r'5ee7e0b66124d7c782d9aa79a29ba19a8209103c';

abstract class _$AppearanceViewModel extends $Notifier<AppearanceState> {
  AppearanceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppearanceState, AppearanceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppearanceState, AppearanceState>,
              AppearanceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
