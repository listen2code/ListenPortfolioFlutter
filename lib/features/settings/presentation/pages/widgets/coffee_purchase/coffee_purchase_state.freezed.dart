// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coffee_purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoffeePurchaseState {

 bool get isLoading; List<ProductDetails> get products; bool get isPurchasing; String? get purchasingProductId;
/// Create a copy of CoffeePurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoffeePurchaseStateCopyWith<CoffeePurchaseState> get copyWith => _$CoffeePurchaseStateCopyWithImpl<CoffeePurchaseState>(this as CoffeePurchaseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoffeePurchaseState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.isPurchasing, isPurchasing) || other.isPurchasing == isPurchasing)&&(identical(other.purchasingProductId, purchasingProductId) || other.purchasingProductId == purchasingProductId));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(products),isPurchasing,purchasingProductId);

@override
String toString() {
  return 'CoffeePurchaseState(isLoading: $isLoading, products: $products, isPurchasing: $isPurchasing, purchasingProductId: $purchasingProductId)';
}


}

/// @nodoc
abstract mixin class $CoffeePurchaseStateCopyWith<$Res>  {
  factory $CoffeePurchaseStateCopyWith(CoffeePurchaseState value, $Res Function(CoffeePurchaseState) _then) = _$CoffeePurchaseStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<ProductDetails> products, bool isPurchasing, String? purchasingProductId
});




}
/// @nodoc
class _$CoffeePurchaseStateCopyWithImpl<$Res>
    implements $CoffeePurchaseStateCopyWith<$Res> {
  _$CoffeePurchaseStateCopyWithImpl(this._self, this._then);

  final CoffeePurchaseState _self;
  final $Res Function(CoffeePurchaseState) _then;

/// Create a copy of CoffeePurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? products = null,Object? isPurchasing = null,Object? purchasingProductId = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDetails>,isPurchasing: null == isPurchasing ? _self.isPurchasing : isPurchasing // ignore: cast_nullable_to_non_nullable
as bool,purchasingProductId: freezed == purchasingProductId ? _self.purchasingProductId : purchasingProductId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoffeePurchaseState].
extension CoffeePurchaseStatePatterns on CoffeePurchaseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoffeePurchaseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoffeePurchaseState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoffeePurchaseState value)  $default,){
final _that = this;
switch (_that) {
case _CoffeePurchaseState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoffeePurchaseState value)?  $default,){
final _that = this;
switch (_that) {
case _CoffeePurchaseState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<ProductDetails> products,  bool isPurchasing,  String? purchasingProductId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoffeePurchaseState() when $default != null:
return $default(_that.isLoading,_that.products,_that.isPurchasing,_that.purchasingProductId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<ProductDetails> products,  bool isPurchasing,  String? purchasingProductId)  $default,) {final _that = this;
switch (_that) {
case _CoffeePurchaseState():
return $default(_that.isLoading,_that.products,_that.isPurchasing,_that.purchasingProductId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<ProductDetails> products,  bool isPurchasing,  String? purchasingProductId)?  $default,) {final _that = this;
switch (_that) {
case _CoffeePurchaseState() when $default != null:
return $default(_that.isLoading,_that.products,_that.isPurchasing,_that.purchasingProductId);case _:
  return null;

}
}

}

/// @nodoc


class _CoffeePurchaseState extends CoffeePurchaseState {
  const _CoffeePurchaseState({this.isLoading = true, final  List<ProductDetails> products = const [], this.isPurchasing = false, this.purchasingProductId}): _products = products,super._();
  

@override@JsonKey() final  bool isLoading;
 final  List<ProductDetails> _products;
@override@JsonKey() List<ProductDetails> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override@JsonKey() final  bool isPurchasing;
@override final  String? purchasingProductId;

/// Create a copy of CoffeePurchaseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoffeePurchaseStateCopyWith<_CoffeePurchaseState> get copyWith => __$CoffeePurchaseStateCopyWithImpl<_CoffeePurchaseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoffeePurchaseState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.isPurchasing, isPurchasing) || other.isPurchasing == isPurchasing)&&(identical(other.purchasingProductId, purchasingProductId) || other.purchasingProductId == purchasingProductId));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_products),isPurchasing,purchasingProductId);

@override
String toString() {
  return 'CoffeePurchaseState(isLoading: $isLoading, products: $products, isPurchasing: $isPurchasing, purchasingProductId: $purchasingProductId)';
}


}

/// @nodoc
abstract mixin class _$CoffeePurchaseStateCopyWith<$Res> implements $CoffeePurchaseStateCopyWith<$Res> {
  factory _$CoffeePurchaseStateCopyWith(_CoffeePurchaseState value, $Res Function(_CoffeePurchaseState) _then) = __$CoffeePurchaseStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<ProductDetails> products, bool isPurchasing, String? purchasingProductId
});




}
/// @nodoc
class __$CoffeePurchaseStateCopyWithImpl<$Res>
    implements _$CoffeePurchaseStateCopyWith<$Res> {
  __$CoffeePurchaseStateCopyWithImpl(this._self, this._then);

  final _CoffeePurchaseState _self;
  final $Res Function(_CoffeePurchaseState) _then;

/// Create a copy of CoffeePurchaseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? products = null,Object? isPurchasing = null,Object? purchasingProductId = freezed,}) {
  return _then(_CoffeePurchaseState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDetails>,isPurchasing: null == isPurchasing ? _self.isPurchasing : isPurchasing // ignore: cast_nullable_to_non_nullable
as bool,purchasingProductId: freezed == purchasingProductId ? _self.purchasingProductId : purchasingProductId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
