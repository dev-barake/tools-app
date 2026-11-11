import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tools_app/core/theme/app_colors.dart';
import 'package:tools_app/features/pdf_merger/models/pdf_file_model.dart';

class PdfFileTile extends StatelessWidget {
  const PdfFileTile({
    super.key,
    required this.file,
    required this.onRemove,
    this.dragHandle,
  });

  final PdfFileModel file;
  final VoidCallback onRemove;
  final Widget? dragHandle;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lavender.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lavender.withValues(alpha: 0.15)
        )
      ),
      child: Row(
        children: [
          const Icon(
            Icons.picture_as_pdf_rounded,
            color: AppColors.lavender,
            size:30
          ),
          const SizedBox(width:12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize:13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height:5),
                Row(
                  children: [
                    Text(
                      file.formattedSize,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                    if(file.pageCount != null) ...[
                      const SizedBox(width:10),
                      Text(
                        '${file.pageCount}pages',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11
                        ),
                      )
                    ]
                  ],
                )
              ],
            ) 
          ),
          if(dragHandle != null)dragHandle!,
          IconButton(
            tooltip: null,
            onPressed: onRemove,
            icon:const Icon(
              Icons.close_rounded,
              color:AppColors.muted,
              size:20,
            )
          )
        ],
      ),
    );
  }
}