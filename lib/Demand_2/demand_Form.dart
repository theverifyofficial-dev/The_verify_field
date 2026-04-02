import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import '../Custom_Widget/constant.dart';
import '../utilities/bug_founder_fuction.dart';
import 'package:http/http.dart' as http;


class TenantDemandUpdatePage extends StatefulWidget {
  final Map demand;
  const TenantDemandUpdatePage({super.key, required this.demand});

  @override
  State<TenantDemandUpdatePage> createState() => _TenantDemandUpdatePageState();
}

class _TenantDemandUpdatePageState extends State<TenantDemandUpdatePage>
    with SingleTickerProviderStateMixin {


  // Fields
  bool _notInterested = false;
  String? _parking;
  String? _lift;
  String? _furnished;
  String? _familyStructure;
  String? _familyMember;
  int _adultCount = 1;
  int _childrenCount = 0;
  String? _religion;

  static const primaryRed = Color(0xFFDC2626);
  static const bgWhite = Color(0xFFF9FAFB);
  static const cardWhite = Colors.white;
  static const textBlack = Color(0xFF111827);
  static const borderColor = Color(0xFFE5E7EB);
  final TextEditingController _furnitureCtrl = TextEditingController();
  final TextEditingController _totalCtrl = TextEditingController();


  DateTime? _visitingDate;

  final TextEditingController _vehicleNoCtrl = TextEditingController();
  String? _vehicleType;

  final Set<String> _floor = {};
  Map<String, int> _selectedFurniture = {}; // e.g., {'Sofa': 2, 'Bed': 1}


  DateTime? _shiftingDate;

  final TextEditingController _messageCtrl = TextEditingController();
  String? _buyRent;

  bool _isUpdating = false;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

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
    '',
  ];

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
    _loadInitialValues();
  }


  void _updateFamilyTotal() {
    final total = _adultCount + _childrenCount;
    _totalCtrl.text = total.toString();
    setState(() {});
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

  void _loadInitialValues() {
    final d = widget.demand;

    // SAFE BASIC FIELDS
    _parking = safeString(d["parking"]);
    _lift = safeString(d["lift"]);
    _furnished = safeString(d["furnished_unfurnished"]);
    _familyStructure = safeString(d["family_structur"]);
    _familyMember = safeString(d["family_member"]);
    _religion = safeString(d["religion"]);

    // ✅ FURNITURE (SAFE JSON)
    final rawFurniture = safeString(d["furnished_item"]);

    if (rawFurniture != null) {
      try {
        final decoded = jsonDecode(rawFurniture);
        if (decoded is Map<String, dynamic>) {
          _selectedFurniture = Map<String, int>.from(decoded);

          _furnitureCtrl.text = _selectedFurniture.entries
              .map((e) => "${e.key} (${e.value})")
              .join(", ");
        }
      } catch (e) {
        print("❌ Furniture JSON Error: $e");
        _selectedFurniture = {};
        _furnitureCtrl.clear();
      }
    } else {
      _selectedFurniture = {};
      _furnitureCtrl.clear();
    }

    // ✅ FLOOR (NO DUPLICATE ADD)
    _floor.clear();
    final floorRaw = safeString(d["floor"]);
    if (floorRaw != null) {
      _floor.addAll(
        floorRaw.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty),
      );
    }

    // ✅ FAMILY MEMBER
    final total = int.tryParse(_familyMember ?? "0") ?? 0;

    // ✅ COUNT OF PERSON (A-C FORMAT)
    final countRaw = safeString(d["count_of_person"]);
    if (countRaw != null && countRaw.contains("-")) {
      final parts = countRaw.split("-");
      _adultCount = safeInt(parts[0].replaceAll("A", ""), defaultValue: 1);
      _childrenCount = safeInt(parts[1].replaceAll("C", ""), defaultValue: 0);
    } else if (total > 0) {
      // fallback if count_of_person missing
      _adultCount = 1;
      _childrenCount = total - 1;
    }

    _updateFamilyTotal();

    // ✅ VISITING DATE
    final visitingRaw = safeString(d["visiting_dates"]);
    if (visitingRaw != null) {
      _visitingDate = DateTime.tryParse(visitingRaw);
    }

    // ✅ SHIFTING DATE
    final shiftingRaw = safeString(d["shifting_date"]);
    if (shiftingRaw != null) {
      _shiftingDate = DateTime.tryParse(shiftingRaw);
    }

    // ✅ VEHICLE
    _vehicleNoCtrl.text = safeString(d["vichle_no"]) ?? "";
    _vehicleType = safeString(d["vichle_type"]);

    // ✅ BUY / RENT
    _buyRent = safeString(d["Buy_rent"]);

    // ✅ MESSAGE
    _messageCtrl.text = safeString(d["Message"]) ?? "";
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _vehicleNoCtrl.dispose();
    _messageCtrl.dispose();
    _furnitureCtrl.dispose(); // 🔥 ADD THIS
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),

      prefixIcon: Icon(icon, color: primaryRed),

      filled: true,
      fillColor: Colors.white,

      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      // 🔥 TEXT COLORS
      hintStyle: TextStyle(color: Colors.grey.shade400),

      // 🔥 BORDER
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryRed, width: 1.5),
      ),
    );
  }

  Widget _optionBox(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value ?? label,
            style: TextStyle(
              fontSize: 15,
              color: value == null ? Colors.grey : textBlack,
              fontWeight: value == null ? FontWeight.normal : FontWeight.w600,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
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
              color: Colors.black87          ),
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

  void _showSelectBottomSheet({
    required String title,
    required List<String> items,
    required Function(String) onSelect,
  }) {
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
            ...items.map(
                  (e) => ListTile(
                title: Text(e),
                onTap: () {
                  Navigator.pop(ctx);
                  onSelect(e);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(num n) {
    if (n >= 10000000) return "₹${(n / 10000000).toStringAsFixed(1)}Cr";
    if (n >= 100000) return "₹${(n / 100000).toStringAsFixed(1)}L";
    if (n >= 1000) return "₹${(n / 1000).toStringAsFixed(0)}k";
    return "₹${n.toInt()}";
  }


  Future<void> _updateDemand() async {
    setState(() => _isUpdating = true);

    print("🚀 UPDATE DEMAND STARTED");

    String? error;

    if (!_notInterested && _shiftingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please select shifting date"),
        ),
      );
      setState(() => _isUpdating = false);
      return;
    }


    _familyMember = (_adultCount + _childrenCount).toString();

    print("👨‍👩‍👧 Family Ratio OK → $_adultCount A, $_childrenCount C");

    final payload = {
      "id": widget.demand["id"].toString(),

      "parking": _parking ?? widget.demand["parking"] ?? "",
      "lift": _lift ?? widget.demand["lift"] ?? "",
      "furnished_unfurnished": _furnished ?? widget.demand["furnished_unfurnished"] ?? "",
      "family_structur": _familyStructure ?? widget.demand["family_structur"] ?? "",
      "family_member": (_adultCount + _childrenCount).toString(),
      "count_of_person": (_familyMember != null)
          ? "${_adultCount}A-${_childrenCount}C"
          : widget.demand["count_of_person"] ?? "",

      "religion": _religion ?? widget.demand["religion"] ?? "",

      "shifting_date": (!_notInterested && _shiftingDate != null)
          ? DateFormat("yyyy-MM-dd").format(_shiftingDate!)
          : (widget.demand["shifting_date"] ?? ""),

      "visiting_dates": _visitingDate == null
          ? widget.demand["visiting_dates"] ?? ""
          : DateFormat("yyyy-MM-dd").format(_visitingDate!),

      "vichle_no": _vehicleNoCtrl.text.isNotEmpty
          ? _vehicleNoCtrl.text.trim()
          : widget.demand["vichle_no"] ?? "",

      "vichle_type": _vehicleType ?? widget.demand["vichle_type"] ?? "",

      "floor": _floor.join(','), // ALWAYS send

      "Message": _messageCtrl.text.isNotEmpty
          ? _messageCtrl.text.trim()
          : widget.demand["Message"] ?? "",

      "Buy_rent": _buyRent ?? widget.demand["Buy_rent"] ?? "",
      "not_intrested": _notInterested ? "1" : "0",

      "furnished_item": jsonEncode(_selectedFurniture),
    };

    print("📦 REQUEST PAYLOAD:");
    payload.forEach((k, v) => print("   $k → $v"));

    final uri = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php",
    );

    try {
      final response = await http.post(
        uri,
        body: payload,
      );

      print("📥 RESPONSE STATUS: ${response.statusCode}");
      print("📥 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data["message"] ?? "Updated Successfully"),
          ),
        );

        Navigator.pop(context, true);
      } else {
        String errorMessage = "Server error (${response.statusCode})";

        if (response.body.isNotEmpty) {
          try {
            final data = jsonDecode(response.body);
            if (data is Map && data["message"] != null) {
              errorMessage = data["message"];
            }
          } catch (_) {
            errorMessage = response.body;
          }
        }

        await BugLogger.log(
          apiLink: uri.toString(),
          error: response.body,
          statusCode: response.statusCode,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print("❌ HTTP EXCEPTION: $e");

      await BugLogger.log(
        apiLink: uri.toString(),
        error: e.toString(),
        statusCode: 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Network error. Please check internet connection."),
        ),
      );
    } finally {
      print("🏁 UPDATE DEMAND FINISHED");
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      backgroundColor: bgWhite,
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Update Demand",
                  style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold,fontSize: 16,color: textBlack),
                ),
              ),
              const SizedBox(height: 12),

              // Furnished

              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

              DropdownButtonFormField<String>(
                  value: _furnished,
                  decoration: InputDecoration(
                    labelText: "Select Furnished Type",
                    labelStyle: TextStyle(color: Colors.black87),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    // ✅ Error text style
                    errorStyle: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),

                    // ✅ Error border (deep red)
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),

                    // ✅ Focused border when error
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),
                  ),
                dropdownColor: Colors.white, // 🔥 VERY IMPORTANT (menu bg)
                items: furnishingOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option,style: TextStyle(color: Colors.black87),

                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _furnished = val;
                      // Clear previously selected furniture if not furnished
                      if (val == 'Unfurnished') {
                        _selectedFurniture.clear();
                      }
                    });
                  },

                  validator: (val) =>
                  val == null || val.isEmpty ? 'Please select furnishing' : null,
                ),

              if (_furnished == 'Fully Furnished' || _furnished == 'Semi Furnished')
                GestureDetector(
                    onTap: () => _showFurnitureBottomSheet(context),
                    child: AbsorbPointer(
                      child: Padding(
                        padding:  EdgeInsets.only(top: 16.0),
                        child:
                        TextFormField(
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            labelText: "Select Furniture Items",
                            labelStyle: TextStyle(color: Colors.black87),
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true, // ✅ enable background color
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          controller: _furnitureCtrl,

                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 12),

              // Shifting Date
              dropdownField(
                title: "Shifting Date*",
                value: _shiftingDate == null
                    ? null
                    : DateFormat("yyyy-MM-dd").format(_shiftingDate!),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                    _shiftingDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2040),
                  );
                  if (picked != null)
                    setState(() => _shiftingDate = picked);
                },
              ),

                    const SizedBox(height: 12),

                    // 🔥 FAMILY TYPE
                    DropdownButtonFormField<String>(
                      value: _familyStructure,
                      decoration: _inputStyle("Family Type", Icons.family_restroom),
                      dropdownColor: Colors.white, // 🔥 VERY IMPORTANT (menu bg)

                      items: ["Joint", "Nuclear", "Bachelor", "Live-In relation"]
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (v) => setState(() => _familyStructure = v),
                      style: const TextStyle(color: Colors.black),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        /// 👨 Adults
                        Expanded(
                          child: TextFormField(
                            decoration: _inputStyle("Adults", Icons.person),
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
                            decoration: _inputStyle("Child", Icons.child_care),
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


              const SizedBox(height: 12),

              // Religion
              dropdownField(
                title: "Religion (Optional)",
                value: _religion,
                onTap: () => _showSelectBottomSheet(
                  title: "Religion",
                  items: [
                    "Hindu",
                    "Muslim",
                    "Sikh",
                    "Christian",
                    "Other"
                  ],
                  onSelect: (v) => setState(() => _religion = v),
                ),
              ),

              const SizedBox(height: 12),



              // Visiting Date
              dropdownField(
                title: "Visiting Date",
                value: _visitingDate == null
                    ? null
                    : DateFormat("yyyy-MM-dd")
                    .format(_visitingDate!),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                    _visitingDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2040),
                  );
                  if (picked != null)
                    setState(() => _visitingDate = picked);
                },
              ),


              // Parking
              Row(
                children: [
                  Expanded(
                    child: dropdownField(
                      title: "Parking",
                      value: _parking,
                      onTap: () => _showSelectBottomSheet(
                        title: "Parking",
                        items: ["Car", "Bike","Both","None"],
                        onSelect: (v) => setState(() => _parking = v),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Lift
                  Expanded(
                    child: dropdownField(
                      title: "Lift",
                      value: _lift,
                      onTap: () => _showSelectBottomSheet(
                        title: "Lift",
                        items: ["Yes", "No"],
                        onSelect: (v) => setState(() => _lift = v),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              dropdownField(
                title: "Vehicle Type",
                value: _vehicleType,


                onTap: () => _showSelectBottomSheet(
                  title: "Vehicle Type",
                  items: ["2-Wheeler", "4-Wheeler", "None"],
                  onSelect: (v) =>
                      setState(() => _vehicleType = v),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _vehicleNoCtrl,
                textCapitalization: TextCapitalization.characters, // 🔥 ALWAYS CAPS
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.black),
                decoration:
                _inputStyle("Vehicle Number (Optional)", Icons.car_crash),
              ),
              const SizedBox(height: 12),

              Text(
                "Select Floor",
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600,color: Colors.black87),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: _floorOptions.map((e) {
                  final isSelected = _floor.contains(e);
                  return ChoiceChip(
                    label: Text(e),
                    labelStyle: TextStyle(color: Colors.white),
                    selected: isSelected,
                    selectedColor: primaryRed,

                    onSelected: (selected) {
                      setState(() {
                        selected ? _floor.add(e) : _floor.remove(e);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // Message
              TextField(
                controller: _messageCtrl,
                maxLines: 3,
                decoration:
                _inputStyle("Message", Icons.note_alt_outlined),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 25),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isUpdating ? null : _updateDemand,
                  icon: _isUpdating
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    _isUpdating ? "Updating..." : "Update Demand",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),

            ],
          ),
        ),
      ),
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

  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

}
