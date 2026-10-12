import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utilities/heic_converter.dart';

class FuturePropertyFileUploadPage extends StatefulWidget {
final String idd;

const FuturePropertyFileUploadPage({
super.key,
required this.idd,
});

@override
State<FuturePropertyFileUploadPage> createState() =>
_FuturePropertyFileUploadPageState();
}

class _FuturePropertyFileUploadPageState
extends State<FuturePropertyFileUploadPage> {
  List<String> existingImages = [];
  List<File> newImages = [];
  List<String> deletedImages = [];

  bool isLoading = true;
  bool isSaving = false;

  final String baseUrl =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/update_multiple_image_future_property.php';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  bool get hasChanges =>
      newImages.isNotEmpty || deletedImages.isNotEmpty;

  Future<void> fetchImages() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'action': 'show',
          'subid': widget.idd.toString(),
        },
      );

      debugPrint("Response Body: ${response.body}");

      final data = json.decode(response.body);

      if (!mounted) return;

      if (data['status'] == 'success') {
        setState(() {
          existingImages = (data['images'] as List)
              .map(
                (item) =>
            'https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item
                .toString()}',
          )
              .toList();

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          existingImages = [];
        });
      }
    } catch (e) {
      debugPrint("Error fetching images: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();

      final pickedFiles = await HeicConverter.pickMultiImage(picker, 
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          newImages.addAll(
            pickedFiles.map(
                  (xfile) => File(xfile.path),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  void deleteExistingImage(String imageUrl) {
    setState(() {
      existingImages.remove(imageUrl);

      final parts = imageUrl.split(
        'new_future_property_api_with_multile_images_store/',
      );

      if (parts.length == 2) {
        deletedImages.add(parts[1]);
      }
    });
  }

  void deleteNewImage(File image) {
    setState(() {
      newImages.remove(image);
    });
  }

  Future<void> updateImages() async {
    if (!hasChanges || isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
// -----------------------------
// DELETE SELECTED IMAGES
// -----------------------------
      if (deletedImages.isNotEmpty) {
        final Map<String, String> deleteBody = {
          'action': 'delete_selected',
          'subid': widget.idd.toString(),
        };

        for (int i = 0; i < deletedImages.length; i++) {
          deleteBody['delete_images[$i]'] = deletedImages[i];
        }

        final deleteResponse = await http.post(
          Uri.parse(baseUrl),
          body: deleteBody,
        );

        debugPrint(
          "Delete Response: ${deleteResponse.body}",
        );
      }

// -----------------------------
// UPLOAD NEW IMAGES
// -----------------------------
      if (newImages.isNotEmpty) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl),
        );

        request.fields['action'] = 'insert';
        request.fields['subid'] = widget.idd.toString();

        for (final image in newImages) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'images[]',
              image.path,
            ),
          );
        }

        final response = await request.send();

        final body =
        await response.stream.bytesToString();

        debugPrint(
          "Insert Response: $body",
        );
      }

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "Images updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15,
      );

      setState(() {
        newImages.clear();
        deletedImages.clear();
        isLoading = true;
      });

      await fetchImages();
    } catch (e) {
      debugPrint("Error updating images: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong while updating images.",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget buildImageCard({
    required Widget image,
    required VoidCallback onDelete,
    bool isNew = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,

// Dark gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 45,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),

// NEW badge
          if (isNew)
            Positioned(
              left: 7,
              top: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  "NEW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

// Delete button
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

// --------------------------------
// FIXED TOP SAVE BUTTON
// --------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,

        title: const Text(
          "Property Images",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: hasChanges && !isSaving
                  ? updateImages
                  : null,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                backgroundColor: hasChanges && !isSaving
                    ? Colors.blue
                    : Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isSaving
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                "Save",
                style: TextStyle(
                  color: hasChanges
                      ? Colors.white
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
// --------------------------------
// ADD PHOTOS SECTION
// --------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: InkWell(
              onTap: pickImage,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.blue.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Photos",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Select multiple property photos",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),

// --------------------------------
// IMAGE COUNT
// --------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              12,
              18,
              8,
            ),
            child: Row(
              children: [
                Text(
                  "${existingImages.length + newImages.length} Photos",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                if (hasChanges)
                  Text(
                    "Unsaved changes",
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),

// --------------------------------
// IMAGE GRID
// --------------------------------
          Expanded(
            child: existingImages.isEmpty &&
                newImages.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 65,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No property photos",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Tap Add Photos to upload images",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                24,
              ),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount:
              existingImages.length +
                  newImages.length,
              itemBuilder: (context, index) {
                if (index <
                    existingImages.length) {
                  final url =
                  existingImages[index];

                  return buildImageCard(
                    image: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stack) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                            size: 35,
                          ),
                        );
                      },
                    ),
                    onDelete: () =>
                        deleteExistingImage(url),
                  );
                }

                final newIndex =
                    index -
                        existingImages.length;

                final file =
                newImages[newIndex];

                return buildImageCard(
                  image: Image.file(
                    file,
                    fit: BoxFit.cover,
                  ),
                  isNew: true,
                  onDelete: () =>
                      deleteNewImage(file),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
