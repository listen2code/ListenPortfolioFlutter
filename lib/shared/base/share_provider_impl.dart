import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:share_plus/share_plus.dart';

/// Concrete implementation for handling [ShareEffect] using [SharePlus].
class ShareProviderImpl extends BaseProvider<ShareEffect> {
  const ShareProviderImpl();

  @override
  void handleEffect(ShareEffect effect) {
    if (effect.files.isNotEmpty) {
      SharePlus.instance.share(
        ShareParams(
          files: effect.files.map((e) => XFile(e)).toList(),
          text: effect.text,
          subject: effect.subject,
        ),
      );
    } else if (effect.text != null) {
      SharePlus.instance.share(ShareParams(text: effect.text, subject: effect.subject));
    }
  }
}
