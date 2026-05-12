import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

class InsuranceFormScreen extends StatefulWidget {
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  const InsuranceFormScreen({
    super.key,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber});

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
  File? panCardPhoto;

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

    /// VALIDATIONS FIRST
    if (selectedCategory == null) {
      showSnack("Please select vehicle category");
      return;
    }

    if (selectedWheeler == null) {
      showSnack("Please select wheeler type");
      return;
    }

    if (selectedFuel == null) {
      showSnack("Please select fuel type");
      return;
    }

    if (pollutionStatus == "Yes" && pollutionPhoto == null) {
      showSnack("Upload Pollution Photo");
      return;
    }


    setState(() => isLoading = true);

    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '00',
        ),
      );

      /// FIELDS
      request.fields['name_'] = nameController.text.trim();
      request.fields['number'] = numberController.text.trim();
      request.fields['vehicle_number'] = vehicleNumberController.text.trim();
      request.fields['vehicle_category'] = selectedCategory!;
      request.fields['vehicle_type'] = selectedWheeler!;
      request.fields['petrol_desiel'] = selectedFuel!;
      request.fields['fieldworkar_name'] = widget.fieldWorkerName;
      request.fields['fieldworkar_number'] = widget.fieldWorkerNumber;
      request.fields['email_id'] = emailController.text.trim();
      request.fields['Nominie_name'] = nomineeNameController.text.trim();
      request.fields['Nominie_age'] = nomineeAgeController.text.trim();
      request.fields['Nominie_relation'] = nomineeRelationController.text.trim();
      request.fields['claim'] = claimStatus;
      request.fields['polution_yes_no'] = pollutionStatus;
      request.fields['expiry_date'] = expiryDateController.text.trim();

      request.fields['current_dates'] =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      /// FILE UPLOADS

      if (panCardPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'pan_card_photo',
          panCardPhoto!.path,
        ));
      }

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

      /// MULTIPLE CAR IMAGES

      print("Total Multiple Images Selected: ${carMultipleImages.length}");

      for (var image in carMultipleImages) {

        print("Uploading Image: ${image.path}");

        request.files.add(
          await http.MultipartFile.fromPath(
            'car_images[]',
            image.path,
          ),
        );
      }

      /// DEBUG FILES

      print("------ FILES GOING TO API ------");

      for (var file in request.files) {
        print("FIELD: ${file.field}");
        print("FILE NAME: ${file.filename}");
      }

      print("TOTAL FILES SENT: ${request.files.length}");

      /// SEND REQUEST

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: $responseBody");

      if (response.statusCode == 200) {

        final decoded = jsonDecode(responseBody);

        /// SUCCESS
        if (decoded["status"] == true) {

          setState(() => isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Submitted Successfully')),
          );

          Navigator.pop(context, true);
        }

        /// DUPLICATE VEHICLE
        else if (decoded["status"] == false &&
            decoded["vehicle_number"] != null) {

          setState(() => isLoading = false);

          final vehicleNumber = decoded["vehicle_number"];
          final addedByName = decoded["added_by_fieldworker_name"];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Vehicle $vehicleNumber already exists\nAdded by: $addedByName",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );

          vehicleNumberController.clear();
        }

        /// OTHER FAILURE
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

  void showSnack(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }



  List<String> vehicleCategoryOptions = [
    "Commercial",
    "Private",
  ];

  List<String> wheelOptions = [
    "2 Wheeler",
    "3 Wheeler",
    "4 Wheeler",
    "6 Wheeler",
    "8 Wheeler",
  ];

  String? selectedCategory;
  String? selectedWheeler;

  List<String> fuelOptions = [
    "Petrol / CNG",
    "Petrol",
    "Diesel",
    "CNG",
    "EV",
  ];

  String? selectedFuel;

  Future<void> pickMultipleImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 75);
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      carMultipleImages = pickedFiles.map((e) => File(e.path)).toList();
      setState(() {});
    }
  }

  Widget buildTextField(String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int? maxLength,
        bool isRequired = false,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,

        validator: (value) {
          if (isRequired) {
            if (value == null || value
                .trim()
                .isEmpty) {
              return 'Required';
            }
          }

          if (keyboardType == TextInputType.phone &&
              value != null &&
              value.isNotEmpty) {
            if (value.length != 10) {
              return 'Enter valid 10-digit number';
            }
          }

          if (label.toLowerCase().contains("vehicle number") &&
              value != null &&
              value.isNotEmpty) {
            if (value.length < 6) {
              return 'Enter valid vehicle number';
            }
          }

          return null;
        },

        style: theme.textTheme.bodyMedium?.copyWith(
          fontFamily: "PoppinsMedium",
        ),

        decoration: InputDecoration(

          counterText: "",

          labelText: label,

          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontFamily: "PoppinsMedium",
          ),

          filled: true,

          fillColor: theme.cardColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: theme.dividerColor,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: theme.dividerColor,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRadioRow(
      String title,
      String groupValue,
      Function(String) onChanged,
      ) {

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: groupValue.isNotEmpty
                ? theme.colorScheme.primary
                : theme.dividerColor,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),

        child: Row(
          children: [

            /// TITLE
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: "PoppinsMedium",
                ),
              ),
            ),

            /// YES
            Row(
              children: [
                Radio<String>(
                  value: "Yes",
                  groupValue: groupValue,
                  activeColor: theme.colorScheme.primary,
                  visualDensity: VisualDensity.compact,
                  onChanged: (v) => onChanged(v!),
                ),

                Text(
                  "Yes",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            /// NO
            Row(
              children: [
                Radio<String>(
                  value: "No",
                  groupValue: groupValue,
                  activeColor: theme.colorScheme.primary,
                  visualDensity: VisualDensity.compact,
                  onChanged: (v) => onChanged(v!),
                ),

                Text(
                  "No",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  /// ✅ PREMIUM IMAGE PICKER WITH PREVIEW
  Widget buildUploadCard(String title, File? file, VoidCallback onTap) {

    final theme = Theme.of(context);
    final isUploaded = file != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: isUploaded
                ? theme.colorScheme.primary
                : theme.dividerColor,
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0,2),
            )
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// ICON / IMAGE
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),

              child: file != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.upload_file,
                size: 20,
                color: theme.iconTheme.color,
              ),
            ),

            const SizedBox(height: 6),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 2),

            /// STATUS
            Text(
              isUploaded ? "Uploaded" : "Upload",
              style: theme.textTheme.labelSmall?.copyWith(
                color: isUploaded
                    ? Colors.green
                    : theme.hintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    Function(String?)? onChanged,
    String hint = "Select",
  }) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: "PoppinsMedium",
            ),
          ),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: value == null
                    ? theme.dividerColor
                    : theme.colorScheme.primary,
              ),
            ),

            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,

                /// 👇 Theme Based Dropdown Background
                dropdownColor: isDark
                    ? const Color(0xFF020617)   // dark dropdown
                    : Colors.white,            // light dropdown

                hint: Text(
                  hint,
                  style: theme.textTheme.bodySmall,
                ),

                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),

                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.iconTheme.color,
                ),

                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVehicleCategoryDropdown() {
    return buildDropdownField(
      label: "Vehicle Category *",
      value: selectedCategory,
      items: vehicleCategoryOptions,
      hint: "Select Category",
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
          selectedWheeler = null;
          vehicleTypeController.clear();
        });
      },
    );
  }

  Widget buildWheelerDropdown() {
    return buildDropdownField(
      label: "Wheeler Type *",
      value: selectedWheeler,
      items: wheelOptions,
      hint: selectedCategory == null
          ? "Select category first"
          : "Select Wheeler",
      onChanged: selectedCategory == null
          ? null
          : (value) {
        setState(() {
          selectedWheeler = value;
          vehicleTypeController.text =
          "${selectedCategory!} | ${selectedWheeler!}";
        });
      },
    );
  }

  Widget buildFuelDropdown() {
    return buildDropdownField(
      label: "Fuel Type *",
      value: selectedFuel,
      items: fuelOptions,
      hint: "Select Fuel Type",
      onChanged: (value) {
        setState(() {
          selectedFuel = value;
        });
      },
    );
  }

  Widget buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A),
            Color(0xFF020617),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔝 TOP ROW (Back + Logo)
              Row(
                children: [

                  /// BACK BUTTON
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 250),

                  /// LOGO
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage(AppImages.logo),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// 📝 FORM TITLE
              const Text(
                "Insurance Form",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Application",
                style: TextStyle(
                  color: Color(0xFFFACC15),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [

        const Icon(
          Icons.folder,
          size: 18,
          color: Color(0xFFFACC15),
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF020617) : Colors.grey.shade50,

        body: Stack(
            children: [

            Column(
            children: [

            /// 🔥 PREMIUM HEADER
            buildPremiumHeader(),

        /// 🔥 FORM AREA
        Expanded(
            child: SingleChildScrollView(
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

                  buildVehicleCategoryDropdown(),
                  buildWheelerDropdown(),
                  buildFuelDropdown(),

                   SizedBox(height: 10),
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

                  buildRadioRow(
                    "Pollution",
                    pollutionStatus,
                        (v) => setState(() => pollutionStatus = v),
                  ),

                  if (pollutionStatus == "Yes")
                    buildUploadCard(
                      "Pollution Photo",
                      pollutionPhoto,
                          () => pickImage((f) => pollutionPhoto = f),
                    ),

                  /// ✅ SECTION: DOCUMENTS
                  SizedBox(height: 16,),

                  buildSectionTitle("Document Uploads"),


                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.1,

                    children: [

                      buildUploadCard(
                        "Aadhar Front",
                        aadharFront,
                            () => pickImage((f) => aadharFront = f),
                      ),

                      buildUploadCard(
                        "Aadhar Back",
                        aadharBack,
                            () => pickImage((f) => aadharBack = f),
                      ),

                      buildUploadCard(
                        "RC Front",
                        rcFront,
                            () => pickImage((f) => rcFront = f),
                      ),

                      buildUploadCard(
                        "RC Back",
                        rcBack,
                            () => pickImage((f) => rcBack = f),
                      ),

                      buildUploadCard(
                        "Vehicle Photo",
                        carPhoto,
                            () => pickImage((f) => carPhoto = f),
                      ),

                      buildUploadCard(
                        "PAN Card",
                        panCardPhoto,
                            () => pickImage((f) => panCardPhoto = f),
                      ),

                      buildUploadCard(
                        "Old Policy",
                        oldPolicy,
                            () => pickImage((f) => oldPolicy = f),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: pickMultipleImages,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          /// ICON BOX
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Icon(
                              Icons.upload_file,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Car Multiple Images",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: "PoppinsMedium",
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  carMultipleImages.isEmpty
                                      ? "Tap to upload vehicle images"
                                      : "${carMultipleImages.length} images selected",
                                  style: Theme.of(context).textTheme.bodySmall,
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

                  SizedBox(height: 20,),

                  if (carMultipleImages.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: carMultipleImages.length,
                        itemBuilder: (context, index) {

                          final file = carMultipleImages[index];

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Stack(
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
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
                        const Color(0xFFE6C47A),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "SUBMIT DETAILS",
                        style: TextStyle(
                          color: Colors.black,
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
    ]),
    );
  }
}

