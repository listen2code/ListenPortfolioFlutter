// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_me_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AboutMeViewModel)
final aboutMeViewModelProvider = AboutMeViewModelProvider._();

final class AboutMeViewModelProvider
    extends $NotifierProvider<AboutMeViewModel, AboutMeState> {
  AboutMeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aboutMeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aboutMeViewModelHash();

  @$internal
  @override
  AboutMeViewModel create() => AboutMeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AboutMeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AboutMeState>(value),
    );
  }
}

String _$aboutMeViewModelHash() => r'70d01f9e67e3f3cfbf0dcf19e6d60628ae792e53';

abstract class _$AboutMeViewModel extends $Notifier<AboutMeState> {
  AboutMeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AboutMeState, AboutMeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AboutMeState, AboutMeState>,
              AboutMeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
