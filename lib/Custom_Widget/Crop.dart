import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

// Runs in a background isolate via compute() (mobile/desktop), so the
// UI thread stays free while rotating. flutter_image_compress's `rotate`
// param was removed — it doesn't reliably persist the rotation across
// platforms (notably Flutter Web), which was exactly the "not saved
// after done" symptom. The `image` package is pure Dart, so the
// rotation is baked into the actual pixel data and works everywhere.
class _RotateJob {
  final Uint8List bytes;
  final bool clockwise;
  const _RotateJob(this.bytes, this.clockwise);
}

Uint8List _rotateImageBytes(_RotateJob job) {
  final decoded = img.decodeImage(job.bytes);
  if (decoded == null) return job.bytes;

  final rotated = img.copyRotate(
    decoded,
    angle: job.clockwise ? 90 : -90,
  );

  return Uint8List.fromList(img.encodeJpg(rotated, quality: 92));
}

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
  late CropController _controller;

  late Uint8List _imageData;

  bool _cropping = false;
  bool _rotating = false;

  bool get _busy => _cropping || _rotating;

  @override
  void initState() {
    super.initState();

    _controller = CropController();
    _imageData = widget.imageData;
  }

  Future<void> _rotate(bool clockwise) async {
    if (_busy) return;

    HapticFeedback.selectionClick();
    setState(() => _rotating = true);

    try {
      final rotated = await compute(
        _rotateImageBytes,
        _RotateJob(_imageData, clockwise),
      );

      if (!mounted) return;

      setState(() {
        _imageData = rotated;
        _rotating = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _rotating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't rotate image.")),
        );
      }
    }
  }

  Future<File> _saveImage(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();

    final path =
        '${dir.path}/crop_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressed = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 90,
    );

    final file = File(path);
    await file.writeAsBytes(compressed);

    return file;
  }

  Future<void> _handleDone() async {
    if (_busy) return;

    HapticFeedback.mediumImpact();
    setState(() => _cropping = true);

    try {
      _controller.crop();
    } catch (_) {
      if (mounted) {
        setState(() => _cropping = false);
      }
    }
  }

  Future<void> _handleClose() async {
    if (_busy) return;

    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Discard crop?"),
        content: const Text("Your changes will be lost."),
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
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Image Edit',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _busy ? null : _handleClose,
          ),
          actions: [
            TextButton(
              onPressed: _busy
                  ? null
                  : () => Navigator.of(context).pop(widget.imageFile),
              child: const Text(
                "SKIP",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: _busy ? null : _handleDone,
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
        body: Stack(
          children: [
            // No ValueKey on image change: crop_your_image already
            // reacts to image updates via didUpdateWidget internally,
            // so forcing a full remount here only added extra rebuild
            // cost on every rotate.
            Crop(
              key: ValueKey(_imageData.hashCode),
              image: _imageData,
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
                    } catch (_) {
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

                    setState(() => _cropping = false);

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

            // Unified overlay for both cropping and rotating so the UI
            // gives immediate feedback either way, with a short label
            // telling the user which step is running.
            AnimatedOpacity(
              opacity: _busy ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: IgnorePointer(
                ignoring: !_busy,
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 12),
                        Text(
                          _cropping ? "Processing image..." : "Rotating...",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _busy ? null : () => _rotate(false),
                    icon: const Icon(Icons.rotate_left),
                    label: const Text("Left"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _busy ? null : () => _rotate(true),
                    icon: const Icon(Icons.rotate_right),
                    label: const Text("Right"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}