import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listen_core/core.dart';
import 'package:listen_uikit/uikit.dart';

import '../../../../../shared/shared.dart';
import 'resume_intent.dart';
import 'resume_state.dart';
import 'resume_view_model.dart';

class ResumePage extends ConsumerWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseRefreshPage<ResumeViewModel, ResumeState>(
      title: I18nKeys.resume.tr,
      provider: resumeViewModelProvider,
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf_outlined),
          tooltip: I18nKeys.exportPDF.tr,
          onPressed: () {
            ref.read(resumeViewModelProvider.notifier).handleIntent(
              const ResumeIntent.exportPDF(),
            );
          },
        ),
      ],
      body: (context, child, viewModel, state) {
        if (state == null) return const SizedBox.shrink();

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                CommonButton(
                  text: I18nKeys.retry.tr,
                  onPressed: () {
                    viewModel?.handleIntent(const ResumeIntent.init());
                  },
                ),
              ],
            ),
          );
        }

        if (state.markdownContent.isEmpty) {
          return Center(
            child: CommonText(I18nKeys.emptyResume.tr),
          );
        }

        return Markdown(
          data: state.markdownContent,
          selectable: true,
        );
      },
    );
  }
}
