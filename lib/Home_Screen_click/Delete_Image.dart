import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Home_Screen_click/showVehicle.dart';

import '../ui_decoration_tools/constant.dart';

class Delete_Image extends StatefulWidget {
  const Delete_Image({super.key});

  @override
  State<Delete_Image> createState() => _Delete_ImageState();
}

class _Delete_ImageState extends State<Delete_Image> {
  int _id = 0;
  bool _isDeleting = false;
  bool _isLoadingImages = true;
  List<ShowVehicleModel> _images = [];
  // Store IDs of images toggled to cross (marked for deletion)
  Set<String> _crossedImageIds = {};

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt('id_Building') ?? 0;
    await _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() => _isLoadingImages = true);
    try {
      final images = await ShowVehicleNumbers(_id);
      setState(() {
        _images = images;
        _crossedImageIds.clear(); // Reset selection on fresh load
        _isLoadingImages = false;
      });
    } catch (e) {
      print('Error fetching images: $e');
      setState(() => _isLoadingImages = false);
    }
  }

  Future<void> DeleteVehicleNumbers(String itemId) async {
    final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/Delete_Added_images_realestate?idd=$itemId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print('Item deleted successfully: $itemId');
    } else {
      print('Error deleting item. Status code: ${response.statusCode}');
      throw Exception('Failed to delete image');
    }
  }

  Future<List<ShowVehicleModel>> ShowVehicleNumbers(int id) async {
    final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/Show_Image_under_Realestatet?id_num=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      return result.map((e) => ShowVehicleModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> _deleteSelectedImages() async {
    if (_crossedImageIds.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'Delete Images?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete ${_crossedImageIds.length} image(s)?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.delete, size: 18, color: Colors.white),
            label: Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isDeleting = true);

      for (final id in _crossedImageIds) {
        await DeleteVehicleNumbers(id);
      }

      _crossedImageIds.clear();
      await _fetchImages();

      setState(() => _isDeleting = false);

      // ✅ Optionally go back after deletion
      Navigator.pop(context, true);
    }
  }

  void _toggleCrossSelection(String id) {
    setState(() {
      if (_crossedImageIds.contains(id)) {
        _crossedImageIds.remove(id);
      } else {
        _crossedImageIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(PhosphorIcons.caret_left_bold,
                  color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
      body: _isLoadingImages
          ? Center(child: CircularProgressIndicator())
          : _images.isEmpty
          ? Center(child: Text("No Image Found!"))
          : Column(
        children: [
          if (_crossedImageIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete_forever),
                label:
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("Delete Selected (${_crossedImageIds.length})"),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isDeleting ? null : _deleteSelectedImages,
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final item = _images[index];
                final isCrossed = _crossedImageIds.contains(item.iid.toString());

                return GestureDetector(
                  onTap: () => _toggleCrossSelection(item.iid.toString()),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 190,
                              // width: 120,
                              child: CachedNetworkImage(
                                imageUrl:
                                "https://verifyserve.social/${item.image_ji}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                    AppImages.loading,
                                    fit: BoxFit.cover),
                                errorWidget: (context, error, stack) =>
                                    Image.asset(AppImages.imageNotFound,
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 100,),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                            isCrossed ? Colors.red : Colors.green,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isCrossed ? Icons.close : Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isDeleting)
            const LinearProgressIndicator(
              minHeight: 4,
              backgroundColor: Colors.transparent,
            ),
        ],
      ),
    );
  }
}
