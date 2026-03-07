// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_of_service_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TermsOfServiceViewModel)
final termsOfServiceViewModelProvider = TermsOfServiceViewModelProvider._();

final class TermsOfServiceViewModelProvider
    extends $NotifierProvider<TermsOfServiceViewModel, TermsOfServiceState> {
  TermsOfServiceViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'termsOfServiceViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$termsOfServiceViewModelHash();

  @$internal
  @override
  TermsOfServiceViewModel create() => TermsOfServiceViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TermsOfServiceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TermsOfServiceState>(value),
    );
  }
}

String _$termsOfServiceViewModelHash() =>
    r'2d532f65fdaa2b5a4c46e293e7e9b52ec4186b2d';

abstract class _$TermsOfServiceViewModel
    extends $Notifier<TermsOfServiceState> {
  TermsOfServiceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TermsOfServiceState, TermsOfServiceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TermsOfServiceState, TermsOfServiceState>,
              TermsOfServiceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
