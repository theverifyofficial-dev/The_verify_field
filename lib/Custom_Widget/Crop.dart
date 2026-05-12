import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> cropImage(String path) async {

  final cropped = await ImageCropper().cropImage(

    sourcePath: path,

    compressQuality: 85,

    uiSettings: [

      AndroidUiSettings(

        toolbarTitle: 'Crop Image',

        toolbarColor: Colors.black,

        toolbarWidgetColor: Colors.white,

        lockAspectRatio: false,

        hideBottomControls: false,
      ),

      IOSUiSettings(
        title: 'Crop Image',
      ),
    ],
  );

  if (cropped == null) return null;

  return File(cropped.path);
}