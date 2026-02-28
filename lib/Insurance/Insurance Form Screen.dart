import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InsuranceFormScreen extends StatefulWidget {
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  const InsuranceFormScreen({super.key, required this.fieldWorkerName, required this.fieldWorkerNumber});

  @override
  State<InsuranceFormScreen> createState() => _InsuranceFormScreenState();
}

class _InsuranceFormScreenState extends State<InsuranceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final fieldWorkerNameController = TextEditingController();
  final fieldWorkerNumberController = TextEditingController();
  final vehicleTypeController = TextEditingController();

  File? aadharFront;
  File? aadharBack;
  File? rcFront;
  File? rcBack;
  File? carPhoto;
  File? oldPolicy;

  final picker = ImagePicker();
  bool isLoading = false;
  final emailController = TextEditingController();
  final nomineeNameController = TextEditingController();
  final nomineeAgeController = TextEditingController();
  final nomineeRelationController = TextEditingController();

  String claimStatus = "No";
  String pollutionStatus = "No";
  List<File> carMultipleImages = [];
  File? pollutionPhoto;
  final expiryDateController = TextEditingController();
  Future<void> pickImage(Function(File) onSelected) async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked != null) {
      onSelected(File(picked.path));
      setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();

    fieldWorkerNameController.text = widget.fieldWorkerName;
    fieldWorkerNumberController.text = widget.fieldWorkerNumber;
  }
  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://verifyserve.social/PHP_Files/insurance_insert_api/insurance_details/insert.php',
        ),
      );

      /// 🔹 FIELDS
      request.fields['name_'] = nameController.text.trim();
      request.fields['number'] = numberController.text.trim();
      request.fields['vehicle_number'] = vehicleNumberController.text.trim();
      request.fields['fieldworkar_name'] = widget.fieldWorkerName;
      request.fields['fieldworkar_number'] = widget.fieldWorkerNumber;
      request.fields['vehicle_type'] = vehicleTypeController.text.trim();
      request.fields['email_id'] = emailController.text.trim();
      request.fields['Nominie_name'] = nomineeNameController.text.trim();
      request.fields['Nominie_age'] = nomineeAgeController.text.trim();
      request.fields['Nominie_relation'] = nomineeRelationController.text.trim();
      request.fields['claim'] = claimStatus;
      request.fields['polution_yes_no'] = pollutionStatus;
      request.fields['expiry_date'] = expiryDateController.text.trim();

      /// 🔹 Pollution validation
      if (pollutionStatus == "Yes" && pollutionPhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload Pollution Photo')),
        );
        setState(() => isLoading = false);
        return;
      }

      /// 🔹 FILES (Optional)
      if (pollutionPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'polution_photo',
          pollutionPhoto!.path,
        ));
      }

      if (aadharFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Aadhar_front',
          aadharFront!.path,
        ));
      }

      if (aadharBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Aadhar_back',
          aadharBack!.path,
        ));
      }

      if (rcFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Rc_front',
          rcFront!.path,
        ));
      }

      if (rcBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Rc_back',
          rcBack!.path,
        ));
      }

      if (carPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'car_photo',
          carPhoto!.path,
        ));
      }

      if (oldPolicy != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'old_policy_docement',
          oldPolicy!.path,
        ));
      }

      /// 🔹 MULTIPLE IMAGES
      for (var image in carMultipleImages) {
        request.files.add(await http.MultipartFile.fromPath(
          'car_multiple_images[]',
          image.path,
        ));
      }

      /// 🔹 SEND REQUEST
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY: $responseBody");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);

        /// ✅ SUCCESS CASE
        if (decoded["status"] == true) {

          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Submitted Successfully')),
          );

          Navigator.pop(context, true);
        }

        /// ❌ DUPLICATE VEHICLE CASE
        else if (decoded["status"] == false &&
            decoded["vehicle_number"] != null) {

          setState(() => isLoading = false);

          final vehicleNumber = decoded["vehicle_number"];
          final addedByName = decoded["added_by_fieldworker_name"];
          final addedByNumber = decoded["added_by_fieldworker_number"];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Vehicle $vehicleNumber already exists\n"
                    "Added by: $addedByName",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );

          vehicleNumberController.clear();
        }

        /// ⚠️ OTHER FAILURE
        else {
          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(decoded["message"] ?? "Something went wrong"),
            ),
          );
        }
      } else {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
      }

    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 75);

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      carMultipleImages = pickedFiles.map((e) => File(e.path)).toList();
      setState(() {});
    }
  }
  Widget buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int? maxLength,
        bool isRequired = false, // ✅ NEW
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDark ? Colors.white10 : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,

          validator: (value) {

            /// ✅ REQUIRED CHECK ONLY WHEN NEEDED
            if (isRequired) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
            }

            /// ✅ MOBILE VALIDATION
            if (keyboardType == TextInputType.phone &&
                value != null &&
                value.isNotEmpty) {
              if (value.length != 10) {
                return 'Enter valid 10-digit number';
              }
            }

            /// ✅ VEHICLE NUMBER BASIC CHECK
            if (label.toLowerCase().contains("vehicle number") &&
                value != null &&
                value.isNotEmpty) {
              if (value.length < 6) {
                return 'Enter valid vehicle number';
              }
            }

            return null;
          },

          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontFamily: "PoppinsMedium",
          ),

          decoration: InputDecoration(
            counterText: "",
            labelText: label,
            labelStyle: TextStyle(
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadioRow(String title, String groupValue,
      Function(String) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDark ? Colors.white10 : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Text(title,
                style: const TextStyle(fontFamily: "PoppinsMedium")),
            const Spacer(),
            Radio(
              value: "Yes",
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
            ),
            const Text("Yes"),
            Radio(
              value: "No",
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
            ),
            const Text("No"),
          ],
        ),
      ),
    );
  }
  /// ✅ PREMIUM IMAGE PICKER WITH PREVIEW
  Widget buildImagePicker(
      String title, File? file, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDark ? Colors.white10 : Colors.white,

          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.shade200,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Row(
          children: [

            /// PREVIEW
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.indigo.withOpacity(0.12),
              ),
              child: file == null
                  ? const Icon(Icons.upload_rounded,
                  color: Colors.indigo)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(file,
                    fit: BoxFit.cover),
              ),
            ),

            const SizedBox(width: 14),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "PoppinsMedium",
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    file == null
                        ? "Tap to upload"
                        : "Image selected",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: "PoppinsMedium",
                      color: isDark
                          ? Colors.white54
                          : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),

            if (file != null)
              const Icon(Icons.check_circle,
                  color: Colors.green),
          ],
        ),
      ),
    );
  }
  Widget buildDateField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: pickExpiryDate,
        child: AbsorbPointer(
          child: buildTextField(
            "Expiry Date",
            expiryDateController,
          ),
        ),
      ),
    );
  }
  Future<void> pickExpiryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      expiryDateController.text =
          DateFormat("dd-MM-yyyy").format(date); // format tera choice 😎
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDark ? const Color(0xFF020617) : Colors.grey.shade50,

      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF020617) : Colors.grey.shade100,
        surfaceTintColor:
        isDark ? const Color(0xFF020617) : Colors.grey.shade100,


        title: const Text("Insurance Details",style: TextStyle(fontFamily: "PoppinsMedium"),),
        elevation: 0,
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            padding: const EdgeInsets.all(18),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  /// ✅ SECTION: CUSTOMER DETAILS
                  const Text(
                    "Customer Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "PoppinsBold",
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildTextField(
                      "Name", nameController,
                    isRequired: true,
                  ),
                  buildTextField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      "Number", numberController,
                    isRequired: true,
                  ),

                  buildTextField("Vehicle Number",
                      vehicleNumberController,
                    keyboardType: TextInputType.text,
                    isRequired: true,
                  ),

                  buildTextField(
                      "Vehicle Type", vehicleTypeController,
                    isRequired: true,
                  ),

                  const SizedBox(height: 10),
                  buildTextField(
                    "Email ID",
                    emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  buildTextField("Nominee Name", nomineeNameController),

                  buildTextField(
                    "Nominee Age",
                    nomineeAgeController,
                    keyboardType: TextInputType.number,
                  ),

                  buildTextField("Nominee Relation", nomineeRelationController),
                  GestureDetector(
                    onTap: pickExpiryDate,
                    child: AbsorbPointer(
                      child: buildTextField(
                        "Expiry Date",
                        expiryDateController,
                      ),
                    ),
                  ),

                  buildRadioRow(
                    "Pollution",
                    pollutionStatus,
                        (v) => setState(() => pollutionStatus = v),
                  ),

                  if (pollutionStatus == "Yes")
                    buildImagePicker(
                      "Pollution Photo",
                      pollutionPhoto,
                          () => pickImage((f) => pollutionPhoto = f),
                    ),

                  const SizedBox(height: 20),

                  /// ✅ SECTION: DOCUMENTS
                  const Text(
                    "Upload Documents",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "PoppinsBold",
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildImagePicker(
                      "Aadhar Front", aadharFront,
                          () => pickImage((f) => aadharFront = f)),

                  buildImagePicker(
                      "Aadhar Back", aadharBack,
                          () => pickImage((f) => aadharBack = f)),

                  buildImagePicker(
                      "RC Front", rcFront,
                          () => pickImage((f) => rcFront = f)),

                  buildImagePicker(
                      "RC Back", rcBack,
                          () => pickImage((f) => rcBack = f)),

                  buildImagePicker(
                      "Vehicle Photo", carPhoto,
                          () => pickImage((f) => carPhoto = f)),

                  buildImagePicker(
                      "Old Policy (Optional)", oldPolicy,
                          () => pickImage((f) => oldPolicy = f)),

                  GestureDetector(
                    onTap: pickMultipleImages,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: isDark ? Colors.white10 : Colors.white,

                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          /// ✅ PREVIEW STACK
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.indigo.withOpacity(0.12),
                            ),
                            child: carMultipleImages.isEmpty
                                ? const Icon(Icons.upload_rounded, color: Colors.indigo)
                                : Stack(
                              children: carMultipleImages.take(3).map((file) {
                                final index = carMultipleImages.indexOf(file);

                                return Positioned(
                                  left: index * 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      file,
                                      height: 56,
                                      width: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "Car Multiple Images",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  carMultipleImages.isEmpty
                                      ? "Tap to upload"
                                      : "${carMultipleImages.length} images selected",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "PoppinsMedium",
                                    color: isDark ? Colors.white54 : Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (carMultipleImages.isNotEmpty)
                            const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                  if (carMultipleImages.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: carMultipleImages.length,
                        itemBuilder: (context, index) {
                          final file = carMultipleImages[index];

                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Stack(
                              children: [

                                /// ✅ IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    file,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                /// ✅ REMOVE BUTTON 🔥
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      carMultipleImages.removeAt(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
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
                  const SizedBox(height: 24),

                  /// ✅ PREMIUM BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "SUBMIT DETAILS",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "PoppinsBold",
                          fontSize: 14,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          /// ✅ LOADING OVERLAY
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}