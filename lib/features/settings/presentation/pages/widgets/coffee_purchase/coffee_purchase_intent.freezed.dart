// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coffee_purchase_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoffeePurchaseIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoffeePurchaseIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CoffeePurchaseIntent()';
}


}

/// @nodoc
class $CoffeePurchaseIntentCopyWith<$Res>  {
$CoffeePurchaseIntentCopyWith(CoffeePurchaseIntent _, $Res Function(CoffeePurchaseIntent) __);
}


/// Adds pattern-matching-related methods to [CoffeePurchaseIntent].
extension CoffeePurchaseIntentPatterns on CoffeePurchaseIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Init value)?  init,TResult Function( _BuyProduct value)?  buyProduct,TResult Function( _PurchaseUpdated value)?  purchaseUpdated,TResult Function( _AppResumed value)?  appResumed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _BuyProduct() when buyProduct != null:
return buyProduct(_that);case _PurchaseUpdated() when purchaseUpdated != null:
return purchaseUpdated(_that);case _AppResumed() when appResumed != null:
return appResumed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Init value)  init,required TResult Function( _BuyProduct value)  buyProduct,required TResult Function( _PurchaseUpdated value)  purchaseUpdated,required TResult Function( _AppResumed value)  appResumed,}){
final _that = this;
switch (_that) {
case _Init():
return init(_that);case _BuyProduct():
return buyProduct(_that);case _PurchaseUpdated():
return purchaseUpdated(_that);case _AppResumed():
return appResumed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Init value)?  init,TResult? Function( _BuyProduct value)?  buyProduct,TResult? Function( _PurchaseUpdated value)?  purchaseUpdated,TResult? Function( _AppResumed value)?  appResumed,}){
final _that = this;
switch (_that) {
case _Init() when init != null:
return init(_that);case _BuyProduct() when buyProduct != null:
return buyProduct(_that);case _PurchaseUpdated() when purchaseUpdated != null:
return purchaseUpdated(_that);case _AppResumed() when appResumed != null:
return appResumed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function( String productId)?  buyProduct,TResult Function( List<PurchaseDetails> purchases)?  purchaseUpdated,TResult Function()?  appResumed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _BuyProduct() when buyProduct != null:
return buyProduct(_that.productId);case _PurchaseUpdated() when purchaseUpdated != null:
return purchaseUpdated(_that.purchases);case _AppResumed() when appResumed != null:
return appResumed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function( String productId)  buyProduct,required TResult Function( List<PurchaseDetails> purchases)  purchaseUpdated,required TResult Function()  appResumed,}) {final _that = this;
switch (_that) {
case _Init():
return init();case _BuyProduct():
return buyProduct(_that.productId);case _PurchaseUpdated():
return purchaseUpdated(_that.purchases);case _AppResumed():
return appResumed();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function( String productId)?  buyProduct,TResult? Function( List<PurchaseDetails> purchases)?  purchaseUpdated,TResult? Function()?  appResumed,}) {final _that = this;
switch (_that) {
case _Init() when init != null:
return init();case _BuyProduct() when buyProduct != null:
return buyProduct(_that.productId);case _PurchaseUpdated() when purchaseUpdated != null:
return purchaseUpdated(_that.purchases);case _AppResumed() when appResumed != null:
return appResumed();case _:
  return null;

}
}

}

/// @nodoc


class _Init extends CoffeePurchaseIntent {
  const _Init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Init);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CoffeePurchaseIntent.init()';
}


}




/// @nodoc


class _BuyProduct extends CoffeePurchaseIntent {
  const _BuyProduct(this.productId): super._();
  

 final  String productId;

/// Create a copy of CoffeePurchaseIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuyProductCopyWith<_BuyProduct> get copyWith => __$BuyProductCopyWithImpl<_BuyProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuyProduct&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'CoffeePurchaseIntent.buyProduct(productId: $productId)';
}


}

/// @nodoc
abstract mixin class _$BuyProductCopyWith<$Res> implements $CoffeePurchaseIntentCopyWith<$Res> {
  factory _$BuyProductCopyWith(_BuyProduct value, $Res Function(_BuyProduct) _then) = __$BuyProductCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class __$BuyProductCopyWithImpl<$Res>
    implements _$BuyProductCopyWith<$Res> {
  __$BuyProductCopyWithImpl(this._self, this._then);

  final _BuyProduct _self;
  final $Res Function(_BuyProduct) _then;

/// Create a copy of CoffeePurchaseIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(_BuyProduct(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PurchaseUpdated extends CoffeePurchaseIntent {
  const _PurchaseUpdated(final  List<PurchaseDetails> purchases): _purchases = purchases,super._();
  

 final  List<PurchaseDetails> _purchases;
 List<PurchaseDetails> get purchases {
  if (_purchases is EqualUnmodifiableListView) return _purchases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purchases);
}


/// Create a copy of CoffeePurchaseIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseUpdatedCopyWith<_PurchaseUpdated> get copyWith => __$PurchaseUpdatedCopyWithImpl<_PurchaseUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseUpdated&&const DeepCollectionEquality().equals(other._purchases, _purchases));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_purchases));

@override
String toString() {
  return 'CoffeePurchaseIntent.purchaseUpdated(purchases: $purchases)';
}


}

/// @nodoc
abstract mixin class _$PurchaseUpdatedCopyWith<$Res> implements $CoffeePurchaseIntentCopyWith<$Res> {
  factory _$PurchaseUpdatedCopyWith(_PurchaseUpdated value, $Res Function(_PurchaseUpdated) _then) = __$PurchaseUpdatedCopyWithImpl;
@useResult
$Res call({
 List<PurchaseDetails> purchases
});




}
/// @nodoc
class __$PurchaseUpdatedCopyWithImpl<$Res>
    implements _$PurchaseUpdatedCopyWith<$Res> {
  __$PurchaseUpdatedCopyWithImpl(this._self, this._then);

  final _PurchaseUpdated _self;
  final $Res Function(_PurchaseUpdated) _then;

/// Create a copy of CoffeePurchaseIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? purchases = null,}) {
  return _then(_PurchaseUpdated(
null == purchases ? _self._purchases : purchases // ignore: cast_nullable_to_non_nullable
as List<PurchaseDetails>,
  ));
}


}

/// @nodoc


class _AppResumed extends CoffeePurchaseIntent {
  const _AppResumed(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppResumed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CoffeePurchaseIntent.appResumed()';
}


}




// dart format on
