import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';
import 'package:listen_portfolio_flutter/shared/extension/navigation_extension.dart';

/// Login page with MVI pattern
/// Uses ListenableBuilder to respond to global theme and language changes
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Listen for navigation intents
    _setupNavigation(context, ref);

    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    // 2. Wrap with ListenableBuilder for dynamic theme/language updates
    return ListenableBuilder(
      listenable: settingManager,

      builder: (context, child) {
        final theme = Theme.of(context);
        final accentColor = settingManager.accentColor;

        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withValues(alpha: 0.05), theme.scaffoldBackgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    _buildLogo(accentColor),
                    const SizedBox(height: 30),
                    _buildTitle(theme),
                    const SizedBox(height: 50),
                    _buildUsernameField(state, viewModel, theme, accentColor),
                    const SizedBox(height: 20),
                    _buildPasswordField(state, viewModel, theme, accentColor),
                    _buildForgotPasswordButton(viewModel, accentColor),
                    const SizedBox(height: 30),
                    _buildLoginButton(state, viewModel, accentColor),
                    const SizedBox(height: 15),
                    _buildSkipButton(viewModel),
                    const SizedBox(height: 30),
                    _buildSignupLink(viewModel, accentColor),
                    if (state.errorMessage != null) ...[const SizedBox(height: 20), _buildErrorMessage(state.errorMessage!)],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _setupNavigation(BuildContext context, WidgetRef ref) {
    ref.listenNavigation<LoginState, LoginNavigationTarget>(loginViewModelProvider, (target) {
      switch (target) {
        case LoginNavigationTarget.signup:
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpPage()));
          break;
        case LoginNavigationTarget.forgotPassword:
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
          break;
        case LoginNavigationTarget.home:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
          break;
      }
    });
  }

  // ---------------------------------------------------------------------------
  // UI Components
  // ---------------------------------------------------------------------------

  Widget _buildLogo(Color accentColor) {
    return Hero(
      tag: 'logo',
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Icon(Icons.auto_awesome, size: 60, color: accentColor),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(I18nKeys.welcomeBack.tr, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(I18nKeys.signInToContinue.tr, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _buildUsernameField(LoginState state, LoginViewModel viewModel, ThemeData theme, Color accentColor) {
    return TextFormField(
      onChanged: (value) => viewModel.handleIntent(LoginIntent.usernameChanged(value)),
      decoration: InputDecoration(
        hintText: I18nKeys.username.tr,
        prefixIcon: Icon(Icons.person_outline, color: accentColor),
        errorText: state.usernameError,
      ),
    );
  }

  Widget _buildPasswordField(LoginState state, LoginViewModel viewModel, ThemeData theme, Color accentColor) {
    return TextFormField(
      onChanged: (value) => viewModel.handleIntent(LoginIntent.passwordChanged(value)),
      obscureText: !state.isPasswordVisible,
      decoration: InputDecoration(
        hintText: I18nKeys.password.tr,
        prefixIcon: Icon(Icons.lock_outline, color: accentColor),
        errorText: state.passwordError,
        suffixIcon: IconButton(
          icon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: accentColor),
          onPressed: () => viewModel.handleIntent(const LoginIntent.togglePasswordVisibility()),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(LoginViewModel viewModel, Color accentColor) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToForgotPassword()),
        child: Text(I18nKeys.forgotPassword.tr, style: TextStyle(color: accentColor)),
      ),
    );
  }

  Widget _buildLoginButton(LoginState state, LoginViewModel viewModel, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => viewModel.handleIntent(const LoginIntent.submitLogin()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: state.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              )
            : Text(
                I18nKeys.login.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildSkipButton(LoginViewModel viewModel) {
    return TextButton(
      onPressed: () => viewModel.handleIntent(const LoginIntent.skipLogin()),
      child: Text(I18nKeys.skipForNow.tr, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildSignupLink(LoginViewModel viewModel, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(I18nKeys.noAccount.tr, style: const TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
          child: Text(
            I18nKeys.signUp.tr,
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }
}
