// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fault_injection_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaultInjectionIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaultInjectionIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaultInjectionIntent()';
}


}

/// @nodoc
class $FaultInjectionIntentCopyWith<$Res>  {
$FaultInjectionIntentCopyWith(FaultInjectionIntent _, $Res Function(FaultInjectionIntent) __);
}


/// Adds pattern-matching-related methods to [FaultInjectionIntent].
extension FaultInjectionIntentPatterns on FaultInjectionIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _SelectCategory value)?  selectCategory,TResult Function( _RunScenario value)?  runScenario,TResult Function( _ClearConsole value)?  clearConsole,TResult Function( _CopyTraceId value)?  copyTraceId,TResult Function( _DrillTrace value)?  drillTrace,TResult Function( _ResetAll value)?  resetAll,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _SelectCategory() when selectCategory != null:
return selectCategory(_that);case _RunScenario() when runScenario != null:
return runScenario(_that);case _ClearConsole() when clearConsole != null:
return clearConsole(_that);case _CopyTraceId() when copyTraceId != null:
return copyTraceId(_that);case _DrillTrace() when drillTrace != null:
return drillTrace(_that);case _ResetAll() when resetAll != null:
return resetAll(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _SelectCategory value)  selectCategory,required TResult Function( _RunScenario value)  runScenario,required TResult Function( _ClearConsole value)  clearConsole,required TResult Function( _CopyTraceId value)  copyTraceId,required TResult Function( _DrillTrace value)  drillTrace,required TResult Function( _ResetAll value)  resetAll,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _SelectCategory():
return selectCategory(_that);case _RunScenario():
return runScenario(_that);case _ClearConsole():
return clearConsole(_that);case _CopyTraceId():
return copyTraceId(_that);case _DrillTrace():
return drillTrace(_that);case _ResetAll():
return resetAll(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _SelectCategory value)?  selectCategory,TResult? Function( _RunScenario value)?  runScenario,TResult? Function( _ClearConsole value)?  clearConsole,TResult? Function( _CopyTraceId value)?  copyTraceId,TResult? Function( _DrillTrace value)?  drillTrace,TResult? Function( _ResetAll value)?  resetAll,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _SelectCategory() when selectCategory != null:
return selectCategory(_that);case _RunScenario() when runScenario != null:
return runScenario(_that);case _ClearConsole() when clearConsole != null:
return clearConsole(_that);case _CopyTraceId() when copyTraceId != null:
return copyTraceId(_that);case _DrillTrace() when drillTrace != null:
return drillTrace(_that);case _ResetAll() when resetAll != null:
return resetAll(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function( FaultCategory category)?  selectCategory,TResult Function( FaultScenarioType type)?  runScenario,TResult Function()?  clearConsole,TResult Function( String traceId)?  copyTraceId,TResult Function( String traceId)?  drillTrace,TResult Function()?  resetAll,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _SelectCategory() when selectCategory != null:
return selectCategory(_that.category);case _RunScenario() when runScenario != null:
return runScenario(_that.type);case _ClearConsole() when clearConsole != null:
return clearConsole();case _CopyTraceId() when copyTraceId != null:
return copyTraceId(_that.traceId);case _DrillTrace() when drillTrace != null:
return drillTrace(_that.traceId);case _ResetAll() when resetAll != null:
return resetAll();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function( FaultCategory category)  selectCategory,required TResult Function( FaultScenarioType type)  runScenario,required TResult Function()  clearConsole,required TResult Function( String traceId)  copyTraceId,required TResult Function( String traceId)  drillTrace,required TResult Function()  resetAll,}) {final _that = this;
switch (_that) {
case _Init():
return init();case _SelectCategory():
return selectCategory(_that.category);case _RunScenario():
return runScenario(_that.type);case _ClearConsole():
return clearConsole();case _CopyTraceId():
return copyTraceId(_that.traceId);case _DrillTrace():
return drillTrace(_that.traceId);case _ResetAll():
return resetAll();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function( FaultCategory category)?  selectCategory,TResult? Function( FaultScenarioType type)?  runScenario,TResult? Function()?  clearConsole,TResult? Function( String traceId)?  copyTraceId,TResult? Function( String traceId)?  drillTrace,TResult? Function()?  resetAll,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _SelectCategory() when selectCategory != null:
return selectCategory(_that.category);case _RunScenario() when runScenario != null:
return runScenario(_that.type);case _ClearConsole() when clearConsole != null:
return clearConsole();case _CopyTraceId() when copyTraceId != null:
return copyTraceId(_that.traceId);case _DrillTrace() when drillTrace != null:
return drillTrace(_that.traceId);case _ResetAll() when resetAll != null:
return resetAll();case _:
  return null;

}
}

}

/// @nodoc


class _Init extends FaultInjectionIntent {
  const _Init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaultInjectionIntent.init()';
}


}




/// @nodoc


class _SelectCategory extends FaultInjectionIntent {
  const _SelectCategory(this.category): super._();
  

