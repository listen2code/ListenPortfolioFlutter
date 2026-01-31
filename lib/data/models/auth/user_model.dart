import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/auth/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for User with JSON serialization
/// Converts between JSON and domain entity
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
    String? bio,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert model to domain entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      bio: bio,
      createdAt: createdAt,
    );
  }

  /// Convert domain entity to model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      bio: user.bio,
      createdAt: user.createdAt,
    );
  }
}
