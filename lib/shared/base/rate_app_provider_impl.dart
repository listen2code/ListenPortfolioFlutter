import 'package:listen_core/core.dart';

import '../shared.dart';

/// Effect to redirect to the app store rating listing.
class RateAppEffect extends BaseEffect {
  RateAppEffect();
}

/// Provider to handle [RateAppEffect].
class RateAppProviderImpl extends BaseProvider<RateAppEffect> {
  const RateAppProviderImpl();

  @override
  void handleEffect(RateAppEffect effect) {
    ReviewService().openStoreRating();
  }
}
