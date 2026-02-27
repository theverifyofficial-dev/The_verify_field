import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'InsuranceShowListPage.dart';

class UpdateInsuranceFormScreen extends StatefulWidget {
  final InsuranceModel item;

  const UpdateInsuranceFormScreen({super.key, required this.item,});

  @override
  State<UpdateInsuranceFormScreen> createState() => _UpdateInsuranceFormScreenState();
}

class _UpdateInsuranceFormScreenState extends State<UpdateInsuranceFormScreen> {

  @override
  void initState() {
    super.initState();
    fetchMultipleImages();
    final item = widget.item;

    nameController.text = item.name ?? "";
    numberController.text = item.number ?? "";
    vehicleNumberController.text = item.vehicleNumber ?? "";
    fieldWorkerNameController.text = item.fieldWorkerName ?? "";
    fieldWorkerNumberController.text = item.fieldWorkerNumber ?? "";
    vehicleTypeController.text = item.vehicleType ?? "";

    nameController.text = item.name ?? "";
    numberController.text = item.number ?? "";
    vehicleNumberController.text = item.vehicleNumber ?? "";
    fieldWorkerNameController.text = item.fieldWorkerName ?? "";
    fieldWorkerNumberController.text = item.fieldWorkerNumber ?? "";
    vehicleTypeController.text = item.vehicleType ?? "";

    emailController.text = item.emailId ?? "";
    nomineeNameController.text = item.nomineeName ?? "";
    nomineeAgeController.text = item.nomineeAge ?? "";
    nomineeRelationController.text = item.nomineeRelation ?? "";

    expiryDateController.text = item.expiryDate ?? "";

    claimStatus = item.claim ?? "No";
    pollutionStatus = item.pollutionYesNo ?? "No";

  }

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

  final emailController = TextEditingController();
  final nomineeNameController = TextEditingController();
  final nomineeAgeController = TextEditingController();
  final nomineeRelationController = TextEditingController();
  final expiryDateController = TextEditingController();
  bool hideExistingPollutionImage = false;
  String claimStatus = "No";
  String pollutionStatus = "No";

