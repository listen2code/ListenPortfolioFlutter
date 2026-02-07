import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/mvi_navigation.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_intent.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.withValues(alpha: 0.05), Colors.white],
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
                _buildLogo(),
                const SizedBox(height: 30),
                _buildTitle(),
                const SizedBox(height: 50),
                _buildUsernameField(state, viewModel),
                const SizedBox(height: 20),
                _buildPasswordField(state, viewModel),
                _buildForgotPasswordButton(viewModel),
                const SizedBox(height: 30),
                _buildLoginButton(state, viewModel),
                const SizedBox(height: 15),
                _buildSkipButton(viewModel),
                const SizedBox(height: 30),
                _buildSignupLink(viewModel),
                if (state.errorMessage != null) ...[const SizedBox(height: 20), _buildErrorMessage(state.errorMessage!)],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI Components (Declarative)
  // ---------------------------------------------------------------------------

  Widget _buildLogo() {
    return Hero(
      tag: 'logo',
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: const Icon(Icons.auto_awesome, size: 60, color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text('Sign in to continue', style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildUsernameField(LoginState state, LoginViewModel viewModel) {
    return TextFormField(
      onChanged: (value) => viewModel.handleIntent(LoginIntent.usernameChanged(value)),
      decoration: InputDecoration(
        hintText: 'Username',
        prefixIcon: const Icon(Icons.person_outline),
        errorText: state.usernameError,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField(LoginState state, LoginViewModel viewModel) {
    return TextFormField(
      onChanged: (value) => viewModel.handleIntent(LoginIntent.passwordChanged(value)),
      obscureText: !state.isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: state.passwordError,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => viewModel.handleIntent(const LoginIntent.togglePasswordVisibility()),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildForgotPasswordButton(LoginViewModel viewModel) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToForgotPassword()),
        child: const Text('Forgot Password?', style: TextStyle(color: Colors.blueAccent)),
      ),
    );
  }

  Widget _buildLoginButton(LoginState state, LoginViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
        boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
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
            : const Text(
                'LOGIN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildSkipButton(LoginViewModel viewModel) {
    return TextButton(
      onPressed: () => viewModel.handleIntent(const LoginIntent.skipLogin()),
      child: const Text('Skip for now', style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildSignupLink(LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: FittedBox(child: const Text("Don't have an account? "))),
        TextButton(
          onPressed: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
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
