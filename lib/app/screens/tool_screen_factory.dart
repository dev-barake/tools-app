import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tools_app/app/data/tool_catalog.dart';
import 'package:tools_app/features/pdf_merger/controllers/pdf_merge_controller.dart';
import 'package:tools_app/shared/controllers/tool_controller.dart';
import 'package:tools_app/features/barcode_maker/screens/barcode_maker_screen.dart';
import 'package:tools_app/features/barcode_scanner/screens/barcode_reader_screen.dart';
import 'package:tools_app/features/image_to_pdf/screens/image_pdf_screen.dart';
import 'package:tools_app/features/password_generator/screens/password_screen.dart';
import 'package:tools_app/features/pdf_merger/screens/pdf_merge_screen.dart';
import 'package:tools_app/features/qr_code_maker/screens/qr_code_screen.dart';
import 'package:tools_app/features/qr_code_scanner/screens/qr_scanner_screen.dart';



Widget buildToolScreen(int index, ToolController controller) => switch (index) {
  0 => PdfMergeScreen(controller: controller,pdfController: Get.find<PdfMergeController>(tag:'pdf-merge-$index',),),
  1 => QrCodeScreen(controller: controller),
  2 => QrScannerScreen(controller: controller),
  3 => PasswordScreen(controller: controller),
  4 => ImagePdfScreen(controller: controller),
  5 => BarcodeReaderScreen(controller: controller),
  6 => BarcodeMakerScreen(controller: controller),
  _ => throw RangeError.index(index, toolCatalog),
};