  File? pollutionPhoto;
  List<String> serverMultipleImages = [];
  List<File> carMultipleImages = [];
  Future<void> fetchMultipleImages() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/PHP_Files/"
              "insurance_insert_api/insurance_details/"
              "show_insurance_multiple_image.php?subid=${widget.item.id}"));

      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true) {
        final List data = decoded['data'];

        serverMultipleImages =
            data.map<String>((e) => insuranceBaseUrl + e['car_images']).toList();
      }
    } catch (e) {
      debugPrint("Multiple Image Error: $e");
    }

    if (mounted) setState(() {});
  }
  List<String> deleteImages = [];

  final picker = ImagePicker();
  bool isLoading = false;
   String insuranceBaseUrl =
      "https://verifyserve.social/PHP_Files/insurance_insert_api/insurance_details/";

  String? _buildUrl(String? path) {
    if (path == null || path.isEmpty) return null;

    if (path.startsWith("http")) return path;

    return insuranceBaseUrl + path; // ✅ correct
  }

  Future<void> pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 75);
    if (!mounted) return;
    if (pickedFiles != null) {
      carMultipleImages = pickedFiles.map((e) => File(e.path)).toList();
      setState(() {});
    }
  }

  Future<void> pickImage(Function(File) onSelected) async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (!mounted) return;
    if (picked != null) {
      onSelected(File(picked.path));
      setState(() {});
    }
  }
  Future<void> submitForm() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://verifyserve.social/PHP_Files/'
              'insurance_insert_api/insurance_details/'
              'insurance_update.php',
        ),
      );

      request.fields['id'] = widget.item.id.toString();

      request.fields['name_'] = nameController.text;
      request.fields['number'] = numberController.text;
      request.fields['vehicle_number'] = vehicleNumberController.text;
      request.fields['fieldworkar_name'] = widget.item.fieldWorkerName.toString();
      request.fields['fieldworkar_number'] = widget.item.fieldWorkerNumber.toString();
      request.fields['vehicle_type'] = vehicleTypeController.text;

      request.fields['email_id'] = emailController.text;
      request.fields['Nominie_name'] = nomineeNameController.text;
      request.fields['Nominie_age'] = nomineeAgeController.text;
      request.fields['Nominie_relation'] = nomineeRelationController.text;

      request.fields['claim'] = claimStatus;
      request.fields['polution_yes_no'] = pollutionStatus;
      request.fields['expiry_date'] = expiryDateController.text;

      /// ✅ DOCUMENTS

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

      /// ✅ MULTIPLE IMAGES

      for (var image in carMultipleImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'car_multiple_images[]',
            image.path,
          ),
        );
      }

      /// ✅ DELETE IMAGES

      for (var image in deleteImages) {
        request.fields['delete_images[]'] = image;
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint("UPDATE RESPONSE: $responseBody");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated Successfully')),
        );

        Navigator.pop(context, true);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
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
          DateFormat("dd-MM-yyyy").format(date);
      setState(() {});
    }
  }
  Widget buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int? maxLength,
        bool isRequired = false,
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

  Widget buildPreview({
    required File? file,
    required String? networkUrl,
  }) {
    /// ✅ NEW IMAGE SELECTED
    if (file != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          width: 56,
          height: 56,
        ),
      );
    }

    /// ✅ OLD IMAGE FROM SERVER
    if (networkUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          networkUrl,
          fit: BoxFit.cover,
          width: 56,
          height: 56,

          errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, color: Colors.red),

          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const SizedBox(
              height: 20,
              width: 20,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2,
                color: Colors.blue,
                ),
              ),
            );
          },
        ),
      );
    }

    /// ✅ NO IMAGE
    return const Icon(Icons.upload_rounded, color: Colors.indigo);
  }
  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    vehicleNumberController.dispose();
    fieldWorkerNameController.dispose();
    fieldWorkerNumberController.dispose();
    vehicleTypeController.dispose();
    emailController.dispose();
    nomineeNameController.dispose();
    nomineeAgeController.dispose();
    nomineeRelationController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }
  /// ✅ PREMIUM IMAGE PICKER WITH PREVIEW
  Widget buildImagePicker(String title, File? file, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final networkUrl = _getNetworkUrl(title);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isDark ? Colors.white10 : Colors.white,
        ),
        child: Row(
          children: [

            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.indigo.withOpacity(0.12),
                ),
                child: buildPreview(
                  file: file,
                  networkUrl: networkUrl,
                ),
              ),
            ),


            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontFamily: "PoppinsMedium")),
                  const SizedBox(height: 4),
                  Text(
                    file != null
                        ? "New image selected"
                        : networkUrl != null
                        ? "Existing image"
                        : "Tap to upload",
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: "PoppinsMedium",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getNetworkUrl(String title) {
    final item = widget.item;

    switch (title) {

      case "Aadhar Front":
        return item.aadharFrontUrl;

      case "Aadhar Back":
        return item.aadharBackUrl;

      case "RC Front":
        return item.rcFrontUrl;

      case "RC Back":
        return item.rcBackUrl;

      case "Car Photo":
        return item.carPhotoUrl;

      case "Old Policy (Optional)":
        return item.oldPolicyUrl;

    /// ✅🔥 ADD THIS ↓↓↓

      case "Pollution Photo":
        return item.pollutionPhotoUrl;
    }

    return null;
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasServerImage =
        widget.item.pollutionPhotoUrl != null;

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
                      isRequired: true
                  ),


                  buildTextField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      "Number", numberController,
                      isRequired: true
                  ),

                  buildTextField("Vehicle Number",
                      vehicleNumberController,
                    keyboardType: TextInputType.text,
                      isRequired: true
                  ),

                  buildTextField(
                      "Vehicle Type", vehicleTypeController,
                      isRequired: true
                  ),

                  buildTextField("Nominee Name", nomineeNameController),

                  buildTextField(
                    "Nominee Age",
                    nomineeAgeController,
                    keyboardType: TextInputType.number,
                  ),
                  buildTextField("Nominee Relation", nomineeRelationController),

                  buildTextField(
                    "Email ID",
                    emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),


                  buildRadioRow(
                    "Claim",
                    claimStatus,
                        (v) => setState(() => claimStatus = v),
                  ),

                  buildRadioRow(
                    "Pollution",
                    pollutionStatus,
                        (v) {
                      setState(() {
                        pollutionStatus = v;

                        /// Optional → No पर image clear
                        if (v == "No") {
                          pollutionPhoto = null;
                        }
                      });
                    },
                  ),


                  GestureDetector(
                    onTap: pickExpiryDate,
                    child: AbsorbPointer(
                      child: buildTextField("Expiry Date", expiryDateController),
                    ),
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
                    "Aadhar Front",
                    aadharFront,
                        () => pickImage((f) => aadharFront = f),
                  ),

                  buildImagePicker(
                    "Aadhar Back",
                    aadharBack,
                        () => pickImage((f) => aadharBack = f),
                  ),

                  buildImagePicker(
                    "RC Front",
                    rcFront,
                        () => pickImage((f) => rcFront = f),
                  ),

                  buildImagePicker(
                    "RC Back",
                    rcBack,
                        () => pickImage((f) => rcBack = f),
                  ),

                  buildImagePicker(
                    "Car Photo",
                    carPhoto,
                        () => pickImage((f) => carPhoto = f),
                  ),

                  buildImagePicker(
                    "Pollution Photo",
                    pollutionPhoto,
                        () => pickImage((f) => pollutionPhoto = f),
                  ),
                  buildImagePicker(
                    "Old Policy (Optional)",
                    oldPolicy,
                        () => pickImage((f) => oldPolicy = f),
                  ),
                  GestureDetector(
                    onTap: pickMultipleImages,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: isDark ? Colors.white10 : Colors.white,
                      ),
                      child: Row(
                        children: [

                          /// ✅ SMART PREVIEW STACK
                          SizedBox(
                            height: 56,
                            width: 56,
                            child: carMultipleImages.isNotEmpty

                            /// ✅ NEW IMAGES SELECTED
                                ? Stack(
                              children: carMultipleImages.take(3).map((file) {
                                final index =
                                carMultipleImages.indexOf(file);

                                return Positioned(
                                  left: index * 12,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: Image.file(
                                      file,
                                      height: 56,
                                      width: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )

                            /// ✅ SERVER IMAGES BEFORE EDIT
                                : serverMultipleImages.isNotEmpty
                                ? Stack(
                              children:
                              serverMultipleImages.take(3).map((imageUrl) {
                                final index =
                                serverMultipleImages.indexOf(imageUrl);

                                return Positioned(
                                  left: index * 12,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      height: 56,
                                      width: 56,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )

                            /// ✅ NO IMAGE
                                : const Icon(
                              Icons.upload_rounded,
                              color: Colors.indigo,
                            ),
                          ),

                          const SizedBox(width: 14),

                          /// ✅ SMART TEXT
                          Expanded(
                            child: Text(
                              carMultipleImages.isNotEmpty
                                  ? "${carMultipleImages.length} images selected"

                                  : serverMultipleImages.isNotEmpty
                                  ? "${serverMultipleImages.length} existing images"

                                  : "Upload Car Images",

                              style: const TextStyle(
                                fontFamily: "PoppinsMedium",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (serverMultipleImages.isNotEmpty && carMultipleImages.isEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: serverMultipleImages.length,
                        itemBuilder: (context, index) {

                          final imageUrl = serverMultipleImages[index];

                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Stack(
                              children: [

                                /// ✅ IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    imageUrl,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                /// ✅ DELETE ICON
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {

                                      /// ✅ ADD TO DELETE LIST
                                      final relativePath =
                                      imageUrl.replaceFirst(insuranceBaseUrl, "");

                                      deleteImages.add(relativePath);

                                      /// ✅ REMOVE FROM UI
                                      serverMultipleImages.removeAt(index);

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

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    file,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),

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
              child:  Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
            )
        ],
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
}