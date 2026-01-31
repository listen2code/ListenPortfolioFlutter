// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginState {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get isPasswordVisible => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get usernameError => throw _privateConstructorUsedError;
  String? get passwordError => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginState value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginState value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginState value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginStateCopyWith<LoginState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
    LoginState value,
    $Res Function(LoginState) then,
  ) = _$LoginStateCopyWithImpl<$Res, LoginState>;
  @useResult
  $Res call({
    String username,
    String password,
    bool isPasswordVisible,
    bool isLoading,
    bool isSuccess,
    String? errorMessage,
    String? usernameError,
    String? passwordError,
  });
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? isPasswordVisible = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? usernameError = freezed,
    Object? passwordError = freezed,
  }) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            isPasswordVisible: null == isPasswordVisible
                ? _value.isPasswordVisible
                : isPasswordVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            usernameError: freezed == usernameError
                ? _value.usernameError
                : usernameError // ignore: cast_nullable_to_non_nullable
                      as String?,
            passwordError: freezed == passwordError
                ? _value.passwordError
                : passwordError // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginStateImplCopyWith<$Res>
    implements $LoginStateCopyWith<$Res> {
  factory _$$LoginStateImplCopyWith(
    _$LoginStateImpl value,
    $Res Function(_$LoginStateImpl) then,
  ) = __$$LoginStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String username,
    String password,
    bool isPasswordVisible,
    bool isLoading,
    bool isSuccess,
    String? errorMessage,
    String? usernameError,
    String? passwordError,
  });
}

/// @nodoc
class __$$LoginStateImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginStateImpl>
    implements _$$LoginStateImplCopyWith<$Res> {
  __$$LoginStateImplCopyWithImpl(
    _$LoginStateImpl _value,
    $Res Function(_$LoginStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? isPasswordVisible = null,
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? usernameError = freezed,
    Object? passwordError = freezed,
  }) {
    return _then(
      _$LoginStateImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        isPasswordVisible: null == isPasswordVisible
            ? _value.isPasswordVisible
            : isPasswordVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        usernameError: freezed == usernameError
            ? _value.usernameError
            : usernameError // ignore: cast_nullable_to_non_nullable
                  as String?,
        passwordError: freezed == passwordError
            ? _value.passwordError
            : passwordError // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LoginStateImpl implements _LoginState {
  const _$LoginStateImpl({
    this.username = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.usernameError,
    this.passwordError,
  });

  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final bool isPasswordVisible;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  final String? errorMessage;
  @override
  final String? usernameError;
  @override
  final String? passwordError;

  @override
  String toString() {
    return 'LoginState(username: $username, password: $password, isPasswordVisible: $isPasswordVisible, isLoading: $isLoading, isSuccess: $isSuccess, errorMessage: $errorMessage, usernameError: $usernameError, passwordError: $passwordError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginStateImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.usernameError, usernameError) ||
                other.usernameError == usernameError) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    username,
    password,
    isPasswordVisible,
    isLoading,
    isSuccess,
    errorMessage,
    usernameError,
    passwordError,
  );

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginStateImplCopyWith<_$LoginStateImpl> get copyWith =>
      __$$LoginStateImplCopyWithImpl<_$LoginStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LoginState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LoginState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LoginState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _LoginState implements LoginState {
  const factory _LoginState({
    final String username,
    final String password,
    final bool isPasswordVisible,
    final bool isLoading,
    final bool isSuccess,
    final String? errorMessage,
    final String? usernameError,
    final String? passwordError,
  }) = _$LoginStateImpl;

  @override
  String get username;
  @override
  String get password;
  @override
  bool get isPasswordVisible;
  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  String? get errorMessage;
  @override
  String? get usernameError;
  @override
  String? get passwordError;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginStateImplCopyWith<_$LoginStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
