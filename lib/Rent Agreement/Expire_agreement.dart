import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import '../model/Expire_Agreement.dart';
import 'Expire_aggrement_details.dart';

class AgreementApiService {
  static const String _baseUrl =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement';

  // ✅ FIXED: return type changed from ExpireAgreementData → ExpireAgreementResponse
  static Future<ExpireAgreementResponse> fetchExpiredAgreements({
    required String fieldWorkerNumber,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/agreement_expire.php?Fieldwarkarnumber=$fieldWorkerNumber',
    );

    try {
      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return ExpireAgreementResponse.fromJson(jsonMap); // ✅ FIXED
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Failed to fetch agreements: $e');
    }
  }
}

class ExpireAgreementScreen extends StatefulWidget {
  final String fieldWorkerNumber;

  const ExpireAgreementScreen({
    super.key,
    required this.fieldWorkerNumber,
  });

  @override
  State<ExpireAgreementScreen> createState() => _ExpireAgreementScreenState();
}

class _ExpireAgreementScreenState extends State<ExpireAgreementScreen> {
  List<ExpireAgreementData> _agreements = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchExpiredAgreements();
  }

  Future<void> _fetchExpiredAgreements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await AgreementApiService.fetchExpiredAgreements(
        fieldWorkerNumber: widget.fieldWorkerNumber,
      );

      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);

      final filteredData = result.data.where((item) {
        if (item.renewalDate == null) return true;

        final renewalOnly = DateTime(
          item.renewalDate!.date.year,
          item.renewalDate!.date.month,
          item.renewalDate!.date.day,
        );

        // Future = renew ho gaya = hide
        // Past/aaj = expire ho gaya, renew nahi hua = dikhao
        return !renewalOnly.isAfter(todayOnly);
      }).toList();

      setState(() => _agreements = filteredData);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppImages.transparent, height: 40),centerTitle:  true,
        backgroundColor:  Colors.black,
        surfaceTintColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xfff5f5f5),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            Padding(
              padding: const EdgeInsets.all(40),
              child:
              Text(_errorMessage!,
                style:
                const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,),
            ),
            // const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchExpiredAgreements,
              child: const Text('Retry',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
    }

    if (_agreements.isEmpty) {
      return
       const
       Center(
         child:
         Text(
           'No expired agreements found.',
           style:
           TextStyle(color:Colors.purple),
         ),
       );
    }
    // ✅ Yahan koi extra filter nahi - already _fetchExpiredAgreements mein ho gaya
    return RefreshIndicator(
      onRefresh: _fetchExpiredAgreements,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _agreements.length,
        itemBuilder: (context, index) {
          return _AgreementCard(
            data: _agreements[index],
            onRefresh: _fetchExpiredAgreements,);
        },
      ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  final ExpireAgreementData data;
  final VoidCallback onRefresh; // ✅ ADD KARO
  const _AgreementCard({required this.data,required this.onRefresh});

  String _formatDate(AgreementDate? agreementDate) {
    if (agreementDate == null) return '—';
    final d = agreementDate.date;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Top Section ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ACTIVE badge + days expired chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.circle, color: Color(0xFF4CAF50), size: 8),
                          SizedBox(width: 5),
                          Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Days left/expired chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: data.daysLeft < 0
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.daysLeft < 0
                            ? '${data.daysLeft.abs()} days ago'
                            : '${data.daysLeft} days left',
                        style: TextStyle(
                          color: data.daysLeft < 0
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Agreement thumbnail + type + address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Aadhar front image as thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: data.ownerAadharFront.isNotEmpty
                          ? Image.network(
                        '$baseUrl${data.ownerAadharFront}',
                        width: 56,
                        height: 56,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFFDDE3F0),
                          child: const Icon(Icons.home_work_outlined,
                              color: Colors.blueGrey, size: 28),
                        ),
                      )
                          : Container(
                        width: 56,
                        height: 56,
                        color: const Color(0xFFDDE3F0),
                        child: const Icon(Icons.home_work_outlined,
                            color: Colors.blueGrey, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.agreementType,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          // Text(
                          //   data.rentedAddress.trim().isNotEmpty
                          //       ? data.rentedAddress.trim()
                          //       : '—',
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.grey.shade600,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),

                Divider(color: Colors.grey.shade200, height: 1),
                 const SizedBox(height: 4),

                // Monthly Rent + Shifting Date
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTHLY RENT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${data.monthlyRent} /mo',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SHIFTING DATE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.8,
                            ),

                          ),
                          const SizedBox(height: 6),

                          Row(
                            children: [
                               const Icon(Icons.calendar_today_outlined,
                                  size: 14, color: Colors.purple),

                                const SizedBox(width: 5),

                              Text(
                                _formatDate(data.shiftingDate),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Owner & Tenant info
                _InfoRow(label: 'Owner', value: '${data.ownerName.trim()} (${data.ownerRelation} ${data.relationPersonNameOwner.trim()})'),
                _InfoRow(label: 'Tenant', value: '${data.tenantName.trim()} (${data.tenantRelation} ${data.relationPersonNameTenant.trim()})'),
                _InfoRow(label: 'Security', value: '₹${data.security}'),
                _InfoRow(label: 'Maintenance', value: data.maintaince),
                _InfoRow(label: 'Meter', value: data.meter),
                if (data.renewalDate != null)
                  _InfoRow(
                    label: 'Renewal Date',
                    value: _formatDate(data.renewalDate),
                  ),
               // _InfoRow(label: 'Field Worker', value: '${data.fieldWorkerName} (${data.fieldWorkerNumber})'),

                const SizedBox(height: 16),

                // VIEW DOCUMENT button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    // ✅ Fix — .then() se refresh hoga sirf WAPAS aane ke baad
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpireAgreementDetailPage(data: data),
                        ),
                      ).then((_) {
                        onRefresh(); // ← ab sahi jagah
                      });
                    },
                    icon: const Icon(Icons.open_in_new, size: 18, color: Colors.white),
                    label: const Text(
                      'VIEW DOCUMENT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Strip ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Owner + Tenant initials avatars
                SizedBox(
                  width: 52,
                  height: 28,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.blueGrey.shade300,
                          child: Text(
                            data.ownerName.trim().isNotEmpty
                                ? data.ownerName.trim()[0]
                                : 'O',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.indigo.shade300,
                          child: Text(
                            data.tenantName.trim().isNotEmpty
                                ? data.tenantName.trim()[0]
                                : 'T',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Agreement ID
                Text(
                  'ID: #${data.id}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
            ),
          ),
        ],
      ),
    );
  }
}