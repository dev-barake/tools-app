import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tools_app/core/theme/app_colors.dart';

class MergeProgress extends StatelessWidget {
  const MergeProgress({
    super.key,
    required this.progress,
    required this.processedFiles,
    required this.totalFiles,
    this.isComplete = false,
    this.errorMessage,

  });

  final double progress;
  final int processedFiles;
  final int totalFiles;
  final bool isComplete;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0.0,1.0);
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;
    final title = hasError ? 'Merging failed' : isComplete ? 
    'PDFs merged successfully' : 'Merging your PDFs';
    final subtitle = hasError ? errorMessage! : isComplete ? 'Your combined PDF is ready.' : 'Please wait while your documents are combined';
    final progressColor = hasError ? Colors.red : isComplete ? Colors.green : AppColors.lavender;

    return Container(
      width:double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:AppColors.lavender.withValues(alpha:0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:AppColors.lavender.withValues(alpha:0.15),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasError ? Icons.error_outline_rounded : 
                isComplete ? Icons.check_circle_outline_rounded : Icons.picture_as_pdf_rounded,
                color: progressColor,
                size:25
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Text(
                  title,
                  style:const TextStyle(
                    fontSize:15,
                    fontWeight:FontWeight.w700
                  )
                ),
              ),

              const SizedBox(height:12),
              Text(
                subtitle,
                style:const TextStyle(
                  color:AppColors.muted,
                  fontSize:12,
                  height: 1.5
                )
              ),
              if(!hasError) ...[
                const SizedBox(height:20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style:TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    Text(
                      '${(normalizedProgress * 100).round()}%',
                      style: TextStyle(
                        color:progressColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: normalizedProgress,
                    minHeight: 8,
                    backgroundColor: AppColors.lavender.withValues(alpha:0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressColor,
                    ),
                  ),
                ),

                const SizedBox(height: 12,),
                Text(
                  '$processedFiles of $totalFiles files processed',
                  style:const TextStyle(
                    color:AppColors.muted,
                    fontSize: 11
                  )
                )
              ]
            ],
          ),
        ],
      ),
    );
  }
}