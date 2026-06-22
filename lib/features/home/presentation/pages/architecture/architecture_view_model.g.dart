// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'architecture_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ArchitectureViewModel)
final architectureViewModelProvider = ArchitectureViewModelProvider._();

final class ArchitectureViewModelProvider
    extends $NotifierProvider<ArchitectureViewModel, ArchitectureState> {
  ArchitectureViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'architectureViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$architectureViewModelHash();

  @$internal
  @override
  ArchitectureViewModel create() => ArchitectureViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArchitectureState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArchitectureState>(value),
    );
  }
}

String _$architectureViewModelHash() =>
    r'a40a557699826c19ad2d86f7018e64edacb8e392';

abstract class _$ArchitectureViewModel extends $Notifier<ArchitectureState> {
  ArchitectureState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ArchitectureState, ArchitectureState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ArchitectureState, ArchitectureState>,
              ArchitectureState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
