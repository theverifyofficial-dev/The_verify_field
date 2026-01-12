import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';

class UpdateImages extends StatefulWidget {
  final int propertyId;

  const UpdateImages({super.key, required this.propertyId});

  @override
  State<UpdateImages> createState() => _MultiImagePickerPageState();
}

class _MultiImagePickerPageState extends State<UpdateImages> {
  List<String> existingImages = [];
  List<File> newImages = [];
  List<String> deletedImages = [];
  bool isLoading = true;
  late int ID = widget.propertyId;

  // 🔹 Separate endpoints
  late final String fetchUrl =
      'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_show_mumlitiple_image_api.php?subid=$ID';

  late final String updateUrl =
      'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_upcoming_multiple_image.php';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  // 🔹 Fetch images from the server
  Future<void> fetchImages() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(fetchUrl),
        body: {
          'action': 'show',
          'subid': widget.propertyId.toString(),
        },
      );

      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}");
      }

      final data = json.decode(response.body);

      if (data is Map &&
          data['status'] == 'success' &&
          data['data'] is List) {
        setState(() {
          existingImages = (data['data'] as List)
              .where((item) => item['M_images'] != null)
              .map((item) =>
          'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item['M_images']}')
              .toList();
        });
      } else {
        await BugLogger.log(
          apiLink: fetchUrl,
          error: response.body,
          statusCode: response.statusCode,
        );
        print("Unexpected API response: $data");
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: fetchUrl,
        error: e.toString(),
        statusCode: 500,
      );
      print("Error fetching images: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }


  // 🔹 Pick new images from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        newImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  // 🔹 Mark an existing image for deletion
  void deleteExistingImage(String imageUrl) {
    setState(() {
      existingImages.remove(imageUrl);
      final parts = imageUrl.split('main_realestate/');
      if (parts.length == 2) {
        deletedImages.add(parts[1]);
      }
    });
  }

  // 🔹 Delete marked images from server
  Future<void> deleteMarkedImages() async {
    if (deletedImages.isEmpty) return;

    try {
      Map<String, String> deleteBody = {
        'action': 'delete_selected',
        'subid': widget.propertyId.toString(),
      };

      for (int i = 0; i < deletedImages.length; i++) {
        deleteBody['delete_images[$i]'] = deletedImages[i];
      }

      final deleteResponse = await http.post(Uri.parse(updateUrl), body: deleteBody);
      print("Delete Response: ${deleteResponse.body}");

      Fluttertoast.showToast(
        msg: "Selected images deleted successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );

      setState(() {
        deletedImages.clear();
        isLoading = true;
      });

      await fetchImages();
    } catch (e) {
      print("Error deleting images: $e");
    }
  }

  // 🔹 Remove a newly picked (local) image
  void deleteNewImage(File image) {
    setState(() {
      newImages.remove(image);
    });
  }

  // 🔹 Update (insert new + delete selected)
  Future<void> updateImages() async {
    try {
      // 1️⃣ Handle deletions
      if (deletedImages.isNotEmpty) {
        Map<String, String> deleteBody = {
          'action': 'delete_selected',
          'subid': widget.propertyId.toString(),
        };

        for (int i = 0; i < deletedImages.length; i++) {
          deleteBody['delete_images[$i]'] = deletedImages[i];
        }

        final deleteResponse = await http.post(Uri.parse(updateUrl), body: deleteBody);
        print("Delete Response: ${deleteResponse.body}");
      }

      // 2️⃣ Handle insertions
      if (newImages.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse(updateUrl));
        request.fields['action'] = 'insert';
        request.fields['subid'] = widget.propertyId.toString();

        for (File image in newImages) {
          request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
        }

        var res = await request.send();
        var body = await res.stream.bytesToString();
        print("Insert Response: $body");
      }

      // 3️⃣ Confirmation Toast
      Fluttertoast.showToast(
        msg: "Images updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // 4️⃣ Refresh state
      setState(() {
        newImages.clear();
        deletedImages.clear();
        isLoading = true;
      });

      await fetchImages();
    } catch (e) {
      print("Error updating images: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong while updating images.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Images"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: pickImage,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (existingImages.isEmpty && newImages.isEmpty)
          ? const Center(child: Text("No images to display"))
          : Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                // 🔹 Existing images
                for (var url in existingImages)
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(url, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => deleteExistingImage(url),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),

                // 🔹 New images
                for (var file in newImages)
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => deleteNewImage(file),
                          child: const CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Column(
            children: [
              if (deletedImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete_forever, color: Colors.white),
                    label: Text(
                      "Delete Selected (${deletedImages.length})",
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: deleteMarkedImages,
                  ),
                ),
              ElevatedButton(
                onPressed: updateImages,
                child: const Text("Submit Changes"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
