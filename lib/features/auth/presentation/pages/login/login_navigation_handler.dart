import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_portfolio_flutter/core/base/mvi_navigation.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_state.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/login/login_view_model.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/password/forgot_password_page.dart';
import 'package:listen_portfolio_flutter/features/auth/presentation/pages/sign_up/sign_up_page.dart';
import 'package:listen_portfolio_flutter/features/home/presentation/pages/home_page.dart';

class LoginNavigationHandler extends ConsumerWidget {
  final Widget child;
  const LoginNavigationHandler({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Isolated navigation logic
    ref.listenNavigation<LoginState, LoginNavigationTarget>(
      loginViewModelProvider,
      (target) {
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
      },
    );

    return child;
  }
}
