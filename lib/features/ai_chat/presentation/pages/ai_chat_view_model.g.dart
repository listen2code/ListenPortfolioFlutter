// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChatViewModel)
final aiChatViewModelProvider = AiChatViewModelProvider._();

final class AiChatViewModelProvider
    extends $NotifierProvider<AiChatViewModel, AiChatState> {
  AiChatViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatViewModelHash();

  @$internal
  @override
  AiChatViewModel create() => AiChatViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiChatState>(value),
    );
  }
}

String _$aiChatViewModelHash() => r'42e5be62bfa95a51b05d8f182496f77bdd162188';

abstract class _$AiChatViewModel extends $Notifier<AiChatState> {
  AiChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AiChatState, AiChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiChatState, AiChatState>,
              AiChatState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
