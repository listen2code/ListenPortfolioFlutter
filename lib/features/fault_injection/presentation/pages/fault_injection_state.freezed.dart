// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fault_injection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaultInjectionState {

 FaultCategory get selectedCategory; List<FaultScenarioModel> get scenarios; FaultScenarioType? get runningType; String? get activeTraceId; List<ExecutionStepLog> get consoleLogs; bool get isSafeModeTriggered; int get totalRuns; int get recoveredCount;
/// Create a copy of FaultInjectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaultInjectionStateCopyWith<FaultInjectionState> get copyWith => _$FaultInjectionStateCopyWithImpl<FaultInjectionState>(this as FaultInjectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaultInjectionState&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&const DeepCollectionEquality().equals(other.scenarios, scenarios)&&(identical(other.runningType, runningType) || other.runningType == runningType)&&(identical(other.activeTraceId, activeTraceId) || other.activeTraceId == activeTraceId)&&const DeepCollectionEquality().equals(other.consoleLogs, consoleLogs)&&(identical(other.isSafeModeTriggered, isSafeModeTriggered) || other.isSafeModeTriggered == isSafeModeTriggered)&&(identical(other.totalRuns, totalRuns) || other.totalRuns == totalRuns)&&(identical(other.recoveredCount, recoveredCount) || other.recoveredCount == recoveredCount));
}


@override
int get hashCode => Object.hash(runtimeType,selectedCategory,const DeepCollectionEquality().hash(scenarios),runningType,activeTraceId,const DeepCollectionEquality().hash(consoleLogs),isSafeModeTriggered,totalRuns,recoveredCount);

@override
String toString() {
  return 'FaultInjectionState(selectedCategory: $selectedCategory, scenarios: $scenarios, runningType: $runningType, activeTraceId: $activeTraceId, consoleLogs: $consoleLogs, isSafeModeTriggered: $isSafeModeTriggered, totalRuns: $totalRuns, recoveredCount: $recoveredCount)';
}


}

/// @nodoc
abstract mixin class $FaultInjectionStateCopyWith<$Res>  {
  factory $FaultInjectionStateCopyWith(FaultInjectionState value, $Res Function(FaultInjectionState) _then) = _$FaultInjectionStateCopyWithImpl;
@useResult
$Res call({
 FaultCategory selectedCategory, List<FaultScenarioModel> scenarios, FaultScenarioType? runningType, String? activeTraceId, List<ExecutionStepLog> consoleLogs, bool isSafeModeTriggered, int totalRuns, int recoveredCount
});




}
/// @nodoc
class _$FaultInjectionStateCopyWithImpl<$Res>
    implements $FaultInjectionStateCopyWith<$Res> {
  _$FaultInjectionStateCopyWithImpl(this._self, this._then);

  final FaultInjectionState _self;
  final $Res Function(FaultInjectionState) _then;

/// Create a copy of FaultInjectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedCategory = null,Object? scenarios = null,Object? runningType = freezed,Object? activeTraceId = freezed,Object? consoleLogs = null,Object? isSafeModeTriggered = null,Object? totalRuns = null,Object? recoveredCount = null,}) {
  return _then(_self.copyWith(
selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as FaultCategory,scenarios: null == scenarios ? _self.scenarios : scenarios // ignore: cast_nullable_to_non_nullable
as List<FaultScenarioModel>,runningType: freezed == runningType ? _self.runningType : runningType // ignore: cast_nullable_to_non_nullable
as FaultScenarioType?,activeTraceId: freezed == activeTraceId ? _self.activeTraceId : activeTraceId // ignore: cast_nullable_to_non_nullable
as String?,consoleLogs: null == consoleLogs ? _self.consoleLogs : consoleLogs // ignore: cast_nullable_to_non_nullable
as List<ExecutionStepLog>,isSafeModeTriggered: null == isSafeModeTriggered ? _self.isSafeModeTriggered : isSafeModeTriggered // ignore: cast_nullable_to_non_nullable
as bool,totalRuns: null == totalRuns ? _self.totalRuns : totalRuns // ignore: cast_nullable_to_non_nullable
as int,recoveredCount: null == recoveredCount ? _self.recoveredCount : recoveredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FaultInjectionState].
extension FaultInjectionStatePatterns on FaultInjectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaultInjectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaultInjectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaultInjectionState value)  $default,){
final _that = this;
switch (_that) {
case _FaultInjectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaultInjectionState value)?  $default,){
final _that = this;
switch (_that) {
case _FaultInjectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FaultCategory selectedCategory,  List<FaultScenarioModel> scenarios,  FaultScenarioType? runningType,  String? activeTraceId,  List<ExecutionStepLog> consoleLogs,  bool isSafeModeTriggered,  int totalRuns,  int recoveredCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaultInjectionState() when $default != null:
return $default(_that.selectedCategory,_that.scenarios,_that.runningType,_that.activeTraceId,_that.consoleLogs,_that.isSafeModeTriggered,_that.totalRuns,_that.recoveredCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FaultCategory selectedCategory,  List<FaultScenarioModel> scenarios,  FaultScenarioType? runningType,  String? activeTraceId,  List<ExecutionStepLog> consoleLogs,  bool isSafeModeTriggered,  int totalRuns,  int recoveredCount)  $default,) {final _that = this;
switch (_that) {
case _FaultInjectionState():
return $default(_that.selectedCategory,_that.scenarios,_that.runningType,_that.activeTraceId,_that.consoleLogs,_that.isSafeModeTriggered,_that.totalRuns,_that.recoveredCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FaultCategory selectedCategory,  List<FaultScenarioModel> scenarios,  FaultScenarioType? runningType,  String? activeTraceId,  List<ExecutionStepLog> consoleLogs,  bool isSafeModeTriggered,  int totalRuns,  int recoveredCount)?  $default,) {final _that = this;
switch (_that) {
case _FaultInjectionState() when $default != null:
return $default(_that.selectedCategory,_that.scenarios,_that.runningType,_that.activeTraceId,_that.consoleLogs,_that.isSafeModeTriggered,_that.totalRuns,_that.recoveredCount);case _:
  return null;

}
}

}

/// @nodoc


class _FaultInjectionState extends FaultInjectionState {
  const _FaultInjectionState({this.selectedCategory = FaultCategory.all, final  List<FaultScenarioModel> scenarios = const [], this.runningType, this.activeTraceId, final  List<ExecutionStepLog> consoleLogs = const [], this.isSafeModeTriggered = false, this.totalRuns = 0, this.recoveredCount = 0}): _scenarios = scenarios,_consoleLogs = consoleLogs,super._();
  

@override@JsonKey() final  FaultCategory selectedCategory;
 final  List<FaultScenarioModel> _scenarios;
@override@JsonKey() List<FaultScenarioModel> get scenarios {
  if (_scenarios is EqualUnmodifiableListView) return _scenarios;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scenarios);
}

@override final  FaultScenarioType? runningType;
@override final  String? activeTraceId;
 final  List<ExecutionStepLog> _consoleLogs;
@override@JsonKey() List<ExecutionStepLog> get consoleLogs {
  if (_consoleLogs is EqualUnmodifiableListView) return _consoleLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_consoleLogs);
}

