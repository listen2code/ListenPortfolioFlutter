// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SignupRequestModel _$SignupRequestModelFromJson(Map<String, dynamic> json) {
  return _SignupRequestModel.fromJson(json);
}

/// @nodoc
mixin _$SignupRequestModel {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SignupRequestModel value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SignupRequestModel value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SignupRequestModel value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this SignupRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignupRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignupRequestModelCopyWith<SignupRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupRequestModelCopyWith<$Res> {
  factory $SignupRequestModelCopyWith(
    SignupRequestModel value,
    $Res Function(SignupRequestModel) then,
  ) = _$SignupRequestModelCopyWithImpl<$Res, SignupRequestModel>;
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class _$SignupRequestModelCopyWithImpl<$Res, $Val extends SignupRequestModel>
    implements $SignupRequestModelCopyWith<$Res> {
  _$SignupRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignupRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignupRequestModelImplCopyWith<$Res>
    implements $SignupRequestModelCopyWith<$Res> {
  factory _$$SignupRequestModelImplCopyWith(
    _$SignupRequestModelImpl value,
    $Res Function(_$SignupRequestModelImpl) then,
  ) = __$$SignupRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class __$$SignupRequestModelImplCopyWithImpl<$Res>
    extends _$SignupRequestModelCopyWithImpl<$Res, _$SignupRequestModelImpl>
    implements _$$SignupRequestModelImplCopyWith<$Res> {
  __$$SignupRequestModelImplCopyWithImpl(
    _$SignupRequestModelImpl _value,
    $Res Function(_$SignupRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignupRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(
      _$SignupRequestModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SignupRequestModelImpl implements _SignupRequestModel {
  const _$SignupRequestModelImpl({
    required this.name,
    required this.email,
    required this.password,
  });

  factory _$SignupRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignupRequestModelImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'SignupRequestModel(name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupRequestModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, email, password);

  /// Create a copy of SignupRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupRequestModelImplCopyWith<_$SignupRequestModelImpl> get copyWith =>
      __$$SignupRequestModelImplCopyWithImpl<_$SignupRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SignupRequestModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SignupRequestModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SignupRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SignupRequestModelImplToJson(this);
  }
}

abstract class _SignupRequestModel implements SignupRequestModel {
  const factory _SignupRequestModel({
    required final String name,
    required final String email,
    required final String password,
  }) = _$SignupRequestModelImpl;

  factory _SignupRequestModel.fromJson(Map<String, dynamic> json) =
      _$SignupRequestModelImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  String get password;

  /// Create a copy of SignupRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignupRequestModelImplCopyWith<_$SignupRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
