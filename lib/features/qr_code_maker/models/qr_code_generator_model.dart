class QrCodeModel{
  
  const QrCodeModel({
    required this.type,
    required this.data,
    this.errorCorrectionLevel = 'Medium',
    this.foregroundColor = 0xff000000,
    this.backgroundColor = 0xffffffff,
    this.size = 220,
  });

  final String type;
  final String data;
  final String errorCorrectionLevel;
  final int foregroundColor;
  final int backgroundColor;
  final double size;

  QrCodeModel copyWith({
    String? type,
    String? data,
    String? errorCorrectionLevel,
    int? foregroundColor,
    int? backgroundColor,
    double? size,
  }){
    return QrCodeModel(
      type: type ?? this.type, 
      data: data ?? this.data,
      errorCorrectionLevel: errorCorrectionLevel ?? this.errorCorrectionLevel,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      size: size ?? this.size
    );
  }

  
}