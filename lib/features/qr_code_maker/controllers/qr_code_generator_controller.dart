





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tools_app/features/qr_code_maker/models/qr_code_generator_model.dart';

class QrCodeGeneratorController extends GetxController{

  //qr content types
  final RxString qrType = 'URL'.obs;

  //input controllers
  final TextEditingController valueController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  //wifi settings
  final RxString wifiSecurity = 'WPA'.obs;
  final RxBool hideWifiPassword = true.obs;

  //Qr customzation

  final RxString errorCorrectionLevel = 'Medium'.obs;
  final RxInt foregroundColor = 0xff000000.obs;
  final RxInt backgroundColor = 0xffffffff.obs;
  final RxDouble qrSize = 220.0.obs;

  //Gnerate qr configuration
  final Rxn<QrCodeModel> generatedQr = Rxn<QrCodeModel>();

  //UI state
  final RxBool isGenerating = false.obs;
  final RxString errorMesssage = ''.obs;

  //change qr content type
  void setQrType(String value){
    qrType.value = value;
    clearGeneratedQr();
    clearMessage();
  }

  //Chage error correction level
  void setErrorCorrectionLevel(String value){
    errorCorrectionLevel.value = value;
    clearGeneratedQr();
    clearMessage();
  }

  //Chage WIfi security
  void setWifiSecurity(String value){
    wifiSecurity.value = value;
    clearGeneratedQr();
    clearMessage();
  }

  //change Qr foreGroundColor
  void setForegroundColor(int value){
    foregroundColor.value = value;
    clearGeneratedQr();
  }

  //change Qr backGroundColor
  void setBackgroundColor(int value){
    backgroundColor.value = value;
    clearGeneratedQr();
  }

  //change qr size
  void setQrSize(double value){
    qrSize.value = value;
    clearGeneratedQr();
  }

  //Clear generated QR
  void clearGeneratedQr(){
    generatedQr.value = null;
  }

  //display error message
  void showMessage(String value){
    errorMesssage.value = value;
  }

  //clear error message
  void clearMessage(){
    errorMesssage.value = '';
  }

  //Generate QR configuration
  void generateQrCode(){
    if(isGenerating.value) return;
    final data = _buildQrData();

    if(data == null || data.isEmpty){
      return;
    }

    generatedQr.value = QrCodeModel(
      type: qrType.value,
      data: data,
      errorCorrectionLevel: errorCorrectionLevel.value,
      foregroundColor: foregroundColor.value,
      backgroundColor: backgroundColor.value,
      size: qrSize.value
    );
    clearMessage();
  }

  //prepare stata according to selected QR type

  String? _buildQrData(){
    switch(qrType.value){
      case 'URL':
        final url = valueController.text.trim();
        if(url.isEmpty){
          showMessage('Enter a Url.');
          return null;
        }
        final uri = Uri.tryParse(url);
        if(uri == null || !uri.hasAuthority || !['hhtp' ,'https'].contains(uri.scheme.toLowerCase())){
          showMessage('Enter a vali URL starting with http:// or https://.');
          return null;
        }
        return url;
      case 'Text':
        final text = valueController.text.trim();
        if(text.isEmpty){
          showMessage('Enter some text to generate your QR code');
          return null;
        }
        return text;

      case 'Email':
        final email = valueController.text.trim();
        if(!GetUtils.isEmail(email)){
          showMessage('Enter a valid Email address.');
          return null;
        }
        return 'mailto:$email';

      case 'Phone':
        final phone = valueController.text.trim();
        if(phone.isEmpty){
          showMessage('Enter a phone number');
          return null;
        }
        return 'tel:$phone';

      case 'SMS': 
        final message = valueController.text.trim();
        if(message.isEmpty){
          showMessage('Enter an SMS message.');
          return null;
        }
        return 'sms:$message';

      case 'Wi-Fi':
        return _buildWifiData();
      case 'vCard':
        return _buildVCardData();
       
      default:
        showMessage('Unsupported QR content type.');
        return null;

      
    }
  }

  //prepare wifi qr data
  String? _buildWifiData(){
    final networkName = valueController.text.trim();
    final password = passwordController.text;

    if(networkName.isEmpty){
      showMessage('Enter the Wi-Fi  network name.');
      return null;
    }

    if(wifiSecurity.value != 'nopass' && password.isEmpty){
      showMessage('Enter he Wi-Fi password');
      return null;
    }

    final escapedName = _escapeWifiValue(networkName);
    final escapedPassword = _escapeWifiValue(password);

    return 'WIFI:T:${wifiSecurity.value};'
    'S:$escapedName;'
    'P:$escapedPassword;;';
  }

  //prepare vCard QR Data
  String? _buildVCardData(){
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if(name.isEmpty){
      showMessage('Enter the contact name.');
      return null;
    }
    if(email.isNotEmpty && !GetUtils.isEmail(email)){
      showMessage('Enter a valid contact email address.');
      return null;
    }

    if(phone.isEmpty && email.isEmpty){
      showMessage('Add at least a phone numer or email address.');
      return null;
    }

    return[
      'BEGIN:VCARD',
      'VERSION:3.0',
      'FN:${_escapeVCardValue(name)}',
      if(phone.isNotEmpty) 'TEL:$phone',
      if(email.isNotEmpty) 'EMAIL:$email',
      'END:VCARD',
    ].join('\n');
  }

  //escaped special wifi character
  String _escapeWifiValue(String value){
    return value.replaceAll(RegExp(r'([\\;,:""])'), r'\$1',);
  }

  //escape special vCard chracters
  String _escapeVCardValue(String value){
    return value
      .replaceAll('\\', r'\\')
      .replaceAll(';', r'\;')
      .replaceAll(',', r'\,')
      .replaceAll('\n', r'\n');
  }

  @override
  void onClose(){
    valueController.dispose();
    passwordController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.onClose();
  }




}