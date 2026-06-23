import 'package:listen_core/core.dart';
import 'package:printing/printing.dart';

/// Side effect triggering the platform printing engine to render and share/print PDF from HTML.
class PrintPdfEffect extends BaseEffect {
  final String htmlContent;
  final String fileName;

  PrintPdfEffect({required this.htmlContent, required this.fileName});

  @override
  String toString() => 'PrintPdfEffect(fileName: $fileName)';
}

/// Centralized provider implementation for handling [PrintPdfEffect] natively.
class PrintPdfProviderImpl extends BaseProvider<PrintPdfEffect> {
  const PrintPdfProviderImpl();

  @override
  void handleEffect(PrintPdfEffect effect) async {
    try {
      await Printing.layoutPdf(
        // ignore: deprecated_member_use
        onLayout: (format) async => await Printing.convertHtml(
          format: format,
          html: effect.htmlContent,
        ),
        name: effect.fileName,
      );
    } catch (e, stackTrace) {
      appLogger.e('PrintPdfProvider: Failed to generate/print PDF', error: e, stackTrace: stackTrace);
    }
  }
}
