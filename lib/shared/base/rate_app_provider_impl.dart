import 'package:listen_core/core.dart';

import '../shared.dart';

/// Actions supported by the rate app effect.
enum RateAppAction {
  /// Checks rate limits and prompts in-app review dialog if eligible.
  checkAndPrompt,

  /// Opens the store listing page directly.
  openStoreListing,
}

/// Effect to trigger in-app review prompting or redirecting to store rating.
class RateAppEffect extends BaseEffect {
  final RateAppAction action;
  final bool force;

  RateAppEffect({
    this.action = RateAppAction.openStoreListing,
    this.force = false,
  });
}

/// Provider to handle [RateAppEffect].
class RateAppProviderImpl extends BaseProvider<RateAppEffect> {
  const RateAppProviderImpl();

  @override
  void handleEffect(RateAppEffect effect) {
    switch (effect.action) {
      case RateAppAction.checkAndPrompt:
        ReviewService().checkAndPromptReview(force: effect.force);
        break;
      case RateAppAction.openStoreListing:
        ReviewService().openStoreRating();
        break;
    }
  }
}
