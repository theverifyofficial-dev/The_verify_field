import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../constant.dart';
import '../../utilities/bug_founder_fuction.dart';
import 'Admin_demand_detail.dart';

class CustomerDemandFormPage extends StatefulWidget {
  const CustomerDemandFormPage({super.key});

  @override
  State<CustomerDemandFormPage> createState() => _CustomerDemandFormPageState();
}

class _CustomerDemandFormPageState extends State<CustomerDemandFormPage> with SingleTickerProviderStateMixin  {

  final _formKey = GlobalKey<FormState>();
  final Dio _dio = Dio();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _fetchingCustomer = false;
  Map<String, dynamic>? _existingCustomer;



  String? _buyRent, _reference, _location;
  bool _isSubmitting = false;
  final String _status = "New";
  bool _isUrgent = false;

  RangeValues _buyBudget = const RangeValues(1000000, 5000000);


  RangeValues _rentBudget = const RangeValues(5000, 20000);


  final List<String> _buyRentOptions = ["Buy", "Rent"];
  final List<String> _referenceOptions = ["99 Acres", "Housing", "Instagram", "Youtube","facebook","Website","Other"];
  final List<String> _locationOptions = [
    "Sultanpur", "Chhattarpur", "Rajpur Khurd", "Aya Nagar", "Ghitorni"];

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


  Future<void> _fetchCustomerByPhone(String phone) async {
    if (phone.length != 10) return;

    setState(() => _fetchingCustomer = true);

    try {
      final res = await _dio.get(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/fecth_tenant_number.php?Tnumber=$phone",
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

  void _autofillFromExistingCustomer(Map<String, dynamic> data) {
    // NAME
    if (_nameCtrl.text.isEmpty && data["Tname"] != null) {
      _nameCtrl.text = data["Tname"].toString();
    }


    // BUY / RENT
    if (_buyRent == null && data["Buy_rent"] != null) {
      _buyRent = data["Buy_rent"];
    }

    // LOCATION
    if (_location == null && data["Location"] != null) {
      _location = data["Location"];
    }

    // Reference
    if (_reference == null && data["Reference"] != null) {
      _reference = data["Reference"];
    }

    // MESSAGE (append, don’t replace)
    if (_messageCtrl.text.isEmpty && data["Message"] != null) {
      _messageCtrl.text = data["Message"].toString();
    }

    // BHK (multi-select safe)
    if (_selectedBhks.isEmpty && data["Bhk"] != null) {
      _selectedBhks.clear();
      final bhks = data["Bhk"].toString().split(",");
      for (final b in bhks) {
        _selectedBhks.add(b.trim());
      }
    }

    // PRICE → BUDGET
    if (data["Price"] != null) {
      final parts = data["Price"].toString().split("-");
      if (parts.length == 2) {
        final start = double.tryParse(parts[0]);
        final end = double.tryParse(parts[1]);

        if (start != null && end != null) {
          if (_buyRent == "Buy") {
            _buyBudget = RangeValues(start, end);
          } else {
            _rentBudget = RangeValues(start, end);
          }
        }
      }
    }
  }



  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final isBuy = _buyRent == "Buy";

    if (_selectedBhks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please select at least one BHK option"),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final formData = {
      "Tname": _nameCtrl.text.trim(),
      "Tnumber": _numberCtrl.text.trim(),
      "Buy_rent": _buyRent,
      "Reference": _reference ?? "",
      "Price": _buyRent == "Buy"
          ? "${_buyBudget.start.toInt()}-${_buyBudget.end.toInt()}"
          : "${_rentBudget.start.toInt()}-${_rentBudget.end.toInt()}",
      "Message": _messageCtrl.text.trim(),
      "Bhk": _selectedBhks.join(", "),
      "Location": _location ?? "",
      "Status": _status, // Always "New"
      "mark": _isUrgent, // true / false urgent flag
      "created_date": DateFormat('yyyy-MM-dd').format(now),
      "Result": "", // Initially blank
      "by_field": "false", // STRING, not bool
    };

    try {
      final res = await _dio.post(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
        data: jsonEncode(formData),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      print('printing response ${res.data}');

      if (res.statusCode == 200) {
        final data = res.data;

        print(data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data["message"]),
          ),
        );

        if (data["main_status"] == "redemand") {
          final parentId = data["matched_add_demand_id"].toString();

          print(parentId);


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AdminDemandDetail(demandId: parentId),
            ),
          );
          return;
        }

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
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
          error: res.data.toString(),
          statusCode: res.statusCode ?? 0,
        );

      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";

      // ✅ Backend responded with error
      if (e.response != null) {
        final status = e.response?.statusCode;
        final data = e.response?.data;

        if (data is Map && data["message"] != null) {
          errorMessage = data["message"];
        } else {
          errorMessage = "Server error ($status)";
        }

        print(errorMessage);

        // 🔍 LOG REAL ERROR
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
          error: data.toString(),
          statusCode: status ?? 0,
        );
      }

