import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation for handling [MessageEffect] using [CommonToast].
class MessageProviderImpl extends BaseProvider<MessageEffect> {
  const MessageProviderImpl();

  @override
  void handleEffect(MessageEffect effect) {
    if (effect.type == MessageType.dialog) {
      CommonDialog.showMessage(title: effect.title ?? "", message: effect.message);
      return;
    }
    CommonToast.show(
      effect.message,
      type: effect.type == MessageType.error ? ToastType.error : ToastType.info,
    );
  }
}
