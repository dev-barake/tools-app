
import 'dart:io';
import 'dart:typed_data';


import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import 'package:tools_app/features/pdf_merger/models/pdf_file_model.dart';
import 'package:tools_app/features/pdf_merger/services/pdf_merge_service.dart';
import 'package:share_plus/share_plus.dart';

class PdfMergeController extends GetxController {
  // PDF service.
  final PdfMergeService _pdfMergeService = PdfMergeService();

  // Selected PDF files.
  final RxList<PdfFileModel> selectedFiles = <PdfFileModel>[].obs;

  // File picker loading state.
  final RxBool isPickingFiles = false.obs;

  //PDF saving state
  final RxBool isSavingPdf = false.obs;

  // PDF merging state.
  final RxBool isMerging = false.obs;
  final RxBool isMergeComplete = false.obs;

  // Merge progress (0.0 to 1.0).
  final RxDouble mergeProgress = 0.0.obs;

  // Number of files processed during merging.
  final RxInt processedFiles = 0.obs;

  // Resulting merged PDF.
  final Rxn<Uint8List> mergedPdfBytes = Rxn<Uint8List>();

  // Error message.
  final RxString errorMessage = ''.obs;

  // Open device file picker and select multiple PDFs.
  Future<void> pickPdfFiles() async {
    if (isPickingFiles.value || isMerging.value) return;

    try {
      isPickingFiles.value = true;
      errorMessage.value = '';

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
        withData: false,
      );

      if (result == null || result.files.isEmpty) return;

      for (final file in result.files) {
        if (file.extension?.toLowerCase() != 'pdf') continue;

        // A local file path is required for PDF processing.
        final filePath = file.path;

        if (filePath == null || filePath.isEmpty) {
          errorMessage.value =
              'Unable to access ${file.name}. Please select it again.';
          continue;
        }

        // Prevent duplicate files.
        final alreadySelected = selectedFiles.any(
          (existingFile) => existingFile.path == filePath,
        );

        if (alreadySelected) continue;

        // Convert picker result into our PDF model.
        final pdfFile = PdfFileModel(
          name: file.name,
          path: filePath,
          size: file.size,
          extension: file.extension!.toLowerCase(),
        );

        selectedFiles.add(pdfFile);
      }
    } catch (error) {
      errorMessage.value = 'Unable to select PDF files: $error';
    } finally {
      isPickingFiles.value = false;
    }
  }

  // Start merging the selected PDFs.
  Future<void> mergePdfs() async {
    if (isMerging.value) return;

    if (!canMerge) {
      errorMessage.value = 'Select at least two PDF files to merge.';
      return;
    }

    // Reset previous merge state.
    errorMessage.value = '';
    isMergeComplete.value = false;
    mergeProgress.value = 0.0;
    processedFiles.value = 0;
    mergedPdfBytes.value = null;

    try {
      isMerging.value = true;

      final files = selectedFiles
          .map((pdfFile) => File(pdfFile.path))
          .toList();

      final result = await _pdfMergeService.mergePdfs(
        files,
        onProgress: (processed, total) {
          processedFiles.value = processed;

          // Reserve the final 5% for generating the output PDF.
          mergeProgress.value = total == 0
              ? 0.0
              : (processed / total) * 0.95;
        },
      );

      mergedPdfBytes.value = result;
      mergeProgress.value = 1.0;
      isMergeComplete.value = true;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst(
        'Exception: ',
        '',
      );

      isMergeComplete.value = false;
    } finally {
      isMerging.value = false;
    }
  }

  //save the merged pdf to a user-selected location
  Future<void> saveMergedPdf()async{
    if(isSavingPdf.value)return;

    final pdfBytes = mergedPdfBytes.value;
    if(!isMergeComplete.value || pdfBytes == null) {
      Get.snackbar(
        'Nothing to save',
        'Merge your PDF files first', 
      );
      return;
    }

    try{
      isSavingPdf.value = true; 
      final savedPath = await  FilePicker.platform.saveFile(
        dialogTitle: 'Save merged PDF',
        fileName: 'merged_document.pdf',
        bytes: pdfBytes,
        type: FileType.custom,
        allowedExtensions: ['pdf']
      );

      //the user cancelled the save dialog
      if(savedPath == null) return;

      Get.snackbar(
        'PDF Saved.',
        'Your merged PDF has been saved successfully',
        snackPosition: SnackPosition.BOTTOM, 
      );

    }catch (error){
      Get.snackbar(
        'Saving failed',
        'Unable to save the PDF: $error',
        snackPosition: SnackPosition.BOTTOM 
      );
    } finally{
      isSavingPdf.value = false;
    }
  }
  //share pdf using adroids native share sheet
  Future<void> shareMergedPdf()async{
    final pdfBytes = mergedPdfBytes.value;

    if(!isMergeComplete.value || pdfBytes == null){
      Get.snackbar(
        'Nothing to share', 
        'Merge your PDF files first',
        snackPosition: SnackPosition.BOTTOM
      );
      return;
    }

    try{
      await SharePlus.instance.share(
        ShareParams(
          title:'Share merged PDF',
          subject:'Merged PDF document',
          files: [
            XFile.fromData(
              pdfBytes,
              mimeType:'application/pdf',
            )
          ],
          fileNameOverrides: ['merged_document.pdf'],
        )
      );
    }catch (error){
      Get.snackbar(
        'Sharing failed',
        'Unable to share the PDF: $error',
        snackPosition: SnackPosition.BOTTOM 
      );
    }
  }

  // Remove a selected PDF.
  void removePdf(int index) {
    if (isMerging.value) return;
    if (index < 0 || index >= selectedFiles.length) return;

    selectedFiles.removeAt(index);
    _resetMergeState();
  }

  // Clear all selected PDFs.
  void clearSelection() {
    if (isMerging.value) return;

    selectedFiles.clear();
    _resetMergeState();
  }

  // Reorder selected PDFs.
  void reorderPdf(int oldIndex, int newIndex) {
    if (isMerging.value) return;

    if (oldIndex < 0 ||
        oldIndex >= selectedFiles.length ||
        newIndex < 0 ||
        newIndex > selectedFiles.length) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final file = selectedFiles.removeAt(oldIndex);
    selectedFiles.insert(newIndex, file);

    _resetMergeState();
  }

  // Reset merge-related state when the selection changes.
  void _resetMergeState() {
    errorMessage.value = '';
    isMergeComplete.value = false;
    mergeProgress.value = 0.0;
    processedFiles.value = 0;
    mergedPdfBytes.value = null;
  }

  // Number of selected PDF files.
  int get selectedFileCount => selectedFiles.length;

  // Whether there are enough files to merge.
  bool get canMerge =>
      selectedFiles.length >= 2 && !isMerging.value;

  // Total size of selected PDFs in bytes.
  int get totalFileSize {
    return selectedFiles.fold(
      0,
      (total, file) => total + file.size,
    );
  }

  // Total formatted file size.
  String get formattedTotalSize {
    final bytes = totalFileSize;

    if (bytes < 1024) return '$bytes B';

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }

    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
