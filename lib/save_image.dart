import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> saveImage(String url, String fileName) async {
  // final completer = Completer<String>();

  // image.image.resolve(ImageConfiguration()).addListener((imageInfo) async {
  //   final byteData =
  //       await imageInfo.image.toByteData(format: ImageByteFormat.png);
  //   final pngBytes = byteData.buffer.asUint8List();

  //   final fileName = pngBytes.hashCode;
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$fileName';
  //   final file = File(filePath);
  //   await file.writeAsBytes(pngBytes);

  //   completer.complete(filePath);
  // });
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';
  final http.Response response = await http.get(Uri.parse(url));
  final File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
  // return completer.future;
}
