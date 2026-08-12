import 'package:listen_core/core.dart';

/// Pure Data Effect for requesting scroll positioning to a specific project.
class ScrollToProjectEffect extends BaseEffect {
  final int index;
  final String businessId;

  ScrollToProjectEffect({required this.index, required this.businessId});

  @override
  String toString() {
    return 'ScrollToProjectEffect(index: $index, businessId: $businessId)';
  }
}
