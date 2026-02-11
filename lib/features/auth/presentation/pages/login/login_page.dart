import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/base_ref_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/core/theme/setting_provider.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';
import 'package:listen_portfolio_flutter/shared/widgets/common_text_field.dart';

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

  // Set up navigation listeners
  void _setupNavigation(BuildContext context) {
    ref.listenNavigation<LoginState, LoginNavigationTarget>(loginViewModelProvider, (target) {
      switch (target) {
        case LoginNavigationTarget.signup:
          AppNav.to(const SignUpPage());
          break;
        case LoginNavigationTarget.forgotPassword:
          AppNav.to(const ForgotPasswordPage());
          break;
        case LoginNavigationTarget.success:
          // Close login page and return true to inform the caller (interceptor) about success
          AppNav.back(true);
          break;
        case LoginNavigationTarget.back:
          // Close login page and return false to indicate it was dismissed/skipped
          AppNav.back(false);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setupNavigation(context);

    // Common UI state listeners for errors and general messages
    ref.listenError(loginViewModelProvider);
    ref.listenMessage(loginViewModelProvider);

    // Sync controllers with state
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

    return BaseStatelessPage(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      body: (context, child) {
        final accentColor = settingManager.accentColor;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildLogo(accentColor),
              const SizedBox(height: 30),
              _buildTitle(Theme.of(context)),
              const SizedBox(height: 50),
              _buildUsernameField(state, viewModel),
              const SizedBox(height: 20),
              _buildPasswordField(state, viewModel),
              _buildRememberAndForgot(state, viewModel, accentColor),
              const SizedBox(height: 30),
              _buildLoginButton(state, viewModel, accentColor),
              const SizedBox(height: 15),
              _buildSkipButton(viewModel),
              const SizedBox(height: 10),
              _buildSignupLink(viewModel, accentColor),
            ],
          ),
        );
      },
    );
  }

  // --- Sub-widgets builders ---

  Widget _buildLogo(Color accentColor) {
    return Hero(
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
          child: Image.asset(
            R.imagesIcLauncherAdaptiveFore,
            width: 60,
            height: 60,
            color: accentColor,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText(
          I18nKeys.welcomeBack.tr,
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CommonText(
          I18nKeys.signInToContinue.tr,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildUsernameField(LoginState state, LoginViewModel viewModel) {
    return CommonTextField(
      controller: _usernameController,
      type: TextFieldType.text,
      labelText: I18nKeys.username.tr,
      prefixIcon: Icons.person_outline,
      errorText: state.usernameError,
      onChanged: (value) => viewModel.handleIntent(LoginIntent.usernameChanged(value)),
    );
  }

  Widget _buildPasswordField(LoginState state, LoginViewModel viewModel) {
    return CommonTextField(
      controller: _passwordController,
      type: TextFieldType.password,
      labelText: I18nKeys.password.tr,
      prefixIcon: Icons.lock_outline,
      errorText: state.passwordError,
      onChanged: (value) => viewModel.handleIntent(LoginIntent.passwordChanged(value)),
    );
  }

  Widget _buildRememberAndForgot(LoginState state, LoginViewModel viewModel, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: state.rememberMe,
                  activeColor: accentColor,
                  onChanged: (value) => viewModel.handleIntent(const LoginIntent.toggleRememberMe()),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                  onTap: () => viewModel.handleIntent(const LoginIntent.toggleRememberMe()),
                  child: CommonText(
                    I18nKeys.rememberMe.tr,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 2,
          child: TextButton(
            onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToForgotPassword()),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerRight),
            child: CommonText(
              I18nKeys.forgotPassword.tr,
              style: TextStyle(color: accentColor, fontSize: 13),
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state, LoginViewModel viewModel, Color accentColor) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        boxShadow: [
          BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => viewModel.handleIntent(const LoginIntent.submitLogin()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: state.isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
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
        Flexible(
          child: CommonText(I18nKeys.noAccount.tr, style: const TextStyle(color: Colors.grey), maxLines: 1),
        ),
        TextButton(
          onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
          child: CommonText(
            I18nKeys.signUp.tr,
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
