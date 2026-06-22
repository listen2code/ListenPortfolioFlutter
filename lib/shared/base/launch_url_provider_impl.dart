import 'package:listen_core/core.dart';
import 'package:url_launcher/url_launcher.dart';

/// Standard Effect for launching a URL in the browser/system.
class LaunchUrlEffect extends BaseEffect {
  final String url;
  LaunchUrlEffect(this.url);

  @override
  String toString() {
    return 'LaunchUrlEffect(url: $url)';
  }
}

/// Concrete implementation for handling [LaunchUrlEffect] using [url_launcher].
class LaunchUrlProviderImpl extends BaseProvider<LaunchUrlEffect> {
  const LaunchUrlProviderImpl();

  @override
  void handleEffect(LaunchUrlEffect effect) async {
    final uri = Uri.parse(effect.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
