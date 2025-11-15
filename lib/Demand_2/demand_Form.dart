import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../constant.dart';

class DemandForm extends StatefulWidget {
  const DemandForm({super.key});

  @override
  State<DemandForm> createState() => _CustomerDemandFormPageState();
}

class _CustomerDemandFormPageState extends State<DemandForm>

    with SingleTickerProviderStateMixin  {
  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();

  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String? _buyRent, _reference, _location;
  bool _isSubmitting = false;

  final String _status = "New";
  bool _isUrgent = false;

  RangeValues _bhkRange = const RangeValues(1, 3);
  RangeValues _buyBudget = const RangeValues(1000000, 5000000);

  // Rent dropdown values (5k, 10k, 15k…)
  final List<int> _rentSteps = [5000, 10000, 15000, 20000, 25000, 30000, 40000, 50000, 75000, 100000];
  int? _rentMin = 5000;
  int? _rentMax = 20000;

  final List<String> _buyRentOptions = ["Buy", "Rent"];
  final List<String> _referenceOptions = ["99 Acres", "Housing", "Instagram", "Youtube","facebook","Website","Other"];
  final List<String> _locationOptions = [
    "SultanPur", "Chhattarpur", "Rajpur Khurd", "Aya Nagar", "Ghitorni",""
  ];

  // Office assignment controls
  String _assignType = "All Offices";
  String? _selectedOffice;
  final List<String> _officeOptions = [
    "All Offices",
    "SultanPur Office",
    "Chhattarpur Office",
    "Rajpur Office",
    "Aya Nagar Office",
    "Ghitorni Office",
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
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }


  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final isBuy = _buyRent == "Buy";

    final formData = {
      "Tname": _nameCtrl.text.trim(),
      "Tnumber": _numberCtrl.text.trim(),
      "Buy_rent": _buyRent,
      "Reference": _reference ?? "",
      "Price": isBuy
          ? "${_buyBudget.start.toInt()}-${_buyBudget.end.toInt()}"
          : "$_rentMin-$_rentMax",
      "Message": _messageCtrl.text.trim(),
      "Bhk": "${_bhkRange.start.toInt()}-${_bhkRange.end.toInt()}",
      "Location": _location ?? "",
      "Status": _status, // Always "New"
      "mark": _isUrgent, // true / false urgent flag
      "created_date": DateFormat('yyyy-MM-dd').format(now),
      "Result": "", // Initially blank
    };

    try {
      final res = await _dio.post(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
        data: jsonEncode(formData),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(res.data["message"] ?? "Demand Added Successfully"),
          ),
        );
        _formKey.currentState?.reset();
        setState(() {
          _buyRent = _reference = _location = null;
          _isUrgent = false;
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(res.data["message"] ?? "Failed to Add Demand"),
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
      setState(() => _isSubmitting = false);
    }
  }

  // 🎨 Input decoration
  InputDecoration _inputStyle(String label, IconData icon) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.4),
      ),
    );
  }

  // 💰 Smart formatter
  String _formatAmount(num n) {
    if (n >= 10000000) return "₹${(n / 10000000).toStringAsFixed(1)}Cr";
    if (n >= 100000) return "₹${(n / 100000).toStringAsFixed(1)}L";
    if (n >= 1000) return "₹${(n / 1000).toStringAsFixed(0)}k";
    return "₹${n.toInt()}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBuy = _buyRent == "Buy";
    final isRent = _buyRent == "Rent";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(PhosphorIcons.caret_left_bold,
              color: Colors.white, size: 30),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [


              // 🚨 Premium Urgent Demand Swipe Toggle (Pulse + Bounce)
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Left Label & Description ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mark as Urgent",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isUrgent ? Colors.redAccent : Theme.of(context).hintColor,
                        ),
                      ),
                      Text(
                        _isUrgent ? "High priority demand" : "Normal priority demand",
                        style: TextStyle(
                          fontSize: 13,
                          color: _isUrgent
                              ? Colors.redAccent.withOpacity(0.8)
                              : Theme.of(context).hintColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),

                  // --- Right Swipe Button ---
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _isUrgent = !_isUrgent);
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta != null) {
                        final dx = details.primaryDelta!;
                        if (dx > 5 && !_isUrgent) setState(() => _isUrgent = true);
                        if (dx < -5 && _isUrgent) setState(() => _isUrgent = false);
                      }
                    },
                    child: ScaleTransition(
                      scale: _isUrgent
                          ? _pulseAnimation
                          : const AlwaysStoppedAnimation(1.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 74,
                        height: 36,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: _isUrgent
                              ? Colors.redAccent.withOpacity(0.85)
                              : Colors.grey.shade400.withOpacity(0.5),
                          boxShadow: _isUrgent
                              ? [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                              : [],
                        ),
                        child: Stack(
                          children: [
                            AnimatedAlign(
                              duration: const Duration(milliseconds: 250),
                              alignment: _isUrgent
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              curve: Curves.easeOutBack,
                              child: AnimatedScale(
                                scale: _isUrgent ? 1.05 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutBack,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _isUrgent
                                            ? Colors.redAccent.withOpacity(0.4)
                                            : Colors.black26,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isUrgent
                                        ? Icons.flash_on_rounded
                                        : Icons.power_settings_new_rounded,
                                    color: _isUrgent ? Colors.redAccent : Colors.grey,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),


              TextFormField(
                controller: _nameCtrl,
                decoration: _inputStyle("Customer Name", Icons.person),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _numberCtrl,
                decoration: _inputStyle("Phone Number", Icons.phone),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                validator: (v) =>
                v!.length != 10 ? "Enter valid 10-digit number" : null,
              ),
              GestureDetector(
                onTap: () => _showSelectBottomSheet(
                  title: "Select Type (Buy or Rent)",
                  items: _buyRentOptions,
                  onSelect: (v) => setState(() => _buyRent = v),
                ),
                child: _optionBox("Buy / Rent", _buyRent),
              ),
              GestureDetector(
                onTap: () => _showSelectBottomSheet(
                  title: "Select Reference",
                  items: _referenceOptions,
                  onSelect: (v) => setState(() => _reference = v),
                ),
                child: _optionBox("Reference From", _reference),
              ),
              GestureDetector(
                onTap: () => _showSelectBottomSheet(
                  title: "Select Location",
                  items: _locationOptions,
                  onSelect: (v) => setState(() => _location = v),
                ),
                child: _optionBox("Location", _location),
              ),

              if (_buyRent != null) ...[
                const SizedBox(height: 10),
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
                          isBuy
                              ? "Select Buy Price Range (₹)"
                              : "Select Rent Range (₹/month)",
                          style: theme.textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w600)),

                      // 🟢 Buy uses RangeSlider
                      if (isBuy)
                        RangeSlider(
                          values: _buyBudget,
                          min: 500000,
                          max: 20000000,
                          divisions: 40,
                          labels: RangeLabels(
                            _formatAmount(_buyBudget.start),
                            _formatAmount(_buyBudget.end),
                          ),
                          onChanged: (r) => setState(() => _buyBudget = r),
                        ),

                      // 🟣 Rent uses Dropdowns
                      if (isRent) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<int>(
                                value: _rentMin,
                                decoration: const InputDecoration(
                                    labelText: "Min (₹)",
                                    border: OutlineInputBorder()),
                                items: _rentSteps
                                    .map((e) => DropdownMenuItem(
                                    value: e, child: Text(_formatAmount(e))))
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
                                    labelText: "Max (₹)",
                                    border: OutlineInputBorder()),
                                items: _rentSteps
                                    .map((e) => DropdownMenuItem(
                                    value: e, child: Text(_formatAmount(e))))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _rentMax = v),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 12),
                      Text("Select BHK Range",
                          style: theme.textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w600)),
                      RangeSlider(
                        values: _bhkRange,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        activeColor: theme.colorScheme.primary,
                        labels: RangeLabels(
                          "${_bhkRange.start.toInt()} BHK",
                          "${_bhkRange.end.toInt()} BHK",
                        ),
                        onChanged: (r) => setState(() => _bhkRange = r),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 10),
              TextFormField(
                controller: _messageCtrl,
                decoration:
                _inputStyle("Message", Icons.note_alt_outlined),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isSubmitting
                      ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.upload, color: Colors.white, size: 25),
                  label: Text(
                    _isSubmitting ? "Submitting..." : "Submit Demand",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSubmitting ? null : _submitForm,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
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
  // 🔽 Reusable Bottom Sheet Selector
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
}


