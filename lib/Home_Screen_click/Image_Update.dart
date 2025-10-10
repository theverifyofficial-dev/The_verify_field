import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../ui_decoration_tools/app_images.dart';
import 'Real-Estate.dart';

class image_Update extends StatefulWidget {
  String id;
  image_Update({super.key, required this.id});

  @override
  State<image_Update> createState() => _image_UpdateState();
}

class _image_UpdateState extends State<image_Update> {

  File? _imageFile;
  bool _isLoading = false;

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85, // Compression quality
    );

    return result;
  }

  Future<void> uploadImageWithTitle(File imageFile, String title) async {
    String uploadUrl = 'https://verifyserve.social/phprealstateimages.php'; // Replace with your API endpoint

    FormData formData = FormData.fromMap({
      "PVR_id": title,
      "Realstate_image": await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        setState(() {
          _imageFile = null;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful: ${response.data}')),
        );
        print('Upload successful: ${response.data}');
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_Real_Estate()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      print('Error occurred: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (_imageFile == null) {
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
    }

    await uploadImageWithTitle(_imageFile!, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.pencil,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                onPressed: () async {
                  File? pickedImage = (await pickAndCompressImage()) as File?;
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = pickedImage;
                    });
                  }
                },
                child: Text('Pick Image'),
              ),

              SizedBox(
                width: 100,
              ),

              Container(
                width: 100,
                height: 100,
                child: Center(
                  child: _imageFile != null
                      ? Image.file(_imageFile!)
                      : Text('No image selected.',style: TextStyle(color: Colors.white),),
                ),
              ),

            ],
          ),


          SizedBox(height: 0),
          GestureDetector(
            onTap: () async {
              _handleUpload();
              setState(() {
                _isLoading = true;
              });

            },
            child: Center(
              child: Container(
                height: 50,
                width: 200,
                // margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: Colors.red.withOpacity(0.8)),
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : const Center(
                  child: Text(
                    "Upload Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
