import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../Custom_Widget/constant.dart';

class EditPlotImage extends StatefulWidget {
  final String sub_id;

  const EditPlotImage({super.key, required this.sub_id});

  @override
  State<EditPlotImage> createState() => _EditPlotImageState();
}

class _EditPlotImageState extends State<EditPlotImage> {
  List<String> existingImages = [];
  List<File> newImages = [];
  List<String> deletedImages = [];
  bool isLoading = true;

  final String baseUrl =
      'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/edit_plot_multiple_image.php';

  final String fullBaseImageUrl =
      'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  // ================= FETCH IMAGES =================
  Future<void> fetchImages() async {
    try {
      final response = await http.post(Uri.parse(baseUrl), body: {
        'action': 'show',
        'sub_id': widget.sub_id,
      });

      print("SHOW Response: ${response.body}");

      final data = json.decode(response.body);

      if (data['status'] == 'success') {


        setState(() {
          existingImages = (data['images'] as List).map((item) {
            String img = item.toString().trim();

            // If already full URL
            if (img.startsWith("http")) {
              return img;
            }

            // Always just attach base URL
            return fullBaseImageUrl + img;
          }).toList();


          print("Final Image URLs: $existingImages");

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Fetch Error: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= PICK MULTIPLE =================

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        newImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  // ================= DELETE EXISTING =================

  void deleteExistingImage(String imageUrl) {
    setState(() {
      existingImages.remove(imageUrl);

      // extract full folder path required by API
      final filePath =
      imageUrl.replaceAll(fullBaseImageUrl, '');

      deletedImages.add(filePath);
      // this will send:
      // Plot_for_multiple_images/img1.jpg
    });
  }

  void deleteNewImage(File image) {
    setState(() {
      newImages.remove(image);
    });
  }

  // ================= DELETE SELECTED =================

  Future<void> deleteMarkedImages() async {
    if (deletedImages.isEmpty) return;

    try {
      Map<String, String> deleteBody = {
        'action': 'delete_selected',
        'sub_id': widget.sub_id,
      };

      for (int i = 0; i < deletedImages.length; i++) {
        deleteBody['delete_images[$i]'] = deletedImages[i];
      }

      final deleteResponse =
      await http.post(Uri.parse(baseUrl), body: deleteBody);

      print("DELETE Response: ${deleteResponse.body}");

      Fluttertoast.showToast(
        msg: "Selected images deleted successfully.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      deletedImages.clear();
      await fetchImages();
    } catch (e) {
      print("Delete Error: $e");
    }
  }

  // ================= INSERT + UPDATE =================

  Future<void> updateImages() async {
    try {
      // DELETE FIRST
      if (deletedImages.isNotEmpty) {
        await deleteMarkedImages();
      }

      // INSERT NEW
      if (newImages.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

        request.fields['action'] = 'insert';
        request.fields['sub_id'] = widget.sub_id;

        for (File image in newImages) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'images[]',
              image.path,
            ),
          );
        }

        var res = await request.send();
        var body = await res.stream.bytesToString();
        print("INSERT Response: $body");
      }

      Fluttertoast.showToast(
        msg: "Images updated successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      newImages.clear();
      deletedImages.clear();

      await fetchImages();
    } catch (e) {
      print("Update Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
        iconTheme: IconThemeData(color:Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: pickImage,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : existingImages.isEmpty && newImages.isEmpty
          ? const Center(child: Text("No images to display"))
          : Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                // EXISTING IMAGES
                for (var url in existingImages)
                  Stack(
                    children: [
                      Positioned.fill(
                        child:
                        Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("IMAGE LOAD ERROR: $error");
                            print("FAILED URL: $url");

                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 40),
                              ),
                            );
                          },
                        )
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () =>
                              deleteExistingImage(url),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close,
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),

                // NEW IMAGES
                for (var file in newImages)
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () =>
                              deleteNewImage(file),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close,
                                color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;

              return SizedBox(
                width: width > 500 ? 300 : width * 0.7, // ⭐ responsive logic
                height: 50,
                child: ElevatedButton(
                  onPressed: updateImages,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.blue.withOpacity(0.4),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff4facfe),
                          Color(0xff00f2fe),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.touch_app, color: Colors.white),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              "Submit Image",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
