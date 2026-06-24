// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResumeViewModel)
final resumeViewModelProvider = ResumeViewModelProvider._();

final class ResumeViewModelProvider
    extends $NotifierProvider<ResumeViewModel, ResumeState> {
  ResumeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resumeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resumeViewModelHash();

  @$internal
  @override
  ResumeViewModel create() => ResumeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResumeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResumeState>(value),
    );
  }
}

String _$resumeViewModelHash() => r'69deca78c234b98515211c75d8e53bdc24917067';

abstract class _$ResumeViewModel extends $Notifier<ResumeState> {
  ResumeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ResumeState, ResumeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResumeState, ResumeState>,
              ResumeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
