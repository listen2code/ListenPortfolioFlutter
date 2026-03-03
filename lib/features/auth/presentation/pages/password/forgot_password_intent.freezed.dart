// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForgotPasswordIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForgotPasswordIntent()';
}


}

/// @nodoc
class $ForgotPasswordIntentCopyWith<$Res>  {
$ForgotPasswordIntentCopyWith(ForgotPasswordIntent _, $Res Function(ForgotPasswordIntent) __);
}


/// Adds pattern-matching-related methods to [ForgotPasswordIntent].
extension ForgotPasswordIntentPatterns on ForgotPasswordIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _EmailChanged value)?  emailChanged,TResult Function( _SubmitReset value)?  submitReset,TResult Function( _NavigateToLogin value)?  navigateToLogin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailChanged() when emailChanged != null:
return emailChanged(_that);case _SubmitReset() when submitReset != null:
return submitReset(_that);case _NavigateToLogin() when navigateToLogin != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _EmailChanged value)  emailChanged,required TResult Function( _SubmitReset value)  submitReset,required TResult Function( _NavigateToLogin value)  navigateToLogin,}){
final _that = this;
switch (_that) {
case _EmailChanged():
return emailChanged(_that);case _SubmitReset():
return submitReset(_that);case _NavigateToLogin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _EmailChanged value)?  emailChanged,TResult? Function( _SubmitReset value)?  submitReset,TResult? Function( _NavigateToLogin value)?  navigateToLogin,}){
final _that = this;
switch (_that) {
case _EmailChanged() when emailChanged != null:
return emailChanged(_that);case _SubmitReset() when submitReset != null:
return submitReset(_that);case _NavigateToLogin() when navigateToLogin != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email)?  emailChanged,TResult Function()?  submitReset,TResult Function()?  navigateToLogin,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailChanged() when emailChanged != null:
return emailChanged(_that.email);case _SubmitReset() when submitReset != null:
return submitReset();case _NavigateToLogin() when navigateToLogin != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email)  emailChanged,required TResult Function()  submitReset,required TResult Function()  navigateToLogin,}) {final _that = this;
switch (_that) {
case _EmailChanged():
return emailChanged(_that.email);case _SubmitReset():
return submitReset();case _NavigateToLogin():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email)?  emailChanged,TResult? Function()?  submitReset,TResult? Function()?  navigateToLogin,}) {final _that = this;
switch (_that) {
case _EmailChanged() when emailChanged != null:
return emailChanged(_that.email);case _SubmitReset() when submitReset != null:
return submitReset();case _NavigateToLogin() when navigateToLogin != null:
return navigateToLogin();case _:
  return null;

}
}

}

/// @nodoc


class _EmailChanged extends ForgotPasswordIntent {
  const _EmailChanged(this.email): super._();
  

 final  String email;

/// Create a copy of ForgotPasswordIntent
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
  return 'ForgotPasswordIntent.emailChanged(email: $email)';
}


}

/// @nodoc
abstract mixin class _$EmailChangedCopyWith<$Res> implements $ForgotPasswordIntentCopyWith<$Res> {
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

/// Create a copy of ForgotPasswordIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(_EmailChanged(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubmitReset extends ForgotPasswordIntent {
  const _SubmitReset(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitReset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForgotPasswordIntent.submitReset()';
}


}




/// @nodoc


class _NavigateToLogin extends ForgotPasswordIntent {
  const _NavigateToLogin(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForgotPasswordIntent.navigateToLogin()';
}


}




// dart format on
