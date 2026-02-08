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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UsernameChanged value)?  usernameChanged,TResult Function( PasswordChanged value)?  passwordChanged,TResult Function( TogglePasswordVisibility value)?  togglePasswordVisibility,TResult Function( ToggleRememberMe value)?  toggleRememberMe,TResult Function( SubmitLogin value)?  submitLogin,TResult Function( NavigateToSignup value)?  navigateToSignup,TResult Function( NavigateToForgotPassword value)?  navigateToForgotPassword,TResult Function( SkipLogin value)?  skipLogin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UsernameChanged() when usernameChanged != null:
return usernameChanged(_that);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility(_that);case ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe(_that);case SubmitLogin() when submitLogin != null:
return submitLogin(_that);case NavigateToSignup() when navigateToSignup != null:
return navigateToSignup(_that);case NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword(_that);case SkipLogin() when skipLogin != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UsernameChanged value)  usernameChanged,required TResult Function( PasswordChanged value)  passwordChanged,required TResult Function( TogglePasswordVisibility value)  togglePasswordVisibility,required TResult Function( ToggleRememberMe value)  toggleRememberMe,required TResult Function( SubmitLogin value)  submitLogin,required TResult Function( NavigateToSignup value)  navigateToSignup,required TResult Function( NavigateToForgotPassword value)  navigateToForgotPassword,required TResult Function( SkipLogin value)  skipLogin,}){
final _that = this;
switch (_that) {
case UsernameChanged():
return usernameChanged(_that);case PasswordChanged():
return passwordChanged(_that);case TogglePasswordVisibility():
return togglePasswordVisibility(_that);case ToggleRememberMe():
return toggleRememberMe(_that);case SubmitLogin():
return submitLogin(_that);case NavigateToSignup():
return navigateToSignup(_that);case NavigateToForgotPassword():
return navigateToForgotPassword(_that);case SkipLogin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UsernameChanged value)?  usernameChanged,TResult? Function( PasswordChanged value)?  passwordChanged,TResult? Function( TogglePasswordVisibility value)?  togglePasswordVisibility,TResult? Function( ToggleRememberMe value)?  toggleRememberMe,TResult? Function( SubmitLogin value)?  submitLogin,TResult? Function( NavigateToSignup value)?  navigateToSignup,TResult? Function( NavigateToForgotPassword value)?  navigateToForgotPassword,TResult? Function( SkipLogin value)?  skipLogin,}){
final _that = this;
switch (_that) {
case UsernameChanged() when usernameChanged != null:
return usernameChanged(_that);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility(_that);case ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe(_that);case SubmitLogin() when submitLogin != null:
return submitLogin(_that);case NavigateToSignup() when navigateToSignup != null:
return navigateToSignup(_that);case NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword(_that);case SkipLogin() when skipLogin != null:
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
case UsernameChanged() when usernameChanged != null:
return usernameChanged(_that.username);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility();case ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe();case SubmitLogin() when submitLogin != null:
return submitLogin();case NavigateToSignup() when navigateToSignup != null:
return navigateToSignup();case NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword();case SkipLogin() when skipLogin != null:
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
case UsernameChanged():
return usernameChanged(_that.username);case PasswordChanged():
return passwordChanged(_that.password);case TogglePasswordVisibility():
return togglePasswordVisibility();case ToggleRememberMe():
return toggleRememberMe();case SubmitLogin():
return submitLogin();case NavigateToSignup():
return navigateToSignup();case NavigateToForgotPassword():
return navigateToForgotPassword();case SkipLogin():
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
case UsernameChanged() when usernameChanged != null:
return usernameChanged(_that.username);case PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case TogglePasswordVisibility() when togglePasswordVisibility != null:
return togglePasswordVisibility();case ToggleRememberMe() when toggleRememberMe != null:
return toggleRememberMe();case SubmitLogin() when submitLogin != null:
return submitLogin();case NavigateToSignup() when navigateToSignup != null:
return navigateToSignup();case NavigateToForgotPassword() when navigateToForgotPassword != null:
return navigateToForgotPassword();case SkipLogin() when skipLogin != null:
return skipLogin();case _:
  return null;

}
}

}

/// @nodoc


class UsernameChanged implements LoginIntent {
  const UsernameChanged(this.username);
  

 final  String username;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsernameChangedCopyWith<UsernameChanged> get copyWith => _$UsernameChangedCopyWithImpl<UsernameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsernameChanged&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,username);

@override
String toString() {
  return 'LoginIntent.usernameChanged(username: $username)';
}


}

/// @nodoc
abstract mixin class $UsernameChangedCopyWith<$Res> implements $LoginIntentCopyWith<$Res> {
  factory $UsernameChangedCopyWith(UsernameChanged value, $Res Function(UsernameChanged) _then) = _$UsernameChangedCopyWithImpl;
@useResult
$Res call({
 String username
});




}
/// @nodoc
class _$UsernameChangedCopyWithImpl<$Res>
    implements $UsernameChangedCopyWith<$Res> {
  _$UsernameChangedCopyWithImpl(this._self, this._then);

  final UsernameChanged _self;
  final $Res Function(UsernameChanged) _then;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,}) {
  return _then(UsernameChanged(
null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PasswordChanged implements LoginIntent {
  const PasswordChanged(this.password);
  

 final  String password;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordChangedCopyWith<PasswordChanged> get copyWith => _$PasswordChangedCopyWithImpl<PasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'LoginIntent.passwordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class $PasswordChangedCopyWith<$Res> implements $LoginIntentCopyWith<$Res> {
  factory $PasswordChangedCopyWith(PasswordChanged value, $Res Function(PasswordChanged) _then) = _$PasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$PasswordChangedCopyWithImpl<$Res>
    implements $PasswordChangedCopyWith<$Res> {
  _$PasswordChangedCopyWithImpl(this._self, this._then);

  final PasswordChanged _self;
  final $Res Function(PasswordChanged) _then;

/// Create a copy of LoginIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(PasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TogglePasswordVisibility implements LoginIntent {
  const TogglePasswordVisibility();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TogglePasswordVisibility);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.togglePasswordVisibility()';
}


}




/// @nodoc


class ToggleRememberMe implements LoginIntent {
  const ToggleRememberMe();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleRememberMe);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.toggleRememberMe()';
}


}




/// @nodoc


class SubmitLogin implements LoginIntent {
  const SubmitLogin();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.submitLogin()';
}


}




/// @nodoc


class NavigateToSignup implements LoginIntent {
  const NavigateToSignup();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateToSignup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.navigateToSignup()';
}


}




/// @nodoc


class NavigateToForgotPassword implements LoginIntent {
  const NavigateToForgotPassword();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateToForgotPassword);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.navigateToForgotPassword()';
}


}




/// @nodoc


class SkipLogin implements LoginIntent {
  const SkipLogin();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginIntent.skipLogin()';
}


}




// dart format on
