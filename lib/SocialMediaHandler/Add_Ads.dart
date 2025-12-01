import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../ui_decoration_tools/app_images.dart';

class InsertMetaAdsExpensePro extends StatefulWidget {
  final String flatId;
  const InsertMetaAdsExpensePro({super.key, required this.flatId});

  @override
  State<InsertMetaAdsExpensePro> createState() =>
      _InsertMetaAdsExpenseProState();
}

class _InsertMetaAdsExpenseProState extends State<InsertMetaAdsExpensePro>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController cost = TextEditingController();
  final TextEditingController duration = TextEditingController();
  final TextEditingController views = TextEditingController();
  final TextEditingController leeds = TextEditingController();
  final TextEditingController impression = TextEditingController();
  final TextEditingController clicks = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();

  // dropdowns
  String? selectedPlatform;
  final List<String> platforms = [
    'Meta',
    'Instagram',
    'Facebook',
    'Google Ads',
    'YouTube',
    'LinkedIn',
    'WhatsApp'
    'X'
  ];

  // UI state
  bool _isSubmitting = false;
  late AnimationController _shakeController;
  double _shakeOffset = 0.0;

  // stagger animation flags
  final List<bool> _visible = List.generate(12, (_) => false);

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      // shaking effect from controller's value
      final t = _shakeController.value;
      setState(() {
        _shakeOffset = sin(t * pi * 4) * (8.0 * (1 - t)); // decaying shake
      });
    });

    // staggered reveal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _visible.length; i++) {
        Future.delayed(Duration(milliseconds: 80 * i), () {
          if (mounted) setState(() => _visible[i] = true);
        });
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    cost.dispose();
    duration.dispose();
    views.dispose();
    leeds.dispose();
    impression.dispose();
    clicks.dispose();
    area.dispose();
    startDate.dispose();
    endDate.dispose();
    startTime.dispose();
    endTime.dispose();
    super.dispose();
  }

  // ---------------------- PICKERS ----------------------
  Future<void> _pickDate(TextEditingController controller) async {
    DateTime initial = DateTime.now();
    try {
      final parts = controller.text.split('-');
      if (parts.length == 3) {
        initial = DateTime.tryParse(controller.text) ?? DateTime.now();
      }
    } catch (_) {}
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = "${picked.year.toString().padLeft(4, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay initial = TimeOfDay.now();
    try {
      final parts = controller.text.split(':');
      if (parts.length >= 2) {
        initial = TimeOfDay(
            hour: int.parse(parts[0].padLeft(2, '0')),
            minute: int.parse(parts[1].padLeft(2, '0')));
      }
    } catch (_) {}
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      controller.text =
      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
    }
  }

  // ------------ Validation shake (if fails) --------------
  void _triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  // ------------------ Submit Flow -----------------------
  Future<void> _submit() async {
    // validate
    if (!_formKey.currentState!.validate() || selectedPlatform == null) {
      if (selectedPlatform == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a Platform'),
          backgroundColor: Colors.redAccent,
        ));
      }
      _triggerShake();
      return;
    }

    setState(() => _isSubmitting = true);

    // countdown dialog like your building form
    int countdown = 3;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          Future.delayed(const Duration(seconds: 1), () async {
            if (countdown > 1) {
              setStateDialog(() => countdown--);
            } else {
              setStateDialog(() => countdown = 0);
              await Future.delayed(const Duration(milliseconds: 600));
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            }
          });

          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Submitting...", textAlign: TextAlign.center),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: countdown > 0
                    ? Text("$countdown",
                    key: ValueKey<int>(countdown),
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.red[300]
                            : Colors.red))
                    : const Icon(Icons.verified_rounded,
                    key: ValueKey('veri'), color: Colors.green, size: 56),
              ),
              const SizedBox(height: 10),
              Text(countdown > 0 ? "Please wait..." : "Verified!",
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)),
            ]),
          );
        });
      },
    );

    // API call
    try {
      final res = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/insert_meta_ads_expanse.php"),
        body: {
          "subid": widget.flatId,
          "cost": cost.text.trim(),
          "duration": duration.text.trim(),
          "views": views.text.trim(),
          "leeds": leeds.text.trim(),
          "impression": impression.text.trim(),
          "clicks": clicks.text.trim(),
          "platform": selectedPlatform ?? '',
          "area": area.text.trim(),
          "start_date": startDate.text.trim(),
          "end_date": endDate.text.trim(),
          "start_time": startTime.text.trim(),
          "end_time": endTime.text.trim(),
        },
      );

      final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      final success = body['status'] == 'success' || res.statusCode == 200;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['message'] ??
            (success ? 'Submitted successfully' : 'Submission failed')),
        backgroundColor: success ? Colors.green : Colors.redAccent,
      ));

      if (success) Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Network error. Try again.'),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ---------------------- UI pieces ----------------------
  Widget _sectionCard(int index, {required String title, required Widget child}) {
    final visible = _visible.length > index ? _visible[index] : true;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      opacity: visible ? 1.0 : 0.0,
      child: Transform.translate(
        offset: Offset(0, visible ? 0 : 12),
        child: _buildSectionCard(title: title, child: child),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 10),
            child
          ]),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController c,
      {required String label,
        TextInputType keyboardType = TextInputType.text,
        String? hint,
        bool requiredField = true,
        List<TextInputFormatter>? inputFormatters}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint ?? 'Enter $label',
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.black45),
        errorStyle: const TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
      ),
      validator: (v) {
        if (!requiredField) return null;
        if (v == null || v.trim().isEmpty) return 'Please enter $label';
        return null;
      },
    );
  }

  Widget _dropdown(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorStyle: const TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      onChanged: onChanged,
      validator: (v) => v == null || v.isEmpty ? 'Please select $label' : null,
      items: items
          .map((i) => DropdownMenuItem<String>(
        value: i,
        child: Text(i, style: const TextStyle(fontSize: 14)),
      ))
          .toList(),
    );
  }

  // ---------------------- BUILD --------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(AppImages.verify, height: 72),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold,
              color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Transform.translate(
        offset: Offset(_shakeOffset, 0), // shake whole form when triggered
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Text(
                  "Meta Ads Expense",
                  style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 16),

              // cost
              _sectionCard(
                0,
                title: 'Cost (INR)',
                child: _textField(cost,
                    label: 'Cost',
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ]),
              ),

              // duration + platform row
              _sectionCard(
                1,
                title: 'Duration                            Platform',
                child: Row(children: [
                  Expanded(
                    child: _textField(duration,
                        label: 'Duration (e.g., 7 days)',
                        keyboardType: TextInputType.text),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dropdown('Platform', platforms, selectedPlatform,
                            (val) {
                          setState(() => selectedPlatform = val);
                        }),
                  ),
                ]),
              ),

              // views / leeds / impression / clicks row
              _sectionCard(
                2,
                title: 'Performance Metrics',
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: _textField(views,
                            label: 'Views', keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _textField(leeds,
                            label: 'Leeds', keyboardType: TextInputType.number)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                        child: _textField(impression,
                            label: 'Impression',
                            keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _textField(clicks,
                            label: 'Clicks', keyboardType: TextInputType.number)),
                  ]),
                ]),
              ),

              // area
              _sectionCard(
                3,
                title: 'Area / Campaign',
                child: _textField(area, label: 'Area (City / Locality)'),
              ),

              // date/time pickers
              _sectionCard(
                4,
                title: 'Start Date & Time',
                child: Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(startDate),
                      child: AbsorbPointer(
                        child: _textField(startDate,
                            label: 'Start Date (YYYY-MM-DD)'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(startTime),
                      child: AbsorbPointer(
                        child: _textField(startTime, label: 'Start Time (HH:MM:SS)'),
                      ),
                    ),
                  ),
                ]),
              ),

              _sectionCard(
                5,
                title: 'End Date & Time',
                child: Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickDate(endDate),
                      child: AbsorbPointer(
                        child: _textField(endDate, label: 'End Date (YYYY-MM-DD)'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(endTime),
                      child: AbsorbPointer(
                        child: _textField(endTime, label: 'End Time (HH:MM:SS)'),
                      ),
                    ),
                  ),
                ]),
              ),

              const SizedBox(height: 8),

              // note card
              Card(
                elevation: 3,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text.rich(
                    TextSpan(
                      text: 'Note: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black),
                      children: [
                        TextSpan(
                          text:
                          'Dates & times should be in local timezone. Use date/time pickers for correct format.',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.black87),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // submit
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)),
                      SizedBox(width: 10),
                      Text('Processing...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  )
                      : const Text('Submit',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 40),
            ]),
          ),
        ),
      ),
    );
  }
}
