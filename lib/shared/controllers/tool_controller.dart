
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ToolController extends GetxController {
  ToolController({required this.toolIndex});

  final int toolIndex;
  final Random _passwordRandom = Random.secure();

  final RxInt passwordLength = 16.obs;
  final RxBool upper = true.obs;
  final RxBool lower = true.obs;
  final RxBool numbers = true.obs;
  final RxBool symbols = true.obs;

  final RxnString password = RxnString();
  final RxnString message = RxnString();

  final RxString qrType = 'URL'.obs;
  final RxString barcodeFormat = 'Code 128'.obs;
  final RxString conversionMode = 'Images to PDF'.obs;

  final TextEditingController valueController =
      TextEditingController();

  void showMessage(String value) {
    message.value = value;
  }

  void clearMessage() {
    message.value = null;
  }

  void setQrType(String value) {
    qrType.value = value;
    clearMessage();
  }

  void setBarcodeFormat(String value) {
    barcodeFormat.value = value;
    clearMessage();
  }

  void setConversionMode(String value) {
    conversionMode.value = value;
    clearMessage();
  }

  void setPasswordLength(double value) {
    passwordLength.value = value.round();
    password.value = null;
    clearMessage();
  }

  void setUpper(bool value) {
    upper.value = value;
    _resetPassword();
  }

  void setLower(bool value) {
    lower.value = value;
    _resetPassword();
  }

  void setNumbers(bool value) {
    numbers.value = value;
    _resetPassword();
  }

  void setSymbols(bool value) {
    symbols.value = value;
    _resetPassword();
  }

  void _resetPassword() {
    password.value = null;
    clearMessage();
  }

  void generatePassword() {
    final categories = <String>[
      if (upper.value) 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      if (lower.value) 'abcdefghijklmnopqrstuvwxyz',
      if (numbers.value) '0123456789',
      if (symbols.value) r'!@#$%^&*()-_=+[]{};:,.?',
    ];

    if (categories.isEmpty) {
      showMessage('Choose at least one character type.');
      return;
    }

    if (passwordLength.value < categories.length) {
      showMessage(
        'Increase the length to fit every selected type.',
      );
      return;
    }

    final pool = categories.join();

    final result = <String>[
      for (final category in categories)
        category[_passwordRandom.nextInt(category.length)],
    ];

    while (result.length < passwordLength.value) {
      result.add(pool[_passwordRandom.nextInt(pool.length)]);
    }

    result.shuffle(_passwordRandom);

    password.value = result.join();
    clearMessage();
  }

  Future<void> copyPassword() async {
    final value = password.value;
    if (value == null) return;

    try {
      await Clipboard.setData(ClipboardData(text: value));
      showMessage('Password copied to clipboard.');
    } on PlatformException {
      showMessage(
        'Copy unavailable. Select the password to copy it.',
      );
    }
  }

  void generateQrCode() {
    if (valueController.text.trim().isEmpty) {
      showMessage('Add some content to get started.');
    } else {
      showMessage(
        'QR generation will be connected in the next implementation step.',
      );
    }
  }

  void scanImage({required bool isQr}) {
    showMessage(
      'Image selection will be connected in the next implementation step.',
    );
  }

  void selectPdfFiles() {
    showMessage(
      'The file picker will be connected when file tools are wired up.',
    );
  }

  void selectConversionFiles() {
    showMessage(
      'File selection and conversion will be connected in the next implementation step.',
    );
  }

  void generateBarcode() {
    if (valueController.text.trim().isEmpty) {
      showMessage('Enter a value to get started.');
    } else {
      showMessage(
        'Barcode generation will be connected in the next implementation step.',
      );
    }
  }

  void showBarcodePreviewMessage() {
    showMessage(
      'Barcode preview will be connected in the next implementation step.',
    );
  }

  @override
  void onClose() {
    valueController.dispose();
    super.onClose();
  }
}
