// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crash_log_list_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CrashLogListIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrashLogListIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CrashLogListIntent()';
}


}

/// @nodoc
class $CrashLogListIntentCopyWith<$Res>  {
$CrashLogListIntentCopyWith(CrashLogListIntent _, $Res Function(CrashLogListIntent) __);
}


/// Adds pattern-matching-related methods to [CrashLogListIntent].
extension CrashLogListIntentPatterns on CrashLogListIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _Refresh value)?  refresh,TResult Function( _TriggerCrash value)?  triggerCrash,TResult Function( _DeleteAll value)?  deleteAll,TResult Function( _DeleteLog value)?  deleteLog,TResult Function( _ShareLog value)?  shareLog,TResult Function( _ViewLog value)?  viewLog,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _Refresh() when refresh != null:
return refresh(_that);case _TriggerCrash() when triggerCrash != null:
return triggerCrash(_that);case _DeleteAll() when deleteAll != null:
return deleteAll(_that);case _DeleteLog() when deleteLog != null:
return deleteLog(_that);case _ShareLog() when shareLog != null:
return shareLog(_that);case _ViewLog() when viewLog != null:
return viewLog(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _Refresh value)  refresh,required TResult Function( _TriggerCrash value)  triggerCrash,required TResult Function( _DeleteAll value)  deleteAll,required TResult Function( _DeleteLog value)  deleteLog,required TResult Function( _ShareLog value)  shareLog,required TResult Function( _ViewLog value)  viewLog,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _Refresh():
return refresh(_that);case _TriggerCrash():
return triggerCrash(_that);case _DeleteAll():
return deleteAll(_that);case _DeleteLog():
return deleteLog(_that);case _ShareLog():
return shareLog(_that);case _ViewLog():
return viewLog(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _Refresh value)?  refresh,TResult? Function( _TriggerCrash value)?  triggerCrash,TResult? Function( _DeleteAll value)?  deleteAll,TResult? Function( _DeleteLog value)?  deleteLog,TResult? Function( _ShareLog value)?  shareLog,TResult? Function( _ViewLog value)?  viewLog,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _Refresh() when refresh != null:
return refresh(_that);case _TriggerCrash() when triggerCrash != null:
return triggerCrash(_that);case _DeleteAll() when deleteAll != null:
return deleteAll(_that);case _DeleteLog() when deleteLog != null:
return deleteLog(_that);case _ShareLog() when shareLog != null:
return shareLog(_that);case _ViewLog() when viewLog != null:
return viewLog(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function()?  refresh,TResult Function()?  triggerCrash,TResult Function()?  deleteAll,TResult Function( File file)?  deleteLog,TResult Function( File file)?  shareLog,TResult Function( File file)?  viewLog,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _Refresh() when refresh != null:
return refresh();case _TriggerCrash() when triggerCrash != null:
return triggerCrash();case _DeleteAll() when deleteAll != null:
return deleteAll();case _DeleteLog() when deleteLog != null:
return deleteLog(_that.file);case _ShareLog() when shareLog != null:
return shareLog(_that.file);case _ViewLog() when viewLog != null:
return viewLog(_that.file);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function()  refresh,required TResult Function()  triggerCrash,required TResult Function()  deleteAll,required TResult Function( File file)  deleteLog,required TResult Function( File file)  shareLog,required TResult Function( File file)  viewLog,}) {final _that = this;
switch (_that) {
case _Init():
return init();case _Refresh():
return refresh();case _TriggerCrash():
return triggerCrash();case _DeleteAll():
return deleteAll();case _DeleteLog():
return deleteLog(_that.file);case _ShareLog():
return shareLog(_that.file);case _ViewLog():
return viewLog(_that.file);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function()?  refresh,TResult? Function()?  triggerCrash,TResult? Function()?  deleteAll,TResult? Function( File file)?  deleteLog,TResult? Function( File file)?  shareLog,TResult? Function( File file)?  viewLog,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _Refresh() when refresh != null:
return refresh();case _TriggerCrash() when triggerCrash != null:
return triggerCrash();case _DeleteAll() when deleteAll != null:
return deleteAll();case _DeleteLog() when deleteLog != null:
return deleteLog(_that.file);case _ShareLog() when shareLog != null:
return shareLog(_that.file);case _ViewLog() when viewLog != null:
return viewLog(_that.file);case _:
  return null;

}
}

}

