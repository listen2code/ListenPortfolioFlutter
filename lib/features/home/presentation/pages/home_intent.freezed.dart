// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent()';
}


}

/// @nodoc
class $HomeIntentCopyWith<$Res>  {
$HomeIntentCopyWith(HomeIntent _, $Res Function(HomeIntent) __);
}


/// Adds pattern-matching-related methods to [HomeIntent].
extension HomeIntentPatterns on HomeIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TabChanged value)?  tabChanged,TResult Function( _Refresh value)?  refresh,TResult Function( _Logout value)?  logout,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that);case _Refresh() when refresh != null:
return refresh(_that);case _Logout() when logout != null:
return logout(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TabChanged value)  tabChanged,required TResult Function( _Refresh value)  refresh,required TResult Function( _Logout value)  logout,}){
final _that = this;
switch (_that) {
case _TabChanged():
return tabChanged(_that);case _Refresh():
return refresh(_that);case _Logout():
return logout(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TabChanged value)?  tabChanged,TResult? Function( _Refresh value)?  refresh,TResult? Function( _Logout value)?  logout,}){
final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that);case _Refresh() when refresh != null:
return refresh(_that);case _Logout() when logout != null:
return logout(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( HomeTab tab)?  tabChanged,TResult Function()?  refresh,TResult Function()?  logout,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that.tab);case _Refresh() when refresh != null:
return refresh();case _Logout() when logout != null:
return logout();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( HomeTab tab)  tabChanged,required TResult Function()  refresh,required TResult Function()  logout,}) {final _that = this;
switch (_that) {
case _TabChanged():
return tabChanged(_that.tab);case _Refresh():
return refresh();case _Logout():
return logout();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( HomeTab tab)?  tabChanged,TResult? Function()?  refresh,TResult? Function()?  logout,}) {final _that = this;
switch (_that) {
case _TabChanged() when tabChanged != null:
return tabChanged(_that.tab);case _Refresh() when refresh != null:
return refresh();case _Logout() when logout != null:
return logout();case _:
  return null;

}
}

}

/// @nodoc


class _TabChanged extends HomeIntent {
  const _TabChanged(this.tab): super._();
  

 final  HomeTab tab;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TabChangedCopyWith<_TabChanged> get copyWith => __$TabChangedCopyWithImpl<_TabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TabChanged&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'HomeIntent.tabChanged(tab: $tab)';
}


}

/// @nodoc
abstract mixin class _$TabChangedCopyWith<$Res> implements $HomeIntentCopyWith<$Res> {
  factory _$TabChangedCopyWith(_TabChanged value, $Res Function(_TabChanged) _then) = __$TabChangedCopyWithImpl;
@useResult
$Res call({
 HomeTab tab
});




}
/// @nodoc
class __$TabChangedCopyWithImpl<$Res>
    implements _$TabChangedCopyWith<$Res> {
  __$TabChangedCopyWithImpl(this._self, this._then);

  final _TabChanged _self;
  final $Res Function(_TabChanged) _then;

/// Create a copy of HomeIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(_TabChanged(
null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as HomeTab,
  ));
}


}

/// @nodoc


class _Refresh extends HomeIntent {
  const _Refresh(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.refresh()';
}


}




/// @nodoc


class _Logout extends HomeIntent {
  const _Logout(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Logout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeIntent.logout()';
}


}




// dart format on
