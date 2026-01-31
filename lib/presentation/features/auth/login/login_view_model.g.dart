// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginViewModelHash() => r'55adcaf68686b64cb4118d5491d56dab8142d956';

/// ViewModel for login feature
/// Handles user intents and emits new states
/// Implements unidirectional data flow (MVI pattern)
///
/// Copied from [LoginViewModel].
@ProviderFor(LoginViewModel)
final loginViewModelProvider =
    AutoDisposeNotifierProvider<LoginViewModel, LoginState>.internal(
      LoginViewModel.new,
      name: r'loginViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loginViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoginViewModel = AutoDisposeNotifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
