import 'dart:convert';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Custom_Widget/constant.dart';
import '../../Demand_2/Demand_detail.dart';
import '../../Demand_2/redemand_detailpage.dart';
import '../../utilities/bug_founder_fuction.dart';

enum DemandEditMode {
  add,
  updateDemand,
  updateRedemand,
}

class CustomerDemandFormPage extends StatefulWidget {
  final DemandEditMode mode;
  final String? demandId;     // main demand id
  final String? redemandId;   // redemand id

  const CustomerDemandFormPage({
    super.key,
    required this.mode,
    this.demandId,
    this.redemandId,
  });

  @override
  State<CustomerDemandFormPage> createState() =>
      _CustomerDemandFormPageState();
}

class _CustomerDemandFormPageState extends State<CustomerDemandFormPage> with SingleTickerProviderStateMixin  {

  String? _selectedBudgetLabel;
  bool _showCustomSlider = false;

  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final TextEditingController _furnitureCtrl = TextEditingController();
  final TextEditingController _totalCtrl = TextEditingController();
  bool _fetchingCustomer = false;
  Map<String, dynamic>? _existingCustomer;

  Map<String, dynamic>? _demandData;
  bool _loadingDemand = false;

  String? _buyRent, _reference, _location;
  bool _isSubmitting = false;
  String get _status {
    if (widget.mode == DemandEditMode.add) return "New";
    return _demandData?["Status"] ?? "New";
  }
  bool _isUrgent = false;

  RangeValues _buyBudget = const RangeValues(1000000, 5000000);

  RangeValues _rentBudget = const RangeValues(5000, 20000);

  void _resetBudgetState() {
    _selectedBudgetLabel = null;
    _showCustomSlider = false;

    // Optional: reset ranges to defaults
    _buyBudget = const RangeValues(1000000, 5000000);
    _rentBudget = const RangeValues(5000, 20000);
  }


  String? _parking;
  String? _lift;
  String? _furnished;
  String? _familyStructure;
  String? _familyMember;
  int _adultCount = 1;
  int _childrenCount = 0;
  String? _religion;
  DateTime? _shiftingDate;

  DateTime? _visitingDate;

  final Set<String> _floor = {};
  Map<String, int> _selectedFurniture = {}; // e.g., {'Sofa': 2, 'Bed': 1}

  final List<String> _buyRentOptions = ["Buy", "Rent"];
  final List<String> _referenceOptions = ["99 Acres", "Housing", "Instagram", "Youtube","facebook","Website","Other"];
  final List<String> _locationOptions = [
    "Sultanpur", "Chhattarpur", "Rajpur Khurd", "Aya Nagar", "Ghitorni"];

  final List<String> _floorOptions = [
    "Ground",
    "Upper Ground",
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Top"
  ];

  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _totalCtrl.text = (_adultCount + _childrenCount).toString();

    // 🔥 LOAD DATA FOR UPDATE MODE
    if (widget.mode != DemandEditMode.add) {
      _loadDemandForEdit();
    }

