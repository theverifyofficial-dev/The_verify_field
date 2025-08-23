import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/show_demand_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TenantController extends GetxController {
  var tenantList = <Cat_id>[].obs;
  var _num = ''.obs;
  var _na = ''.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _num.value = prefs.getString('number') ?? '';
    _na.value = prefs.getString('name') ?? '';

    // ✅ Only call fetchTenants after _num is loaded
    if (_num.value.isNotEmpty) {
      fetchTenants(_num.value);
    } else {
      Get.snackbar("Error", "Field worker number not founkd");
    }
  }

  void fetchTenants(String num) async {
    final url = 'https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$num';

    final response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        tenantList.value = data
            .map((json) => Cat_id.FromJson(json))
            .toList()
            .reversed
            .toList();

      } else {
        Get.snackbar('Error', 'Failed to fetch tenant data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid response format');
      print("JSON decode error: $e");
    }
  }

  List<Cat_id> get filteredList {
    if (searchText.value.trim().isEmpty) return tenantList;
    final query = searchText.value.toLowerCase();
    return tenantList.where((item) {
      return item.V_name.toLowerCase().contains(query) ||
          item.V_number.replaceAll(" ", "").toLowerCase().contains(query) ||
          item.place.toLowerCase().contains(query) ||
          item.Gadi_Number.toLowerCase().contains(query) ||
          item.Parking.toLowerCase().contains(query) ||
          item.V_number.toLowerCase().contains(query) ||
          item.Family_Members.toLowerCase().contains(query) ||
          item.id.toString().toLowerCase().contains(query) ||
          item.bhk.toLowerCase().contains(query);
    }).toList();
  }

}

