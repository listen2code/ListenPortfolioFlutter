// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent()';
}


}

/// @nodoc
class $LoginIntentCopyWith<$Res>  {
$LoginIntentCopyWith(LoginIntent _, $Res Function(LoginIntent) __);
}


/// Adds pattern-matching-related methods to [LoginIntent].
extension LoginIntentPatterns on LoginIntent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _UsernameChanged value)?  usernameChanged,TResult Function( _PasswordChanged value)?  passwordChanged,TResult Function( _TogglePasswordVisibility value)?  togglePasswordVisibility,TResult Function( _ToggleRememberMe value)?  toggleRememberMe,TResult Function( _SubmitLogin value)?  submitLogin,TResult Function( _NavigateToSignup value)?  navigateToSignup,TResult Function( _NavigateToForgotPassword value)?  navigateToForgotPassword,TResult Function( _SkipLogin value)?  skipLogin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsernameChanged() when usernameChanged != null:
return usernameChanged(_that);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case _TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility(_that);case _ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe(_that);case _SubmitLogin() when submitLogin != null:
return submitLogin(_that);case _NavigateToSignup() when navigateToSignup != null:
return navigateToSignup(_that);case _NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword(_that);case _SkipLogin() when skipLogin != null:
return skipLogin(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _UsernameChanged value)  usernameChanged,required TResult Function( _PasswordChanged value)  passwordChanged,required TResult Function( _TogglePasswordVisibility value)  togglePasswordVisibility,required TResult Function( _ToggleRememberMe value)  toggleRememberMe,required TResult Function( _SubmitLogin value)  submitLogin,required TResult Function( _NavigateToSignup value)  navigateToSignup,required TResult Function( _NavigateToForgotPassword value)  navigateToForgotPassword,required TResult Function( _SkipLogin value)  skipLogin,}){
final _that = this;
switch (_that) {
case _UsernameChanged():
return usernameChanged(_that);case _PasswordChanged():
return passwordChanged(_that);case _TogglePasswordVisibility():
return togglePasswordVisibility(_that);case _ToggleRememberMe():
return toggleRememberMe(_that);case _SubmitLogin():
return submitLogin(_that);case _NavigateToSignup():
return navigateToSignup(_that);case _NavigateToForgotPassword():
return navigateToForgotPassword(_that);case _SkipLogin():
return skipLogin(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _UsernameChanged value)?  usernameChanged,TResult? Function( _PasswordChanged value)?  passwordChanged,TResult? Function( _TogglePasswordVisibility value)?  togglePasswordVisibility,TResult? Function( _ToggleRememberMe value)?  toggleRememberMe,TResult? Function( _SubmitLogin value)?  submitLogin,TResult? Function( _NavigateToSignup value)?  navigateToSignup,TResult? Function( _NavigateToForgotPassword value)?  navigateToForgotPassword,TResult? Function( _SkipLogin value)?  skipLogin,}){
final _that = this;
switch (_that) {
case _UsernameChanged() when usernameChanged != null:
return usernameChanged(_that);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case _TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility(_that);case _ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe(_that);case _SubmitLogin() when submitLogin != null:
return submitLogin(_that);case _NavigateToSignup() when navigateToSignup != null:
return navigateToSignup(_that);case _NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword(_that);case _SkipLogin() when skipLogin != null:
return skipLogin(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String username)?  usernameChanged,TResult Function( String password)?  passwordChanged,TResult Function()?  togglePasswordVisibility,TResult Function()?  toggleRememberMe,TResult Function()?  submitLogin,TResult Function()?  navigateToSignup,TResult Function()?  navigateToForgotPassword,TResult Function()?  skipLogin,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsernameChanged() when usernameChanged != null:
return usernameChanged(_that.username);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case _TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility();case _ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe();case _SubmitLogin() when submitLogin != null:
return submitLogin();case _NavigateToSignup() when navigateToSignup != null:
return navigateToSignup();case _NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword();case _SkipLogin() when skipLogin != null:
return skipLogin();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String username)  usernameChanged,required TResult Function( String password)  passwordChanged,required TResult Function()  togglePasswordVisibility,required TResult Function()  toggleRememberMe,required TResult Function()  submitLogin,required TResult Function()  navigateToSignup,required TResult Function()  navigateToForgotPassword,required TResult Function()  skipLogin,}) {final _that = this;
switch (_that) {
case _UsernameChanged():
return usernameChanged(_that.username);case _PasswordChanged():
return passwordChanged(_that.password);case _TogglePasswordVisibility():
return togglePasswordVisibility();case _ToggleRememberMe():
return toggleRememberMe();case _SubmitLogin():
return submitLogin();case _NavigateToSignup():
return navigateToSignup();case _NavigateToForgotPassword():
return navigateToForgotPassword();case _SkipLogin():
return skipLogin();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String username)?  usernameChanged,TResult? Function( String password)?  passwordChanged,TResult? Function()?  togglePasswordVisibility,TResult? Function()?  toggleRememberMe,TResult? Function()?  submitLogin,TResult? Function()?  navigateToSignup,TResult? Function()?  navigateToForgotPassword,TResult? Function()?  skipLogin,}) {final _that = this;
switch (_that) {
case _UsernameChanged() when usernameChanged != null:
return usernameChanged(_that.username);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case _TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility();case _ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe();case _SubmitLogin() when submitLogin != null:
return submitLogin();case _NavigateToSignup() when navigateToSignup != null:
return navigateToSignup();case _NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword();case _SkipLogin() when skipLogin != null:
return skipLogin();case _:
  return null;

}
}

}