    print(" redemand id from add page : ${widget.redemandId}");

  }

  void _updateFamilyTotal() {
    final total = _adultCount + _childrenCount;
    _totalCtrl.text = total.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _messageCtrl.dispose();
    _furnitureCtrl.dispose(); // 🔥 ADD THIS
    super.dispose();
  }

  bool get _canSubmitRedemand {
    if (_existingCustomer == null) return true;

    final fwName = _existingCustomer?["assigned_fieldworker_name"];

    // can submit only if fieldworker is assigned
    return fwName != null && fwName.toString().trim().isNotEmpty;
  }

  Widget _redemandBlockedBanner() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.red.withOpacity(0.12),
        border: Border.all(
          color: Colors.red.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.block_rounded,
            color: Colors.red.shade700,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Redemand Not Allowed Yet",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "You can add a new demand only after the previous demand is assigned to Fieldworker.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _extractLast10Digits(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 10) {
      return digitsOnly.substring(digitsOnly.length - 10);
    }
    return "";
  }

  Future<void> _loadDemandForEdit() async {
    setState(() => _loadingDemand = true);

    try {
      if (widget.mode == DemandEditMode.updateDemand) {
        await _fetchMainDemand();
      } else {
        await _fetchRedemand();
      }

      if (_demandData != null) {
        _autofillFromExistingCustomer(_demandData!);
      }
    } finally {
      if (mounted) setState(() => _loadingDemand = false);
    }
  }

  Future<Response> _updateDemandDispatcher(Map<String, dynamic> payload) {
    if (widget.mode == DemandEditMode.updateDemand) {
      return _updateMainDemand(payload);
    } else {
      return _updateRedemand(payload);
    }
  }

  Future<void> _fetchMainDemand() async {
    final res = await http.get(Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
    ));

    if (res.statusCode == 200) {
      final jsonRes = jsonDecode(res.body);
      if (jsonRes["success"] == true &&
          jsonRes["data"] is List &&
          jsonRes["data"].isNotEmpty) {
        _demandData = Map<String, dynamic>.from(jsonRes["data"][0]);
      }
    }
  }

  Future<void> _fetchRedemand() async {
    print(" redemand id from add page : ${widget.redemandId}");
    final res = await http.get(Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}",
    ));

    if (res.statusCode == 200) {
      final jsonRes = jsonDecode(res.body);
      if (jsonRes["success"] == true &&
          jsonRes["data"] is List &&
          jsonRes["data"].isNotEmpty) {
        _demandData = Map<String, dynamic>.from(jsonRes["data"][0]);
      }
    }
  }

  Future<Response> _updateMainDemand(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_tenant_demand_api_for_admin.php",
        data: FormData.fromMap(payload),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return res;
    } on DioException catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_tenant_demand_api_for_admin.php",
        error: e.response?.data.toString() ?? e.message ?? "Unknown error",
        statusCode: e.response?.statusCode ?? 0,
      );
      rethrow;
    }
  }

  Future<Response> _updateRedemand(Map<String, dynamic> payload) async {
    try {
      final res = await _dio.post(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_redemand_option.php",
        data: FormData.fromMap(payload),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return res;
    } on DioException catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_redemand_option.php",
        error: e.response?.data.toString() ?? e.message ?? "Unknown error",
        statusCode: e.response?.statusCode ?? 0,
      );
      rethrow;
    }
  }

  String extractCreatedDate(dynamic value) {
    if (value == null) return "--";

    try {
      if (value is Map && value["date"] != null) {
        return formatDate(value["date"]);
      }

      return formatDate(value.toString());
    } catch (_) {
      return "--";
    }
  }

  Future<void> _fetchCustomerByPhone(String phone) async {
    if (phone.length != 10) return;

    if (widget.mode != DemandEditMode.add) return;

    setState(() => _fetchingCustomer = true);

    try {
      final res = await _dio.get(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/fecth_tenant_number.php?Tnumber=$phone",
      );

      if (res.statusCode == 200 && res.data["success"] == true) {
        final List list = res.data["data"];
        if (list.isEmpty) return;

        final data = list.first;

        setState(() {
          _existingCustomer = data;
          _autofillFromExistingCustomer(data);
        });
      }
    } catch (_) {
     } finally {
      if (mounted) setState(() => _fetchingCustomer = false);
    }
  }

  String? safeString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    if (str.isEmpty || str == "--" || str.toLowerCase() == "null") {
      return null;
    }
    return str;
  }

  int safeInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  double? safeDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  void _autofillFromExistingCustomer(Map<String, dynamic> data) {

    final name = safeString(data["Tname"]);
    final number = safeString(data["Tnumber"]);
    final message = safeString(data["Message"]);

    // NAME / NUMBER
    if (_nameCtrl.text.isEmpty && name != null) {
      _nameCtrl.text = name;
    }

    if (_numberCtrl.text.isEmpty && number != null) {
      _numberCtrl.text = number;
    }

    if (_messageCtrl.text.isEmpty && message != null) {
      _messageCtrl.text = message;
    }

    // URGENT
    final mark = safeString(data["mark"]);
    if (mark != null) {
      _isUrgent = mark == "1";
    }

    // BUY / RENT
    final buyRent = safeString(data["Buy_rent"]);
    if (_buyRent == null && buyRent != null) {
      _buyRent = buyRent;
    }

    // LOCATION
    final location = safeString(data["Location"]);
    if (_location == null && location != null) {
      _location = location;
    }

    // REFERENCE
    final reference = safeString(data["Reference"]);
    if (_reference == null && reference != null) {
      _reference = reference;
    }

    // BHK
    final bhkRaw = safeString(data["Bhk"]);
    if (_selectedBhks.isEmpty && bhkRaw != null) {
      _selectedBhks.clear();
      _selectedBhks.addAll(
        bhkRaw.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty),
      );
    }

    // SIMPLE FIELDS
    _parking ??= safeString(data["parking"]);
    _lift ??= safeString(data["lift"]);
    _furnished ??= safeString(data["furnished_unfurnished"]);
    _familyStructure ??= safeString(data["family_structur"]);
    _familyMember ??= safeString(data["family_member"]);
    _religion ??= safeString(data["religion"]);

    // FLOOR
    final floorRaw = safeString(data["floor"]);
    if (floorRaw != null) {
      _floor.clear();
      _floor.addAll(
        floorRaw.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty),
      );
    }

    // COUNT (A-C format)
    final countRaw = safeString(data["count_of_person"]);
    if (countRaw != null && countRaw.contains("-")) {
      final parts = countRaw.split("-");
      _adultCount = safeInt(parts[0].replaceAll("A", ""), defaultValue: 1);
      _childrenCount = safeInt(parts[1].replaceAll("C", ""), defaultValue: 0);
      _updateFamilyTotal(); // keep UI in sync
    }

    // DATES
    final shiftingRaw = safeString(data["shifting_date"]);
    if (shiftingRaw != null) {
      _shiftingDate = DateTime.tryParse(shiftingRaw);
    }

    final visitingRaw = safeString(data["visiting_dates"]);
    if (visitingRaw != null) {
      _visitingDate = DateTime.tryParse(visitingRaw);
    }

    // FURNITURE (SAFE JSON)
    final furnitureRaw = safeString(data["furnished_item"]);
    if (furnitureRaw != null) {
      try {
        final decoded = jsonDecode(furnitureRaw);
        if (decoded is Map<String, dynamic>) {
          _selectedFurniture = Map<String, int>.from(decoded);
          _furnitureCtrl.text = _selectedFurniture.entries
              .map((e) => "${e.key} (${e.value})")
              .join(", ");
        }
      } catch (_) {
        _selectedFurniture = {};
        _furnitureCtrl.clear();
      }
    }

    // PRICE
    final priceRaw = safeString(data["Price"]);
    if (priceRaw != null && priceRaw.contains("-")) {
      final parts = priceRaw.split("-");

      final start = safeDouble(parts[0]);
      final end = safeDouble(parts[1]);

      if (start != null && end != null) {
        if (_buyRent == "Buy") {
          _buyBudget = RangeValues(start, end);
        } else {
          _rentBudget = RangeValues(start, end);
        }

        _selectedBudgetLabel = "Custom Range";
        _showCustomSlider = true;
      }
    }

    if (mounted) setState(() {});
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);


    final prefs = await SharedPreferences.getInstance();
    final AName = prefs.getString('name') ?? "";
    print(AName);


    final now = DateTime.now();
    final isBuy = _buyRent == "Buy";

    final String? updateId = widget.mode == DemandEditMode.updateDemand
        ? widget.demandId
        : widget.redemandId;

    if (widget.mode != DemandEditMode.add && updateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Invalid demand ID. Please reopen the page."),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    if (_buyRent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select Buy/Rent")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    if (_selectedBudgetLabel == null && !_showCustomSlider) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select Budget")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    Map<String, dynamic> formData;

    final basePayload = {
      "Tname": _nameCtrl.text.trim(),
      "Tnumber": _numberCtrl.text.trim(),

      "Price": _buyRent == null
          ? ""
          : _buyRent == "Buy"
          ? "${_buyBudget.start.toInt()}-${_buyBudget.end.toInt()}"
          : "${_rentBudget.start.toInt()}-${_rentBudget.end.toInt()}",

      "Bhk": _selectedBhks.isEmpty ? "" : _selectedBhks.join(", "),
      "Location": _location ?? "",
      "Buy_rent": _buyRent ?? "",
      "Reference": _reference ?? "",
      "Message": _messageCtrl.text.trim(),

      "mark": _isUrgent ? "1" : "0",
      "admin_name": AName,

      // 🔥 NEW FIELDS (IMPORTANT)
      "parking": _parking ?? "",
      "lift": _lift ?? "",
      "furnished_unfurnished": _furnished ?? "",
      "family_structur": _familyStructure ?? "",
      "family_member": _familyMember ?? "",
      "count_of_person": "${_adultCount}A-${_childrenCount}C",
      "religion": _religion ?? "",
      "shifting_date": _shiftingDate != null
          ? DateFormat("yyyy-MM-dd").format(_shiftingDate!)
          : "",
      "visiting_dates": _visitingDate != null
          ? DateFormat("yyyy-MM-dd").format(_visitingDate!)
          : "",
      "floor": _floor.isNotEmpty ? _floor.join(',') : "",
      "furnished_item": _selectedFurniture.isNotEmpty
          ? jsonEncode(_selectedFurniture)
          : "--",
    };


    if (widget.mode == DemandEditMode.add) {
      formData = {
        ...basePayload,
        "Status": "New",
        "created_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "Result": "",
        "by_field": "false",
      };
    }
    else {
      formData = {
        ...basePayload,
        "id": widget.mode == DemandEditMode.updateDemand
            ? widget.demandId
            : widget.redemandId,
      };
    }

    AppLogger.api("MODE: ${widget.mode}");
    AppLogger.api("DEMAND ID: ${widget.demandId}");
    AppLogger.api("REDEMAND ID: ${widget.redemandId}");
    AppLogger.api("FINAL PAYLOAD: $formData");

    try {

      Response? res;

      if (widget.mode == DemandEditMode.add) {
        res = await _dio.post(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
          data: jsonEncode(formData),
          options: Options(headers: {"Content-Type": "application/json"}),
        );
      } else {
        formData["id"] = widget.mode == DemandEditMode.updateDemand
            ? widget.demandId
            : widget.redemandId;

        res = await _updateDemandDispatcher(formData);
      }

// 🔐 SAFETY CHECK
      if (res == null) {
        throw Exception("Update API returned null response");
      }

      print('printing response ${res.data}');

      if (res.statusCode == 200) {
        final data = res.data;

        print(data);
        final msg = data["message"] ?? data["msg"] ?? "Something went wrong";


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(msg),
          ),
        );

        Navigator.pop(context);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(res.data["message"] ?? "Failed to Add Demand"),
          ),
        );

        await BugLogger.log(
          apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
          error: res.data.toString(),
          statusCode: res.statusCode ?? 0,
        );

      }
    } on DioException catch (e) {

      print("🔥 FULL ERROR RESPONSE:");
      print(e.response?.data);
      print("🔥 STATUS CODE: ${e.response?.statusCode}");
      print("🔥 HEADERS: ${e.response?.headers}");

      String errorMessage = "Something went wrong";

      if (e.response != null) {
        final status = e.response?.statusCode;
        final data = e.response?.data;

        // ✅ HANDLE STRING RESPONSE (MOST IMPORTANT)
        if (data is String && data.isNotEmpty) {
          errorMessage = data;
        }

        // ✅ HANDLE JSON RESPONSE
        else if (data is Map && data["message"] != null) {
          errorMessage = data["message"];
        }

        else {
          errorMessage = "Server error ($status)";
        }

        await BugLogger.log(
          apiLink: "REDemand API",
          error: data.toString(),
          statusCode: status ?? 0,
        );
      } else {
        errorMessage = "Network error";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(errorMessage),
        ),
      );
    }
    finally {
      setState(() => _isSubmitting = false);
    }
  }

  // 🎨 Input decoration
  InputDecoration _modernInput(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),

      filled: true,
      fillColor: const Color(0xFFF1F3F6),

      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  final List<String> _bhkOptions = [
    "1 RK",
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK",
    "Commercial",
    "Plot",
  ];

  final Set<String> _selectedBhks = {};

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),

        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4F46E5),
          secondary: Color(0xFF6366F1),
        ),

        cardColor: Colors.white,

        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      child: Scaffold(

        appBar: AppBar(
          surfaceTintColor: Colors.black,
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,

          title: Image.asset(AppImages.verify, height: 70),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              PhosphorIcons.caret_left_bold,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),

        body: _loadingDemand
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add New Demand",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Register a specific real estate requirement for fieldworkers.",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mark as Urgent",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text("Prioritize this demand",
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isUrgent,
                        onChanged: (v) => setState(() => _isUrgent = v),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                if (_existingCustomer != null) ...[
                  _ExistingCustomerCard(
                    data: _existingCustomer!,
                    isDark: false,
                  ),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Basic Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _numberCtrl,
                        decoration: _modernInput("Customer Number", Icons.phone),
                        keyboardType: TextInputType.phone,
                        maxLength: 12,
                        onChanged: (value) {
                          final last10 = _extractLast10Digits(value);
                          if (last10.length == 10 && !_fetchingCustomer) {
                            _fetchCustomerByPhone(last10);
                          }
                        },
                        validator: (value) {
                          final last10 = _extractLast10Digits(value ?? "");
                          return last10.length != 10 ? "Invalid number" : null;
                        },
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _nameCtrl,
                        decoration: _modernInput("Customer Name", Icons.person),
                        validator: (v) =>
                        v == null || v.trim().isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _buyRent,
                        decoration: _modernInput("Buy/Rent", Icons.currency_rupee),

                        items: _buyRentOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _buyRent = v;
                            _resetBudgetState();
                          });
                        },
                        validator: (v) => v == null ? "Select type" : null,
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _location,
                        decoration: _modernInput("e.g. Sultanpur", Icons.location_on_sharp),



                        items: _locationOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _location = v),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _reference,
                        decoration: _modernInput("e.g. 99 Acres", Icons.source),
                        items: _referenceOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _reference = v),
                      ),
                      // 👉 move all basic fields here
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                  _buyRent != null ?
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Property Preferences",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                        const SizedBox(height: 16),

                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                budgetDropdown(type: _buyRent!, theme: Theme.of(context)),

                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 8,
                                  children: _bhkOptions.map((e) {
                                    final selected = _selectedBhks.contains(e);
                                    return ChoiceChip(
                                      label: Text(e),
                                      selected: selected,
                                      selectedColor:  const Color(0xFFDC2626),
                                      onSelected: (val) {
                                        setState(() {
                                          val
                                              ? _selectedBhks.add(e)
                                              : _selectedBhks.remove(e);
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Additional Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _furnished,
                        decoration: _modernInput("Furnishing Requirement", Icons.chair),
                        items: furnishingOptions
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _furnished = v;
                            if (v == "Unfurnished") _selectedFurniture.clear();
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      if (_furnished == "Fully Furnished" ||
                          _furnished == "Semi Furnished")
                        GestureDetector(
                          onTap: () => _showFurnitureBottomSheet(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _furnitureCtrl,
                              readOnly: true,
                              decoration: _modernInput("e.g. Fan", Icons.chair).copyWith(
                                hintText: "Tap to select furniture",
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_selectedFurniture.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            _selectedFurniture.clear();
                                            _furnitureCtrl.clear();
                                          });
                                        },
                                      ),
                                    const Icon(Icons.keyboard_arrow_down),
                                  ],
                                ),                              ),
                              onTap: () => _showFurnitureBottomSheet(context),
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _familyStructure,
                        decoration: _modernInput("Family Type", Icons.family_restroom),
                        items: ["Joint", "Nuclear", "Bachelor", "Live-In relation"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _familyStructure = v),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          /// 👨 Adults
                          Expanded(
                            child: TextFormField(
                              decoration: _modernInput("Adults", Icons.person),
                              keyboardType: TextInputType.number,
                              initialValue: _adultCount.toString(),
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              onChanged: (v) {
                                _adultCount = int.tryParse(v) ?? 0;
                                _updateFamilyTotal();
                              },
                            ),
                          ),

                          /// ➕ PLUS SIGN
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "+",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),

                          /// 👶 Children
                          Expanded(
                            child: TextFormField(
                              decoration: _modernInput("Child", Icons.child_care),
                              keyboardType: TextInputType.number,
                              initialValue: _childrenCount.toString(),
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                              onChanged: (v) {
                                _childrenCount = int.tryParse(v) ?? 0;
                                _updateFamilyTotal();
                              },
                            ),
                          ),

                          /// ➡️ EQUAL SIGN
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "=",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),

                          /// 👥 TOTAL
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _totalCtrl.text.isEmpty ? "0" : _totalCtrl.text,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _religion,
                        decoration: _modernInput("e.g. Hindu", Icons.temple_hindu),
                        items: ["Hindu", "Muslim", "Sikh", "Christian", "Other"]
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _religion = v),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _parking,
                        decoration: _modernInput("Parking", Icons.local_parking),
                        items: ["Car", "Bike", "Both", "None"]
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _parking = v),
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _lift,
                        decoration: _modernInput("Lift", Icons.elevator),
                        items: ["Yes", "No"]
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _lift = v),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        children: _floorOptions.map((e) {
                          final selected = _floor.contains(e);
                          return ChoiceChip(
                            label: Text(e),

                            selected: selected,
                            selectedColor: Color(0xFFDC2626),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            onSelected: (val) {
                              setState(() {
                                val ? _floor.add(e) : _floor.remove(e);
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      ListTile(
                        title: Text(_shiftingDate == null
                            ? "Select Shifting Date"
                            : DateFormat("yyyy-MM-dd").format(_shiftingDate!)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2040),
                          );
                          if (picked != null) {
                            setState(() => _shiftingDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      ListTile(
                        title: Text(_visitingDate == null
                            ? "Select Visiting Date"
                            : DateFormat("yyyy-MM-dd").format(_visitingDate!)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2040),
                          );
                          if (picked != null) {
                            setState(() => _visitingDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _messageCtrl,
                  maxLines: 3,
                  decoration: _modernInput(
                    "Describe the specific needs...",
                    Icons.notes,
                  ),
                ),

                const SizedBox(height: 20),

                if (_existingCustomer != null && !_canSubmitRedemand)
                  _redemandBlockedBanner(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_isSubmitting || !_canSubmitRedemand)
                        ? null
                        : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _submitButtonColor(Theme.of(context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_submitButtonText,style: TextStyle(color: Colors.white),),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _submitButtonText {
    if (_isSubmitting) return "Submitting...";
    if (!_canSubmitRedemand) return "Waiting for Assign";
    if (widget.mode == DemandEditMode.add) return "Submit Demand";
    if (widget.mode == DemandEditMode.updateDemand) return "Update Demand";
    return "Update Redemand";  }

  Color _submitButtonColor(ThemeData theme) {
    if (_isSubmitting) return Colors.grey.shade600;;

    if (!_canSubmitRedemand) {
      return Colors.red.shade600; // warning state
    }
    return const Color(0xFFDC2626);
  }

  Widget _optionBox(String label, String? value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value ?? label,
              style: TextStyle(
                fontSize: 15,
                color: value == null
                    ? theme.hintColor
                    : theme.colorScheme.onSurface,
              )),
          Icon(Icons.keyboard_arrow_down, color: theme.iconTheme.color),
        ],
      ),
    );
  }

  void _showSelectBottomSheet({
    required String title,
    required List<String> items,
    required Function(String) onSelect,
  })
  {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...items.map((e) => ListTile(
              title: Text(e),
              onTap: () {
                Navigator.pop(ctx);
                onSelect(e);
              },
            )),
          ],
        ),
      ),
    );
  }

  Widget budgetDropdown({
    required String type, // Buy / Rent
    required ThemeData theme,
  }) {
    final presets = type == "Buy" ? buyBudgetPresets : rentBudgetPresets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == "Buy" ? "Budget Range" : "Monthly Rent Budget",
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black
          ),
        ),
        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          value: _selectedBudgetLabel,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text("Select budget range"),
          items: presets.map((p) {
            final label = p.keys.first;
            return DropdownMenuItem(
              value: label,
              child: Text(label),
            );
          }).toList(),
          onChanged: (label) {
            setState(() {
              _selectedBudgetLabel = label;
              final range =
                  presets.firstWhere((p) => p.keys.first == label).values.first;

              if (label == "Custom Range") {
                _showCustomSlider = true;
              } else {
                _showCustomSlider = false;
                if (type == "Buy") {
                  _buyBudget = range;
                } else {
                  _rentBudget = range;
                }
              }
            });
          },
        ),

        if (_showCustomSlider) ...[
          const SizedBox(height: 12),
          BudgetSelector(
            type: type,
            buyBudget: _buyBudget,
            rentBudget: _rentBudget,
            onBuyChange: (v) => setState(() => _buyBudget = v),
            onRentChange: (v) => setState(() => _rentBudget = v),
          ),
        ],
      ],
    );
  }

  Widget dropdownField({
    required String title,
    required String? value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: _optionBox(title, value),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _showFurnitureBottomSheet(BuildContext context) {
    final List<String> furnitureItems = [
      'Refrigerator',
      'Washing Machine',
      'Wardrobe',
      'AC',
      'Water Purifier',
      'Single Bed',
      'Double Bed',
      'Geyser',
      'LED TV',
      'Sofa Set',
      'Induction',
      'Gas Stove',
    ];

    final Map<String, int> tempSelection = Map.from(_selectedFurniture);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Select Furniture",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                            ),
                          ),
                        ),
                        TextButton(

                          onPressed: () {
                            setState(() {
                              _selectedFurniture = Map.fromEntries(
                                tempSelection.entries.where((e) => e.value > 0),
                              );

                              _furnitureCtrl.text = _selectedFurniture.isEmpty
                                  ? ""
                                  : _selectedFurniture.entries
                                  .map((e) => "${e.key} (${e.value})")
                                  .join(", ");
                            });

                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            "SAVE",
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                          ),
                        )
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  /// 🔥 GRID STYLE (BETTER THAN LIST)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: furnitureItems.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final item = furnitureItems[index];
                          final isSelected = tempSelection.containsKey(item);
                          final count = tempSelection[item] ?? 0;

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  tempSelection.remove(item);
                                } else {
                                  tempSelection[item] = 1;
                                }
                              });
                            },

                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                ),
                                color: isSelected
                                    ? Colors.black.withOpacity(0.05)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),

                                  /// 🔥 COUNTER
                                  if (isSelected)
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              if (count > 1) {
                                                tempSelection[item] = count - 1;
                                              }
                                            });
                                          },
                                          child: const Icon(Icons.remove, size: 18,color: Colors.black,),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 6),
                                          child: Text(
                                            "$count",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,color: Colors.black,),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              tempSelection[item] = count + 1;
                                            });
                                          },
                                          child: const Icon(Icons.add, size: 18,color: Colors.black,),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}

