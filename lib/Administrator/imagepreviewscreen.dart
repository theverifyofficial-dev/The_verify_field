import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewScreen({super.key, required this.imageUrl});

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Download failed")),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File(
        "${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg",
      );
      await file.writeAsBytes(response.bodyBytes);

      await Gal.putImage(file.path, album: "VerifyServe");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Saved to Gallery"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, color: Colors.red, size: 120),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text("Download", style: TextStyle(color: Colors.white)),
        onPressed: () => _downloadImage(context),
      ),
    );
  }
}
