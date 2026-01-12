import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import '../model/show_demand_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantController extends GetxController {
  var tenantList = <Cat_id>[].obs;

  var _num = ''.obs;
  String get number => _num.value; // 👈 Public getter

  var _na = ''.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print("🔄 TenantController onInit called");
    _loadUserData();
  }

  void _loadUserData() async {
    print("📥 Loading user data from SharedPreferences...");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedNum = prefs.getString('number');
    String? savedName = prefs.getString('name');

    print("✅ SharedPreferences (raw) number: $savedNum, name: $savedName");

    _num.value = savedNum ?? '';
    _na.value = savedName ?? '';

    print("📌 Controller _num set to: ${_num.value}");
    print("📌 Controller _na set to: ${_na.value}");

    // ✅ Only call fetchTenants after _num is loaded
    if (_num.value.isNotEmpty) {
      print("🚀 Fetching tenants for number: ${_num.value}");
      fetchTenants(_num.value);
    } else {
      print("❌ No number found in SharedPreferences");
      Get.snackbar("Error", "Field worker number not found");
    }
  }

  Future<void> fetchTenants(String num) async {
    final url =
        'https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$num';

    print("🌐 API request to: $url");

    try {
      final response = await http.get(Uri.parse(url));

      print("📡 Response status: ${response.statusCode}");
      print("📡 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        print("✅ Decoded JSON length: ${data.length}");

        tenantList.value = data
            .map((json) => Cat_id.FromJson(json))
            .toList()
            .reversed
            .toList();

        print("📊 tenantList updated. Count: ${tenantList.length}");
      } else {
        await BugLogger.log(
            apiLink: "https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$num",
            error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
        );
        print("❌ Failed with status code: ${response.statusCode}");
        Get.snackbar('Error', 'Failed to fetch tenant data');
      }
    } catch (e) {
      await BugLogger.log(apiLink: "https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$num",
          error: e.toString(),
          statusCode: 500,
      );
      print("🔥 JSON decode error or API failure: $e");
      Get.snackbar('Error', 'Invalid response format');
    }
  }

  List<Cat_id> get filteredList {
    if (searchText.value.trim().isEmpty) return tenantList;

    final query = searchText.value.toLowerCase();
    print("🔎 Filtering tenants with query: $query");

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
