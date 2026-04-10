import 'dart:convert';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Demand_2/redemand_detailpage.dart';
import '../../Custom_Widget/constant.dart';
import '../../utilities/bug_founder_fuction.dart';
import 'Demand_detail.dart';

enum DemandEditMode {
  add,
  updateDemand,
  updateRedemand,
}

class AddDemandField extends StatefulWidget {
  final DemandEditMode mode;
  final String? demandId;     // main demand id
  final String? redemandId;   // redemand id

  const AddDemandField({
    super.key,
    required this.mode,
    this.demandId,
    this.redemandId,
  });

  @override
  State<AddDemandField> createState() =>
      _AddDemandFieldPageState();
}

class _AddDemandFieldPageState extends State<AddDemandField> with SingleTickerProviderStateMixin  {

  String? _selectedBudgetLabel;
  bool _showCustomSlider = false;

  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final TextEditingController _furnitureCtrl = TextEditingController();
  final TextEditingController _totalCtrl = TextEditingController();


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
    // 🔥 LOAD DATA FOR UPDATE MODE
    if (widget.mode != DemandEditMode.add) {
      _loadDemandForEdit();
    }

    _totalCtrl.text = (_adultCount + _childrenCount).toString();


    AppLogger.api(" redemand id from add page : ${widget.redemandId}");

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
    _totalCtrl.dispose();
    super.dispose();
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
    } finally {
      if (mounted) setState(() => _loadingDemand = false);
    }
  }

  Future<Response> _updateDemandDispatcher(FormData formData) {
    if (widget.mode == DemandEditMode.updateDemand) {
      return _updateMainDemand(formData);
    } else {
      return _updateRedemand(formData);
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
    AppLogger.api(" redemand id from add page : ${widget.redemandId}");
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

  Future<Response> _updateMainDemand(FormData formData) async {
    try {
      final res = await _dio.post(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_tenant_demand_api_for_admin.php",
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );
      return res;
    } on DioException catch (e) {
      await BugLogger.log(
        apiLink: "edit_tenant_demand_api_for_admin.php",
        error: e.response?.data.toString() ?? e.message ?? "Unknown error",
        statusCode: e.response?.statusCode ?? 0,
      );
      rethrow;
    }
  }

  Future<Response> _updateRedemand(FormData formData) async {
    try {
      final res = await _dio.post(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_redemand_option.php",
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
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


  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final FName = prefs.getString('name') ?? "";
      final FLocation = prefs.getString('location') ?? "";

      if (_buyRent == null) {
        _showError("Select Buy/Rent");
        setState(() => _isSubmitting = false);

        return;
      }

      if (_selectedBudgetLabel == null && !_showCustomSlider) {
        _showError("Select Budget");
        setState(() => _isSubmitting = false);
        return;
      }

      final formData = FormData.fromMap({
        "Tname": _nameCtrl.text.trim(),
        "Tnumber": _numberCtrl.text.trim(),
        "Price": _getPrice(),
        "Bhk": _selectedBhks.join(", "),
        "Location": _location ?? "",
        "Buy_rent": _buyRent ?? "",
        "Reference": _reference ?? "",
        "Message": _messageCtrl.text.trim(),

        "mark": _isUrgent ? "1" : "0",
        "assigned_fieldworker_name": FName,
        "assigned_fieldworker_location": FLocation,
        "assigned_subadmin_name": "Saurabh Yadav",
        "assigned_subadmin_location": FLocation,
        "Status": "assigned to fieldworker",
        "by_field": "true",

        "parking": _parking ?? "",
        "lift": _lift ?? "",
        "furnished_unfurnished": _furnished ?? "",
        "family_structur": _familyStructure ?? "",
        "family_member": _familyMember ?? "",
        "count_of_person": "${_adultCount}A-${_childrenCount}C",
        "religion": _religion ?? "",
        "shifting_date": _formatDate(_shiftingDate),
        "visiting_dates": _formatDate(_visitingDate),
        "floor": _floor.join(','),
        "furnished_item": _selectedFurniture.isNotEmpty
            ? jsonEncode(_selectedFurniture)
            : "--",

        if (widget.mode == DemandEditMode.add)
          "created_date": DateFormat('yyyy-MM-dd').format(DateTime.now()),

        if (widget.mode != DemandEditMode.add)
          "id": widget.mode == DemandEditMode.updateDemand
              ? widget.demandId
              : widget.redemandId,
      });

      final res = await _dio.post(
        widget.mode == DemandEditMode.add
            ? "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/add_demand_for_fieldwokar.php"
            : "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/edit_redemand_option.php",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      final msg = _parseMessage(res.data);

      if (res.statusCode == 200) {
        _showSuccess(msg);
        if (mounted) Navigator.pop(context, true);
      } else {
        _showError(msg);
      }

    } on DioException catch (e) {
      final msg = _parseMessage(e.response?.data) ?? "Network error";
      _showError(msg);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
  String _getPrice() {
    if (_buyRent == "Buy") {
      return "${_buyBudget.start.toInt()}-${_buyBudget.end.toInt()}";
    } else {
      return "${_rentBudget.start.toInt()}-${_rentBudget.end.toInt()}";
    }
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat("yyyy-MM-dd").format(date) : "";
  }

  String _parseMessage(dynamic data) {
    final msg = data?["message"] ?? data?["msg"];

    if (msg is String) return msg;
    if (msg is Map) return msg.values.join(", ");
    return "Something went wrong";
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text(msg)),
    );
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
                      "You will find this demand in your accept tab after the form submit.",
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
                        activeColor: Colors.red,
                        value: _isUrgent,
                        onChanged: (v) => setState(() => _isUrgent = v),
                      )
                    ],
                  ),
                ),

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
                        onChanged: (value) {},
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
                                      selectedColor: Color(0xFFDC2626),
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

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_isSubmitting)
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
    if (widget.mode == DemandEditMode.add) return "Submit Demand";
    if (widget.mode == DemandEditMode.updateDemand) return "Update Demand";
    return "Update Redemand";  }

  Color _submitButtonColor(ThemeData theme) {
    if (_isSubmitting) return Colors.grey.shade600;;

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
                  /// 🔥 HEADER (CLEAN)
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
            theme.colorScheme.primary.withOpacity(0.15),
            theme.colorScheme.primary.withOpacity(0.05),
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

                onSelected: (_) =>
                isBuy ? onBuyChange(r) : onRentChange(r),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // RANGE SLIDER
          RangeSlider(
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