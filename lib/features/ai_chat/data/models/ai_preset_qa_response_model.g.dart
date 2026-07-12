// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_preset_qa_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresetQaItem _$PresetQaItemFromJson(Map json) =>
    $checkedCreate('_PresetQaItem', json, ($checkedConvert) {
      final val = _PresetQaItem(
        question: $checkedConvert('question', (v) => v as String),
        answer: $checkedConvert('answer', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PresetQaItemToJson(_PresetQaItem instance) =>
    <String, dynamic>{'question': instance.question, 'answer': instance.answer};
