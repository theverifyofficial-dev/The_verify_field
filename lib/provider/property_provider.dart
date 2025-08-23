import 'package:flutter/material.dart';

import '../Future_Property_OwnerDetails_section/New_Update/flat_edit_model.dart';

class PropertyProvider with ChangeNotifier {
  Property1? _property;

  Property1? get property => _property;

  void setProperty(Property1 property) {
    _property = property;
    notifyListeners();
  }
}