      // ❌ No response → network / timeout / SSL
      else {
        errorMessage = "Network error. Check internet connection.";

        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/Tenant_demand_insert.php",
          error: e.message ?? "Unknown Dio error",
          statusCode: 0,
        );
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
    final theme = Theme.of(context);

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
              if (_existingCustomer != null) ...[
                _ExistingCustomerCard(
                  data: _existingCustomer!,
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
                const SizedBox(height: 16),
              ],

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
                controller: _numberCtrl,
                enabled: _existingCustomer == null,
                decoration: _inputStyle("Phone Number", Icons.phone).copyWith(
                  suffixIcon: _fetchingCustomer
                      ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                      : null,
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (v) {
                  if (v.length == 10) {
                    _fetchCustomerByPhone(v);
                  }
                },
                validator: (v) =>
                v!.length != 10 ? "Enter valid 10-digit number" : null,
              ),

              TextFormField(
                controller: _nameCtrl,
                decoration: _inputStyle("Customer Name", Icons.person),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 10),

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
                      BudgetSelector(
                        type: _buyRent!,
                        buyBudget: _buyBudget,
                        rentBudget: _rentBudget,
                        onBuyChange: (v) => setState(() => _buyBudget = v),
                        onRentChange: (v) => setState(() => _rentBudget = v),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Select BHK",
                        style: theme.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: _bhkOptions.map((e) {
                          final isSelected = _selectedBhks.contains(e);
                          return ChoiceChip(
                            label: Text(e),
                            selected: isSelected,
                            selectedColor: theme.colorScheme.primary.withOpacity(0.25),
                            onSelected: (selected) {
                              setState(() {
                                selected ? _selectedBhks.add(e) : _selectedBhks.remove(e);
                              });
                            },
                          );
                        }).toList(),
                      ),

                      if (_selectedBhks.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          "Selected: ${_selectedBhks.join(', ')}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
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

              if (_existingCustomer != null && !_canSubmitRedemand) ...[
                _redemandBlockedBanner(),
              ],
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isSubmitting
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Icon(
                    !_canSubmitRedemand
                        ? Icons.lock_outline
                        : Icons.upload,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: Text(
                    _submitButtonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _submitButtonColor(theme),
                    disabledBackgroundColor:
                    Colors.red.withOpacity(0.6), // 👈 still visible
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _canSubmitRedemand ? 6 : 0,
                  ),
                  onPressed: (_isSubmitting || !_canSubmitRedemand)
                      ? null
                      : _submitForm,
                ),
              ),

            ]),
          ),
        ),
      ),
    );
  }

  String get _submitButtonText {
    if (_isSubmitting) return "Submitting...";
    if (!_canSubmitRedemand) return "Waiting for Assign";
    return "Submit Demand";
  }

  Color _submitButtonColor(ThemeData theme) {
    if (_isSubmitting) return Colors.grey.shade600;;

    if (!_canSubmitRedemand) {
      return Colors.red.shade600; // warning state
    }
    return theme.colorScheme.primary; // normal
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


class BudgetSelector extends StatelessWidget {
  final String type; // "Buy" or "Rent"
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
    final accent = theme.colorScheme.primary;

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(isDark ? 0.10 : 0.08),
            accent.withOpacity(isDark ? 0.08 : 0.10),
          ],
        ),
        border: Border.all(
          color: accent.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
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
                  "EXISTING",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: Colors.white.withOpacity(0.25)),
          const SizedBox(height: 6),

          row("Type", data["Buy_rent"]),
          row("Budget", data["Price"] != null ? "₹ ${data["Price"]}" : null),
          row("BHK", data["Bhk"]),
          row("Location", data["Location"]),
          row("Family Members", data["family_member"]),
          row("Parking", data["parking"]),
          row("Shifting Date", data["shifting_date"]),
          row("Floor", data["floor"]),

          const SizedBox(height: 8),
          Divider(color: Colors.white.withOpacity(0.22)),
          const SizedBox(height: 6),

          row("Fieldworker", data["assigned_fieldworker_name"]),
          row("FW Location", data["assigned_fieldworker_location"]),

        ],
      ),
    );
  }
}
