import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setupNavigation(BuildContext context) {
    ref.listenNavigation<LoginState, LoginNavigationTarget>(loginViewModelProvider, (target) {
      switch (target) {
        case LoginNavigationTarget.signup:
          AppNav.to("${Routes.signup}?${Routes.argName}=${_usernameController.text}");
          break;
        case LoginNavigationTarget.forgotPassword:
          AppNav.to(Routes.forgotPassword);
          break;
        case LoginNavigationTarget.success:
          AppNav.back(true);
          break;
        case LoginNavigationTarget.back:
          AppNav.back(false);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setupNavigation(context);

    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (_usernameController.text.isEmpty && next.username.isNotEmpty) {
        _usernameController.text = next.username;
      }
      if (_passwordController.text.isEmpty && next.password.isNotEmpty) {
        _passwordController.text = next.password;
      }
    });

    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final accentColor = context.accentColor;

    return BasePage(
      provider: loginViewModelProvider,
      body: (context, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo
              Hero(
                tag: 'logo',
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CommonImage.asset(
                      R.imagesIcLauncherAdaptiveFore,
                      width: 60,
                      height: 60,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Header
              Column(
                children: [
                  CommonText(
                    I18nKeys.welcomeBack.tr,
                    style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CommonText(
                    I18nKeys.signInToContinue.tr,
                    style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // Username
              CommonTextField(
                controller: _usernameController,
                type: TextFieldType.text,
                labelText: I18nKeys.username.tr,
                prefixIcon: Icons.person_outline,
                errorText: state.usernameError,
                onChanged: (value) => viewModel.handleIntent(LoginIntent.usernameChanged(value)),
              ),
              const SizedBox(height: 20),
              // Password
              CommonTextField(
                controller: _passwordController,
                type: TextFieldType.password,
                labelText: I18nKeys.password.tr,
                prefixIcon: Icons.lock_outline,
                errorText: state.passwordError,
                onChanged: (value) => viewModel.handleIntent(LoginIntent.passwordChanged(value)),
              ),
              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Wrap Checkbox with Transform.translate to nudge it down for better alignment
                        Transform.translate(
                          offset: const Offset(0, 1),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: state.rememberMe,
                              activeColor: accentColor,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value) =>
                                  viewModel.handleIntent(const LoginIntent.toggleRememberMe()),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: CommonButton(
                            text: I18nKeys.rememberMe.tr,
                            type: ButtonType.text,
                            isFullWidth: false,
                            height: 40,
                            padding: EdgeInsets.zero,
                            foregroundColor: Colors.grey,
                            fontSize: 14.f,
                            onPressed: () => viewModel.handleIntent(const LoginIntent.toggleRememberMe()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: CommonButton(
                      text: I18nKeys.forgotPassword.tr,
                      type: ButtonType.text,
                      isFullWidth: false,
                      height: 40,
                      padding: EdgeInsets.zero,
                      fontSize: 14.f,
                      onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToForgotPassword()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Buttons
              CommonButton(
                text: I18nKeys.login.tr,
                isLoading: state.isLoading,
                onPressed: () => viewModel.handleIntent(const LoginIntent.submitLogin()),
                borderRadius: 15,
                height: 56,
              ),
              const SizedBox(height: 15),
              CommonButton(
                text: I18nKeys.skipForNow.tr,
                type: ButtonType.text,
                foregroundColor: Colors.grey,
                onPressed: () => viewModel.handleIntent(const LoginIntent.skipLogin()),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: CommonText(
                      I18nKeys.noAccount.tr,
                      style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CommonButton(
                    text: I18nKeys.signUp.tr,
                    type: ButtonType.text,
                    isFullWidth: false,
                    onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
