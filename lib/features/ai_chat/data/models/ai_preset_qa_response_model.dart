import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_preset_qa_response_model.freezed.dart';
part 'ai_preset_qa_response_model.g.dart';

@freezed
abstract class PresetQaItem with _$PresetQaItem {
  const factory PresetQaItem({
    required String question,
    required String answer,
  }) = _PresetQaItem;

  factory PresetQaItem.fromJson(Map<String, dynamic> json) =>
      _$PresetQaItemFromJson(json);
}

class AiPresetQaResponseModel {
  final Map<String, List<PresetQaItem>> qas;

  const AiPresetQaResponseModel({required this.qas});

  factory AiPresetQaResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<PresetQaItem>> parsedQas = {};
    json.forEach((key, value) {
      if (value is List) {
        parsedQas[key] = value
            .map((item) => PresetQaItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    });
    return AiPresetQaResponseModel(qas: parsedQas);
  }

  Map<String, dynamic> toJson() => {
    'qas': qas.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
  };
}
