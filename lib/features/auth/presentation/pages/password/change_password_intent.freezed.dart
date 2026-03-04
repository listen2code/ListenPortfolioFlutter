// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangePasswordIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePasswordIntent()';
}


}

/// @nodoc
class $ChangePasswordIntentCopyWith<$Res>  {
$ChangePasswordIntentCopyWith(ChangePasswordIntent _, $Res Function(ChangePasswordIntent) __);
}


/// Adds pattern-matching-related methods to [ChangePasswordIntent].
extension ChangePasswordIntentPatterns on ChangePasswordIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _OldPasswordChanged value)?  oldPasswordChanged,TResult Function( _NewPasswordChanged value)?  newPasswordChanged,TResult Function( _ConfirmPasswordChanged value)?  confirmPasswordChanged,TResult Function( _SubmitChange value)?  submitChange,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OldPasswordChanged() when oldPasswordChanged != null:
return oldPasswordChanged(_that);case _NewPasswordChanged() when newPasswordChanged != null:
return newPasswordChanged(_that);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that);case _SubmitChange() when submitChange != null:
return submitChange(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _OldPasswordChanged value)  oldPasswordChanged,required TResult Function( _NewPasswordChanged value)  newPasswordChanged,required TResult Function( _ConfirmPasswordChanged value)  confirmPasswordChanged,required TResult Function( _SubmitChange value)  submitChange,}){
final _that = this;
switch (_that) {
case _OldPasswordChanged():
return oldPasswordChanged(_that);case _NewPasswordChanged():
return newPasswordChanged(_that);case _ConfirmPasswordChanged():
return confirmPasswordChanged(_that);case _SubmitChange():
return submitChange(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _OldPasswordChanged value)?  oldPasswordChanged,TResult? Function( _NewPasswordChanged value)?  newPasswordChanged,TResult? Function( _ConfirmPasswordChanged value)?  confirmPasswordChanged,TResult? Function( _SubmitChange value)?  submitChange,}){
final _that = this;
switch (_that) {
case _OldPasswordChanged() when oldPasswordChanged != null:
return oldPasswordChanged(_that);case _NewPasswordChanged() when newPasswordChanged != null:
return newPasswordChanged(_that);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that);case _SubmitChange() when submitChange != null:
return submitChange(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String password)?  oldPasswordChanged,TResult Function( String password)?  newPasswordChanged,TResult Function( String password)?  confirmPasswordChanged,TResult Function()?  submitChange,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OldPasswordChanged() when oldPasswordChanged != null:
return oldPasswordChanged(_that.password);case _NewPasswordChanged() when newPasswordChanged != null:
return newPasswordChanged(_that.password);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that.password);case _SubmitChange() when submitChange != null:
return submitChange();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String password)  oldPasswordChanged,required TResult Function( String password)  newPasswordChanged,required TResult Function( String password)  confirmPasswordChanged,required TResult Function()  submitChange,}) {final _that = this;
switch (_that) {
case _OldPasswordChanged():
return oldPasswordChanged(_that.password);case _NewPasswordChanged():
return newPasswordChanged(_that.password);case _ConfirmPasswordChanged():
return confirmPasswordChanged(_that.password);case _SubmitChange():
return submitChange();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String password)?  oldPasswordChanged,TResult? Function( String password)?  newPasswordChanged,TResult? Function( String password)?  confirmPasswordChanged,TResult? Function()?  submitChange,}) {final _that = this;
switch (_that) {
case _OldPasswordChanged() when oldPasswordChanged != null:
return oldPasswordChanged(_that.password);case _NewPasswordChanged() when newPasswordChanged != null:
return newPasswordChanged(_that.password);case _ConfirmPasswordChanged() when confirmPasswordChanged != null:
return confirmPasswordChanged(_that.password);case _SubmitChange() when submitChange != null:
return submitChange();case _:
  return null;

}
}

}

/// @nodoc


class _OldPasswordChanged extends ChangePasswordIntent {
  const _OldPasswordChanged(this.password): super._();
  

 final  String password;

/// Create a copy of ChangePasswordIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OldPasswordChangedCopyWith<_OldPasswordChanged> get copyWith => __$OldPasswordChangedCopyWithImpl<_OldPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OldPasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'ChangePasswordIntent.oldPasswordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class _$OldPasswordChangedCopyWith<$Res> implements $ChangePasswordIntentCopyWith<$Res> {
  factory _$OldPasswordChangedCopyWith(_OldPasswordChanged value, $Res Function(_OldPasswordChanged) _then) = __$OldPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$OldPasswordChangedCopyWithImpl<$Res>
    implements _$OldPasswordChangedCopyWith<$Res> {
  __$OldPasswordChangedCopyWithImpl(this._self, this._then);

  final _OldPasswordChanged _self;
  final $Res Function(_OldPasswordChanged) _then;

/// Create a copy of ChangePasswordIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_OldPasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NewPasswordChanged extends ChangePasswordIntent {
  const _NewPasswordChanged(this.password): super._();
  

 final  String password;

/// Create a copy of ChangePasswordIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewPasswordChangedCopyWith<_NewPasswordChanged> get copyWith => __$NewPasswordChangedCopyWithImpl<_NewPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewPasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'ChangePasswordIntent.newPasswordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class _$NewPasswordChangedCopyWith<$Res> implements $ChangePasswordIntentCopyWith<$Res> {
  factory _$NewPasswordChangedCopyWith(_NewPasswordChanged value, $Res Function(_NewPasswordChanged) _then) = __$NewPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class __$NewPasswordChangedCopyWithImpl<$Res>
    implements _$NewPasswordChangedCopyWith<$Res> {
  __$NewPasswordChangedCopyWithImpl(this._self, this._then);

  final _NewPasswordChanged _self;
  final $Res Function(_NewPasswordChanged) _then;

/// Create a copy of ChangePasswordIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_NewPasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ConfirmPasswordChanged extends ChangePasswordIntent {
  const _ConfirmPasswordChanged(this.password): super._();
  

 final  String password;

/// Create a copy of ChangePasswordIntent
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
  return 'ChangePasswordIntent.confirmPasswordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class _$ConfirmPasswordChangedCopyWith<$Res> implements $ChangePasswordIntentCopyWith<$Res> {
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

/// Create a copy of ChangePasswordIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(_ConfirmPasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SubmitChange extends ChangePasswordIntent {
  const _SubmitChange(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitChange);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePasswordIntent.submitChange()';
}


}




// dart format on
