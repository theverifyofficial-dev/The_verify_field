// import 'package:shared_preferences/shared_preferences.dart';
//
// class PinService {
//   static const String key = "pinned_demands";
//
//   static Future<Set<String>> getPinned() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(key)?.toSet() ?? {};
//   }
//
//   static Future<void> togglePin(String id) async {
//     final prefs = await SharedPreferences.getInstance();
//     final current = prefs.getStringList(key)?.toSet() ?? {};
//
//     if (current.contains(id)) {
//       current.remove(id);
//     } else {
//       current.add(id);
//     }
//
//     await prefs.setStringList(key, current.toList());
//   }
//
//   static Future<bool> isPinned(String id) async {
//     final prefs = await SharedPreferences.getInstance();
//     final current = prefs.getStringList(key) ?? [];
//     return current.contains(id);
//   }
// }
//
