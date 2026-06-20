// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_me_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel for the About Me page
///
/// Manages the state and business logic for displaying and editing user profile information.
/// Handles data fetching, image selection, and state updates following the MVI pattern.

@ProviderFor(AboutMeViewModel)
final aboutMeViewModelProvider = AboutMeViewModelProvider._();

/// ViewModel for the About Me page
///
/// Manages the state and business logic for displaying and editing user profile information.
/// Handles data fetching, image selection, and state updates following the MVI pattern.
final class AboutMeViewModelProvider
    extends $NotifierProvider<AboutMeViewModel, AboutMeState> {
  /// ViewModel for the About Me page
  ///
  /// Manages the state and business logic for displaying and editing user profile information.
  /// Handles data fetching, image selection, and state updates following the MVI pattern.
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

String _$aboutMeViewModelHash() => r'2345bb8d40a2edfe3a21f179b3da5716c9c3431d';

/// ViewModel for the About Me page
///
/// Manages the state and business logic for displaying and editing user profile information.
/// Handles data fetching, image selection, and state updates following the MVI pattern.

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
