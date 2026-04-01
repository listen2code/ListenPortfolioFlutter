import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_core/core.dart';

part 'overview_intent.freezed.dart';

@freezed
class OverviewIntent extends BaseIntent with _$OverviewIntent {
  const factory OverviewIntent.refresh() = _Refresh;
  const OverviewIntent._();
}
