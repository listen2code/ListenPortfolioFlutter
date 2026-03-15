// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignupRequestModel {

 String get name; String get email; String get password;
/// Create a copy of SignupRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupRequestModelCopyWith<SignupRequestModel> get copyWith => _$SignupRequestModelCopyWithImpl<SignupRequestModel>(this as SignupRequestModel, _$identity);

  /// Serializes this SignupRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupRequestModel&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,password);

@override
String toString() {
  return 'SignupRequestModel(name: $name, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignupRequestModelCopyWith<$Res>  {
  factory $SignupRequestModelCopyWith(SignupRequestModel value, $Res Function(SignupRequestModel) _then) = _$SignupRequestModelCopyWithImpl;
@useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class _$SignupRequestModelCopyWithImpl<$Res>
    implements $SignupRequestModelCopyWith<$Res> {
  _$SignupRequestModelCopyWithImpl(this._self, this._then);

  final SignupRequestModel _self;
  final $Res Function(SignupRequestModel) _then;

/// Create a copy of SignupRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SignupRequestModel].
extension SignupRequestModelPatterns on SignupRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignupRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignupRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignupRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _SignupRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignupRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _SignupRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignupRequestModel() when $default != null:
return $default(_that.name,_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _SignupRequestModel():
return $default(_that.name,_that.email,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _SignupRequestModel() when $default != null:
return $default(_that.name,_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignupRequestModel implements SignupRequestModel {
  const _SignupRequestModel({required this.name, required this.email, required this.password});
  factory _SignupRequestModel.fromJson(Map<String, dynamic> json) => _$SignupRequestModelFromJson(json);

@override final  String name;
@override final  String email;
@override final  String password;

/// Create a copy of SignupRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupRequestModelCopyWith<_SignupRequestModel> get copyWith => __$SignupRequestModelCopyWithImpl<_SignupRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignupRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupRequestModel&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,password);

@override
String toString() {
  return 'SignupRequestModel(name: $name, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SignupRequestModelCopyWith<$Res> implements $SignupRequestModelCopyWith<$Res> {
  factory _$SignupRequestModelCopyWith(_SignupRequestModel value, $Res Function(_SignupRequestModel) _then) = __$SignupRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class __$SignupRequestModelCopyWithImpl<$Res>
    implements _$SignupRequestModelCopyWith<$Res> {
  __$SignupRequestModelCopyWithImpl(this._self, this._then);

  final _SignupRequestModel _self;
  final $Res Function(_SignupRequestModel) _then;

/// Create a copy of SignupRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(_SignupRequestModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
