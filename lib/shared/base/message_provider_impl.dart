import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation of [IMessageProvider] using the project's [CommonToast] UIKit component.
class MessageProviderImpl implements IMessageProvider {
  const MessageProviderImpl();

  @override
  void showInfo(String message) {
    CommonToast.show(message);
  }

  @override
  void showError(String message) {
    CommonToast.show(message, type: ToastType.error);
  }
}
