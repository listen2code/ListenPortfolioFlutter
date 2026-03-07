import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'splash_state.freezed.dart';

@freezed
abstract class SplashState extends BaseState with _$SplashState {
  const factory SplashState() = _SplashState;
  const SplashState._();
}
