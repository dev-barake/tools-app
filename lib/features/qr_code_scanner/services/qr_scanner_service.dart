import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrScannerService{
  final BarcodeScanner _scanner = BarcodeScanner(
    formats: [BarcodeFormat.qrCode],
  );

  Future<List<String>> scanImage(String imagePath) async{
    final inputImage = InputImage.fromFilePath(imagePath);
    final barcodes = await _scanner.processImage(inputImage);

    return barcodes.map(
      (barcode) => barcode.rawValue ?? barcode.displayValue
    ).whereType<String>().where((value) => value.trim().isNotEmpty).toList();
  }

  Future<void> close() async{
    await _scanner.close();
  }
}