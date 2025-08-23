import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/real_Estate_Show_Data_Model.dart';

class RealEstateShowDataProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Property> _properties = [];
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  List<Property> get properties => _properties;
  String get errorMessage => _errorMessage;

  Future<void> fetchProperties() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    const url = 'https://verifyserve.social/PHP_Files/Show_api_in_main_realestate/show_api_in_mainrealestate.php';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final model = RealEstateModel.fromJson(data);
        _properties = model.properties;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load properties. Status: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    }
    catch (e) {
      _errorMessage = 'Error occurred: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProperties() {
    _properties.clear();
    notifyListeners();
  }
}
