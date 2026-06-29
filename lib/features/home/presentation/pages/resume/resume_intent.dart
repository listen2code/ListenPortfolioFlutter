import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';
import '../../../../../../shared/utils/playback_observer_manager.dart';

part 'resume_intent.freezed.dart';

@freezed
class ResumeIntent extends BaseIntent with _$ResumeIntent {
  const factory ResumeIntent.init() = _Init;
  const factory ResumeIntent.exportPDF() = _ExportPDF;
  const ResumeIntent._();

  /// Registers deserializers for MVI playback.
  static void registerPlayback() {
    MviPlaybackRegistry.register('ResumeIntent', 'init', (args) => const ResumeIntent.init());
    MviPlaybackRegistry.register('ResumeIntent', 'exportPDF', (args) => const ResumeIntent.exportPDF());
  }
}
