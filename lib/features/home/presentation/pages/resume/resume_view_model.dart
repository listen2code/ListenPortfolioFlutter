import 'dart:async';

import 'package:listen_core/core.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../shared/shared.dart';
import '../../provider/about_me_provider.dart';
import 'resume_intent.dart';
import 'resume_state.dart';

part 'resume_view_model.g.dart';

@riverpod
class ResumeViewModel extends _$ResumeViewModel with ViewModelMixin<ResumeState, ResumeIntent> {
  @override
  ResumeState build() => const ResumeState();

  @override
  void onVisible() {
    super.onVisible();
    if (state.markdownContent.isEmpty) {
      handleIntent(const ResumeIntent.init());
    }
  }

  @override
  FutureOr<void> onIntent(ResumeIntent intent) {
    return intent.when<FutureOr<void>>(
      init: _onInit,
      exportPDF: _onExportPDF,
    );
  }

  Future<void> _onInit() async {
    await call<String>(
      ref.execute<String, BaseParam>(getResumeUseCaseProvider),
      showLoading: true,
      loadingType: LoadingType.page,
      onSuccess: (content) {
        updateState(state.copyWith(markdownContent: content));
      },
      onFailure: (failure) {
        emitEffect(MessageEffect.error(I18nKeys.errNetwork.tr));
      },
    );
  }

  Future<void> _onExportPDF() async {
    if (state.markdownContent.isEmpty) return;

    updateState(state.copyWith(isExporting: true));
    try {
      final bodyHtml = md.markdownToHtml(state.markdownContent);
      final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", sans-serif;
      color: #333333;
      line-height: 1.6;
      font-size: 14px;
    }
    h1, h2, h3, h4, h5, h6 {
      color: #111111;
      margin-top: 1.5em;
      margin-bottom: 0.5em;
      font-weight: 600;
    }
    h1 {
      font-size: 28px;
      border-bottom: 2px solid #eaecef;
      padding-bottom: 0.3em;
      margin-top: 0;
      text-align: center;
    }
    h2 {
      font-size: 20px;
      border-bottom: 1px solid #eaecef;
      padding-bottom: 0.3em;
    }
    p, ul, ol {
      margin-top: 0;
      margin-bottom: 1em;
    }
    li {
      margin-bottom: 0.5em;
    }
    code {
      font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
      background-color: rgba(27, 31, 35, 0.05);
      border-radius: 3px;
      padding: 0.2em 0.4em;
      font-size: 85%;
    }
    pre {
      background-color: #f6f8fa;
      border-radius: 3px;
      padding: 16px;
      overflow: auto;
    }
    pre code {
      background-color: transparent;
      padding: 0;
    }
    blockquote {
      border-left: 0.25em solid #dfe2e5;
      color: #6a737d;
      padding: 0 1em;
      margin-left: 0;
      margin-right: 0;
    }
    table {
      border-spacing: 0;
      border-collapse: collapse;
      width: 100%;
      margin-bottom: 1em;
    }
    table th, table td {
      padding: 6px 13px;
      border: 1px solid #dfe2e5;
    }
    table tr:nth-child(even) {
      background-color: #f6f8fa;
    }
    @media print {
      body {
        background: transparent;
        color: #000;
      }
      h1, h2, h3 {
        page-break-after: avoid;
      }
      tr, img {
        page-break-inside: avoid;
      }
    }
  </style>
</head>
<body>
  $bodyHtml
</body>
</html>
''';

      emitEffect(
        PrintPdfEffect(
          htmlContent: htmlContent,
          fileName: 'Resume_${DateTime.now().millisecondsSinceEpoch}.pdf',
        ),
      );
    } catch (e, stack) {
      appLogger.e('Failed to compile markdown to PDF', error: e, stackTrace: stack);
      emitEffect(MessageEffect.error(I18nKeys.errServerError.tr));
    } finally {
      updateState(state.copyWith(isExporting: false));
    }
  }
}
