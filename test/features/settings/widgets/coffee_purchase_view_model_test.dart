import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/coffee_purchase/coffee_purchase_intent.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/coffee_purchase/coffee_purchase_state.dart';
import 'package:listen_portfolio_flutter/features/settings/presentation/pages/widgets/coffee_purchase/coffee_purchase_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockIapService extends Mock implements IIapService {}
class MockProductDetails extends Mock implements ProductDetails {}
class MockPurchaseDetails extends Mock implements PurchaseDetails {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockIapService mockIapService;
  late StreamController<List<PurchaseDetails>> purchaseStreamController;
  late ProviderContainer container;
  late ProviderSubscription subscription;
  late CoffeePurchaseViewModel viewModel;
  final List<BaseEffect> emittedEffects = [];

  setUpAll(() {
    registerFallbackValue(<String>{});
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SpUtil.init(prefix: 'test_');

    mockIapService = MockIapService();
    purchaseStreamController = StreamController<List<PurchaseDetails>>.broadcast();
    when(() => mockIapService.purchaseStream).thenAnswer((_) => purchaseStreamController.stream);
    iapService = mockIapService;
    emittedEffects.clear();
  });

  void initViewModel() {
    container = ProviderContainer();
    subscription = container.listen(coffeePurchaseViewModelProvider, (_, __) {});
    viewModel = container.read(coffeePurchaseViewModelProvider.notifier);
    viewModel.onBindEffect((effect) => emittedEffects.add(effect));
    viewModel.onInit();
  }

  tearDown(() {
    subscription.close();
    container.dispose();
    purchaseStreamController.close();
  });

  group('CoffeePurchaseViewModel Tests', () {
    test('Initial initialization triggers loadProducts and listens to stream', () async {
      when(() => mockIapService.queryProducts(any())).thenAnswer((_) async => []);

      initViewModel();

      final stateBefore = container.read(coffeePurchaseViewModelProvider);
      expect(stateBefore.isLoading, isTrue);
      expect(stateBefore.products, isEmpty);

      // Wait for async _onInit to execute
      await Future<void>.delayed(const Duration(milliseconds: 10));

      verify(() => mockIapService.queryProducts(any())).called(1);
      final stateAfter = container.read(coffeePurchaseViewModelProvider);
      expect(stateAfter.isLoading, isFalse);
    });

    test('Query products updates state with sorted products', () async {
      final p1 = MockProductDetails();
      final p2 = MockProductDetails();
      when(() => p1.id).thenReturn('coffee_1');
      when(() => p1.rawPrice).thenReturn(1.99);
      when(() => p2.id).thenReturn('coffee_2');
      when(() => p2.rawPrice).thenReturn(0.99);

      when(() => mockIapService.queryProducts(any())).thenAnswer((_) async => [p1, p2]);

      initViewModel();

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(coffeePurchaseViewModelProvider);
      expect(state.isLoading, isFalse);
      expect(state.products.length, 2);
      expect(state.products[0].id, 'coffee_2'); // Sorted lowest price first
      expect(state.products[1].id, 'coffee_1');
    });

    test('Query products failure emits error effect', () async {
      when(() => mockIapService.queryProducts(any())).thenThrow(Exception('IAP error'));

      initViewModel();

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(coffeePurchaseViewModelProvider);
      expect(state.isLoading, isFalse);
      expect(emittedEffects.any((e) => e is MessageEffect && e.type == MessageType.error), isTrue);
    });

    test('Buy product triggers purchasing state and calls buyProduct', () async {
      final p1 = MockProductDetails();
      when(() => p1.id).thenReturn('coffee_1');
      when(() => p1.rawPrice).thenReturn(1.99);
      when(() => mockIapService.queryProducts(any())).thenAnswer((_) async => [p1]);
      when(() => mockIapService.buyProduct(any())).thenAnswer((_) async => true);

      initViewModel();

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await viewModel.handleIntent(const CoffeePurchaseIntent.buyProduct('coffee_1'));

      final state = container.read(coffeePurchaseViewModelProvider);
      expect(state.isPurchasing, isTrue);
      expect(state.purchasingProductId, 'coffee_1');
      verify(() => mockIapService.buyProduct(p1)).called(1);
    });

    test('Purchase success completes purchase, pops page, and triggers rate app', () async {
      final p1 = MockProductDetails();
      when(() => p1.id).thenReturn('coffee_1');
      when(() => p1.rawPrice).thenReturn(1.99);
      when(() => mockIapService.queryProducts(any())).thenAnswer((_) async => [p1]);
      when(() => mockIapService.buyProduct(any())).thenAnswer((_) async => true);
      when(() => mockIapService.completePurchase(any())).thenAnswer((_) async {});

      initViewModel();

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await viewModel.handleIntent(const CoffeePurchaseIntent.buyProduct('coffee_1'));

      final mockPurchase = MockPurchaseDetails();
      when(() => mockPurchase.productID).thenReturn('coffee_1');
      when(() => mockPurchase.status).thenReturn(PurchaseStatus.purchased);

      purchaseStreamController.add([mockPurchase]);
      // Wait for stream updates
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(coffeePurchaseViewModelProvider);
      expect(state.isPurchasing, isFalse);
      expect(state.purchasingProductId, isNull);

      verify(() => mockIapService.completePurchase(mockPurchase)).called(1);
      expect(emittedEffects.any((e) => e is MessageEffect && e.type == MessageType.info), isTrue);
      expect(emittedEffects.any((e) => e is RateAppEffect), isTrue);
      expect(emittedEffects.any((e) => e is NavigationEffect && (e as NavigationEffect).isBack), isTrue);
    });

    test('Purchase error resets purchasing state and shows toast', () async {
      final p1 = MockProductDetails();
      when(() => p1.id).thenReturn('coffee_1');
      when(() => p1.rawPrice).thenReturn(1.99);
      when(() => mockIapService.queryProducts(any())).thenAnswer((_) async => [p1]);
      when(() => mockIapService.buyProduct(any())).thenAnswer((_) async => true);

      initViewModel();

      // Wait for initialization to complete
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await viewModel.handleIntent(const CoffeePurchaseIntent.buyProduct('coffee_1'));

      final mockPurchase = MockPurchaseDetails();
      when(() => mockPurchase.productID).thenReturn('coffee_1');
      when(() => mockPurchase.status).thenReturn(PurchaseStatus.error);

      purchaseStreamController.add([mockPurchase]);
      // Wait for stream updates
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(coffeePurchaseViewModelProvider);
      expect(state.isPurchasing, isFalse);
      expect(emittedEffects.any((e) => e is MessageEffect && e.type == MessageType.error), isTrue);
    });
  });
}
