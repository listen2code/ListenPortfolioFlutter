// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignUpIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignUpIntent()';
}


}

/// @nodoc
class $SignUpIntentCopyWith<$Res>  {
$SignUpIntentCopyWith(SignUpIntent _, $Res Function(SignUpIntent) __);
}


/// Adds pattern-matching-related methods to [SignUpIntent].
extension SignUpIntentPatterns on SignUpIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _FullNameChanged value)?  fullNameChanged,TResult Function( _EmailChanged value)?  emailChanged,TResult Function( _PasswordChanged value)?  passwordChanged,TResult Function( _ConfirmPasswordChanged value)?  confirmPasswordChanged,TResult Function( _SubmitSignUp value)?  submitSignUp,TResult Function( _NavigateToLogin value)?  navigateToLogin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FullNameChanged() when fullNameChanged != null:
return fullNameChanged(_that);case _EmailChanged() when emailChanged != null:
return emailChanged(_that);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that);case _SubmitSignUp() when submitSignUp != null:
return submitSignUp(_that);case _NavigateToLogin() when navigateToLogin != null:
return navigateToLogin(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _FullNameChanged value)  fullNameChanged,required TResult Function( _EmailChanged value)  emailChanged,required TResult Function( _PasswordChanged value)  passwordChanged,required TResult Function( _ConfirmPasswordChanged value)  confirmPasswordChanged,required TResult Function( _SubmitSignUp value)  submitSignUp,required TResult Function( _NavigateToLogin value)  navigateToLogin,}){
final _that = this;
switch (_that) {
case _FullNameChanged():
return fullNameChanged(_that);case _EmailChanged():
return emailChanged(_that);case _PasswordChanged():
return passwordChanged(_that);case _ConfirmPasswordChanged():
return confirmPasswordChanged(_that);case _SubmitSignUp():
return submitSignUp(_that);case _NavigateToLogin():
return navigateToLogin(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _FullNameChanged value)?  fullNameChanged,TResult? Function( _EmailChanged value)?  emailChanged,TResult? Function( _PasswordChanged value)?  passwordChanged,TResult? Function( _ConfirmPasswordChanged value)?  confirmPasswordChanged,TResult? Function( _SubmitSignUp value)?  submitSignUp,TResult? Function( _NavigateToLogin value)?  navigateToLogin,}){
final _that = this;
switch (_that) {
case _FullNameChanged() when fullNameChanged != null:
return fullNameChanged(_that);case _EmailChanged() when emailChanged != null:
return emailChanged(_that);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that);case _SubmitSignUp() when submitSignUp != null:
return submitSignUp(_that);case _NavigateToLogin() when navigateToLogin != null:
return navigateToLogin(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name)?  fullNameChanged,TResult Function( String email)?  emailChanged,TResult Function( String password)?  passwordChanged,TResult Function( String password)?  confirmPasswordChanged,TResult Function()?  submitSignUp,TResult Function()?  navigateToLogin,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FullNameChanged() when fullNameChanged != null:
return fullNameChanged(_that.name);case _EmailChanged() when emailChanged != null:
return emailChanged(_that.email);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that.password);case _SubmitSignUp() when submitSignUp != null:
return submitSignUp();case _NavigateToLogin() when navigateToLogin != null:
return navigateToLogin();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name)  fullNameChanged,required TResult Function( String email)  emailChanged,required TResult Function( String password)  passwordChanged,required TResult Function( String password)  confirmPasswordChanged,required TResult Function()  submitSignUp,required TResult Function()  navigateToLogin,}) {final _that = this;
switch (_that) {
case _FullNameChanged():
return fullNameChanged(_that.name);case _EmailChanged():
return emailChanged(_that.email);case _PasswordChanged():
return passwordChanged(_that.password);case _ConfirmPasswordChanged():
return confirmPasswordChanged(_that.password);case _SubmitSignUp():
return submitSignUp();case _NavigateToLogin():
return navigateToLogin();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name)?  fullNameChanged,TResult? Function( String email)?  emailChanged,TResult? Function( String password)?  passwordChanged,TResult? Function( String password)?  confirmPasswordChanged,TResult? Function()?  submitSignUp,TResult? Function()?  navigateToLogin,}) {final _that = this;
switch (_that) {
case _FullNameChanged() when fullNameChanged != null:
return fullNameChanged(_that.name);case _EmailChanged() when emailChanged != null:
return emailChanged(_that.email);case _PasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that.password);case _SubmitSignUp() when submitSignUp != null:
return submitSignUp();case _NavigateToLogin() when navigateToLogin != null:
return navigateToLogin();case _:
  return null;

}
}

}

