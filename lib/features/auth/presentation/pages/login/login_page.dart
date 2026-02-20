import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/base_stateless_page.dart';
import 'package:listen_portfolio_flutter/core/extension/context_extension.dart';
import 'package:listen_portfolio_flutter/core/extension/widget_ref_extension.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations.dart';
import 'package:listen_portfolio_flutter/core/i18n/translations_key.dart';
import 'package:listen_portfolio_flutter/core/route/app_nav.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/generated/r.dart';
import 'package:listen_portfolio_flutter/shared/shared.dart';

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
          // Use raw string template for internal navigation
          AppNav.to("${Routes.signup}?name=${_usernameController.text}");
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

    // Sync controllers with state (e.g. after loading saved credentials)
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
      provider: loginViewModelProvider,
      body: (context, child) {
        final accentColor = context.accentColor;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildLogo(accentColor),
              const SizedBox(height: 30),
              _buildTitle(context),
              const SizedBox(height: 50),
              _buildUsernameField(state, viewModel),
              const SizedBox(height: 20),
              _buildPasswordField(state, viewModel),
              _buildRememberAndForgot(context, state, viewModel, accentColor),
              const SizedBox(height: 30),
              _buildLoginButton(context, state, viewModel, accentColor),
              const SizedBox(height: 15),
              _buildSkipButton(context, viewModel),
              const SizedBox(height: 10),
              _buildSignupLink(context, viewModel, accentColor),
              const SizedBox(height: 40),
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

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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

  Widget _buildRememberAndForgot(
    BuildContext context,
    LoginState state,
    LoginViewModel viewModel,
    Color accentColor,
  ) {
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
                    style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
              style: context.textTheme.bodySmall?.copyWith(color: accentColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    LoginState state,
    LoginViewModel viewModel,
    Color accentColor,
  ) {
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
            : CommonText(
                I18nKeys.login.tr,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context, LoginViewModel viewModel) {
    return TextButton(
      onPressed: () => viewModel.handleIntent(const LoginIntent.skipLogin()),
      child: CommonText(
        I18nKeys.skipForNow.tr,
        style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
      ),
    );
  }

  Widget _buildSignupLink(BuildContext context, LoginViewModel viewModel, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CommonText(
            I18nKeys.noAccount.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
          child: CommonText(
            I18nKeys.signUp.tr,
            style: context.textTheme.bodyMedium?.copyWith(color: accentColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
