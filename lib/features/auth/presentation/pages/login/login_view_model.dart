import 'dart:async';

import 'package:listen_core/core.dart';
import '../../../data/models/login_request_model.dart';
import '../../../data/models/user_model.dart';
import 'login_intent.dart';
import '../../provider/auth_provider.dart';
import '../../../../../shared/shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel with ViewModelMixin<LoginState, LoginIntent> {
  @override
  LoginState build() {
    final rememberMe = SpUtil.getBool(AppConstants.loginRememberMeKey);
    if (rememberMe) {
      final username = SpUtil.getString(AppConstants.loginUsernameKey) ?? '';
      _loadSavedPassword();
      return LoginState(username: username, rememberMe: true);
    }
    return const LoginState();
  }

  @override
  FutureOr<void> onIntent(LoginIntent intent) {
    return intent.when<FutureOr<void>>(
      usernameChanged: _onUsernameChanged,
      passwordChanged: _onPasswordChanged,
      togglePasswordVisibility: _onTogglePasswordVisibility,
      toggleRememberMe: _onToggleRememberMe,
      submitLogin: _onSubmitLogin,
      navigateToSignup: () => emitEffect(NavigationEffect(
            target: Routes.signUp,
            arguments: SignUpArguments(initialUsername: state.username),
          )),
      navigateToForgotPassword: () => emitEffect(NavigationEffect(target: Routes.forgotPassword)),
      skipLogin: () => emitEffect(NavigationEffect.back(result: false)),
    );
  }

  Future<void> _onUsernameChanged(String username) async {
    updateState(state.copyWith(username: username, usernameError: null));
    if (state.rememberMe) await _saveOrClearCredentials();
  }

  Future<void> _onPasswordChanged(String password) async {
    updateState(state.copyWith(password: password, passwordError: null));
    if (state.rememberMe) await _saveOrClearCredentials();
  }

  void _onTogglePasswordVisibility() {
    updateState(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onToggleRememberMe() async {
    updateState(state.copyWith(rememberMe: !state.rememberMe));
    await _saveOrClearCredentials();
  }

  Future<void> _onSubmitLogin() async {
    final usernameError = Validators.validateUsername(
      state.username,
      requiredMsg: I18nKeys.fieldRequired.tr,
      minLengthMsg: I18nKeys.minLengthMsg.trArgs(['3']),
    );
    final passwordError = Validators.validatePassword(
      state.password,
      requiredMsg: I18nKeys.fieldRequired.tr,
      minLengthMsg: I18nKeys.minLengthMsg.trArgs(['6']),
    );

    if (usernameError != null || passwordError != null) {
      updateState(state.copyWith(usernameError: usernameError, passwordError: passwordError));
      return;
    }

    await call<UserModel?>(
      ref.execute(
        loginUseCaseProvider,
        param: LoginRequestModel(userName: state.username, password: state.password),
      ),
      showLoading: true,
      onSuccess: (user) async {
        authManager.login(user);
        emitEffect(MessageEffect(I18nKeys.loginSuccess.tr));
        emitEffect(NavigationEffect.back(result: true));
      },
    );
  }

  /// Load the saved password from secure storage and update the state.
  Future<void> _loadSavedPassword() async {
    final password = await SecureStorageUtil.get(AppConstants.loginPasswordKey) ?? '';
    updateState(state.copyWith(password: password));
  }

  Future<void> _saveOrClearCredentials() async {
    if (state.rememberMe) {
      await SpUtil.put(AppConstants.loginUsernameKey, state.username);
      await SecureStorageUtil.put(AppConstants.loginPasswordKey, state.password);
      await SpUtil.put(AppConstants.loginRememberMeKey, true);
    } else {
      await SpUtil.remove(AppConstants.loginUsernameKey);
      await SecureStorageUtil.remove(AppConstants.loginPasswordKey);
      await SpUtil.put(AppConstants.loginRememberMeKey, false);
    }
  }
}
