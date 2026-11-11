import 'package:flutter/material.dart';
import 'package:tools_app/features/pdf_merger/models/pdf_file_model.dart';
import 'package:tools_app/features/pdf_merger/widgets/pdf_file_tile.dart';

class SelectedPdfList extends StatelessWidget {
  const SelectedPdfList({
    super.key,
    required this.files,
    required this.onRemove,
    required this.onReorder,
  });

  final List<PdfFileModel> files;
  final ValueChanged<int> onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    if(files.isEmpty){
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      itemCount: files.length, 
      onReorder: onReorder,
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        final file = files[index];

        return Padding(
          key: ValueKey(file.path),
          padding:const EdgeInsets.only(bottom:10),
          child:PdfFileTile(
            file: file, 
            onRemove: ()=> onRemove(index),
            dragHandle: ReorderableDelayedDragStartListener(    
              index: index,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.drag_handle_rounded,
                  color:Colors.grey,
                  size:22,
                ),
              ),
            ),

          )
        );
      }, 
    );
  }
}