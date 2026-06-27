// Common mock helpers for tests
import 'package:mocktail/mocktail.dart';
import 'package:listen_core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_view_model.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_intent.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/architecture/architecture_state.dart';

// Mock AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

// Mock ArchitectureViewModel (already defined elsewhere but we can provide a generic mock)
class MockArchitectureViewModel extends Mock implements ArchitectureViewModel {}

// Register fallback values for intents if needed
void registerFallbacks() {
  registerFallbackValue(FakeArchitectureIntent());
}

// Fake intents for architecture
class FakeArchitectureIntent extends Fake implements ArchitectureIntent {}

// Fake ArchitectureViewModel to provide custom state in tests
class FakeArchitectureViewModel extends ArchitectureViewModel {
  final ArchitectureState _state;
  FakeArchitectureViewModel(this._state);
  @override
  ArchitectureState build() => _state;
}
