// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_log_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CrashLogListViewModel)
final crashLogListViewModelProvider = CrashLogListViewModelProvider._();

final class CrashLogListViewModelProvider
    extends $NotifierProvider<CrashLogListViewModel, CrashLogListState> {
  CrashLogListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashLogListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashLogListViewModelHash();

  @$internal
  @override
  CrashLogListViewModel create() => CrashLogListViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrashLogListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrashLogListState>(value),
    );
  }
}

String _$crashLogListViewModelHash() =>
    r'eef6e29b9703ce20828420fdfd568735ddc43b75';

abstract class _$CrashLogListViewModel extends $Notifier<CrashLogListState> {
  CrashLogListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CrashLogListState, CrashLogListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CrashLogListState, CrashLogListState>,
              CrashLogListState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
