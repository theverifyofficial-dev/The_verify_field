import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Optional for image type
import 'package:mime/mime.dart'; // To detect MIME type
import 'package:path/path.dart';

class MultiImageUploadProvider with ChangeNotifier {
  bool _isUploading = false;
  bool get isUploading => _isUploading;

  Future<bool> uploadMultipleImages({required int pId, required List<File> images}) async {
    final uri = Uri.parse("https://verifyserve.social/PHP_Files/multiple_image_main_realestate/multiple_image.php");

    final request = http.MultipartRequest('POST', uri);
    request.fields['P_id'] = pId.toString();

    try {
      for (var imageFile in images) {
        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

        request.files.add(await http.MultipartFile.fromPath(
          'imagepath',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
          filename: basename(imageFile.path),
        ));
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print("Upload status code: ${response.statusCode}");
      print("Response body: ${responseBody.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error uploading images: $e");
      return false;
    }
  }
}
