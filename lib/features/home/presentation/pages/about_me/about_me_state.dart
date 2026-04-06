import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../data/models/about_me_model.dart';

part 'about_me_state.freezed.dart';

@freezed
abstract class AboutMeState extends BaseState with _$AboutMeState {
  const factory AboutMeState({File? imageFile, @Default(false) bool isInitialLoaded, AboutMeModel? data}) =
      _AboutMeState;

  const AboutMeState._();
}