/// @nodoc


class _FullNameChanged implements SignUpIntent {
  const _FullNameChanged(this.name);
  

 final  String name;

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FullNameChangedCopyWith<_FullNameChanged> get copyWith => __$FullNameChangedCopyWithImpl<_FullNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FullNameChanged&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'SignUpIntent.fullNameChanged(name: $name)';
}


}

/// @nodoc
abstract mixin class _$FullNameChangedCopyWith<$Res> implements $SignUpIntentCopyWith<$Res> {
  factory _$FullNameChangedCopyWith(_FullNameChanged value, $Res Function(_FullNameChanged) _then) = __$FullNameChangedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$FullNameChangedCopyWithImpl<$Res>
    implements _$FullNameChangedCopyWith<$Res> {
  __$FullNameChangedCopyWithImpl(this._self, this._then);

  final _FullNameChanged _self;
  final $Res Function(_FullNameChanged) _then;

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_FullNameChanged(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EmailChanged implements SignUpIntent {
  const _EmailChanged(this.email);
  

 final  String email;

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailChangedCopyWith<_EmailChanged> get copyWith => __$EmailChangedCopyWithImpl<_EmailChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailChanged&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'SignUpIntent.emailChanged(email: $email)';
}


}

/// @nodoc
abstract mixin class _$EmailChangedCopyWith<$Res> implements $SignUpIntentCopyWith<$Res> {
  factory _$EmailChangedCopyWith(_EmailChanged value, $Res Function(_EmailChanged) _then) = __$EmailChangedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class __$EmailChangedCopyWithImpl<$Res>
    implements _$EmailChangedCopyWith<$Res> {
  __$EmailChangedCopyWithImpl(this._self, this._then);

  final _EmailChanged _self;
  final $Res Function(_EmailChanged) _then;

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_EmailChanged(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PasswordChanged implements SignUpIntent {
  const _PasswordChanged(this.password);
  

 final  String password;

/// Create a copy of SignUpIntent
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
  return 'SignUpIntent.passwordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class _$PasswordChangedCopyWith<$Res> implements $SignUpIntentCopyWith<$Res> {
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

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_PasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ConfirmPasswordChanged implements SignUpIntent {
  const _ConfirmPasswordChanged(this.password);
  

 final  String password;

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfirmPasswordChangedCopyWith<_ConfirmPasswordChanged> get copyWith => __$ConfirmPasswordChangedCopyWithImpl<_ConfirmPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmPasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'SignUpIntent.confirmPasswordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class _$ConfirmPasswordChangedCopyWith<$Res> implements $SignUpIntentCopyWith<$Res> {
  factory _$ConfirmPasswordChangedCopyWith(_ConfirmPasswordChanged value, $Res Function(_ConfirmPasswordChanged) _then) = __$ConfirmPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$ConfirmPasswordChangedCopyWithImpl<$Res>
    implements _$ConfirmPasswordChangedCopyWith<$Res> {
  __$ConfirmPasswordChangedCopyWithImpl(this._self, this._then);

  final _ConfirmPasswordChanged _self;
  final $Res Function(_ConfirmPasswordChanged) _then;

/// Create a copy of SignUpIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_ConfirmPasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubmitSignUp implements SignUpIntent {
  const _SubmitSignUp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitSignUp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignUpIntent.submitSignUp()';
}


}




/// @nodoc


class _NavigateToLogin implements SignUpIntent {
  const _NavigateToLogin();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignUpIntent.navigateToLogin()';
}


}




// dart format on
