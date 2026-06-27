import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';



Future<File?> cropImage(
    BuildContext context,
    String path,
    ) async {
  final file = File(path);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Preparing image..."),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    final imageData = await file.readAsBytes();

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!context.mounted) return null;

    return Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (_) => CropScreen(
          imageFile: file,
          imageData: imageData,
        ),
      ),
    );
  } catch (_) {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    return null;
  }
}

class CropScreen extends StatefulWidget {
  final Uint8List imageData;
  final File imageFile;

  const CropScreen({
    super.key,
    required this.imageData,
    required this.imageFile,
  });

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final CropController _controller = CropController();


  bool _cropping = false;


  Future<File> _saveImage(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();

    final path =
        '${dir.path}/crop_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed =
    await FlutterImageCompress.compressWithList(
      bytes,
      quality: 90,
    );

    final file = File(path);
    await file.writeAsBytes(compressed);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !_cropping,
          child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    centerTitle: true,
                    title: const Text(
          'Crop Aadhaar',
          style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _cropping
                      ? null
                      : () async {
                    final leave = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Discard crop?"),
                        content: const Text(
                          "Your changes will be lost.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Continue Editing"),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Discard"),
                          ),
                        ],
                      ),
                    );

                    if (leave == true && mounted) {
                      Navigator.of(context, rootNavigator: true).pop();                      }
                  },
                ),
                actions: [
          TextButton(
            onPressed: _cropping
                ? null
                : () {
              setState(() => _cropping = true);
              _controller.crop();
            },
            child: _cropping
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              'DONE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
                    ],
              ),
              body:
              Stack(
            children: [
              Crop(
                image: widget.imageData,
                controller: _controller,

                interactive: true,

                baseColor: Colors.black,

                maskColor: Colors.black54,

                aspectRatio: 1.586,

              cornerDotBuilder: (_, __) {
                return Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26,
                      )
                    ],
                  ),
                );
              },

                onCropped: (result) async {
                  switch (result) {
                    case CropSuccess(:final croppedImage):
                      try {
                        final file = await _saveImage(croppedImage);

                        if (!mounted) return;

                        Navigator.pop(context, file);
                        return;
                      } catch (e) {
                        if (!mounted) return;

                        setState(() => _cropping = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to save cropped image."),
                          ),
                        );
                      }
                    case CropFailure():
                      if (!mounted) return;

                      setState(() {
                        _cropping = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            "Unable to crop image. Please try again.",
                          ),
                        ),
                      );
                  }
                },
              ),

              if (_cropping)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Processing image...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),


              bottomNavigationBar: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
          "Move and resize the frame so the entire Aadhaar card is inside.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
                    ),
              ),
            ));
  }
}