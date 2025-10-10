import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';

import '../../ui_decoration_tools/app_images.dart';

class AddTenantUnderFutureProperty extends StatefulWidget {
  final String id;
  final String subId;

  const AddTenantUnderFutureProperty({
    super.key,
    required this.id,
    required this.subId,
  });

  @override
  State<AddTenantUnderFutureProperty> createState() =>
      _AddTenantUnderFuturePropertyState();
}

class _AddTenantUnderFuturePropertyState
    extends State<AddTenantUnderFutureProperty> {
  bool _isLoading = false;

  final TextEditingController _tenantName = TextEditingController();
  final TextEditingController _tenantPhone = TextEditingController();
  final TextEditingController _flatRent = TextEditingController();
  final TextEditingController _shiftingDate = TextEditingController();
  final TextEditingController _members = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _tenantVehicle = TextEditingController();
  final TextEditingController _workProfile = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> uploadTenant() async {
    String uploadUrl =
        'https://verifyserve.social/PHP_Files/add_tanant_in_future_property/insert.php';

    FormData formData = FormData.fromMap({
      "tenant_name": _tenantName.text.trim(),
      "tenant_phone_number": _tenantPhone.text.trim(),
      "flat_rent": _flatRent.text.trim(),
      "shifting_date": _shiftingDate.text.trim(),
      "members": _members.text.trim(),
      "email": _email.text.trim(),
      "tenant_vichal_details": _tenantVehicle.text.trim(),
      "work_profile": _workProfile.text.trim(),
      "bhk": '',
      "type_of_property": '',
      "sub_id": widget.id,
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                underflat_futureproperty(Subid: widget.subId, id: widget.id),
          ),
              (route) => route.isFirst,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful: ${response.data}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold,
              color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Add Tenant",style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 5,),
              _buildTextInput('Tenant Name', _tenantName,),

              _buildSectionCard(
                title: "Phone Number",
                child: TextFormField(
                  controller: _tenantPhone,
                  keyboardType: TextInputType.number,
                  maxLength: 10, // ✅ Limit to 10 digits
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    counterText: "", // ✅ hides length counter
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    filled: true,
                    errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Phone Number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
              ),



              Row(
                children: [
                  Expanded(child: _buildTextInput('Rent Amount', _flatRent,),),
                  const SizedBox(width: 12),
                  Expanded(
                      child:    _buildSectionCard(
                        title: "Shifting Date",
                        child: TextFormField(
                          controller: _shiftingDate,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Pick a date",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            filled: true,
                            errorStyle: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select Shifting Date';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2010),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              setState(() {
                                _shiftingDate.text = DateFormat('dd/MM/yyyy').format(picked);
                              });
                            }
                          },
                        ),
                      ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextInput('Family Members', _members,),),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput('Email', _email,),),
                ],
              ),

              Row(
                children: [
                  Expanded(child: _buildTextInput('Vehicle Details', _tenantVehicle,)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput('Work Profile', _workProfile,)),
                ],
              ),


              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      uploadTenant();
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity, // 🔥 Forces full width
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _sectionTitleStyle()),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextInput(String label, TextEditingController controller, {IconData? icon, TextInputType? keyboardType}) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType, // <--- Add this line
        // style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          // ✅ Error text style (deep red)
          errorStyle: const TextStyle(
            color: Colors.redAccent, // deeper red text
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),

          // ✅ Error border (deep red)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent, // deep red border
              width: 2,
            ),
          ),

          // ✅ Focused border when still error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent, // deep red border when focused
              width: 2,
            ),
            // fillColor: Colors.grey.shade100,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  }
}
