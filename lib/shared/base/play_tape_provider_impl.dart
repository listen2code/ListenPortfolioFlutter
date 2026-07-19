import 'package:listen_core/core.dart';
import '../../features/settings/data/models/playback_step.dart';
import '../utils/playback/playback_player.dart';

class PlayTapeEffect extends BaseEffect {
  final String tapeKey;
  final List<PlaybackStep> steps;

  PlayTapeEffect(this.tapeKey, this.steps);
}

class PlayTapeProviderImpl extends BaseProvider<PlayTapeEffect> {
  const PlayTapeProviderImpl();

  @override
  void handleEffect(PlayTapeEffect effect) {
    MviPlaybackPlayer.instance.play(effect.tapeKey, effect.steps);
  }
}
