import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import '../../../data/models/playback_tape_metadata.dart';
import 'playback_tape_list_intent.dart';
import 'playback_tape_list_state.dart';
import 'playback_tape_list_view_model.dart';

class PlaybackTapeListPage extends ConsumerWidget {
  const PlaybackTapeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<PlaybackTapeListViewModel, PlaybackTapeListState>(
      provider: playbackTapeListViewModelProvider,
      title: I18nKeys.playbackTapeList.tr,
      onRefresh: (viewModel, state) async {
        viewModel.handleIntent(const PlaybackTapeListIntent.loadTapes());
      },
      itemSource: (state) => state.tapes,
      itemBuilder: (context, viewModel, state, item, index) {
        final tape = item as PlaybackTapeMetadata;
        final date = DateTime.fromMillisecondsSinceEpoch(tape.timestamp);
        final formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
        final tapeKey = tape.key;
        final tapeName = tape.name.isNotEmpty ? tape.name : I18nKeys.unnamedTape.tr;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            onTap: () => viewModel.handleIntent(PlaybackTapeListIntent.showTapeDetails(tapeKey, tapeName)),
            leading: const CircleAvatar(child: Icon(Icons.movie_creation_outlined)),
            title: CommonText(
              useFittedBox: false,
              tapeName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: CommonText(
              '$formattedDate · ${I18nKeys.tapeStepsCount.tr.replaceAll('%s', tape.steps.toString())}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonIconButton(
                  icon: const Icon(Icons.play_circle_outline, color: Colors.blue),
                  onPressed: () => viewModel.handleIntent(PlaybackTapeListIntent.startPlayback(tapeKey)),
                  tooltip: I18nKeys.runPlayback.tr,
                ),
                CommonIconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => viewModel.handleIntent(PlaybackTapeListIntent.deleteTape(tapeKey)),
                  tooltip: I18nKeys.delete.tr,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
