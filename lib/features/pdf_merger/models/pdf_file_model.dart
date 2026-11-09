import 'dart:io';

class PdfFileModel {
  final String name;
  final String path;
  final int size;
  final String extension;
  final int? pageCount;

  PdfFileModel({
    required this.name, 
    required this.path, 
    required this.size, 
    required this.extension, 
    this.pageCount
  });


  //create a model from a selected pdf

  factory PdfFileModel.fromFile(File file){
    final fileName = file.path.split(Platform.pathSeparator).last;

    return PdfFileModel(
      name: fileName, 
      path: file.path, 
      size: file.lengthSync(), 
      extension: fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '',
    );
  }

  //file size formatted for display
  String get formattedSize {
    if(size < 1024){
      return '$size B';
    }

    if(size < 1024 * 1024){
      return '${(size / 1024).toStringAsFixed(1)} KB';
    }

    if(size < 1024*1024*1024){
      return '${(size/(1024 * 1024)).toStringAsFixed(2)} MB';
    }

    return '${(size / (1024*1024*1024)).toStringAsFixed(2)} GB';
  }

  //check extention if its pdf

  bool get isPdf => extension == 'pdf';

  //create a copy with updated info
  PdfFileModel copyWith({
    String? name,
    String? path,
    int? size,
    String? extension,
    int? pageCount,
  }){
    return PdfFileModel(
      name: name ?? this.name, 
      path: path ?? this.path, 
      size: size ?? this.size, 
      extension: extension ?? this.extension,
      pageCount: pageCount ?? this.pageCount,
    );
  }

  //convert model to a map

  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'path':path,
      'size':size,
      'extension':extension,
      'pageCount':pageCount
    };
  }

  //create model from a map

  factory PdfFileModel.fromMap(Map<String,dynamic> map){
    return PdfFileModel(
      name: map ['name'] as String, 
      path: map ['path'] as String, 
      size: map ['size'] as int, 
      extension: map ['extension'] as String,
      pageCount: map ['pageCount'] as int?,
    );
  }









}