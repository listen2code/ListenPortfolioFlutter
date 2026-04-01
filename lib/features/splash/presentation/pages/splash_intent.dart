import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'splash_intent.freezed.dart';

@freezed
class SplashIntent extends BaseIntent with _$SplashIntent {
  const factory SplashIntent.init() = _Init;
  const SplashIntent._();
}
