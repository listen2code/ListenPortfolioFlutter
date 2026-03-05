import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'about_me_state.freezed.dart';

@freezed
abstract class AboutMeState extends BaseState with _$AboutMeState {
  const factory AboutMeState({File? imageFile}) = _AboutMeState;

  const AboutMeState._();
}
