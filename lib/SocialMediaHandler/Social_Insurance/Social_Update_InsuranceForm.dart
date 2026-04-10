import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Custom_Widget/constant.dart';
import 'Social_InsuranceShowListPage.dart';

class SocialUpdateInsuranceForm extends StatefulWidget {
  final SocialInsuranceModel item;

  const SocialUpdateInsuranceForm({super.key, required this.item,});

  @override
  State<SocialUpdateInsuranceForm> createState() => _SocialUpdateInsuranceFormState();
}

class _SocialUpdateInsuranceFormState extends State<SocialUpdateInsuranceForm> {

  @override
  void initState() {
    super.initState();
    fetchMultipleImages();

    final item = widget.item;

    // 🔹 TEXT FIELDS
    nameController.text = item.name ?? "";
    numberController.text = item.number ?? "";
    vehicleNumberController.text = item.vehicleNumber ?? "";
    fieldWorkerNameController.text = item.fieldWorkerName ?? "";
    fieldWorkerNumberController.text = item.fieldWorkerNumber ?? "";
    emailController.text = item.emailId ?? "";
    nomineeNameController.text = item.nomineeName ?? "";
    nomineeAgeController.text = item.nomineeAge ?? "";
    nomineeRelationController.text = item.nomineeRelation ?? "";

    claimStatus = item.claim ?? "No";
    pollutionStatus = item.pollutionYesNo ?? "No";

    // ✅ CATEGORY FIX
    if (item.vehicle_category != null &&
        item.vehicle_category!.trim().isNotEmpty) {
      selectedCategory = vehicleCategoryOptions.firstWhere(
            (e) =>
        e.toLowerCase().trim() ==
            item.vehicle_category!.toLowerCase().trim(),
        orElse: () => "",
      );

      if (selectedCategory == "") {
        selectedCategory = null;
      }
    }

    // ✅ WHEELER FIX
    if (item.vehicleType != null &&
        item.vehicleType!.trim().isNotEmpty) {
      selectedWheeler = wheelOptions.firstWhere(
            (e) =>
        e.toLowerCase().trim() ==
            item.vehicleType!.toLowerCase().trim(),
        orElse: () => "",
      );

      if (selectedWheeler == "") {
        selectedWheeler = null;
      }
    }

    // ✅ FUEL FIX
    if (item.fuelType != null &&
        item.fuelType!.trim().isNotEmpty) {
      selectedFuel = fuelOptions.firstWhere(
            (e) =>
        e.toLowerCase().trim() ==
            item.fuelType!.toLowerCase().trim(),
        orElse: () => "",
      );

      if (selectedFuel == "") {
        selectedFuel = null;
      }
    }
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
  File? panCardPhoto;

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
          "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/show_insurance_multiple_image.php?subid=${widget
              .item.id}"));

      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true) {
        final List data = decoded['data'];

        serverMultipleImages =
            data
                .map<String>((e) => insuranceBaseUrl + e['car_images'])
                .toList();
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
      "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/";

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

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://verifyrealestateandservices.in/PHP_Files/'
              'insurance_insert_api/insurance_details/'
              'insurance_update.php',
        ),
      );

      request.fields['id'] = widget.item.id.toString();
      request.fields['name_'] = nameController.text;
      request.fields['number'] = numberController.text;
      request.fields['vehicle_number'] = vehicleNumberController.text;
      request.fields['fieldworkar_name'] =
          widget.item.fieldWorkerName.toString();
      request.fields['fieldworkar_number'] =
          widget.item.fieldWorkerNumber.toString();
      // ✅ NOW SAFE
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select vehicle category")),
        );
        setState(() => isLoading = false);
        return;
      }
      request.fields['vehicle_category'] = selectedCategory!;

      if (selectedWheeler == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select wheeler type")),
        );
        setState(() => isLoading = false);
        return;
      }
      request.fields['vehicle_type'] = selectedWheeler!;

      // ✅ VALIDATE FIRST
      if (selectedFuel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select fuel type")),
        );
        setState(() => isLoading = false);
        return;
      }
      request.fields['petrol_desiel'] = selectedFuel!;

      request.fields['current_dates'] =
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      request.fields['email_id'] = emailController.text;
      request.fields['Nominie_name'] = nomineeNameController.text;
      request.fields['Nominie_age'] = nomineeAgeController.text;
      request.fields['Nominie_relation'] = nomineeRelationController.text;
      request.fields['claim'] = claimStatus;
      request.fields['polution_yes_no'] = pollutionStatus;


      /// ✅ DOCUMENTS


      /// 🔹 PAN FILE
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
      print("Delete Images List Length: ${deleteImages.length}");
      print("Delete Images List Data: $deleteImages");

      for (int i = 0; i < deleteImages.length; i++) {
        request.fields['delete_images[$i]'] = deleteImages[i];
      }

      print("Final Request Fields: ${request.fields}");


      print("Final Request Fields: ${request.fields}");

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
    super.dispose();
  }

  /// ✅ PREMIUM IMAGE PICKER WITH PREVIEW
  Widget buildImagePicker(String title, File? file, VoidCallback onTap) {
    final theme = Theme.of(context);
    final networkUrl = _getNetworkUrl(title);
    final isUploaded = file != null || networkUrl != null;

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
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),

        child: Row(
          children: [

            /// PREVIEW BOX
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),

                child: file != null
                    ? Image.file(
                  file,
                  fit: BoxFit.cover,
                )
                    : networkUrl != null
                    ? Image.network(
                  networkUrl,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.upload_file,
                  size: 20,
                  color: theme.iconTheme.color,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: "PoppinsMedium",
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    file != null
                        ? "New image selected"
                        : networkUrl != null
                        ? "Existing image"
                        : "Tap to upload",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            /// CHECK ICON
            if (isUploaded)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18,
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
                "Update Insurance Form",
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

      case "PAN Card Photo":
        return item.panCardPhotoUrl;

      case "Vehicle Photo":
        return item.carPhotoUrl;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final hasServerImage =
        widget.item.pollutionPhotoUrl != null;

    return Scaffold(

      backgroundColor:
      isDark ? const Color(0xFF020617) : Colors.grey.shade50,

      // appBar: AppBar(
      //   backgroundColor: isDark ? const Color(0xFF020617) : Colors.grey.shade100,
      //   surfaceTintColor:
      //   isDark ? const Color(0xFF020617) : Colors.grey.shade100,
      //
      //   title: const Text("Insurance Details",style: TextStyle(fontFamily: "PoppinsMedium"),),
      //   elevation: 0,
      // ),

      body: Stack(
        children: [

          Column(
            children: [

              /// 🔥 PREMIUM HEADER
              buildPremiumHeader(),

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


                        buildVehicleCategoryDropdown(),
                        buildWheelerDropdown(),
                        buildFuelDropdown(),


                        buildTextField("Nominee Name", nomineeNameController),

                        buildTextField(
                          "Nominee Age",
                          nomineeAgeController,
                          keyboardType: TextInputType.number,
                        ),
                        buildTextField(
                            "Nominee Relation", nomineeRelationController),

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

                        const SizedBox(height: 20),

                        /// ✅ SECTION: DOCUMENTS
                        buildSectionTitle("Upload Documents"),

                        const SizedBox(height: 12),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.1,

                          children: [

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
                              "Vehicle Photo",
                              carPhoto,
                                  () => pickImage((f) => carPhoto = f),
                            ),

                            buildImagePicker(
                              "PAN Card Photo",
                              panCardPhoto,
                                  () => pickImage((f) => panCardPhoto = f),
                            ),

                            buildImagePicker(
                              "Pollution Photo",
                              pollutionPhoto,
                                  () => pickImage((f) => pollutionPhoto = f),
                            ),

                            buildImagePicker(
                              "Old Policy (Optional)",
                              oldPolicy,
                                  () => pickImage((f) => oldPolicy = f), ),
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

                                /// PREVIEW STACK
                                SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: Stack(
                                    children: [

                                      if (carMultipleImages.isNotEmpty)
                                        ...carMultipleImages.take(3).map((file) {
                                          final index = carMultipleImages.indexOf(file);

                                          return Positioned(
                                            left: index * 10,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.file(
                                                file,
                                                height: 48,
                                                width: 48,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }),

                                      if (carMultipleImages.isEmpty && serverMultipleImages.isNotEmpty)
                                        ...serverMultipleImages.take(3).map((url) {
                                          final index = serverMultipleImages.indexOf(url);

                                          return Positioned(
                                            left: index * 10,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                url,
                                                height: 48,
                                                width: 48,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }),

                                      if (carMultipleImages.isEmpty && serverMultipleImages.isEmpty)
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
                                    ],
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
                                        carMultipleImages.isNotEmpty
                                            ? "${carMultipleImages.length} images selected"
                                            : serverMultipleImages.isNotEmpty
                                            ? "${serverMultipleImages.length} existing images"
                                            : "Tap to upload vehicle images",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),

                                if (carMultipleImages.isNotEmpty || serverMultipleImages.isNotEmpty)
                                  const Icon(Icons.check_circle, color: Colors.green),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (serverMultipleImages.isNotEmpty && carMultipleImages.isEmpty)
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: serverMultipleImages.length,
                              itemBuilder: (context, index) {

                                final imageUrl = serverMultipleImages[index];

                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Stack(
                                    children: [

                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          imageUrl,
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

                                            final fileName = imageUrl.split('/').last;
                                            final dbPath = "insurance_uploads/$fileName";

                                            deleteImages.add(dbPath);
                                            serverMultipleImages.removeAt(index);

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
            ],
          ),

          /// ✅ LOADING OVERLAY
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: Center(
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

  Widget buildRadioRow(String title,
      String groupValue,
      Function(String) onChanged,) {
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

            /// YES OPTION
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

            /// NO OPTION
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
}