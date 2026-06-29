import 'package:flutter/material.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../features/settings/data/models/playback_step.dart';

/// Effect to show the steps details of a recorded playback tape.
class ShowTapeDetailsEffect extends BaseEffect {
  final List<PlaybackStep> steps;
  final String name;

  ShowTapeDetailsEffect(this.steps, this.name);
}

/// Provider to handle [ShowTapeDetailsEffect].
class ShowTapeDetailsProviderImpl extends BaseProvider<ShowTapeDetailsEffect> {
  const ShowTapeDetailsProviderImpl();

  @override
  void handleEffect(ShowTapeDetailsEffect effect) {
    final context = AppNavConfig.context;
    if (context != null) {
      CommonDialog.showCustom<void>(
        title: effect.name,
        body: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: effect.steps.length,
            itemBuilder: (context, index) {
              final step = effect.steps[index];
              final type = step.type;
              final name = step.name;
              final tag = step.viewModelTag;
              return ListTile(
                dense: true,
                leading: Icon(
                  type == PlaybackStep.intent ? Icons.input : Icons.notification_important,
                  color: type == PlaybackStep.intent ? Colors.blue : Colors.green,
                ),
                title: CommonText('$tag: ${name.split('(').first}', style: const TextStyle(fontSize: 12)),
                subtitle: CommonText(name, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              );
            },
          ),
        ),
        actions: [
          CommonButton(
            text: UIKitConfig.getString(UIKitConfig.kOk),
            type: ButtonType.text,
            isFullWidth: false,
            onPressed: () => AppNav.back(),
          ),
        ],
      );
    }
  }
}
