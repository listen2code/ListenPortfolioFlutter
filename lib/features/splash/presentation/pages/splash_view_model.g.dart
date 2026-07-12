// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashViewModel)
final splashViewModelProvider = SplashViewModelProvider._();

final class SplashViewModelProvider
    extends $NotifierProvider<SplashViewModel, SplashState> {
  SplashViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashViewModelHash();

  @$internal
  @override
  SplashViewModel create() => SplashViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplashState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplashState>(value),
    );
  }
}

String _$splashViewModelHash() => r'6610197de4535ff8a9ee61732278d54f52c63402';

abstract class _$SplashViewModel extends $Notifier<SplashState> {
  SplashState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SplashState, SplashState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SplashState, SplashState>,
              SplashState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
