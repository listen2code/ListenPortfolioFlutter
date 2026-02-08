// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 String get username; String get password; bool get rememberMe; bool get isPasswordVisible; bool get isLoading; String? get errorMessage; String? get usernameError; String? get passwordError;@override LoginNavigationTarget? get pendingNavigation;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.isPasswordVisible, isPasswordVisible) || other.isPasswordVisible == isPasswordVisible)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.pendingNavigation, pendingNavigation) || other.pendingNavigation == pendingNavigation));
}


@override
int get hashCode => Object.hash(runtimeType,username,password,rememberMe,isPasswordVisible,isLoading,errorMessage,usernameError,passwordError,pendingNavigation);

@override
String toString() {
  return 'LoginState(username: $username, password: $password, rememberMe: $rememberMe, isPasswordVisible: $isPasswordVisible, isLoading: $isLoading, errorMessage: $errorMessage, usernameError: $usernameError, passwordError: $passwordError, pendingNavigation: $pendingNavigation)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 String username, String password, bool rememberMe, bool isPasswordVisible, bool isLoading, String? errorMessage, String? usernameError, String? passwordError,@override LoginNavigationTarget? pendingNavigation
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,Object? rememberMe = null,Object? isPasswordVisible = null,Object? isLoading = null,Object? errorMessage = freezed,Object? usernameError = freezed,Object? passwordError = freezed,Object? pendingNavigation = freezed,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,isPasswordVisible: null == isPasswordVisible ? _self.isPasswordVisible : isPasswordVisible // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,usernameError: freezed == usernameError ? _self.usernameError : usernameError // ignore: cast_nullable_to_non_nullable
as String?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String?,pendingNavigation: freezed == pendingNavigation ? _self.pendingNavigation : pendingNavigation // ignore: cast_nullable_to_non_nullable
as LoginNavigationTarget?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password,  bool rememberMe,  bool isPasswordVisible,  bool isLoading,  String? errorMessage,  String? usernameError,  String? passwordError, @override  LoginNavigationTarget? pendingNavigation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.username,_that.password,_that.rememberMe,_that.isPasswordVisible,_that.isLoading,_that.errorMessage,_that.usernameError,_that.passwordError,_that.pendingNavigation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password,  bool rememberMe,  bool isPasswordVisible,  bool isLoading,  String? errorMessage,  String? usernameError,  String? passwordError, @override  LoginNavigationTarget? pendingNavigation)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.username,_that.password,_that.rememberMe,_that.isPasswordVisible,_that.isLoading,_that.errorMessage,_that.usernameError,_that.passwordError,_that.pendingNavigation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password,  bool rememberMe,  bool isPasswordVisible,  bool isLoading,  String? errorMessage,  String? usernameError,  String? passwordError, @override  LoginNavigationTarget? pendingNavigation)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.username,_that.password,_that.rememberMe,_that.isPasswordVisible,_that.isLoading,_that.errorMessage,_that.usernameError,_that.passwordError,_that.pendingNavigation);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends LoginState {
  const _LoginState({this.username = '', this.password = '', this.rememberMe = false, this.isPasswordVisible = false, this.isLoading = false, this.errorMessage, this.usernameError, this.passwordError, @override this.pendingNavigation}): super._();
  

@override@JsonKey() final  String username;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool rememberMe;
@override@JsonKey() final  bool isPasswordVisible;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override final  String? usernameError;
@override final  String? passwordError;
@override@override final  LoginNavigationTarget? pendingNavigation;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.isPasswordVisible, isPasswordVisible) || other.isPasswordVisible == isPasswordVisible)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.pendingNavigation, pendingNavigation) || other.pendingNavigation == pendingNavigation));
}


@override
int get hashCode => Object.hash(runtimeType,username,password,rememberMe,isPasswordVisible,isLoading,errorMessage,usernameError,passwordError,pendingNavigation);

@override
String toString() {
  return 'LoginState(username: $username, password: $password, rememberMe: $rememberMe, isPasswordVisible: $isPasswordVisible, isLoading: $isLoading, errorMessage: $errorMessage, usernameError: $usernameError, passwordError: $passwordError, pendingNavigation: $pendingNavigation)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 String username, String password, bool rememberMe, bool isPasswordVisible, bool isLoading, String? errorMessage, String? usernameError, String? passwordError,@override LoginNavigationTarget? pendingNavigation
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,Object? rememberMe = null,Object? isPasswordVisible = null,Object? isLoading = null,Object? errorMessage = freezed,Object? usernameError = freezed,Object? passwordError = freezed,Object? pendingNavigation = freezed,}) {
  return _then(_LoginState(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,isPasswordVisible: null == isPasswordVisible ? _self.isPasswordVisible : isPasswordVisible // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,usernameError: freezed == usernameError ? _self.usernameError : usernameError // ignore: cast_nullable_to_non_nullable
as String?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String?,pendingNavigation: freezed == pendingNavigation ? _self.pendingNavigation : pendingNavigation // ignore: cast_nullable_to_non_nullable
as LoginNavigationTarget?,
  ));
}


}

// dart format on
