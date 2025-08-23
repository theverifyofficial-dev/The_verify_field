import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PropertyIdProvider with ChangeNotifier {
  int? _latestPropertyId;
  int? get latestPropertyId => _latestPropertyId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchLatestPropertyId() async {
    _isLoading = true;
    notifyListeners();

    final uri = Uri.parse("https://verifyserve.social/PHP_Files/Main_Realestate/show_only_id.php");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _latestPropertyId = data['latest_P_id'];
        }
      }
    } catch (e) {
      print("Error fetching ID: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
