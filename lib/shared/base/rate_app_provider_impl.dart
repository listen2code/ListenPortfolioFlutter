
import '../shared.dart';

/// Actions supported by [RateAppEffect] for directing rating and review workflows.
enum RateAppAction {
  /// Evaluates gatekeeping rate limits and prompts the native in-app review dialog if eligible.
  checkAndPrompt,

  /// Directly navigates to the external store listing page (Google Play / App Store).
  openStoreListing,
}

/// Side-effect dispatched by ViewModels to trigger rating or store review workflows.
///
/// Decouples ViewModels (e.g., `SettingsViewModel`, `CoffeePurchaseViewModel`, `HomeViewModel`)
/// from Flutter UI widgets and direct [ReviewService] singletons.
class RateAppEffect extends BaseEffect {
  /// The targeted rating action.
  final RateAppAction action;

  /// Whether to force bypass rate-limiting constraints (e.g., upon successful IAP completion).
  final bool force;

  RateAppEffect({
    this.action = RateAppAction.openStoreListing,
    this.force = false,
  });
}

/// Global [BaseProvider] implementation responsible for consuming [RateAppEffect].
///
/// Intercepts dispatched rating effects and routes them to the appropriate [ReviewService] methods.
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
