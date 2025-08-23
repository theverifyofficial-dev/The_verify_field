import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Futureproipoerty_FileUploadPage extends StatefulWidget {
  final String idd;

  const Futureproipoerty_FileUploadPage({super.key, required this.idd});

  @override
  State<Futureproipoerty_FileUploadPage> createState() => _Futureproipoerty_FileUploadPageState();
}

class _Futureproipoerty_FileUploadPageState extends State<Futureproipoerty_FileUploadPage> {
  List<String> existingImages = [];
  List<File> newImages = [];
  List<String> deletedImages = [];
  bool isLoading = true;

  final String baseUrl = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_multiple_image_in_future_property.php';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }
  void toggleImageForDeletion(String imageUrl) {
    setState(() {
      final parts = imageUrl.split('main_realestate/');
      if (parts.length == 2) {
        final fileName = parts[1];
        if (deletedImages.contains(fileName)) {
          deletedImages.remove(fileName); // Unselect if already selected
        } else {
          deletedImages.add(fileName); // Select for deletion
        }
      }
    });
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.post(Uri.parse(baseUrl), body: {
        'action': 'show',
        'subid': widget.idd.toString(),
      });

      print("Response Body: ${response.body}");

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          existingImages = (data['images'] as List)
              .map((item) =>
          'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.toString()}').toList();
          isLoading = false;
        });
      } else {
        print("API success false or unexpected data: $data");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching images: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        newImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  void deleteExistingImage(String imageUrl) {
    setState(() {
      existingImages.remove(imageUrl);
      final parts = imageUrl.split('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/');
      if (parts.length == 2) {
        deletedImages.add(parts[1]);
      }
    });
  }

  Future<void> deleteMarkedImages() async {
    if (deletedImages.isEmpty) return;

    try {
      Map<String, String> deleteBody = {
        'action': 'delete_selected',
        'subid': widget.idd.toString(),
      };

      for (int i = 0; i < deletedImages.length; i++) {
        deleteBody['delete_images[$i]'] = deletedImages[i];
      }

      final deleteResponse = await http.post(Uri.parse(baseUrl), body: deleteBody);
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

  void deleteNewImage(File image) {
    setState(() {
      newImages.remove(image);
    });
  }

  Future<void> updateImages() async {
    try {
      // Delete selected
      if (deletedImages.isNotEmpty) {
        Map<String, String> deleteBody = {
          'action': 'delete_selected',
          'subid': widget.idd.toString(),
        };

        for (int i = 0; i < deletedImages.length; i++) {
          deleteBody['delete_images[$i]'] = deletedImages[i];
        }

        final deleteResponse = await http.post(Uri.parse(baseUrl), body: deleteBody);
        print("Delete Response: ${deleteResponse.body}");
      }

      // Upload new
      if (newImages.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
        request.fields['action'] = 'insert';
        request.fields['subid'] = widget.idd.toString();

        for (File image in newImages) {
          request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
        }

        var res = await request.send();
        var body = await res.stream.bytesToString();
        print("Insert Response: $body");
      }

      Fluttertoast.showToast(
        msg: "Images updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

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
          : existingImages.isEmpty && newImages.isEmpty
          ? const Center(child: Text("No images to display"))
          : Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              children: [
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
                    label: Text("Delete Selected (${deletedImages.length})",
                        style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
