import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

class MyItem {
  final String title;
  MyItem(this.title);
}

class MultiImageCompressor extends StatefulWidget {
  String id;
  MultiImageCompressor({super.key, required this.id});

  @override
  _MultiImageCompressorState createState() => _MultiImageCompressorState();
}

class _MultiImageCompressorState extends State<MultiImageCompressor> {



  bool _isLoading = false;

  bool _isVisible = true;

  int _clickCount = 1;

  /*void _handleButtonClick() {
    setState(() {
      _clickCount++;
    });
    print("Button clicked $_clickCount times");
  }*/

  final ImagePicker imagePicker = ImagePicker();
  List<File> compressedImages = [];

  Future<void> selectAndCompressImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      for (XFile image in selectedImages) {
        XFile? compressed = await compressImage(File(image.path));
        if (compressed != null) {
          compressedImages.add(compressed as File);
        }
      }
      setState(() {});
    }
  }

  Future<XFile?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.absolute.path,
      "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}",
    );

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70, // Adjust quality as needed
    );

    return result;
  }

  Future<void> uploadImageWithTitle(File imageFile, String title) async {
    String uploadUrl = 'https://verifyserve.social/upload.php';

    FormData formData = FormData.fromMap({
      "name": title,
      "image": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        print('✅ Upload successful: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded: ${response.data}')),
        );
      } else {
        print('❌ Upload failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('❌ Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  Future<void> _handleUpload(File _imageFile) async {
    /*if (_imageFile == null) {
      Fluttertoast.showToast(
          msg: "Image are required",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a title')),
      );
      return;
    }*/

    await uploadImageWithTitle(_imageFile, '${widget.id}');
  }

  void printAllItems(title) {
    for (var item in compressedImages) {
      print("Title: ${title}");
    }
    print("Total items: ${compressedImages.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Compress & Show Images")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: selectAndCompressImages,
            child: Text("Select Images"),
          ),
      Expanded(
        child: GridView.builder(
          itemCount: compressedImages.length,
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // You can change this to 2, 4, etc.
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                print('${compressedImages[index]}');
              },
              child: Image.file(
                compressedImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
          ],
      ),

      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ // Space between buttons
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                // Button 2 action
                //  for (var i = 0; i < compressedImages.length; i++) {
                //    print("File: ${compressedImages[i].path}");
                //print('${compressedImages[index]}');
                //_handleUpload(compressedImages[i].path);
                // }

                for (var i = 0; i < compressedImages.length; i++) {
                  File file = compressedImages[i];
                  print("Image ${i + 1}: $file");
                  _handleUpload(file);
                }

              },
              child: Text('Upload Images',style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),

    );



  }
}