/// @nodoc


class _Init extends CrashLogListIntent {
  const _Init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CrashLogListIntent.init()';
}


}




/// @nodoc


class _Refresh extends CrashLogListIntent {
  const _Refresh(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CrashLogListIntent.refresh()';
}


}




/// @nodoc


class _TriggerCrash extends CrashLogListIntent {
  const _TriggerCrash(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerCrash);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CrashLogListIntent.triggerCrash()';
}


}




/// @nodoc


class _DeleteAll extends CrashLogListIntent {
  const _DeleteAll(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CrashLogListIntent.deleteAll()';
}


}




/// @nodoc


class _DeleteLog extends CrashLogListIntent {
  const _DeleteLog(this.file): super._();
  

 final  File file;

/// Create a copy of CrashLogListIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteLogCopyWith<_DeleteLog> get copyWith => __$DeleteLogCopyWithImpl<_DeleteLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteLog&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'CrashLogListIntent.deleteLog(file: $file)';
}


}

/// @nodoc
abstract mixin class _$DeleteLogCopyWith<$Res> implements $CrashLogListIntentCopyWith<$Res> {
  factory _$DeleteLogCopyWith(_DeleteLog value, $Res Function(_DeleteLog) _then) = __$DeleteLogCopyWithImpl;
@useResult
$Res call({
 File file
});




}
/// @nodoc
class __$DeleteLogCopyWithImpl<$Res>
    implements _$DeleteLogCopyWith<$Res> {
  __$DeleteLogCopyWithImpl(this._self, this._then);

  final _DeleteLog _self;
  final $Res Function(_DeleteLog) _then;

/// Create a copy of CrashLogListIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(_DeleteLog(
null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc


class _ShareLog extends CrashLogListIntent {
  const _ShareLog(this.file): super._();
  

 final  File file;

/// Create a copy of CrashLogListIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareLogCopyWith<_ShareLog> get copyWith => __$ShareLogCopyWithImpl<_ShareLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShareLog&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'CrashLogListIntent.shareLog(file: $file)';
}


}

/// @nodoc
abstract mixin class _$ShareLogCopyWith<$Res> implements $CrashLogListIntentCopyWith<$Res> {
  factory _$ShareLogCopyWith(_ShareLog value, $Res Function(_ShareLog) _then) = __$ShareLogCopyWithImpl;
@useResult
$Res call({
 File file
});




}
/// @nodoc
class __$ShareLogCopyWithImpl<$Res>
    implements _$ShareLogCopyWith<$Res> {
  __$ShareLogCopyWithImpl(this._self, this._then);

  final _ShareLog _self;
  final $Res Function(_ShareLog) _then;

/// Create a copy of CrashLogListIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(_ShareLog(
null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc


class _ViewLog extends CrashLogListIntent {
  const _ViewLog(this.file): super._();
  

 final  File file;

/// Create a copy of CrashLogListIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewLogCopyWith<_ViewLog> get copyWith => __$ViewLogCopyWithImpl<_ViewLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewLog&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'CrashLogListIntent.viewLog(file: $file)';
}


}

/// @nodoc
abstract mixin class _$ViewLogCopyWith<$Res> implements $CrashLogListIntentCopyWith<$Res> {
  factory _$ViewLogCopyWith(_ViewLog value, $Res Function(_ViewLog) _then) = __$ViewLogCopyWithImpl;
@useResult
$Res call({
 File file
});




}
/// @nodoc
class __$ViewLogCopyWithImpl<$Res>
    implements _$ViewLogCopyWith<$Res> {
  __$ViewLogCopyWithImpl(this._self, this._then);

  final _ViewLog _self;
  final $Res Function(_ViewLog) _then;

/// Create a copy of CrashLogListIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(_ViewLog(
null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

// dart format on
