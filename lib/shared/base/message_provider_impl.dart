import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation of [IMessageProvider] using the project's [CommonToast] UIKit component.
class MessageProviderImpl implements IMessageProvider {
  const MessageProviderImpl();

  @override
  void show(String message, {MessageType type = MessageType.info}) {
    CommonToast.show(
      message,
      type: type == MessageType.error ? ToastType.error : ToastType.info,
    );
  }
}
