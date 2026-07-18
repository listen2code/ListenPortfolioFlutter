// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_policy_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PrivacyPolicyViewModel)
final privacyPolicyViewModelProvider = PrivacyPolicyViewModelProvider._();

final class PrivacyPolicyViewModelProvider
    extends $NotifierProvider<PrivacyPolicyViewModel, PrivacyPolicyState> {
  PrivacyPolicyViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyPolicyViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyPolicyViewModelHash();

  @$internal
  @override
  PrivacyPolicyViewModel create() => PrivacyPolicyViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivacyPolicyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivacyPolicyState>(value),
    );
  }
}

String _$privacyPolicyViewModelHash() =>
    r'c4489075c75af312b712a69a2797ec350a38e8e0';

abstract class _$PrivacyPolicyViewModel extends $Notifier<PrivacyPolicyState> {
  PrivacyPolicyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PrivacyPolicyState, PrivacyPolicyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PrivacyPolicyState, PrivacyPolicyState>,
              PrivacyPolicyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