class BudgetSelector extends StatelessWidget {
  final String type;
  final RangeValues buyBudget;
  final RangeValues rentBudget;
  final Function(RangeValues) onBuyChange;
  final Function(RangeValues) onRentChange;

  const BudgetSelector({
    super.key,
    required this.type,
    required this.buyBudget,
    required this.rentBudget,
    required this.onBuyChange,
    required this.onRentChange,
  });

  String _formatAmount(num n) {
    if (n >= 10000000) return "₹${(n / 10000000).toStringAsFixed(1)}Cr";
    if (n >= 100000) return "₹${(n / 100000).toStringAsFixed(1)}L";
    if (n >= 1000) return "₹${(n / 1000).toStringAsFixed(0)}k";
    return "₹${n.toInt()}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isBuy = type == "Buy";

    final presets = isBuy
        ? [
      const RangeValues(2000000, 4000000),
      const RangeValues(4000000, 8000000),
      const RangeValues(8000000, 12000000),
    ]
        : [
      const RangeValues(8000, 12000),
      const RangeValues(12000, 20000),
      const RangeValues(20000, 30000),
    ];

    final current = isBuy ? buyBudget : rentBudget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
             Colors.grey.withOpacity(0.15),
             Colors.grey.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            isBuy ? "Buy Budget" : "Monthly Rent Budget",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),

