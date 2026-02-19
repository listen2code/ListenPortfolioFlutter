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
          AppNav.to(Routes.signup);
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
      provider: loginViewModelProvider,
      body: (context, child) {
        final accentColor = context.accentColor;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.f),
              _buildLogo(accentColor),
              SizedBox(height: 30.f),
              _buildTitle(context),
              SizedBox(height: 50.f),
              _buildUsernameField(state, viewModel),
              SizedBox(height: 20.f),
              _buildPasswordField(state, viewModel),
              _buildRememberAndForgot(context, state, viewModel, accentColor),
              SizedBox(height: 30.f),
              _buildLoginButton(context, state, viewModel, accentColor),
              SizedBox(height: 15.f),
              _buildSkipButton(context, viewModel),
              SizedBox(height: 10.f),
              _buildSignupLink(context, viewModel, accentColor),
              SizedBox(height: 40.f),
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
          padding: EdgeInsets.all(15.f),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 20.f, offset: Offset(0, 10.f)),
            ],
          ),
          child: Image.asset(
            R.imagesIcLauncherAdaptiveFore,
            width: 60.f,
            height: 60.f,
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
        SizedBox(height: 8.f),
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
                width: 24.f,
                height: 24.f,
                child: Checkbox(
                  value: state.rememberMe,
                  activeColor: accentColor,
                  onChanged: (value) => viewModel.handleIntent(const LoginIntent.toggleRememberMe()),
                ),
              ),
              SizedBox(width: 8.f),
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
        SizedBox(width: 10.f),
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
      height: 56.f,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.f),
        gradient: LinearGradient(colors: [accentColor, accentColor.withValues(alpha: 0.8)]),
        boxShadow: [
          BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10.f, offset: Offset(0, 5.f)),
        ],
      ),
      child: ElevatedButton(
        onPressed: state.isLoading ? null : () => viewModel.handleIntent(const LoginIntent.submitLogin()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.f)),
        ),
        child: state.isLoading
            ? Center(
                child: SizedBox(
                  height: 20.f,
                  width: 20.f,
                  child: const CircularProgressIndicator(
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
