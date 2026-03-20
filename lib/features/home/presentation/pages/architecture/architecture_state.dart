import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';

part 'architecture_state.freezed.dart';

@freezed
abstract class ArchitectureState extends BaseState with _$ArchitectureState {
  const factory ArchitectureState({
    @Default(false) bool isInitialLoaded,
    String? header,
    @Default([]) List<ArchitectureSection> sections,
  }) = _ArchitectureState;

  const ArchitectureState._();
}

@freezed
abstract class ArchitectureSection with _$ArchitectureSection {
  const factory ArchitectureSection({
    required String title,
    required String content,
    required dynamic icon, // Can be IconData or String (asset path)
    List<ArchitectureLibItem>? libs,
    String? linkLabel,
    String? linkUrl,
  }) = _ArchitectureSection;
}

@freezed
abstract class ArchitectureLibItem with _$ArchitectureLibItem {
  const factory ArchitectureLibItem({required String name, required String desc}) = _ArchitectureLibItem;
}
