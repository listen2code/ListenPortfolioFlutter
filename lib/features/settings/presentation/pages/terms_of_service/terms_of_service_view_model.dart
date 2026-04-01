import 'dart:async';
import 'package:listen_core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'terms_of_service_intent.dart';
import 'terms_of_service_state.dart';

part 'terms_of_service_view_model.g.dart';

@riverpod
class TermsOfServiceViewModel extends _$TermsOfServiceViewModel
    with ViewModelMixin<TermsOfServiceState, TermsOfServiceIntent> {
  @override
  TermsOfServiceState build() => const TermsOfServiceState();

  @override
  void onReady() {
    super.onReady();
    // Use onReady instead of onInit to avoid "modifying provider during build" error.
    // onReady is called within WidgetsBinding.instance.addPostFrameCallback.
    if (state.sections.isEmpty) {
      handleIntent(const TermsOfServiceIntent.init());
    }
  }

  @override
  FutureOr<void> onIntent(TermsOfServiceIntent intent) {
    return intent.when<FutureOr<void>>(init: _onInit);
  }

  Future<void> _onInit() async {
    // These strings are moved from Page to ViewModel as requested.
    const lastUpdated = 'May 2026';
    const mockSections = [
      TermsSection(
        title: '1. Agreement to Terms',
        content:
            'By accessing lPortfolio, you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, you are prohibited from using this application.',
      ),
      TermsSection(
        title: '2. Intellectual Property',
        content:
            'The application and its original content (excluding user-provided data), features, and functionality are and will remain the exclusive property of the developer and its licensors.',
      ),
      TermsSection(
        title: '3. User Accounts',
        content:
            'When you create an account, you must provide information that is accurate and current. You are responsible for safeguarding the password that you use to access the Service.',
      ),
      TermsSection(
        title: '4. Prohibited Activities',
        content:
            'You agree not to engage in any activity that interferes with or disrupts the Service, including but not limited to reverse engineering, data mining, or unauthorized access to our systems.',
      ),
      TermsSection(
        title: '5. Limitation of Liability',
        content:
            'In no event shall the developer be liable for any indirect, incidental, special, or consequential damages resulting from your use or inability to use the service.',
      ),
      TermsSection(
        title: '6. Governing Law',
        content:
            'These Terms shall be governed and construed in accordance with the laws of your local jurisdiction, without regard to its conflict of law provisions.',
      ),
      TermsSection(
        title: '7. Changes to Terms',
        content:
            'We reserve the right to modify or replace these Terms at any time. It is your responsibility to check these Terms periodically for changes.',
      ),
    ];

    updateState(state.copyWith(lastUpdated: lastUpdated, sections: mockSections));
  }
}
