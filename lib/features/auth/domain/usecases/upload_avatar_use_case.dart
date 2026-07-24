import 'package:fpdart/fpdart.dart';
import 'package:listen_core/core.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

/// Use case for uploading user avatar (Base64)
class UploadAvatarUseCase implements UseCase<UserModel?, String> {
  final AuthRepository repository;

  UploadAvatarUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel?>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return const Left(ValidationFailure('Base64 image data must not be empty'));
    }
    return await repository.uploadAvatar(base64Data: param);
  }
}
