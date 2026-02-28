import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation for handling [MessageEffect] using [CommonToast].
class MessageProviderImpl extends BaseProvider<MessageEffect> {
  const MessageProviderImpl();

  @override
  void handleEffect(MessageEffect effect) {
    CommonToast.show(
      effect.message,
      type: effect.type == MessageType.error ? ToastType.error : ToastType.info,
    );
  }
}
