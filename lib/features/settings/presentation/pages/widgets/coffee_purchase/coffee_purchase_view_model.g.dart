// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_purchase_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CoffeePurchaseViewModel)
final coffeePurchaseViewModelProvider = CoffeePurchaseViewModelProvider._();

final class CoffeePurchaseViewModelProvider
    extends $NotifierProvider<CoffeePurchaseViewModel, CoffeePurchaseState> {
  CoffeePurchaseViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coffeePurchaseViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coffeePurchaseViewModelHash();

  @$internal
  @override
  CoffeePurchaseViewModel create() => CoffeePurchaseViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoffeePurchaseState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoffeePurchaseState>(value),
    );
  }
}

String _$coffeePurchaseViewModelHash() =>
    r'3114e4692bd2746c27a40a936207301f942dc5f1';

abstract class _$CoffeePurchaseViewModel
    extends $Notifier<CoffeePurchaseState> {
  CoffeePurchaseState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CoffeePurchaseState, CoffeePurchaseState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CoffeePurchaseState, CoffeePurchaseState>,
              CoffeePurchaseState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