/// @nodoc


class _UsernameChanged extends LoginIntent {
  const _UsernameChanged(this.username): super._();
  

 final  String username;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsernameChangedCopyWith<_UsernameChanged> get copyWith => __$UsernameChangedCopyWithImpl<_UsernameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsernameChanged&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,username);

@override
String toString() {
  return 'LoginIntent.usernameChanged(username: $username)';
}


}

/// @nodoc
abstract mixin class _$UsernameChangedCopyWith<$Res> implements $LoginIntentCopyWith<$Res> {
  factory _$UsernameChangedCopyWith(_UsernameChanged value, $Res Function(_UsernameChanged) _then) = __$UsernameChangedCopyWithImpl;
@useResult
$Res call({
 String username
});




}
/// @nodoc
class __$UsernameChangedCopyWithImpl<$Res>
    implements _$UsernameChangedCopyWith<$Res> {
  __$UsernameChangedCopyWithImpl(this._self, this._then);

  final _UsernameChanged _self;
  final $Res Function(_UsernameChanged) _then;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,}) {
  return _then(_UsernameChanged(
null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PasswordChanged extends LoginIntent {
  const _PasswordChanged(this.password): super._();
  

 final  String password;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordChangedCopyWith<_PasswordChanged> get copyWith => __$PasswordChangedCopyWithImpl<_PasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'LoginIntent.passwordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class _$PasswordChangedCopyWith<$Res> implements $LoginIntentCopyWith<$Res> {
  factory _$PasswordChangedCopyWith(_PasswordChanged value, $Res Function(_PasswordChanged) _then) = __$PasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$PasswordChangedCopyWithImpl<$Res>
    implements _$PasswordChangedCopyWith<$Res> {
  __$PasswordChangedCopyWithImpl(this._self, this._then);

  final _PasswordChanged _self;
  final $Res Function(_PasswordChanged) _then;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_PasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _TogglePasswordVisibility extends LoginIntent {
  const _TogglePasswordVisibility(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TogglePasswordVisibility);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.togglePasswordVisibility()';
}


}




/// @nodoc


class _ToggleRememberMe extends LoginIntent {
  const _ToggleRememberMe(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleRememberMe);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.toggleRememberMe()';
}


}




/// @nodoc


class _SubmitLogin extends LoginIntent {
  const _SubmitLogin(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.submitLogin()';
}


}




/// @nodoc


class _NavigateToSignup extends LoginIntent {
  const _NavigateToSignup(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToSignup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.navigateToSignup()';
}


}




/// @nodoc


class _NavigateToForgotPassword extends LoginIntent {
  const _NavigateToForgotPassword(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToForgotPassword);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.navigateToForgotPassword()';
}


}




/// @nodoc


class _SkipLogin extends LoginIntent {
  const _SkipLogin(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkipLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.skipLogin()';
}


}




// dart format on
