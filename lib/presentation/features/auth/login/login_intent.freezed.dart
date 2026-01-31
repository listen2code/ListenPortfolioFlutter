// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginIntent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginIntentCopyWith<$Res> {
  factory $LoginIntentCopyWith(
    LoginIntent value,
    $Res Function(LoginIntent) then,
  ) = _$LoginIntentCopyWithImpl<$Res, LoginIntent>;
}

/// @nodoc
class _$LoginIntentCopyWithImpl<$Res, $Val extends LoginIntent>
    implements $LoginIntentCopyWith<$Res> {
  _$LoginIntentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UsernameChangedImplCopyWith<$Res> {
  factory _$$UsernameChangedImplCopyWith(
    _$UsernameChangedImpl value,
    $Res Function(_$UsernameChangedImpl) then,
  ) = __$$UsernameChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String username});
}

/// @nodoc
class __$$UsernameChangedImplCopyWithImpl<$Res>
    extends _$LoginIntentCopyWithImpl<$Res, _$UsernameChangedImpl>
    implements _$$UsernameChangedImplCopyWith<$Res> {
  __$$UsernameChangedImplCopyWithImpl(
    _$UsernameChangedImpl _value,
    $Res Function(_$UsernameChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null}) {
    return _then(
      _$UsernameChangedImpl(
        null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UsernameChangedImpl implements UsernameChanged {
  const _$UsernameChangedImpl(this.username);

  @override
  final String username;

  @override
  String toString() {
    return 'LoginIntent.usernameChanged(username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsernameChangedImpl &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @override
  int get hashCode => Object.hash(runtimeType, username);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsernameChangedImplCopyWith<_$UsernameChangedImpl> get copyWith =>
      __$$UsernameChangedImplCopyWithImpl<_$UsernameChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) {
    return usernameChanged(username);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) {
    return usernameChanged?.call(username);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (usernameChanged != null) {
      return usernameChanged(username);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) {
    return usernameChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) {
    return usernameChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (usernameChanged != null) {
      return usernameChanged(this);
    }
    return orElse();
  }
}

abstract class UsernameChanged implements LoginIntent {
  const factory UsernameChanged(final String username) = _$UsernameChangedImpl;

  String get username;

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsernameChangedImplCopyWith<_$UsernameChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PasswordChangedImplCopyWith<$Res> {
  factory _$$PasswordChangedImplCopyWith(
    _$PasswordChangedImpl value,
    $Res Function(_$PasswordChangedImpl) then,
  ) = __$$PasswordChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$PasswordChangedImplCopyWithImpl<$Res>
    extends _$LoginIntentCopyWithImpl<$Res, _$PasswordChangedImpl>
    implements _$$PasswordChangedImplCopyWith<$Res> {
  __$$PasswordChangedImplCopyWithImpl(
    _$PasswordChangedImpl _value,
    $Res Function(_$PasswordChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = null}) {
    return _then(
      _$PasswordChangedImpl(
        null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PasswordChangedImpl implements PasswordChanged {
  const _$PasswordChangedImpl(this.password);

  @override
  final String password;

  @override
  String toString() {
    return 'LoginIntent.passwordChanged(password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordChangedImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, password);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordChangedImplCopyWith<_$PasswordChangedImpl> get copyWith =>
      __$$PasswordChangedImplCopyWithImpl<_$PasswordChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) {
    return passwordChanged(password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) {
    return passwordChanged?.call(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class PasswordChanged implements LoginIntent {
  const factory PasswordChanged(final String password) = _$PasswordChangedImpl;

  String get password;

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordChangedImplCopyWith<_$PasswordChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TogglePasswordVisibilityImplCopyWith<$Res> {
  factory _$$TogglePasswordVisibilityImplCopyWith(
    _$TogglePasswordVisibilityImpl value,
    $Res Function(_$TogglePasswordVisibilityImpl) then,
  ) = __$$TogglePasswordVisibilityImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TogglePasswordVisibilityImplCopyWithImpl<$Res>
    extends _$LoginIntentCopyWithImpl<$Res, _$TogglePasswordVisibilityImpl>
    implements _$$TogglePasswordVisibilityImplCopyWith<$Res> {
  __$$TogglePasswordVisibilityImplCopyWithImpl(
    _$TogglePasswordVisibilityImpl _value,
    $Res Function(_$TogglePasswordVisibilityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TogglePasswordVisibilityImpl implements TogglePasswordVisibility {
  const _$TogglePasswordVisibilityImpl();

  @override
  String toString() {
    return 'LoginIntent.togglePasswordVisibility()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TogglePasswordVisibilityImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) {
    return togglePasswordVisibility();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) {
    return togglePasswordVisibility?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (togglePasswordVisibility != null) {
      return togglePasswordVisibility();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) {
    return togglePasswordVisibility(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) {
    return togglePasswordVisibility?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (togglePasswordVisibility != null) {
      return togglePasswordVisibility(this);
    }
    return orElse();
  }
}

abstract class TogglePasswordVisibility implements LoginIntent {
  const factory TogglePasswordVisibility() = _$TogglePasswordVisibilityImpl;
}

/// @nodoc
abstract class _$$SubmitLoginImplCopyWith<$Res> {
  factory _$$SubmitLoginImplCopyWith(
    _$SubmitLoginImpl value,
    $Res Function(_$SubmitLoginImpl) then,
  ) = __$$SubmitLoginImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SubmitLoginImplCopyWithImpl<$Res>
    extends _$LoginIntentCopyWithImpl<$Res, _$SubmitLoginImpl>
    implements _$$SubmitLoginImplCopyWith<$Res> {
  __$$SubmitLoginImplCopyWithImpl(
    _$SubmitLoginImpl _value,
    $Res Function(_$SubmitLoginImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SubmitLoginImpl implements SubmitLogin {
  const _$SubmitLoginImpl();

  @override
  String toString() {
    return 'LoginIntent.submitLogin()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SubmitLoginImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) {
    return submitLogin();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) {
    return submitLogin?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (submitLogin != null) {
      return submitLogin();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) {
    return submitLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) {
    return submitLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (submitLogin != null) {
      return submitLogin(this);
    }
    return orElse();
  }
}

abstract class SubmitLogin implements LoginIntent {
  const factory SubmitLogin() = _$SubmitLoginImpl;
}

/// @nodoc
abstract class _$$NavigateToSignupImplCopyWith<$Res> {
  factory _$$NavigateToSignupImplCopyWith(
    _$NavigateToSignupImpl value,
    $Res Function(_$NavigateToSignupImpl) then,
  ) = __$$NavigateToSignupImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NavigateToSignupImplCopyWithImpl<$Res>
    extends _$LoginIntentCopyWithImpl<$Res, _$NavigateToSignupImpl>
    implements _$$NavigateToSignupImplCopyWith<$Res> {
  __$$NavigateToSignupImplCopyWithImpl(
    _$NavigateToSignupImpl _value,
    $Res Function(_$NavigateToSignupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NavigateToSignupImpl implements NavigateToSignup {
  const _$NavigateToSignupImpl();

  @override
  String toString() {
    return 'LoginIntent.navigateToSignup()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NavigateToSignupImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) {
    return navigateToSignup();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) {
    return navigateToSignup?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (navigateToSignup != null) {
      return navigateToSignup();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) {
    return navigateToSignup(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) {
    return navigateToSignup?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (navigateToSignup != null) {
      return navigateToSignup(this);
    }
    return orElse();
  }
}

abstract class NavigateToSignup implements LoginIntent {
  const factory NavigateToSignup() = _$NavigateToSignupImpl;
}

/// @nodoc
abstract class _$$NavigateToForgotPasswordImplCopyWith<$Res> {
  factory _$$NavigateToForgotPasswordImplCopyWith(
    _$NavigateToForgotPasswordImpl value,
    $Res Function(_$NavigateToForgotPasswordImpl) then,
  ) = __$$NavigateToForgotPasswordImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NavigateToForgotPasswordImplCopyWithImpl<$Res>
    extends _$LoginIntentCopyWithImpl<$Res, _$NavigateToForgotPasswordImpl>
    implements _$$NavigateToForgotPasswordImplCopyWith<$Res> {
  __$$NavigateToForgotPasswordImplCopyWithImpl(
    _$NavigateToForgotPasswordImpl _value,
    $Res Function(_$NavigateToForgotPasswordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginIntent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NavigateToForgotPasswordImpl implements NavigateToForgotPassword {
  const _$NavigateToForgotPasswordImpl();

  @override
  String toString() {
    return 'LoginIntent.navigateToForgotPassword()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NavigateToForgotPasswordImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String username) usernameChanged,
    required TResult Function(String password) passwordChanged,
    required TResult Function() togglePasswordVisibility,
    required TResult Function() submitLogin,
    required TResult Function() navigateToSignup,
    required TResult Function() navigateToForgotPassword,
  }) {
    return navigateToForgotPassword();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String username)? usernameChanged,
    TResult? Function(String password)? passwordChanged,
    TResult? Function()? togglePasswordVisibility,
    TResult? Function()? submitLogin,
    TResult? Function()? navigateToSignup,
    TResult? Function()? navigateToForgotPassword,
  }) {
    return navigateToForgotPassword?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String username)? usernameChanged,
    TResult Function(String password)? passwordChanged,
    TResult Function()? togglePasswordVisibility,
    TResult Function()? submitLogin,
    TResult Function()? navigateToSignup,
    TResult Function()? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (navigateToForgotPassword != null) {
      return navigateToForgotPassword();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsernameChanged value) usernameChanged,
    required TResult Function(PasswordChanged value) passwordChanged,
    required TResult Function(TogglePasswordVisibility value)
    togglePasswordVisibility,
    required TResult Function(SubmitLogin value) submitLogin,
    required TResult Function(NavigateToSignup value) navigateToSignup,
    required TResult Function(NavigateToForgotPassword value)
    navigateToForgotPassword,
  }) {
    return navigateToForgotPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsernameChanged value)? usernameChanged,
    TResult? Function(PasswordChanged value)? passwordChanged,
    TResult? Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult? Function(SubmitLogin value)? submitLogin,
    TResult? Function(NavigateToSignup value)? navigateToSignup,
    TResult? Function(NavigateToForgotPassword value)? navigateToForgotPassword,
  }) {
    return navigateToForgotPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsernameChanged value)? usernameChanged,
    TResult Function(PasswordChanged value)? passwordChanged,
    TResult Function(TogglePasswordVisibility value)? togglePasswordVisibility,
    TResult Function(SubmitLogin value)? submitLogin,
    TResult Function(NavigateToSignup value)? navigateToSignup,
    TResult Function(NavigateToForgotPassword value)? navigateToForgotPassword,
    required TResult orElse(),
  }) {
    if (navigateToForgotPassword != null) {
      return navigateToForgotPassword(this);
    }
    return orElse();
  }
}

abstract class NavigateToForgotPassword implements LoginIntent {
  const factory NavigateToForgotPassword() = _$NavigateToForgotPasswordImpl;
}
