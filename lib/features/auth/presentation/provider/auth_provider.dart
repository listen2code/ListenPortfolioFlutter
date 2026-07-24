import 'package:listen_core/core.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/change_password_use_case.dart';
import '../../domain/usecases/delete_account_use_case.dart';
import '../../domain/usecases/forgot_password_use_case.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../../domain/usecases/upload_avatar_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

// ============================================================================
// Data Source Providers
// ============================================================================

/// Provides AuthRemoteDataSource instance
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ApiClient.dio, baseUrl: AppEnv.apiBaseUrl);
}

/// Provides AuthLocalDataSource instance
@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSource();
}

// ============================================================================
// Repository Providers
// ============================================================================

/// Provides AuthRepository instance
@riverpod
Future<AuthRepository> authRepository(Ref ref) async {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);
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

/// Provides DeleteAccountUseCase instance
@riverpod
Future<DeleteAccountUseCase> deleteAccountUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return DeleteAccountUseCase(repository);
}

/// Provides UploadAvatarUseCase instance
@riverpod
Future<UploadAvatarUseCase> uploadAvatarUseCase(Ref ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return UploadAvatarUseCase(repository);
}
