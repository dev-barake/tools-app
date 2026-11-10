import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreviewScreen extends StatefulWidget {
  const PdfPreviewScreen({
    super.key,
    required this.pdfBytes,
  });

  final Uint8List pdfBytes;

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {

  late final PdfControllerPinch _pdfController;

  @override
  void initState(){
    super.initState();
    _pdfController = PdfControllerPinch(document: PdfDocument.openData(widget.pdfBytes));
  }

  @override
  void dispose(){
    _pdfController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfViewPinch(controller: _pdfController),
    );
  }
}