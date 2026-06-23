import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'resume_state.freezed.dart';

@freezed
abstract class ResumeState extends BaseState with _$ResumeState {
  const factory ResumeState({
    @Default(false) bool isLoading,
    @Default('') String markdownContent,
    @Default(false) bool isExporting,
    String? errorMessage,
  }) = _ResumeState;

  const ResumeState._();
}
