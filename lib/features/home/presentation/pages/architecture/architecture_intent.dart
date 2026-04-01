import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'architecture_intent.freezed.dart';

@freezed
class ArchitectureIntent extends BaseIntent with _$ArchitectureIntent {
  const factory ArchitectureIntent.refresh() = _Refresh;

  const ArchitectureIntent._();
}
