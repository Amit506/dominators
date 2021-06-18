import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShotPhotoView extends StatelessWidget {
  final String file;
  const ShotPhotoView({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: PhotoView(
            imageProvider: FileImage(File(file)),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blueAccent.withOpacity(0.2),
              height: 150,
              width: double.infinity,
            ),
          ),
          Positioned(
              bottom: 135,
              right: 30,
              child: IconButton(
                  icon: Icon(
                    Icons.near_me,
                    size: 50,
                    color: Colors.lightBlueAccent,
                  ),
                  onPressed: () {}))
        ],
      ),
    );
  }
}