 final  FaultCategory category;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectCategoryCopyWith<_SelectCategory> get copyWith => __$SelectCategoryCopyWithImpl<_SelectCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectCategory&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'FaultInjectionIntent.selectCategory(category: $category)';
}


}

/// @nodoc
abstract mixin class _$SelectCategoryCopyWith<$Res> implements $FaultInjectionIntentCopyWith<$Res> {
  factory _$SelectCategoryCopyWith(_SelectCategory value, $Res Function(_SelectCategory) _then) = __$SelectCategoryCopyWithImpl;
@useResult
$Res call({
 FaultCategory category
});




}
/// @nodoc
class __$SelectCategoryCopyWithImpl<$Res>
    implements _$SelectCategoryCopyWith<$Res> {
  __$SelectCategoryCopyWithImpl(this._self, this._then);

  final _SelectCategory _self;
  final $Res Function(_SelectCategory) _then;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(_SelectCategory(
null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FaultCategory,
  ));
}


}

/// @nodoc


class _RunScenario extends FaultInjectionIntent {
  const _RunScenario(this.type): super._();
  

 final  FaultScenarioType type;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunScenarioCopyWith<_RunScenario> get copyWith => __$RunScenarioCopyWithImpl<_RunScenario>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunScenario&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'FaultInjectionIntent.runScenario(type: $type)';
}


}

/// @nodoc
abstract mixin class _$RunScenarioCopyWith<$Res> implements $FaultInjectionIntentCopyWith<$Res> {
  factory _$RunScenarioCopyWith(_RunScenario value, $Res Function(_RunScenario) _then) = __$RunScenarioCopyWithImpl;
@useResult
$Res call({
 FaultScenarioType type
});




}
/// @nodoc
class __$RunScenarioCopyWithImpl<$Res>
    implements _$RunScenarioCopyWith<$Res> {
  __$RunScenarioCopyWithImpl(this._self, this._then);

  final _RunScenario _self;
  final $Res Function(_RunScenario) _then;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_RunScenario(
null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FaultScenarioType,
  ));
}


}

/// @nodoc


class _ClearConsole extends FaultInjectionIntent {
  const _ClearConsole(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClearConsole);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaultInjectionIntent.clearConsole()';
}


}




/// @nodoc


class _CopyTraceId extends FaultInjectionIntent {
  const _CopyTraceId(this.traceId): super._();
  

 final  String traceId;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CopyTraceIdCopyWith<_CopyTraceId> get copyWith => __$CopyTraceIdCopyWithImpl<_CopyTraceId>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CopyTraceId&&(identical(other.traceId, traceId) || other.traceId == traceId));
}


@override
int get hashCode => Object.hash(runtimeType,traceId);

@override
String toString() {
  return 'FaultInjectionIntent.copyTraceId(traceId: $traceId)';
}


}

/// @nodoc
abstract mixin class _$CopyTraceIdCopyWith<$Res> implements $FaultInjectionIntentCopyWith<$Res> {
  factory _$CopyTraceIdCopyWith(_CopyTraceId value, $Res Function(_CopyTraceId) _then) = __$CopyTraceIdCopyWithImpl;
@useResult
$Res call({
 String traceId
});




}
/// @nodoc
class __$CopyTraceIdCopyWithImpl<$Res>
    implements _$CopyTraceIdCopyWith<$Res> {
  __$CopyTraceIdCopyWithImpl(this._self, this._then);

  final _CopyTraceId _self;
  final $Res Function(_CopyTraceId) _then;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? traceId = null,}) {
  return _then(_CopyTraceId(
null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DrillTrace extends FaultInjectionIntent {
  const _DrillTrace(this.traceId): super._();
  

 final  String traceId;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrillTraceCopyWith<_DrillTrace> get copyWith => __$DrillTraceCopyWithImpl<_DrillTrace>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrillTrace&&(identical(other.traceId, traceId) || other.traceId == traceId));
}


@override
int get hashCode => Object.hash(runtimeType,traceId);

@override
String toString() {
  return 'FaultInjectionIntent.drillTrace(traceId: $traceId)';
}


}

/// @nodoc
abstract mixin class _$DrillTraceCopyWith<$Res> implements $FaultInjectionIntentCopyWith<$Res> {
  factory _$DrillTraceCopyWith(_DrillTrace value, $Res Function(_DrillTrace) _then) = __$DrillTraceCopyWithImpl;
@useResult
$Res call({
 String traceId
});




}
/// @nodoc
class __$DrillTraceCopyWithImpl<$Res>
    implements _$DrillTraceCopyWith<$Res> {
  __$DrillTraceCopyWithImpl(this._self, this._then);

  final _DrillTrace _self;
  final $Res Function(_DrillTrace) _then;

/// Create a copy of FaultInjectionIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? traceId = null,}) {
  return _then(_DrillTrace(
null == traceId ? _self.traceId : traceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResetAll extends FaultInjectionIntent {
  const _ResetAll(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FaultInjectionIntent.resetAll()';
}


}




// dart format on
