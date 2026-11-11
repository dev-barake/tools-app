

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tools_app/features/qr_code_maker/models/qr_code_generator_model.dart';

class QrCodeGeneratorService {
  //generate png bytes from a qr configuration

  Future<Uint8List>generateQeImage(QrCodeModel qrModel)async{
    final qrPainter = QrPainter(
      data: qrModel.data, 
      version: QrVersions.auto,
      errorCorrectionLevel: _getErrorCorrectionLevel(qrModel.errorCorrectionLevel),
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(qrModel.foregroundColor),
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(qrModel.foregroundColor)
      )
    );

    final image = await qrPainter.toImage(qrModel.size);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint() ..color = Color(qrModel.backgroundColor);

    canvas.drawRect(
      Rect.fromLTRB(0, 0, qrModel.size, qrModel.size),
      paint, 
    );

    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(qrModel.size.round(), qrModel.size.round());
    final byteData = await finalImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    image.dispose();
    finalImage.dispose();

    if(byteData == null){
      throw Exception('Unable to generate QR Image.');
    }
    return byteData.buffer.asUint8List();
  }

  //convert the selected correction level into qr_flutter values
  int _getErrorCorrectionLevel(String level){
    switch(level){
      case 'Low':
        return QrErrorCorrectLevel.L;
      case 'Medium':
        return QrErrorCorrectLevel.M;
      case 'High':
        return QrErrorCorrectLevel.H;
      case 'Quartile':
        return QrErrorCorrectLevel.Q;

      default:
        return QrErrorCorrectLevel.M;
    }
  }
}