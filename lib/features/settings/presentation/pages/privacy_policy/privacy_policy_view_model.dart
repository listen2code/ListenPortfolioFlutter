import 'dart:async';
import 'package:listen_portfolio_flutter/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'privacy_policy_intent.dart';
import 'privacy_policy_state.dart';

part 'privacy_policy_view_model.g.dart';

@riverpod
class PrivacyPolicyViewModel extends _$PrivacyPolicyViewModel
    with ViewModelMixin<PrivacyPolicyState, PrivacyPolicyIntent> {
  @override
  PrivacyPolicyState build() => const PrivacyPolicyState();

  @override
  void onReady() {
    super.onReady();
    if (state.sections.isEmpty) {
      handleIntent(const PrivacyPolicyIntent.refresh());
    }
  }

  @override
  FutureOr<void> onIntent(PrivacyPolicyIntent intent) {
    return intent.when<FutureOr<void>>(refresh: _onRefresh);
  }

  Future<void> _onRefresh() async {
    // These strings are moved from Page to ViewModel as requested.
    const lastUpdated = 'May 2026';
    const mockSections = [
      PrivacySection(
        title: '1. Information Collection',
        content:
            'We collect limited information to provide a better experience. This includes account data (if provided) and local configuration settings stored on your device via SharedPreferences and Secure Storage.',
      ),
      PrivacySection(
        title: '2. Third-Party Services',
        content:
            'This app may use third-party libraries for networking (Dio) and state management (Riverpod). These libraries do not collect personally identifiable information unless explicitly stated.',
      ),
      PrivacySection(
        title: '3. Data Security',
        content:
            'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure.',
      ),
      PrivacySection(
        title: '4. Children\'s Privacy',
        content:
            'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children.',
      ),
      PrivacySection(
        title: '5. Data Deletion',
        content:
            'Users can request the deletion of their local data by using the "Reset All Settings" and "Clear Cache" features in the app settings.',
      ),
      PrivacySection(
        title: 'Contact Us',
        content:
            'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at listen2code@gmail.com.',
      ),
    ];

    updateState(state.copyWith(lastUpdated: lastUpdated, sections: mockSections));
  }
}