@override@JsonKey() final  bool isSafeModeTriggered;
@override@JsonKey() final  int totalRuns;
@override@JsonKey() final  int recoveredCount;

/// Create a copy of FaultInjectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaultInjectionStateCopyWith<_FaultInjectionState> get copyWith => __$FaultInjectionStateCopyWithImpl<_FaultInjectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaultInjectionState&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&const DeepCollectionEquality().equals(other._scenarios, _scenarios)&&(identical(other.runningType, runningType) || other.runningType == runningType)&&(identical(other.activeTraceId, activeTraceId) || other.activeTraceId == activeTraceId)&&const DeepCollectionEquality().equals(other._consoleLogs, _consoleLogs)&&(identical(other.isSafeModeTriggered, isSafeModeTriggered) || other.isSafeModeTriggered == isSafeModeTriggered)&&(identical(other.totalRuns, totalRuns) || other.totalRuns == totalRuns)&&(identical(other.recoveredCount, recoveredCount) || other.recoveredCount == recoveredCount));
}


@override
int get hashCode => Object.hash(runtimeType,selectedCategory,const DeepCollectionEquality().hash(_scenarios),runningType,activeTraceId,const DeepCollectionEquality().hash(_consoleLogs),isSafeModeTriggered,totalRuns,recoveredCount);

@override
String toString() {
  return 'FaultInjectionState(selectedCategory: $selectedCategory, scenarios: $scenarios, runningType: $runningType, activeTraceId: $activeTraceId, consoleLogs: $consoleLogs, isSafeModeTriggered: $isSafeModeTriggered, totalRuns: $totalRuns, recoveredCount: $recoveredCount)';
}


}

/// @nodoc
abstract mixin class _$FaultInjectionStateCopyWith<$Res> implements $FaultInjectionStateCopyWith<$Res> {
  factory _$FaultInjectionStateCopyWith(_FaultInjectionState value, $Res Function(_FaultInjectionState) _then) = __$FaultInjectionStateCopyWithImpl;
@override @useResult
$Res call({
 FaultCategory selectedCategory, List<FaultScenarioModel> scenarios, FaultScenarioType? runningType, String? activeTraceId, List<ExecutionStepLog> consoleLogs, bool isSafeModeTriggered, int totalRuns, int recoveredCount
});




}
/// @nodoc
class __$FaultInjectionStateCopyWithImpl<$Res>
    implements _$FaultInjectionStateCopyWith<$Res> {
  __$FaultInjectionStateCopyWithImpl(this._self, this._then);

  final _FaultInjectionState _self;
  final $Res Function(_FaultInjectionState) _then;

/// Create a copy of FaultInjectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedCategory = null,Object? scenarios = null,Object? runningType = freezed,Object? activeTraceId = freezed,Object? consoleLogs = null,Object? isSafeModeTriggered = null,Object? totalRuns = null,Object? recoveredCount = null,}) {
  return _then(_FaultInjectionState(
selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as FaultCategory,scenarios: null == scenarios ? _self._scenarios : scenarios // ignore: cast_nullable_to_non_nullable
as List<FaultScenarioModel>,runningType: freezed == runningType ? _self.runningType : runningType // ignore: cast_nullable_to_non_nullable
as FaultScenarioType?,activeTraceId: freezed == activeTraceId ? _self.activeTraceId : activeTraceId // ignore: cast_nullable_to_non_nullable
as String?,consoleLogs: null == consoleLogs ? _self._consoleLogs : consoleLogs // ignore: cast_nullable_to_non_nullable
as List<ExecutionStepLog>,isSafeModeTriggered: null == isSafeModeTriggered ? _self.isSafeModeTriggered : isSafeModeTriggered // ignore: cast_nullable_to_non_nullable
as bool,totalRuns: null == totalRuns ? _self.totalRuns : totalRuns // ignore: cast_nullable_to_non_nullable
as int,recoveredCount: null == recoveredCount ? _self.recoveredCount : recoveredCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
