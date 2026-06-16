// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'version_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VersionModel {

 String get version; int get buildNumber; String get url; Map<String, String> get changelog;
/// Create a copy of VersionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VersionModelCopyWith<VersionModel> get copyWith => _$VersionModelCopyWithImpl<VersionModel>(this as VersionModel, _$identity);

  /// Serializes this VersionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionModel&&(identical(other.version, version) || other.version == version)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.changelog, changelog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,buildNumber,url,const DeepCollectionEquality().hash(changelog));

@override
String toString() {
  return 'VersionModel(version: $version, buildNumber: $buildNumber, url: $url, changelog: $changelog)';
}


}

/// @nodoc
abstract mixin class $VersionModelCopyWith<$Res>  {
  factory $VersionModelCopyWith(VersionModel value, $Res Function(VersionModel) _then) = _$VersionModelCopyWithImpl;
@useResult
$Res call({
 String version, int buildNumber, String url, Map<String, String> changelog
});




}
/// @nodoc
class _$VersionModelCopyWithImpl<$Res>
    implements $VersionModelCopyWith<$Res> {
  _$VersionModelCopyWithImpl(this._self, this._then);

  final VersionModel _self;
  final $Res Function(VersionModel) _then;

/// Create a copy of VersionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? buildNumber = null,Object? url = null,Object? changelog = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [VersionModel].
extension VersionModelPatterns on VersionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VersionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VersionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VersionModel value)  $default,){
final _that = this;
switch (_that) {
case _VersionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VersionModel value)?  $default,){
final _that = this;
switch (_that) {
case _VersionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  int buildNumber,  String url,  Map<String, String> changelog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VersionModel() when $default != null:
return $default(_that.version,_that.buildNumber,_that.url,_that.changelog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  int buildNumber,  String url,  Map<String, String> changelog)  $default,) {final _that = this;
switch (_that) {
case _VersionModel():
return $default(_that.version,_that.buildNumber,_that.url,_that.changelog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  int buildNumber,  String url,  Map<String, String> changelog)?  $default,) {final _that = this;
switch (_that) {
case _VersionModel() when $default != null:
return $default(_that.version,_that.buildNumber,_that.url,_that.changelog);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VersionModel implements VersionModel {
  const _VersionModel({required this.version, required this.buildNumber, required this.url, required final  Map<String, String> changelog}): _changelog = changelog;
  factory _VersionModel.fromJson(Map<String, dynamic> json) => _$VersionModelFromJson(json);

@override final  String version;
@override final  int buildNumber;
@override final  String url;
 final  Map<String, String> _changelog;
@override Map<String, String> get changelog {
  if (_changelog is EqualUnmodifiableMapView) return _changelog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_changelog);
}


/// Create a copy of VersionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VersionModelCopyWith<_VersionModel> get copyWith => __$VersionModelCopyWithImpl<_VersionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VersionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VersionModel&&(identical(other.version, version) || other.version == version)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._changelog, _changelog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,buildNumber,url,const DeepCollectionEquality().hash(_changelog));

@override
String toString() {
  return 'VersionModel(version: $version, buildNumber: $buildNumber, url: $url, changelog: $changelog)';
}


}

/// @nodoc
abstract mixin class _$VersionModelCopyWith<$Res> implements $VersionModelCopyWith<$Res> {
  factory _$VersionModelCopyWith(_VersionModel value, $Res Function(_VersionModel) _then) = __$VersionModelCopyWithImpl;
@override @useResult
$Res call({
 String version, int buildNumber, String url, Map<String, String> changelog
});




}
/// @nodoc
class __$VersionModelCopyWithImpl<$Res>
    implements _$VersionModelCopyWith<$Res> {
  __$VersionModelCopyWithImpl(this._self, this._then);

  final _VersionModel _self;
  final $Res Function(_VersionModel) _then;

/// Create a copy of VersionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? buildNumber = null,Object? url = null,Object? changelog = null,}) {
  return _then(_VersionModel(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,changelog: null == changelog ? _self._changelog : changelog // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
