
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/features/pdf_merger/controllers/pdf_merge_controller.dart';
import 'package:tools_app/features/pdf_merger/screens/pdf_preview_screen.dart';
import 'package:tools_app/features/pdf_merger/widgets/merge_progress.dart';
import 'package:tools_app/features/pdf_merger/widgets/selected_pdf_list.dart';
import 'package:tools_app/shared/widgets/tool_components.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';

class PdfMergeScreen extends StatelessWidget {
  const PdfMergeScreen({
    super.key,
    required this.controller,
    required this.pdfController,
  });

  final ToolController controller;
  final PdfMergeController pdfController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final files = pdfController.selectedFiles;
      final isMerging = pdfController.isMerging.value;
      final hasMergeResult = pdfController.isMergeComplete.value;
      final error = pdfController.errorMessage.value;
      final isSaving = pdfController.isSavingPdf.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File selection area.
          if (files.isEmpty)
            const ToolPanel(
              child: EmptyFilePrompt(
                icon: Icons.picture_as_pdf_rounded,
                title: 'Add your PDF files',
                subtitle:
                    'Select two or more PDFs to combine into one document.',
              ),
            )
          else
            ToolPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppColors.lavender,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${files.length} PDF file${files.length == 1 ? '' : 's'} selected',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: isMerging
                            ? null
                            : pdfController.clearSelection,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SelectedPdfList(
                    files: files.toList(),
                    onRemove: pdfController.removePdf,
                    onReorder: pdfController.reorderPdf,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 14),

          // File ordering information.
          if (!isMerging && !hasMergeResult)
            const ToolPanel(
              child: Row(
                children: [
                  Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.lavender,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Arrange your files in the order you want them merged. '
                      'The selected order will determine the final document.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // File picker button / loading indicator.
          if (isMerging)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            )
          else if (!hasMergeResult)
            if (pdfController.isPickingFiles.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              PrimaryButton(
                label: files.isEmpty
                    ? 'Choose PDF files'
                    : 'Add more PDF files',
                icon: Icons.add_rounded,
                onPressed: pdfController.pickPdfFiles,
              ),

          // Merge progress and result.
          if (isMerging || hasMergeResult || error.isNotEmpty) ...[
            const SizedBox(height: 16),
            MergeProgress(
              progress: pdfController.mergeProgress.value,
              processedFiles: pdfController.processedFiles.value,
              totalFiles: files.length,
              isComplete: hasMergeResult,
              errorMessage: error.isEmpty ? null : error,
            ),
          ],

          // Merge button.
          if (files.length >= 2 &&
              !isMerging &&
              !hasMergeResult) ...[
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Merge PDFs',
              icon: Icons.merge_type_rounded,
              onPressed: pdfController.mergePdfs,
            ),
          ],

          const SizedBox(height: 12),

          // Selection status.
          if (files.isNotEmpty && !isMerging && !hasMergeResult)
            Text(
              pdfController.canMerge
                  ? 'Your PDFs are ready to merge.'
                  : 'Select at least one more PDF to continue.',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
              ),
            ),

          

          //save merged PDF and start another merge
          if(hasMergeResult) ...[
            const SizedBox(height: 16,),
            //save PDF button

              
              SizedBox(
                width:double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (){
                    final pdfBytes = pdfController.mergedPdfBytes.value;
                
                    if(pdfBytes == null) return;
                    Get.to(()=> PdfPreviewScreen(pdfBytes: pdfBytes));
                  }, 
                  label: const Text('Preview PDF'),
                  icon: const Icon(Icons.visibility),
                ),
              ),

              const SizedBox(height:10),

            SizedBox(
              width: double.infinity,
              child:ElevatedButton.icon(
                onPressed: isSaving ? null : pdfController.saveMergedPdf,
                icon: isSaving ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator( strokeWidth: 2,)
                ) : const Icon(Icons.save_alt_rounded),
                label: Text(
                  isSaving ? 'Saving PDF...' : 'Save PDF',
                ),
              ),
            ),

            

            const SizedBox(height: 10),

            //Start again button
            OutlinedButton.icon(
              onPressed: isSaving ? null : pdfController.clearSelection,
              icon: const Icon(Icons.refresh_rounded), 
              label: const Text('Start Again')
            )
          ],
          

          ToolMessage(controller: controller),
        ],
      );
    });
  }
}
