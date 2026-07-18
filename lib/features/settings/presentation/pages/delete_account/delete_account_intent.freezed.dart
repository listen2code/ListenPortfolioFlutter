// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_intent.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeleteAccountIntent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountIntent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeleteAccountIntent()';
}


}

/// @nodoc
class $DeleteAccountIntentCopyWith<$Res>  {
$DeleteAccountIntentCopyWith(DeleteAccountIntent _, $Res Function(DeleteAccountIntent) __);
}


/// Adds pattern-matching-related methods to [DeleteAccountIntent].
extension DeleteAccountIntentPatterns on DeleteAccountIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ToggleConfirm value)?  toggleConfirm,TResult Function( _DeleteAccount value)?  deleteAccount,TResult Function( _ConfirmDelete value)?  confirmDelete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToggleConfirm() when toggleConfirm != null:
return toggleConfirm(_that);case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that);case _ConfirmDelete() when confirmDelete != null:
return confirmDelete(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ToggleConfirm value)  toggleConfirm,required TResult Function( _DeleteAccount value)  deleteAccount,required TResult Function( _ConfirmDelete value)  confirmDelete,}){
final _that = this;
switch (_that) {
case _ToggleConfirm():
return toggleConfirm(_that);case _DeleteAccount():
return deleteAccount(_that);case _ConfirmDelete():
return confirmDelete(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ToggleConfirm value)?  toggleConfirm,TResult? Function( _DeleteAccount value)?  deleteAccount,TResult? Function( _ConfirmDelete value)?  confirmDelete,}){
final _that = this;
switch (_that) {
case _ToggleConfirm() when toggleConfirm != null:
return toggleConfirm(_that);case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that);case _ConfirmDelete() when confirmDelete != null:
return confirmDelete(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  toggleConfirm,TResult Function()?  deleteAccount,TResult Function()?  confirmDelete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToggleConfirm() when toggleConfirm != null:
return toggleConfirm();case _DeleteAccount() when deleteAccount != null:
return deleteAccount();case _ConfirmDelete() when confirmDelete != null:
return confirmDelete();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  toggleConfirm,required TResult Function()  deleteAccount,required TResult Function()  confirmDelete,}) {final _that = this;
switch (_that) {
case _ToggleConfirm():
return toggleConfirm();case _DeleteAccount():
return deleteAccount();case _ConfirmDelete():
return confirmDelete();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  toggleConfirm,TResult? Function()?  deleteAccount,TResult? Function()?  confirmDelete,}) {final _that = this;
switch (_that) {
case _ToggleConfirm() when toggleConfirm != null:
return toggleConfirm();case _DeleteAccount() when deleteAccount != null:
return deleteAccount();case _ConfirmDelete() when confirmDelete != null:
return confirmDelete();case _:
  return null;

}
}

}

/// @nodoc


class _ToggleConfirm extends DeleteAccountIntent {
  const _ToggleConfirm(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleConfirm);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeleteAccountIntent.toggleConfirm()';
}


}




/// @nodoc


class _DeleteAccount extends DeleteAccountIntent {
  const _DeleteAccount(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccount);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeleteAccountIntent.deleteAccount()';
}


}




/// @nodoc


class _ConfirmDelete extends DeleteAccountIntent {
  const _ConfirmDelete(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfirmDelete);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DeleteAccountIntent.confirmDelete()';
}


}




// dart format on
