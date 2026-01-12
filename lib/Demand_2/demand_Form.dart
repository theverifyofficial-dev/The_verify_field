import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';
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
  String? _parking;
  String? _lift;
  String? _furnished;
  String? _familyStructure;
  String? _familyMember;
  int _adultCount = 1;
  int _childrenCount = 0;
  String? _religion;

  DateTime? _visitingDate;

  final TextEditingController _vehicleNoCtrl = TextEditingController();
  String? _vehicleType;

  RangeValues _buyBudget = const RangeValues(1000000, 5000000);

  RangeValues _rentBudget = const RangeValues(12000, 25000);


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

    _loadInitialValues();
  }


  void _parseMemberCount(String? value) {
    if (value == null || value.isEmpty) return;

    final regex = RegExp(r'(\d+)A-(\d+)C');
    final match = regex.firstMatch(value);

    if (match != null) {
      _adultCount = int.parse(match.group(1)!);
      _childrenCount = int.parse(match.group(2)!);
    }
  }



  void _loadInitialValues() {
    final d = widget.demand;

    _parking = d["parking"];
    _lift = d["lift"];
    _furnished = d["furnished_unfurnished"];
    _familyStructure = d["family_structur"];
    _familyMember = d["family_member"]?.toString();
    _religion = d["religion"];
    if (d["furnished_item"] != null && d["furnished_item"].toString().isNotEmpty) {
      try {
        _selectedFurniture =
        Map<String, int>.from(jsonDecode(d["furnished_item"]));
      } catch (_) {
        _selectedFurniture = {};
      }
    }
    // ✅ total family count
    _familyMember = d["family_member"]?.toString();

    // ✅ parse adult/child from single parameter
    _parseMemberCount(d["count_of_person"]);


    if (d["visiting_dates"] != null && d["visiting_dates"].toString().isNotEmpty) {
      try {
        _visitingDate = DateTime.parse(d["visiting_dates"]);
      } catch (_) {}
    }

    _vehicleNoCtrl.text = d["vichle_no"] ?? "";
    _vehicleType = d["vichle_type"];

    _buyRent = d["Buy_rent"]?.toString();

    final price = d["Price"]?.toString() ?? "";
    if (_buyRent == "Buy") {
      final parts = price.split('-');
      if (parts.length == 2) {
        try {
          _buyBudget = RangeValues(
            double.parse(parts[0]),
            double.parse(parts[1]),
          );
        } catch (_) {}
      }
     } else if (_buyRent == "Rent") {
  final parts = price.split('-');
  if (parts.length == 2) {
  try {
  _rentBudget = RangeValues(
  double.parse(parts[0]),
  double.parse(parts[1]),
  );
  } catch (_) {}
  }
  }



    if (d["floor"] != null) {
      _floor.add(d["floor"].toString());
    }

    if (d["shifting_date"] != null && d["shifting_date"].toString().isNotEmpty) {
      try {
        _shiftingDate = DateTime.parse(d["shifting_date"]);
      } catch (_) {}
    }

    _messageCtrl.text = d["Message"] ?? "";

    final total = int.tryParse(_familyMember ?? "0") ?? 0;
    if (_adultCount + _childrenCount != total && total > 0) {
      _adultCount = 1;
      _childrenCount = total - 1;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _vehicleNoCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _optionBox(String label, String? value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value ?? label,
            style: TextStyle(
              fontSize: 15,
              color: value == null ? theme.hintColor : theme.colorScheme.onSurface,
            ),
          ),
          Icon(Icons.keyboard_arrow_down, color: theme.iconTheme.color),
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

    if (_furnished == null || _furnished!.isEmpty) {
      error = "Please select furnishing type";
    } else if (_familyStructure == null || _familyStructure!.isEmpty) {
      error = "Please select family structure";
    } else if (_familyMember == null || _familyMember!.isEmpty) {
      error = "Please enter family member count";
    } else if (_floor.isEmpty) {
      error = "Please select at least one floor";
    } else if (_buyRent == null || _buyRent!.isEmpty) {
      error = "Please select Buy or Rent";
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.redAccent, content: Text(error)),
      );
      setState(() => _isUpdating = false);
      return;
    }

    final total = int.tryParse(_familyMember!) ?? 0;
    if (_adultCount + _childrenCount != total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Adult + Child count must equal total family members"),
        ),
      );
      setState(() => _isUpdating = false);
      return;
    }

    print("👨‍👩‍👧 Family Ratio OK → $_adultCount A, $_childrenCount C");

    final payload = {
      "id": widget.demand["id"].toString(),
      "parking": _parking ?? "",
      "lift": _lift ?? "",
      "furnished_unfurnished": _furnished ?? "",
      "family_structur": _familyStructure,
      "family_member": _familyMember,
      "count_of_person": "${_adultCount}A-${_childrenCount}C",
      "religion": _religion ?? "",
      "visiting_dates": _visitingDate == null
          ? ""
          : DateFormat("yyyy-MM-dd").format(_visitingDate!),
      "vichle_no": _vehicleNoCtrl.text.trim(),
      "vichle_type": _vehicleType ?? "",
      "floor": _floor.join(','),
      "shifting_date": _shiftingDate == null
          ? ""
          : DateFormat("yyyy-MM-dd").format(_shiftingDate!),
      "Price": _buyRent == "Buy"
          ? "${_buyBudget.start.toInt()}-${_buyBudget.end.toInt()}"
          : "${_rentBudget.start.toInt()}-${_rentBudget.end.toInt()}",
      "Message": _messageCtrl.text.trim(),
      "Buy_rent": _buyRent ?? "",
      "furnished_item":
      _selectedFurniture.isEmpty ? "" : jsonEncode(_selectedFurniture),
    };

    print("📦 REQUEST PAYLOAD:");
    payload.forEach((k, v) => print("   $k → $v"));

    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php",
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
                  "Update Demand Details",
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Furnished
              DropdownButtonFormField<String>(
                  value: _furnished,
                  decoration: InputDecoration(
                    labelText: "Select Furnished Type",
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
                  items: furnishingOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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
                          decoration: InputDecoration(
                            labelText: "Select Furniture Items",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true, // ✅ enable background color
                            // fillColor: Colors.grey.shade800,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          controller: TextEditingController(
                            text: _selectedFurniture.isEmpty
                                ? ''
                                : _selectedFurniture.entries
                                .map((e) => '${e.key} (${e.value})')
                                .join(', '),
                          ),
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

              dropdownField(
                title: "Family Details",
                value: _familyStructure == null
                    ? null
                    : "$_familyStructure • $_familyMember members",
                onTap: () => _showFamilyBottomSheet(context),
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
                      title: "Lift (Optional)",
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
                decoration:
                _inputStyle("Vehicle Number (Optional)", Icons.car_crash),
              ),
              const SizedBox(height: 12),

              // Price
              Text(
                "Price",
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              Text(
                _buyRent == "Buy"
                    ? "Buy Budget"
                    : "Rent Budget (per month)",
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _buyRent == "Buy"
                          ? "${_formatAmount(_buyBudget.start)} – ${_formatAmount(_buyBudget.end)}"
                          : "₹${_rentBudget.start.toInt()} – ₹${_rentBudget.end.toInt()} / month",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    RangeSlider(
                      values: _buyRent == "Buy" ? _buyBudget : _rentBudget,
                      min: _buyRent == "Buy" ? 500000 : 5000,
                      max: _buyRent == "Buy" ? 20000000 : 100000,
                      divisions: _buyRent == "Buy" ? 40 : 19,
                      labels: _buyRent == "Buy"
                          ? RangeLabels(
                        _formatAmount(_buyBudget.start),
                        _formatAmount(_buyBudget.end),
                      )
                          : RangeLabels(
                        "₹${_rentBudget.start.toInt()}",
                        "₹${_rentBudget.end.toInt()}",
                      ),
                      onChanged: (range) {
                        setState(() {
                          if (_buyRent == "Buy") {
                            _buyBudget = range;
                          } else {
                            _rentBudget = range;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              Text(
                "Select Floor",
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: _floorOptions.map((e) {
                  final isSelected = _floor.contains(e);
                  return ChoiceChip(
                    label: Text(e),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary.withOpacity(0.25),
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
              ),
              const SizedBox(height: 25),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isUpdating
                      ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    _isUpdating ? "Updating..." : "Update Demand",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed:
                  _isUpdating ? null : _updateDemand,
                ),
              ),
              const SizedBox(height: 50),
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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark
          ? theme.colorScheme.surface
          : Colors.green.shade50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                children: [
                  // HEADER
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                          Colors.grey.shade900,
                          Colors.grey.shade800,
                        ]
                            :  [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Furniture',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isDark ? Colors.grey.shade700 : Colors.white,
                            foregroundColor:
                            isDark ? Colors.white : theme.colorScheme.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedFurniture = Map.fromEntries(
                                tempSelection.entries
                                    .where((e) => e.value > 0),
                              );
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // LIST
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: furnitureItems.map((item) {
                          final isSelected = tempSelection.containsKey(item);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                  ? theme.colorScheme.primary.withOpacity(0.2)
                                  : Colors.white)
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                if (!isDark)
                                  const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(1, 2),
                                  ),
                              ],
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: theme.colorScheme.primary,
                                value: isSelected,
                                onChanged: (checked) {
                                  setModalState(() {
                                    if (checked == true) {
                                      tempSelection[item] = 1;
                                    } else {
                                      tempSelection.remove(item);
                                    }
                                  });
                                },
                              ),
                              title: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyLarge!.color,
                                ),
                              ),
                              trailing: isSelected
                                  ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle),
                                    color: theme.colorScheme.primary,
                                    onPressed: () {
                                      setModalState(() {
                                        if (tempSelection[item]! > 1) {
                                          tempSelection[item] =
                                              tempSelection[item]! - 1;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    '${tempSelection[item]}',
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon:
                                    const Icon(Icons.add_circle),
                                    color: theme.colorScheme.primary,
                                    onPressed: () {
                                      setModalState(() {
                                        tempSelection[item] =
                                            tempSelection[item]! + 1;
                                      });
                                    },
                                  ),
                                ],
                              )
                                  : null,
                            ),
                          );
                        }).toList(),
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

  void _showFamilyBottomSheet(BuildContext context) {
    String? tempStructure = _familyStructure;
    int tempMembers = int.tryParse(_familyMember ?? "") ?? 0;
    int tempAdults = _adultCount;
    int tempChildren = _childrenCount;

    final TextEditingController memberCtrl =
    TextEditingController(text: tempMembers > 0 ? tempMembers.toString() : "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool isValid =
            tempMembers > 0 &&
                tempAdults >= 1 &&
                tempChildren >= 0 &&
                (tempAdults + tempChildren == tempMembers);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView( // ✅ FIX OVERFLOW
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Family Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // FAMILY STRUCTURE
                      ...[
                        "Joint",
                        "Nuclear",
                        "Bachelor",
                        "Live-In relation"
                      ].map(
                            (type) => RadioListTile<String>(
                          value: type,
                          groupValue: tempStructure,
                          title: Text(type),
                          onChanged: (v) {
                            setSheetState(() => tempStructure = v);
                          },
                        ),
                      ),

                      const Divider(),

                      const Text(
                        "Total Family Members",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),

                      TextField(
                        controller: memberCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter total members",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.group),
                        ),
                        onChanged: (v) {
                          setSheetState(() {
                            tempMembers = int.tryParse(v) ?? 0;

                            if (tempAdults > tempMembers) {
                              tempAdults = tempMembers;
                            }

                            if (tempChildren > tempMembers - tempAdults) {
                              tempChildren = tempMembers - tempAdults;
                            }
                          });
                        },
                      ),

                      if (tempMembers > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Adults + Children must equal $tempMembers",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      _sheetCounter(
                        label: "Adults",
                        value: tempAdults,
                        min: 1,
                        max: tempMembers - tempChildren,
                        enabled: tempMembers > 0,
                        onChanged: (v) {
                          setSheetState(() {
                            tempAdults = v;
                          });
                          },
                      ),

                      _sheetCounter(
                        label: "Children",
                        value: tempChildren,
                        min: 0, // ✅ FIX
                        max: tempMembers - tempAdults,
                        enabled: tempMembers > 0,
                        onChanged: (v) {
                          setSheetState(() {
                            tempChildren = v;
                          });
                          },
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isValid
                              ? () {
                            setState(() {
                              _familyStructure = tempStructure;
                              _familyMember = tempMembers.toString();
                              _adultCount = tempAdults;
                              _childrenCount = tempChildren;
                            });
                            Navigator.pop(ctx);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            elevation: isValid ? 4 : 0,
                            backgroundColor: isValid
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            disabledBackgroundColor: Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: isValid ? 16 : 14,
                              fontWeight: FontWeight.bold,
                              color: isValid ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _sheetCounter({
    required String label,
    required int value,
    required int min,
    required int max,
    required bool enabled,
    required ValueChanged<int> onChanged,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: value > min ? () => onChanged(value - 1) : null,
                ),
                Text("$value", style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: value < max ? () => onChanged(value + 1) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
