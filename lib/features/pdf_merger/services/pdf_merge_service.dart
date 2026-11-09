
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Offset;

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfValidationResult {
  final bool isValid;
  final int? pageCount;
  final String message;

  const PdfValidationResult({
    required this.isValid,
    this.pageCount,
    required this.message,
  });
}

class PdfMergeService {
  // Validate a PDF file and retrieve its page count.
  Future<PdfValidationResult> validatePdf(File file) async {
    if (!await file.exists()) {
      return const PdfValidationResult(
        isValid: false,
        message: 'File does not exist.',
      );
    }

    final extension = file.path.split('.').last.toLowerCase();

    if (extension != 'pdf') {
      return const PdfValidationResult(
        isValid: false,
        message: 'Selected file is not a PDF.',
      );
    }

    try {
      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        return const PdfValidationResult(
          isValid: false,
          message: 'PDF file is empty.',
        );
      }

      final document = PdfDocument(inputBytes: bytes);

      try {
        final pageCount = document.pages.count;

        if (pageCount == 0) {
          return const PdfValidationResult(
            isValid: false,
            message: 'PDF contains no pages.',
          );
        }

        return PdfValidationResult(
          isValid: true,
          message: 'PDF is valid.',
          pageCount: pageCount,
        );
      } finally {
        document.dispose();
      }
    } catch (error) {
      return const PdfValidationResult(
        isValid: false,
        message:
            'Unable to read PDF. It may be corrupted or password-protected.',
      );
    }
  }

  // Get the number of pages in a PDF.
  Future<int> getPageCount(File file) async {
    final result = await validatePdf(file);

    if (!result.isValid || result.pageCount == null) {
      throw Exception(result.message);
    }

    return result.pageCount!;
  }

  // Merge multiple PDFs in the supplied order.
  // Reports progress after each source PDF is processed.
  Future<Uint8List> mergePdfs(
    List<File> files, {
    void Function(int processedFiles, int totalFiles)? onProgress,
  }) async {
    if (files.length < 2) {
      throw Exception('Select at least two PDF files to merge.');
    }

    final totalFiles = files.length;
    var processedFiles = 0;

    onProgress?.call(processedFiles, totalFiles);

    final mergeDocument = PdfDocument();

    try {
      PdfSection? currentSection;

      for (final file in files) {
        final validation = await validatePdf(file);

        if (!validation.isValid) {
          throw Exception(
            '${file.path.split(Platform.pathSeparator).last}: '
            '${validation.message}',
          );
        }

        final sourceBytes = await file.readAsBytes();
        final sourceDocument = PdfDocument(inputBytes: sourceBytes);

        try {
          // Process every page in the source document.
          for (int index = 0;
              index < sourceDocument.pages.count;
              index++) {
            final template =
                sourceDocument.pages[index].createTemplate();

            // Create a new section when page dimensions change.
            if (currentSection == null ||
                currentSection.pageSettings.size != template.size) {
              currentSection = mergeDocument.sections!.add();

              currentSection.pageSettings.size = template.size;
              currentSection.pageSettings.margins.all = 0;
            }

            // Add the original page to the merged document.
            currentSection.pages
                .add()
                .graphics
                .drawPdfTemplate(template, const Offset(0, 0));
          }
        } finally {
          sourceDocument.dispose();
        }

        // Report progress after this PDF has been processed.
        processedFiles++;
        onProgress?.call(processedFiles, totalFiles);
      }

      // Generate the final merged PDF.
      final outputBytes = await mergeDocument.save();

      return Uint8List.fromList(outputBytes);
    } finally {
      mergeDocument.dispose();
    }
  }
}
