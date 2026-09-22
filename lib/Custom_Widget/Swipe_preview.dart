import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';

class SwipePreview extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const SwipePreview({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<SwipePreview> createState() => _SwipePreviewState();
}


class _SwipePreviewState extends State<SwipePreview> {
  late PageController _pageController;
  late int currentIndex;

  bool downloading = false;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    _pageController = PageController(
      initialPage: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> downloadAndSaveImage(String imageUrl) async {
    if (downloading) return;

    setState(() {
      downloading = true;
    });

    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final bytes = Uint8List.fromList(response.data);

      await Gal.putImageBytes(
        bytes,
        name:
        "agreement_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );

      Fluttertoast.showToast(
        msg: "Image saved to gallery ✅",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save image\n$e",
      );
    } finally {
      if (mounted) {
        setState(() {
          downloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "${currentIndex + 1} / ${widget.imageUrls.length}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
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
            onPressed: () {
              downloadAndSaveImage(
                widget.imageUrls[currentIndex],
              );
            },
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,

        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,

            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              child: Image.network(
                widget.imageUrls[index],
                fit: BoxFit.contain,

                loadingBuilder:
                    (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },

                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Icon(
                      Icons.image_rounded,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}