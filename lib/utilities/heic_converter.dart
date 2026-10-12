import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Centralized HEIC/HEIF handling for every image-picker call in the app.
///
/// iPhones capture photos as `.heic`/`.heif` by default. Many screens in
/// this app read the picked file's path directly, or feed it into
/// compression/cropping that may not reliably decode HEIC on every device --
/// which can silently drop the image or upload a file the backend/other
/// viewers can't render. [pickImage] and [pickMultiImage] below are drop-in
/// replacements for `ImagePicker.pickImage` / `ImagePicker.pickMultiImage`:
/// same arguments, same return type, but a HEIC/HEIF result is converted to
/// a real JPG file on disk *before* it is returned, so every existing call
/// site downstream (compression, cropping, upload) keeps working exactly as
/// it already does today and never sees a `.heic` path.
///
/// A non-HEIC pick (the overwhelming majority -- Android, or an iPhone set
/// to "Most Compatible" capture format) is returned completely unchanged.
class HeicConverter {
  HeicConverter._();

  static bool _isHeic(String path) {
    final ext = p.extension(path).toLowerCase();
    return ext == '.heic' || ext == '.heif';
  }

  /// Converts [file] to a JPG file if it is HEIC/HEIF; otherwise returns it
  /// unchanged. Safe to call on any picked/attached image before it is
  /// displayed, compressed, cropped, or uploaded.
  static Future<XFile> resolve(XFile file) async {
    if (!_isHeic(file.path)) return file;
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = p.join(
        dir.path,
        'heic_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        format: CompressFormat.jpeg,
        quality: 95,
      );
      if (result != null) {
        return XFile(result.path);
      }
    } catch (e) {
      // ignore: avoid_print
      print('HeicConverter: failed to convert HEIC image, using original: $e');
    }
    // Conversion failed for some reason -- fall back to the original file
    // rather than blocking the pick entirely.
    return file;
  }

  /// Converts [file] to a JPG file if it is HEIC/HEIF; otherwise returns it
  /// unchanged, as a plain [File] (for call sites that already hold a
  /// `dart:io` File rather than an [XFile] -- e.g. a drag-dropped/attached
  /// file, not one that came from [ImagePicker]).
  static Future<File> resolveFile(File file) async {
    final XFile resolved = await resolve(XFile(file.path));
    return File(resolved.path);
  }

  /// Drop-in replacement for `ImagePicker.pickImage` that converts a
  /// HEIC/HEIF result to JPG before returning it.
  static Future<XFile?> pickImage(
    ImagePicker picker, {
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final XFile? picked = await picker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (picked == null) return null;
    return resolve(picked);
  }

  /// Drop-in replacement for `ImagePicker.pickMultiImage` that converts any
  /// HEIC/HEIF results to JPG before returning them.
  static Future<List<XFile>> pickMultiImage(
    ImagePicker picker, {
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final List<XFile> picked = await picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (picked.isEmpty) return picked;
    final List<XFile> resolved = [];
    for (final f in picked) {
      resolved.add(await resolve(f));
    }
    return resolved;
  }
}
