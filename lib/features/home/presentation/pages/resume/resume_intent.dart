import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'resume_intent.freezed.dart';

@freezed
class ResumeIntent extends BaseIntent with _$ResumeIntent {
  const factory ResumeIntent.init() = _Init;
  const factory ResumeIntent.exportPDF() = _ExportPDF;
  const ResumeIntent._();
}
