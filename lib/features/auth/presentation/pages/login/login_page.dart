import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/shared.dart';
import 'login_intent.dart';
import 'login_state.dart';
import 'login_view_model.dart';
import 'widgets/login_action_buttons.dart';
import 'widgets/login_form_fields.dart';
import 'widgets/login_header.dart';

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
    // 1. Read the initial state from the provider
    // Since build() in LoginViewModel is now synchronous, this is safe and immediate.
    final initialState = ref.read(loginViewModelProvider);

    // 2. Initialize controllers with the saved credentials
    _usernameController = TextEditingController(text: initialState.username);
    _passwordController = TextEditingController(text: initialState.password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep ref.listen for any updates during the session (e.g. auto-fill or reset)
    // but we don't need to handle the first frame here anymore.
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      if (_usernameController.text != next.username) {
        _usernameController.text = next.username;
      }
      if (_passwordController.text != next.password) {
        _passwordController.text = next.password;
      }
    });

    return BaseRefreshPage<LoginViewModel, LoginState>(
      provider: loginViewModelProvider,
      body: (context, child, viewModel, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const SizedBox(height: 50),
              LoginFormFields(
                usernameController: _usernameController,
                passwordController: _passwordController,
                state: state,
                onUsernameChanged: (val) => viewModel.handleIntent(LoginIntent.usernameChanged(val)),
                onPasswordChanged: (val) => viewModel.handleIntent(LoginIntent.passwordChanged(val)),
                onToggleRememberMe: () => viewModel.handleIntent(const LoginIntent.toggleRememberMe()),
                onTapForgotPassword: () => viewModel.handleIntent(const LoginIntent.navigateToForgotPassword()),
              ),
              const SizedBox(height: 30),
              LoginActionButtons(
                onTapLogin: () => viewModel.handleIntent(const LoginIntent.submitLogin()),
                onTapSkip: () => viewModel.handleIntent(const LoginIntent.skipLogin()),
                onTapSignUp: () => viewModel.handleIntent(const LoginIntent.navigateToSignup()),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

