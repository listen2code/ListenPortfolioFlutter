import 'package:mocktail/mocktail.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_state.dart';

/// ============================================================================
/// Mock & Fake Harness Utilities for MVI Testing
/// ============================================================================
///
/// This file consolidates reusable mock implementations and fake state providers
/// utilizing `mocktail` for deterministic unit and widget testing.
///
/// Design Patterns:
/// 1. **Mocks (Behavior Verification & Method Stubs)**:
///    Used when verifying interactions (e.g. `verify(() => repo.login(...)).called(1)`)
///    or stubbing dynamic return futures (`when(() => ...).thenAnswer(...)`).
///
/// 2. **Fakes (Deterministic State Injection)**:
///    Subclasses of ViewModels that return a static, immutable State snapshot.
///    Useful for widget tests where we want to test a specific UI layout without
///    triggering complex asynchronous intent pipelines.

/// Mock implementation of [AuthRepository] for authentication domain tests.
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock implementation of [ArchitectureViewModel] for interaction verification.
class MockArchitectureViewModel extends Mock implements ArchitectureViewModel {}

/// Fallback registration for Mocktail matching arguments.
///
/// When using `any()` with custom non-primitive types in `when()` or `verify()`,
/// Mocktail requires explicit fallback values to prevent runtime type mismatch.
void registerFallbacks() {
  registerFallbackValue(FakeArchitectureIntent());
}

/// Fake implementation of [ArchitectureIntent] to satisfy Mocktail's fallback contract.
class FakeArchitectureIntent extends Fake implements ArchitectureIntent {}

/// Fake implementation of [ArchitectureViewModel] that injects a predetermined [ArchitectureState].
///
/// This bypasses asynchronous use-case fetching and provides instant, synchronous
/// state delivery for rapid widget snapshot verification.
class FakeArchitectureViewModel extends ArchitectureViewModel {
  final ArchitectureState _state;
  
  FakeArchitectureViewModel(this._state);
  
  @override
  ArchitectureState build() => _state;
}
