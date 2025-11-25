import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../constant.dart';

class TenantDemandUpdatePage extends StatefulWidget {
  final Map demand;
  const TenantDemandUpdatePage({super.key, required this.demand});

  @override
  State<TenantDemandUpdatePage> createState() => _TenantDemandUpdatePageState();
}

class _TenantDemandUpdatePageState extends State<TenantDemandUpdatePage>
    with SingleTickerProviderStateMixin {
  final Dio _dio = Dio();

  // Fields
  String? _parking;
  String? _lift;
  String? _furnished;
  String? _familyStructure;
  String? _familyMember;
  String? _religion;

  DateTime? _visitingDate;

  final TextEditingController _vehicleNoCtrl = TextEditingController();
  String? _vehicleType;

  RangeValues _bhkRange = const RangeValues(1, 3);
  RangeValues _buyBudget = const RangeValues(1000000, 5000000);

  final List<int> _rentSteps = [
    5000,
    10000,
    15000,
    20000,
    25000,
    30000,
    40000,
    50000,
    75000,
    100000
  ];
  int? _rentMin = 5000;
  int? _rentMax = 20000;

  String? _floor;
  DateTime? _shiftingDate;

  final TextEditingController _messageCtrl = TextEditingController();
  String? _buyRent;

  bool _isUpdating = false;

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

    _loadInitialValues();
  }

  void _loadInitialValues() {
    final d = widget.demand;

    _parking = d["parking"];
    _lift = d["lift"];
    _furnished = d["furnished_unfurnished"];
    _familyStructure = d["family_structur"];
    _familyMember = d["family_member"]?.toString();
    _religion = d["religion"];

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
          _rentMin = int.parse(parts[0]);
          _rentMax = int.parse(parts[1]);
        } catch (_) {}
      }
    }

    final bhk = d["bhk"]?.toString() ?? d["Bhk"]?.toString();
    if (bhk != null && bhk.contains('-')) {
      final parts = bhk.split('-');
      try {
        _bhkRange = RangeValues(
          double.parse(parts[0]),
          double.parse(parts[1]),
        );
      } catch (_) {}
    }

    _floor = d["floor"]?.toString();

    if (d["shifting_date"] != null && d["shifting_date"].toString().isNotEmpty) {
      try {
        _shiftingDate = DateTime.parse(d["shifting_date"]);
      } catch (_) {}
    }

    _messageCtrl.text = d["Message"] ?? "";
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

    final payload = {
      "id": widget.demand["id"].toString(),
      "parking": _parking ?? "",
      "lift": _lift ?? "",
      "furnished_unfurnished": _furnished ?? "",
      "family_structur": _familyStructure ?? "",
      "family_member": _familyMember ?? "",
      "religion": _religion ?? "",
      "visiting_dates": _visitingDate == null
          ? ""
          : DateFormat("yyyy-MM-dd").format(_visitingDate!),
      "vichle_no": _vehicleNoCtrl.text.trim(),
      "vichle_type": _vehicleType ?? "",
      "Bhk": "${_bhkRange.start.toInt()}-${_bhkRange.end.toInt()}",
      "floor": _floor ?? "",
      "shifting_date": _shiftingDate == null
          ? ""
          : DateFormat("yyyy-MM-dd").format(_shiftingDate!),
      "Price": _buyRent == "Buy"
          ? "${_buyBudget.start.toInt()}-${_buyBudget.end.toInt()}"
          : "$_rentMin-$_rentMax",
      "Message": _messageCtrl.text.trim(),
      "Buy_rent": _buyRent ?? "",
    };

    try {
      final res = await _dio.post(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php",
        data: FormData.fromMap(payload),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(res.data["message"] ?? "Updated Successfully"),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Update failed: ${res.statusCode}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBuy = _buyRent == "Buy";
    final isRent = _buyRent == "Rent";

    return Scaffold(
      appBar: AppBar(
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
                alignment: Alignment.centerLeft,
                child: Text(
                  "Update Demand Details",
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Parking
              dropdownField(
                title: "Parking",
                value: _parking,
                onTap: () => _showSelectBottomSheet(
                  title: "Parking",
                  items: ["Yes", "No"],
                  onSelect: (v) => setState(() => _parking = v),
                ),
              ),

              // Lift
              dropdownField(
                title: "Lift",
                value: _lift,
                onTap: () => _showSelectBottomSheet(
                  title: "Lift",
                  items: ["Yes", "No"],
                  onSelect: (v) => setState(() => _lift = v),
                ),
              ),

              // Furnished
              dropdownField(
                title: "Furnished / Unfurnished",
                value: _furnished,
                onTap: () => _showSelectBottomSheet(
                  title: "Furnished Type",
                  items: [
                    "Furnished",
                    "Semi-Furnished",
                    "Unfurnished",
                  ],
                  onSelect: (v) => setState(() => _furnished = v),
                ),
              ),

              // BHK Slider
              Text(
                "Select BHK Range",
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color:
                  theme.colorScheme.surfaceVariant.withOpacity(0.1),
                ),
                child: RangeSlider(
                  values: _bhkRange,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  labels: RangeLabels(
                    "${_bhkRange.start.toInt()} BHK",
                    "${_bhkRange.end.toInt()} BHK",
                  ),
                  onChanged: (r) => setState(() => _bhkRange = r),
                ),
              ),
              const SizedBox(height: 12),

              // Floor
              dropdownField(
                title: "Floor",
                value: _floor,
                onTap: () => _showSelectBottomSheet(
                  title: "Floor",
                  items: [
                    "Ground",
                    "Upper Ground",
                    "First",
                    "Second",
                    "Third",
                    "Fourth",
                    "Top"
                  ],
                  onSelect: (v) => setState(() => _floor = v),
                ),
              ),

              // Family Structure
              dropdownField(
                title: "Family Structure",
                value: _familyStructure,
                onTap: () => _showSelectBottomSheet(
                  title: "Family Structure",
                  items: ["Joint", "Nuclear", "Single"],
                  onSelect: (v) => setState(() => _familyStructure = v),
                ),
              ),

              // Family Member
              TextField(
                controller:
                TextEditingController(text: _familyMember ?? ""),
                keyboardType: TextInputType.number,
                onChanged: (v) => _familyMember = v,
                decoration:
                _inputStyle("Family Member Count", Icons.group),
              ),
              const SizedBox(height: 12),

              // Religion
              dropdownField(
                title: "Religion",
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

              // Price
              Text(
                "Price",
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              if (isBuy)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.colorScheme.surfaceVariant
                        .withOpacity(0.1),
                  ),
                  child: RangeSlider(
                    values: _buyBudget,
                    min: 500000,
                    max: 20000000,
                    divisions: 40,
                    labels: RangeLabels(
                      _formatAmount(_buyBudget.start),
                      _formatAmount(_buyBudget.end),
                    ),
                    onChanged: (r) =>
                        setState(() => _buyBudget = r),
                  ),
                ),

              if (isRent)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _rentMin,
                        decoration: const InputDecoration(
                          labelText: "Min ₹",
                          border: OutlineInputBorder(),
                        ),
                        items: _rentSteps
                            .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(_formatAmount(e))))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _rentMin = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _rentMax,
                        decoration: const InputDecoration(
                          labelText: "Max ₹",
                          border: OutlineInputBorder(),
                        ),
                        items: _rentSteps
                            .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(_formatAmount(e))))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _rentMax = v),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Shifting Date
              dropdownField(
                title: "Shifting Date",
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

              // Vehicle Number
              TextField(
                controller: _vehicleNoCtrl,
                decoration:
                _inputStyle("Vehicle Number", Icons.car_crash),
              ),
              const SizedBox(height: 12),

              // Vehicle Type
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
}
