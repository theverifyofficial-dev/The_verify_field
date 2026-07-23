import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';

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

  Future<void> downloadAndSaveImage(String imageUrl) async {
    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data);

      await Gal.putImageBytes(
        bytes,
        name: "agreement_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      Fluttertoast.showToast(
        msg: "Image saved to gallery ✅",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save image\n$e",
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme:
        const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          downloading ?
          const Padding(padding: EdgeInsets.all(16),
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
            onPressed: () =>  downloadAndSaveImage,
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: InteractiveViewer(
        scaleEnabled: true,
        minScale: 0.5,
        maxScale: 4.0,
        //boundaryMargin: const EdgeInsets.all(double.infinity),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            widget.ImageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (_, __, ___) => const Icon(
              Icons.image_rounded,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}