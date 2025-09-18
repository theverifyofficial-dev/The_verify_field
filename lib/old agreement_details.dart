import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui_decoration_tools/constant.dart';
import '../model/Agreement_model.dart';
import 'Administrator/Administator_Agreement/Admin_All_agreement_model.dart';
import 'Administrator/imagepreviewscreen.dart';

class AgreementDetails1 extends StatefulWidget {
  const AgreementDetails1({super.key});

  @override
  State<AgreementDetails1> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AgreementDetails1> {
  List<AdminAllAgreementModel> agreements = [];
  bool isLoading = true;
  String? mobileNumber;


  @override
  void initState() {
    super.initState();
    fetchAgreements();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null) {
      fetchAgreements();
    }
  }



  Future<void> fetchAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/main_application/show_agreement_by_fieldworkar.php?Fieldwarkarnumber=$mobileNumber'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map && decoded['success'] == true) {
          final data = decoded['data'];
          if (data is List) {
            setState(() {
              agreements = data
                  .map((e) => AdminAllAgreementModel.fromJson(e))
                  .toList()
                  .reversed
                  .toList();
              isLoading = false;
            });
          } else {
            throw Exception('Data is not a list');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  _launchURL(String pdf_url) async {
    final Uri url = Uri.parse(pdf_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.black,
          backgroundColor: Colors.black,
          title: Image.asset(AppImages.verify, height: 75),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
          itemCount: agreements.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final item = agreements[index];
            return
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    _ownerCard(item),
                    const SizedBox(width: 12),
                    _tenantCard(item),
                    const SizedBox(width: 12),
                    _propertyCard(item),
                  ],
                ),
              );
          },
        ),
      ),
    );
  }
  String getFullImageUrl(String path) {
    path = path.replaceFirst(RegExp(r'^/?uploads/'), '');
    return 'https://theverify.in/uploads/$path';
  }

  Widget _text(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );

  Widget _image(String url) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(imageUrl: url),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey,
          width: 100,
          height: 100,
          child: const Icon(Icons.error, color: Colors.red),
        ),
      ),
    ),
  );

  Widget _ownerCard(AdminAllAgreementModel item) {
    print('${item.tenantAadharBack}');
    return Container(
      width: 300,
      child:
      Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text("🆔 ID: ${item.id}"),
              _text("🏠 Owner Name: ${item.ownerName}"),
              _text("👨‍👦 Owner Relation: ${item.ownerRelation} ${item.relationPersonNameOwner}"),
              _text("📫 Owner Address: ${item.parmanentAddresssOwner}"),
              _text("📞 Owner Mobile: ${item.ownerMobileNo}"),
              _text("🪪 Owner Aadhaar: ${item.ownerAddharNo}"),
              const SizedBox(height: 10),
              _text("📄 Owner Aadhaar (Front & Back):"),
              Row(
                children: [
                  _image('https://theverify.in/${item.ownerAadharFront}'),
                  const SizedBox(width: 10),
                  _image('https://theverify.in/${item.ownerAadharBack}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Tenant Card
  Widget _tenantCard(AdminAllAgreementModel item) {
    return Container(
        width: 300,
        height: 353,
        child: Card(
          color: Colors.grey[850],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _text("👤 Tenant Name: ${item.tenantName}"),
                _text("👨‍👦 Tenant Relation: ${item.tenantRelation} ${item.relationPersonNameTenant}"),
                _text("📫 Tenant Address: ${item.permanentAddressTenant}"),
                _text("📞 Tenant Mobile: ${item.tenantMobileNo}"),
                const SizedBox(height: 10),
                _text("🪪 Tenant Aadhaar: ${item.tenantAddharNo}"),
                const SizedBox(height: 10),
                _text("📄 Tenant Aadhaar (Front & Back):"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _image('https://theverify.in/${item.tenantAadharFront}'),
                    const SizedBox(width: 10),
                    _image('https://theverify.in/${item.tenantAadharBack}'),
                  ],
                ),
              ],
            ),
            ),
          ),
        ));
  }

// Property Card with PDF Button
  Widget _propertyCard(AdminAllAgreementModel item) {
    return Container(
      width: 300,
      child: Card(
        color: Colors.grey[850],
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text("📍 Property Address: ${item.rentedAddress}"),
              _text("💰 Monthly Rent: ₹${item.monthlyRent}"),
              _text("💵 Security: ₹${item.securitys}"),
              _text("⚡ Meter: ${item.meter}"),
              _text("📆 Shifting Date: ${_formatDate(item.shiftingDate)}"),
              // _text("📆 Current Date: ${_formatDate(item.current_date)}"), //commented because of wrong year.
              _text("🛠️ Maintenance: ${item.maintaince}"),
              _text("📏 Custom Meter Unit: ${item.customMeterUnit}"),
              _text("🧾 Custom Maintenance Charge: ₹${item.customMaintenanceCharge}"),
              _text("📉 Installment Security Amount: ₹${item.installmentSecurityAmount}"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _launchURL('https://theverify.in/${item.agreementPdf}'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,foregroundColor: Colors.black),
                child: const Text('View Agreement PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate); // ✅ works with "2025-09-17 00:00:00.000000"
      return "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";
    } catch (e) {
      return rawDate; // fallback in case parsing fails
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

}