          // LIVE DISPLAY
          Text(
            isBuy
                ? "${_formatAmount(current.start)} – ${_formatAmount(current.end)}"
                : "₹${current.start.toInt()} – ₹${current.end.toInt()} / month",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // PRESET CHIPS
          Wrap(
            spacing: 8,
            children: presets.map((r) {
              final label = isBuy
                  ? "${_formatAmount(r.start)} - ${_formatAmount(r.end)}"
                  : "₹${r.start.toInt()} - ₹${r.end.toInt()}";

              return ChoiceChip(
                label: Text(label),
                selected: false,
                selectedColor: const Color(0xFFDC2626),

                onSelected: (_) =>
                isBuy ? onBuyChange(r) : onRentChange(r),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // RANGE SLIDER
          RangeSlider(
            inactiveColor:  Colors.grey,
            activeColor: const Color(0xFFDC2626),
            values: current,
            min: isBuy ? 500000 : 5000,
            max: isBuy ? 20000000 : 100000,
            divisions: isBuy ? 40 : 19,
            labels: isBuy
                ? RangeLabels(
              _formatAmount(current.start),
              _formatAmount(current.end),
            )
                : RangeLabels(
              "₹${current.start.toInt()}",
              "₹${current.end.toInt()}",
            ),
            onChanged: (r) =>
            isBuy ? onBuyChange(r) : onRentChange(r),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, RangeValues>> buyBudgetPresets = [
  {"₹20L – ₹40L": const RangeValues(2000000, 4000000)},
  {"₹40L – ₹80L": const RangeValues(4000000, 8000000)},
  {"₹80L – ₹1.2Cr": const RangeValues(8000000, 12000000)},
  {"₹1.2Cr – ₹2Cr": const RangeValues(12000000, 20000000)},
  {"Custom Range": const RangeValues(0, 0)},
];

final List<Map<String, RangeValues>> rentBudgetPresets = [
  {"₹8k – ₹12k": const RangeValues(8000, 12000)},
  {"₹12k – ₹20k": const RangeValues(12000, 20000)},
  {"₹20k – ₹30k": const RangeValues(20000, 30000)},
  {"₹30k+": const RangeValues(30000, 60000)},
  {"Custom Range": const RangeValues(0, 0)},
];

String formatDate(String date) {
  final parsedDate = DateTime.parse(date);
  return DateFormat('d MMMM yyyy').format(parsedDate);
}

class _ExistingCustomerCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const _ExistingCustomerCard({
    required this.data,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = Colors.red;

    Widget row(String label, dynamic value) {
      if (value == null || value.toString().trim().isEmpty) {
        return const SizedBox.shrink(); // 🔥 hide row completely
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                "$label:",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.hintColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }


    final name = (data["Tname"] ?? "").toString().trim();

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DemandDetail(
              demandId: data["id"].toString(),
              isReadOnly: true, // 🔥 THIS IS THE KEY
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          /// 🔥 RED BORDER ACCENT
          border: Border.all(
            color: const Color(0xFFDC2626).withOpacity(0.25),
          ),

          /// 🔥 SUBTLE RED SHADOW
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: accent.withOpacity(0.9),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["Tname"] ?? "--",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        data["Tnumber"] ?? "--",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.hintColor,
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: accent.withOpacity(0.85),
                  ),
                  child: Text(
                    data["Status"],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
            "Date: ${safeDate(data["Date"] ?? data["created_date"])}",
      style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                "Time: ${data["Time"] ?? "--"}",                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),

            Divider(color: Colors.grey.withOpacity(0.25)),
            const SizedBox(height: 6),

            row("Type", data["Buy_rent"]),
            row("Budget", data["Price"] != null ? "₹ ${data["Price"]}" : null),
            row("BHK", data["Bhk"]),
            row("Location", data["Location"]),
            row("Shifting Date", formatDate(data["shifting_date"])),

            const SizedBox(height: 8),
            Divider(color: Colors.grey.withOpacity(0.22)),
            const SizedBox(height: 6),

            row("Fieldworker", data["assigned_fieldworker_name"]),
            row("FW Location", data["assigned_fieldworker_location"]),

            const SizedBox(height: 6),



            /// 🔥 FINAL REASON
            _summaryItem(
              title: "Final Reason",
              value: data["final_reason"] ?? "-",
              highlight: true,
            ),

            const SizedBox(height: 6),


            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Click to Open detail page >",
                  style: const TextStyle(color: Colors.grey,fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem({
    required String title,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFDC2626).withOpacity(0.05)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? const Color(0xFFDC2626).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: highlight
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  String safeDate(dynamic value) {
    if (value == null) return "--";

    try {
      return formatDate(value.toString());
    } catch (_) {
      return "--";
    }
  }
}
