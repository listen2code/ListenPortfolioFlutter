import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/network_info.dart';
import '../../data/datasources/auth/auth_local_data_source.dart';
import '../../data/datasources/auth/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/change_password_use_case.dart';
import '../../domain/usecases/auth/forgot_password_use_case.dart';
import '../../domain/usecases/auth/get_current_user_use_case.dart';
import '../../domain/usecases/auth/login_use_case.dart';
import '../../domain/usecases/auth/logout_use_case.dart';
import '../../domain/usecases/auth/signup_use_case.dart';

part 'auth_provider.g.dart';

// ============================================================================
// Infrastructure Providers
// ============================================================================

/// Provides FlutterSecureStorage instance
@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

/// Provides SharedPreferences instance
@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// Provides Connectivity instance
@riverpod
Connectivity connectivity(Ref ref) {
  return Connectivity();
}

/// Provides NetworkInfo instance
@riverpod
NetworkInfo networkInfo(Ref ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
}

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provides AuthRemoteDataSource instance
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource();
}

/// Provides AuthLocalDataSource instance
@riverpod
Future<AuthLocalDataSource> authLocalDataSource(Ref ref) async {
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPrefs = await ref.watch(sharedPreferencesProvider.future);

  return AuthLocalDataSource(secureStorage: secureStorage, sharedPreferences: sharedPrefs);
}

// ============================================================================
// Repository Providers
// ============================================================================

/// Provides AuthRepository instance
@riverpod
Future<AuthRepository> authRepository(Ref ref) async {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
  final networkInfo = ref.watch(networkInfoProvider);

  return AuthRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource, networkInfo: networkInfo);
}

// ============================================================================
// Use Case Providers
// ============================================================================

/// Provides LoginUseCase instance
@riverpod
Future<LoginUseCase> loginUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LoginUseCase(repository);
}

/// Provides SignupUseCase instance
@riverpod
Future<SignupUseCase> signupUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return SignupUseCase(repository);
}

/// Provides LogoutUseCase instance
@riverpod
Future<LogoutUseCase> logoutUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LogoutUseCase(repository);
}

/// Provides ForgotPasswordUseCase instance
@riverpod
Future<ForgotPasswordUseCase> forgotPasswordUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return ForgotPasswordUseCase(repository);
}

/// Provides ChangePasswordUseCase instance
@riverpod
Future<ChangePasswordUseCase> changePasswordUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return ChangePasswordUseCase(repository);
}

/// Provides GetCurrentUserUseCase instance
@riverpod
Future<GetCurrentUserUseCase> getCurrentUserUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return GetCurrentUserUseCase(repository);
}
