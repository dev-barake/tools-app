class QrScannerModel {
  const QrScannerModel({
    required this.content,
    required this.format,
    required this.scannedAt,
  });

  final String content;
  final String format;
  final DateTime scannedAt;

  bool get isUrl{
    final uri = Uri.tryParse(content);
    return uri != null && 
    (uri.scheme == 'http' || uri.scheme == 'https') &&
    uri.host.isNotEmpty;
  }

  factory QrScannerModel.fromContent(String content){
    return QrScannerModel(
      content: content,
      format: 'QR Code',
      scannedAt: DateTime.now(),
    );
  }
}