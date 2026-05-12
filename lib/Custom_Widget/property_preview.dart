import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class PropertyPreview extends StatefulWidget {

  final String ImageUrl;

  const PropertyPreview({
    super.key,
    required this.ImageUrl,
  });

  @override
  State<PropertyPreview> createState() =>
      _PropertyPreviewState();
}

class _PropertyPreviewState
    extends State<PropertyPreview> {

  bool downloading = false;

  Future<void> downloadAndSaveImage() async {
    try {

      setState(() => downloading = true);

      final response = await Dio().get(

        widget.ImageUrl,

        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final result =
      await ImageGallerySaverPlus.saveImage(

        Uint8List.fromList(response.data),

        quality: 100,

        name:
        "property_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == true ||
          result['filePath'] != null) {

        Fluttertoast.showToast(
          msg: "Image saved to gallery ✅",
        );

      } else {

        Fluttertoast.showToast(
          msg: "Save failed ❌",
        );
      }

    } catch (e) {

      Fluttertoast.showToast(
        msg: e.toString(),
      );

    } finally {

      if (mounted) {
        setState(() => downloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        iconTheme:
        const IconThemeData(
          color: Colors.white,
        ),

        actions: [

          downloading
              ? const Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          )

              : IconButton(

            onPressed: downloadAndSaveImage,

            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: Center(
        child: InteractiveViewer(

          minScale: 1,
          maxScale: 4,

          child: Image.network(

            widget.ImageUrl,

            loadingBuilder:
                (context, child, progress) {

              if (progress == null) return child;

              return const Center(
                child: CircularProgressIndicator(),
              );
            },

            errorBuilder: (_, __, ___) =>
                Icon(
                  Icons.image_rounded,
                  color: isDark
                      ? Colors.white
                      : Colors.grey,
                  size: 40,
                ),
          ),
        ),
      ),
    );
  }
}