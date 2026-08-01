// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_account_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteAccountViewModel)
final deleteAccountViewModelProvider = DeleteAccountViewModelProvider._();

final class DeleteAccountViewModelProvider
    extends $NotifierProvider<DeleteAccountViewModel, DeleteAccountState> {
  DeleteAccountViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountViewModelHash();

  @$internal
  @override
  DeleteAccountViewModel create() => DeleteAccountViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteAccountState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteAccountState>(value),
    );
  }
}

String _$deleteAccountViewModelHash() =>
    r'1871c6b1368a477d5446342320fa25c8316014a3';

abstract class _$DeleteAccountViewModel extends $Notifier<DeleteAccountState> {
  DeleteAccountState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DeleteAccountState, DeleteAccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeleteAccountState, DeleteAccountState>,
              DeleteAccountState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
