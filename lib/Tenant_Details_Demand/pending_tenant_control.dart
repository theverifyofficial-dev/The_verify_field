import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/show_demand_model.dart';

class TenantController extends GetxController {
  var tenantList = <Cat_id>[].obs;
  var searchText = ''.obs;

  var _num = ''.obs;
  var _na = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _num.value = prefs.getString('number') ?? '';
    _na.value = prefs.getString('name') ?? '';
    if (_num.isNotEmpty) {
      fetchTenants(_num.value);
    } else {
      Get.snackbar("Error", "Field worker number not found");
    }
  }

  void fetchTenants(String num) async {
    final url = 'https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$num';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        tenantList.value = data.map((json) => Cat_id.FromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch tenant data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid response format');
    }
  }

  List<Cat_id> get filteredList {
    if (searchText.value.trim().isEmpty) return tenantList;
    final query = searchText.value.toLowerCase();
    return tenantList.where((item) {
      return item.V_name.toLowerCase().contains(query) ||
          item.V_number.replaceAll(" ", "").toLowerCase().contains(query) ||
          item.place.toLowerCase().contains(query) ||
          item.bhk.toLowerCase().contains(query);
    }).toList();
  }
}
