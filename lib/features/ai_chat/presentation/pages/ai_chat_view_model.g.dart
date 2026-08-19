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

String _$aiChatViewModelHash() => r'3823649ad4417a8eb41b40383abe0c925f18c817';

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
