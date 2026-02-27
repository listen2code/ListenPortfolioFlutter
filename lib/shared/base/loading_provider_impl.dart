import 'package:flutter/foundation.dart';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:listen_portfolio_flutter/uikit/uikit.dart';

/// Concrete implementation of [ILoadingProvider] using the project's [CommonLoading] UIKit component.
class LoadingProviderImpl implements ILoadingProvider {
  const LoadingProviderImpl();

  @override
  void show({String? message}) {
    CommonLoading.show(message: message);
  }

  @override
  void hide() {
    CommonLoading.hide();
  }

  @override
  ValueListenable<bool> get isLoading => CommonLoading.isShowNotifier;
}
