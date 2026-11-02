// 2026-10-29, Building/Flat insurance-linking feature.
//
// Shared fetch helpers for the two real, already-confirmed GET endpoints
// that return vehicles linked to a Building or a Flat:
//   - https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/show_insurance_base_on_building_id.php?Building_id={id}
//   - https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/show_insurance_base_on_flat_id.php?Flat_id={id}
//
// Response shape assumed identical to every other list endpoint on this
// table (`show_api_fieldworkar_number.php`, confirmed in
// InsuranceShowListPage.dart's fetchInsurance()): {"status": true/false,
// "data": [ ...InsuranceModel rows... ]}. If the backend ships a
// different shape for these two specific endpoints, only this file needs
// updating -- every caller just gets a List<InsuranceModel>.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'InsuranceShowListPage.dart' show insuranceBaseUrl, InsuranceModel;

Future<List<InsuranceModel>> fetchVehiclesForBuilding(String buildingId) async {
  final response = await http.get(
    Uri.parse('${insuranceBaseUrl}show_insurance_base_on_building_id.php?Building_id=$buildingId'),
  );
  return _parseVehicleList(response.body);
}

Future<List<InsuranceModel>> fetchVehiclesForFlat(String flatId) async {
  final response = await http.get(
    Uri.parse('${insuranceBaseUrl}show_insurance_base_on_flat_id.php?Flat_id=$flatId'),
  );
  return _parseVehicleList(response.body);
}

List<InsuranceModel> _parseVehicleList(String body) {
  final decoded = jsonDecode(body);
  if (decoded is Map && decoded['status'] == true && decoded['data'] is List) {
    return (decoded['data'] as List).map((e) => InsuranceModel.fromJson(e)).toList();
  }
  // Defensive fallback: some list endpoints on this backend have returned
  // a bare JSON array instead of the {status, data} envelope -- handle
  // that shape too rather than silently showing an empty state for a
  // response that actually had rows.
  if (decoded is List) {
    return decoded.map((e) => InsuranceModel.fromJson(e)).toList();
  }
  return const [];
}
