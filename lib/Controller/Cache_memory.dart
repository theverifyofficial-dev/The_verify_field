import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';


Future<int> getCacheSize() async {
  final dir = await getTemporaryDirectory();
  return _getDirSize(dir);
}

int _getDirSize(Directory dir) {
  int size = 0;

  if (dir.existsSync()) {
    dir.listSync(recursive: true, followLinks: false).forEach((entity) {
      if (entity is File) {
        size += entity.lengthSync();
      }
    });
  }

  return size;
}

Future<bool> checkAndClearCache() async {
  const int maxSize = 100 * 1024 * 1024; // 100MB

  int currentSize = await getCacheSize();

  if (currentSize > maxSize) {
    final dir = await getTemporaryDirectory();
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
      await dir.create();
      return true; // ✅ cache cleared
    }
  }

  return false; // ❌ no need to clear
}


Future<void> checkCacheAndShowToast() async {
  bool cleared = await checkAndClearCache();

  if (cleared) {
    Fluttertoast.showToast(
      msg: "Storage optimized successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}