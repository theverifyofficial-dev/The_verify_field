import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/acceptAgreement.dart';
import '../Admin_Agreement_details.dart';
import 'dart:ui';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _AdminPendingState();
}

class _AdminPendingState extends State<AdminPending> {
  List<AgreementModel2> agreements = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    loadAgreements();
  }

  Future<void> loadAgreements() async {
    try {
      final data = await fetchAgreements();
      setState(() {
        agreements = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading agreements: $e");
    }
  }



  Future<List<AgreementModel2>> fetchAgreements() async {
    final url = Uri.parse(
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement_data_for_admin.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // 🔹 Reverse the mapped list
      return data
          .map((e) => AgreementModel2.fromJson(e))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load agreements');
    }
  }


  Widget _buildAgreementCard(AgreementModel2 agreement,
      {required int displayIndex}) {
    final status = agreement.status?.toLowerCase() ?? '';
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    Color statusColor;
    String statusText;

    if (status == "rejected") {
      statusColor = Colors.red;
      statusText = "REJECTED";
    } else if (status == "fields updated") {
      statusColor = Colors.blue;
      statusText = "UPDATED";
    } else if (status == "awaiting signature") {
      statusColor = Colors.pink;
      statusText = "AWAITING SIGNATURE";
    }
    else {
      statusColor = Colors.green;
      statusText = "UNDER REVIEW";
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white: Colors.grey.shade900 ,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 TOP ROW (Status + View Details)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                  "ID: ${agreement.id}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminAgreementDetails(
                          agreementId: agreement.id),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "VIEW DETAILS",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 TITLE
          Text(
            agreement.Type,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.black : Colors
                  .white,
            ),
          ),

          const SizedBox(height: 6),

          /// 🔹 OWNER + TENANT
          Row(
            children: [
              Expanded(
                child: Text(
                  "Owner: ${agreement.ownerName}",
                  style:  TextStyle(fontWeight: FontWeight.w500,
                      color: isDark ? Colors.black : Colors
                          .white),
                ),
              ),
              Expanded(
                child: Text(
                  "Tenant: ${agreement.tenantName}",
                  textAlign: TextAlign.end,
                  style:  TextStyle(fontWeight: FontWeight.w500,
                    color: isDark ? Colors.black : Colors
                        .white,),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 ADDRESS
          Text(
            "📍${agreement.rentedAddress}",
            style: TextStyle( color: isDark ? Colors.black87: Colors.white ,),
          ),

          const SizedBox(height: 12),

          /// 🔹 DATE ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shifting: ${_formatDate(agreement.shiftingDate.toString().split(' ')[0])}",
                style: TextStyle( color: isDark ? Colors.black : Colors
                    .white, fontSize: 12),
              ),
              Text(
                "Filled: ${_formatDate(agreement.currentDate)}",
                style: TextStyle( color: isDark ? Colors.black : Colors
                    .white, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔹 STATUS MESSAGE BOX
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isDark ? Colors.black87: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: statusColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "${agreement.status ?? 'Pending'} • ${agreement.messages ?? ''}",
                    style:  TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors
                        .black87,),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// 🔹 BOTTOM ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cost ₹${agreement.agreement_price}",
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.black : Colors
                      .white,
                ),
              ),
              Text(
                "By: ${agreement.fieldwarkarname}",
                style: TextStyle( color: isDark ? Colors.black : Colors
                    .white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic rawDate) {
    try {
      String actualDate =
      rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return "--";
      final date = DateTime.parse(actualDate.split(' ')[0]);
      return "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";
    } catch (_) {
      return "--";
    }
  }
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED),))
          : agreements.isEmpty
          ? const Center(child: Text("No agreements found"))
          : ListView.builder(
        itemCount: agreements.length,

        itemBuilder: (context, index) {
          int displayIndex = agreements.length - index;
          return _buildAgreementCard(agreements[index],displayIndex: displayIndex,);
        },
      ),
    );
  }
}
