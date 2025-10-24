import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class UpcomingPropertyImage {
  final int id;
  final String imagePath;
  final int subId;

  UpcomingPropertyImage({
    required this.id,
    required this.imagePath,
    required this.subId,
  });

  factory UpcomingPropertyImage.fromJson(Map<String, dynamic> json) {
    return UpcomingPropertyImage(
      id: int.tryParse(json['F_id'].toString()) ?? 0,
      imagePath: json['images'] ?? "",
      subId: int.tryParse(json['subid'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F_id': id,
      'images': imagePath,
      'subid': subId,
    };
  }
}


class MultiImg extends StatefulWidget {
  final int propertyId;

  const MultiImg({super.key, required this.propertyId});

  @override
  State<MultiImg> createState() => _MultiImagePickerPageState();
}

class _MultiImagePickerPageState extends State<MultiImg> {
  List<String> existingImages = [];
  List<File> newImages = [];
  List<String> deletedImages = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    try {
      final images = await fetchUpcomingPropertyImages(widget.propertyId);
      setState(() {
        existingImages = images
            .map((e) =>
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${e.imagePath}")
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  
  Future<List<UpcomingPropertyImage>> fetchUpcomingPropertyImages(int id) async {
    final url =
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/multiple_image_for_urgent_flat.php?subid=$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['status'] == 'success' && decoded['data'] != null) {
        final List<dynamic> imagesList = decoded['data'];
        return imagesList
            .map((item) => UpcomingPropertyImage.fromJson(item))
            .toList();
      } else {
        throw Exception("Invalid response structure: missing 'data' key");
      }
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // for multiple images

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        newImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
      });
    }
  }

  // 🔹 Delete an existing image
// inside _MultiImagePickerPageState

  void deleteExistingImage(String imageUrl) {
    setState(() {
      existingImages.remove(imageUrl);

      // ✅ Strip full URL to relative path
      final parts = imageUrl.split('main_realestate/');
      if (parts.length == 2) {
        deletedImages.add(parts[1]); // e.g., 'uploads/xyz.jpg'
      }
    });
  }

// 🔹 Submit only deletion (via separate button)
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

      final deleteResponse = await http.post(Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/urgent_flat_multiple_image.php"), body: deleteBody);
      print("Delete Response: ${deleteResponse.body}");


      Fluttertoast.showToast(
        msg: "Selected images deleted successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR, // or TOP
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );


      // Refresh UI
      setState(() {
        deletedImages.clear();
        isLoading = true;
      });
      fetchUpcomingPropertyImages(widget.propertyId);
    } catch (e) {
      print("Error deleting images: $e");
    }
  }

  // 🔹 Delete a newly picked image
  void deleteNewImage(File image) {
    setState(() {
      newImages.remove(image);
    });
  }

  Future<void> updateImages() async {
    try {
      if (deletedImages.isNotEmpty) {
        Map<String, String> deleteBody = {
          'action': 'delete_selected',
          'subid': widget.propertyId.toString(),
        };

        for (int i = 0; i < deletedImages.length; i++) {
          deleteBody['delete_images[$i]'] = deletedImages[i];
        }

        final deleteResponse = await http.post(Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/urgent_flat_multiple_image.php"), body: deleteBody);
        print("Delete Response: ${deleteResponse.body}");
      }


      // 2. Insert new images
      if (newImages.isNotEmpty) {
        var request = http.MultipartRequest('POST', Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/urgent_flat_multiple_image.php"));
        request.fields['action'] = 'insert';
        request.fields['subid'] = widget.propertyId.toString(); // ✅ added here

        for (File image in newImages) {
          request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
        }

        var res = await request.send();
        var body = await res.stream.bytesToString();
        print("Insert Response: $body");
      }

      // 3. Show confirmation
      Fluttertoast.showToast(
        msg: "Images updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );


      // 4. Refresh list after submission
      setState(() {
        newImages.clear();
        deletedImages.clear();
        isLoading = true;
      });

      await     fetchUpcomingPropertyImages(widget.propertyId);


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
      body: existingImages.isEmpty && newImages.isEmpty
          ? Center(child: Text("No images to display"))
          :Column(
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
                          child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.close, color: Colors.red)),
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
                          child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.close, color: Colors.red)),
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
                    icon: const Icon(Icons.delete_forever,color: Colors.white,),
                    label: Text("Delete Selected (${deletedImages.length})",style: TextStyle(color: Colors.white),),
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
          // ElevatedButton(
          //   onPressed: updateImages,
          //   child: const Text("Submit Changes"),
          // ),
        ],
      ),
    );
  }
}
