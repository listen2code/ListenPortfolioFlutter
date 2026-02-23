import 'package:flutter/material.dart';

/// Represents the possible authentication statuses
enum AuthStatus { loggedIn, loggedOut }

/// Generic authentication state container
class AuthState<T> {
  final AuthStatus status;
  final T? user;

  const AuthState._({required this.status, this.user});

  /// Factory for logged out state
  const AuthState.loggedOut() : this._(status: AuthStatus.loggedOut);

  /// Factory for logged in state with user data
  const AuthState.loggedIn(T user) : this._(status: AuthStatus.loggedIn, user: user);

  /// Helper getter to identify guest users
  bool get isGuest => status == AuthStatus.loggedOut;
}

/// A generic Singleton manager for handling user sessions in memory
class BaseAuthManager<T> extends ChangeNotifier {
  AuthState<T> _state = AuthState<T>.loggedOut();

  /// Current authentication state getter
  AuthState<T> get state => _state;

  /// Update session with user data and notify observers
  void login(T? user) {
    if (user != null) {
      _state = AuthState<T>.loggedIn(user);
      notifyListeners();
    }
  }

  /// Reset session to logged out and notify observers
  void logout() {
    _state = AuthState<T>.loggedOut();
    notifyListeners();
  }
}
