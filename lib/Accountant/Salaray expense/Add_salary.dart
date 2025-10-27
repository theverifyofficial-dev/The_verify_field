import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant.dart';
import 'Salary_home.dart';

class AddSalary extends StatefulWidget {
  const AddSalary({super.key});

  @override
  State<AddSalary> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddSalary> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController Allowance = TextEditingController();
  final TextEditingController Base_pay = TextEditingController();
  final TextEditingController Net_pay = TextEditingController();
  final TextEditingController deduction = TextEditingController();
  final TextEditingController Employee_name = TextEditingController();
  final TextEditingController designation = TextEditingController();

  final List<String> _modeTypes = ['UPI', 'Bank Transaction', 'Cheque', 'Cash'];
  String? _selectedMode;
  DateTime? _payingDate;
  File? _imageFile;
  String? _selectedCategory;

  Future<XFile?> _pickAndCompressImage() async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Image Source"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text("Camera")),
          TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text("Gallery")),
        ],
      ),
    );

    if (source == null) return null;
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/expense_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );
  }

  void _resetForm() {
    Allowance.clear();
    Base_pay.clear();
    Net_pay.clear();
    deduction.clear();
    Employee_name.clear();
    designation.clear();
    _selectedMode = null;
    _payingDate = null;
    _imageFile = null;
    setState(() {});
  }


  Future<void> _uploadExpense(File imageFile) async {
    const uploadUrl =
        'https://verifyserve.social/Second%20PHP%20FILE/Expanse/salary_expanse.php';
    Dio dio = Dio();



    String year = _payingDate != null ? DateFormat('yyyy').format(_payingDate!) : '';
    String month = _payingDate != null ? DateFormat('MM').format(_payingDate!) : '';

    FormData formData = FormData.fromMap({
      "PaymentMode": _selectedMode ?? '',
      "Allowances": Allowance.text.trim(),
      "BasicPay": Base_pay.text.trim(),
      "NetPay": Net_pay.text.trim(),
      "Deductions": deduction.text.trim(),
      "EmployeeName": Employee_name.text.trim(),
      "Designation": designation.text.trim(),
      "PaymentDate": _payingDate != null
          ? DateFormat('yyyy-MM-dd').format(_payingDate!)
          : '',
      "Year": year,
      "Month": month,
      "SalarySlip": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    try {
      final response = await dio.post(uploadUrl, data: formData);
      final data = response.data is String ? jsonDecode(response.data) : response.data;

      final statusCode = response.statusCode ?? 0;
      final isSuccess = data['success'].toString() == 'true';

      if ((statusCode == 200 || statusCode == 201) && isSuccess) {
        if (!mounted) return;
        _resetForm();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SalaryHome()),
              (route) => route.isFirst,
        );
        Fluttertoast.showToast(
          msg: "✅ Expense #${data['id']} added successfully!",
        );
      } else {
        Fluttertoast.showToast(
          msg: "❌ Upload failed: ${data['message'] ?? 'Unknown error'}",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "❌ Upload failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      return;
    }

    if (_imageFile == null) {
      Fluttertoast.showToast(msg: "Please select an image first.");
      return;
    }

    if (double.tryParse(Base_pay.text) == null ||
        double.parse(Base_pay.text) <= 0) {
      Fluttertoast.showToast(msg: "Invalid amount entered.");
      return;
    }
    if (double.tryParse(Net_pay.text) == null ||
        double.parse(Net_pay.text) <= 0) {
      Fluttertoast.showToast(msg: "Invalid amount entered.");
      return;
    }

    if (double.tryParse(deduction.text) == null ||
        double.parse(deduction.text) <= 0) {
      Fluttertoast.showToast(msg: "Invalid amount entered.");
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Submission"),
        content: const Text("Are you sure you want to submit this expense?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Submit")),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    await _showCountdownDialog();
    await _uploadExpense(_imageFile!);
  }

  Future<void> _showCountdownDialog() async {
    int countdown = 3;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialog) {
          Future.delayed(const Duration(seconds: 1), () async {
            if (countdown > 1) {
              setDialog(() => countdown--);
            } else {
              await Future.delayed(const Duration(seconds: 1));
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            }
          });

          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Submitting...", textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: countdown > 0
                      ? Text(
                    "$countdown",
                    key: ValueKey<int>(countdown),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  )
                      : const Icon(Icons.verified_rounded,
                      key: ValueKey<String>('verified'),
                      color: Colors.green,
                      size: 60),
                ),
                const SizedBox(height: 8),
                Text(countdown > 0 ? "Please wait..." : "Verified!",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16)),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildCard(String title, Widget child) => Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.only(bottom: 20),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        child
      ]),
    ),
  );

  Widget _textField(String label, TextEditingController ctrl,
      {TextInputType? type, bool isNumber = false}) {
    return _buildCard(
      label,
      TextFormField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: "Enter $label",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
        ),
        inputFormatters: isNumber
            ? [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ]
            : [],
        validator: (v) =>
        (v == null || v.trim().isEmpty) ? "Please enter $label" : null,
      ),
    );
  }

  Widget _dropdownField() {
    return _buildCard(
      "Payment Mode",
      DropdownButtonFormField<String>(
        value: _selectedMode,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
        ),
        validator: (val) =>
        val == null ? "Please select a payment mode" : null,
        onChanged: (val) => setState(() => _selectedMode = val),
        items: _modeTypes
            .map((mode) => DropdownMenuItem(
          value: mode,
          child: Text(mode, style: const TextStyle(fontSize: 14)),
        ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold,
              color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildCard(
              "Upload Salary Slip",
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload, color: Colors.white),
                    label: const Text("Pick Image",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600),
                    onPressed: () async {
                      final pickedXFile = await _pickAndCompressImage();
                      if (pickedXFile != null) {
                        setState(() => _imageFile = File(pickedXFile.path));
                      }
                    },
                  ),
                  _imageFile != null
                      ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_imageFile!,
                          width: 150, height: 120, fit: BoxFit.cover))
                      : const Text('No Salary Slip selected'),
                ],
              ),
            ),

            _textField("Employee Name", Employee_name),

            _textField("Designation", designation),

            _textField("Allowance amount", Allowance,type: TextInputType.number, isNumber: true),

            Row(
              children: [
                Expanded(
                    child: _textField("Base pay", Base_pay,
                        type: TextInputType.number, isNumber: true)),
                const SizedBox(width: 16),
                Expanded(
                    child: _textField("Net pay", Net_pay,
                        type: TextInputType.number, isNumber: true)),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    "Paying Date",
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _payingDate = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          _payingDate != null
                              ? DateFormat('dd MMM yyyy').format(_payingDate!)
                              : "Select Date",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: _textField("Deduction", deduction,
                        type: TextInputType.number, isNumber: true)),
              ],
            ),

            _dropdownField(),

            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 30,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text("Processing...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                )
                    : const Text("Submit",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 50),
          ]),
        ),
      ),
    );
  }
}
