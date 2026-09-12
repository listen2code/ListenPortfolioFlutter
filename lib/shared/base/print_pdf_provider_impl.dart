import 'package:listen_core/core.dart';
import 'package:printing/printing.dart';

/// Single-use side effect triggering the platform native printing and PDF export engine.
///
/// Encapsulates the fully styled [htmlContent] (compiled from Markdown with typography CSS)
/// and the desired output [fileName].
///
/// ### Clean Architecture Effect Rationale:
/// Under MVI, the ViewModel cannot and should not directly invoke UI or OS-level printing dialogs.
/// Instead, it emits [PrintPdfEffect]. The UI layer / provider infrastructure intercepts
/// this effect and bridges to the native OS print spooler or sharing sheet.
class PrintPdfEffect extends BaseEffect {
  /// The complete HTML string including `<style>` definitions for print layout.
  final String htmlContent;

  /// Suggested file name when saving or sharing the generated PDF.
  final String fileName;

  PrintPdfEffect({required this.htmlContent, required this.fileName});

  @override
  String toString() => 'PrintPdfEffect(fileName: $fileName)';
}

/// Centralized provider implementation for executing [PrintPdfEffect] across platforms.
///
/// Integrates with `package:printing` to convert HTML to high-precision vector PDF documents
/// and launch the native platform print preview dialog (AirPrint on iOS, Android Print Spooler,
/// or Web Print API).
class PrintPdfProviderImpl extends BaseProvider<PrintPdfEffect> {
  const PrintPdfProviderImpl();

  /// Invokes the native platform printing pipeline with vector HTML-to-PDF compilation.
  ///
  /// ### Cross-Platform Execution Paths:
  /// - **iOS/iPadOS**: Bridges to `UIPrintInteractionController` (AirPrint) with
  ///   built-in AirDrop, Mail, and Files export actions.
  /// - **Android**: Bridges to `android.print.PrintManager` with PDF spooling
  ///   and "Save as PDF" storage provider options.
  /// - **Web**: Bridges to browser printing subsystem via an invisible iframe
  ///   and `window.print()`.
  ///
  /// Defensively handles any system spooler cancellation or rendering exceptions
  /// to ensure the calling UI loop is never crashed.
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
