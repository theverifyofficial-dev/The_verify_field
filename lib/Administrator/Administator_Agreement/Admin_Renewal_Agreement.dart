import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import '../../model/Model_Renewal_agreement.dart';
import 'Admin_Renewal_agreement_details.dart';

class AgreementService {
  static const String _baseUrl =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement';

  static Future<renewalAgreementResponse> fetchRenewalAgreements({
    required String number,
  }) async {

    final uri = Uri.parse(
      '$_baseUrl/30_days_renew_agreement.php?Fieldwarkarnumber=$number',
    );

    try {
      final response = await http
          .get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        print('📦 RAW RESPONSE: ${response.body}'); // ← ADD KARO
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return renewalAgreementResponse.fromJson(jsonMap);

      } else {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to fetch agreements: $e',
      );
    }
  }
}


class AdminDocumentsScreen extends StatefulWidget {
  final String fieldWorkerNumber;

  const AdminDocumentsScreen({
    super.key,
    required this.fieldWorkerNumber,
  });

  @override
  State<AdminDocumentsScreen> createState() =>
      _AdminDocumentsScreenState();
}

class _AdminDocumentsScreenState
    extends State<AdminDocumentsScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  String _location = '';
  String _post = '';

  bool _isAdmin = false;
  bool _isSubAdmin = false;

  final Map<String, List<RenewalAgreementData>> _groupedData = {};
  List<RenewalAgreementData> _agreements = [];
  List<Map<String, String>> _allowedWorkers = [];

  final List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit Kasaniya", "id": "9711775300"},
    {"name": "Ravi Kumar",     "id": "9711275300"},
    {"name": "Faizan Khan",    "id": "9971172204"},
    {"name": "Jitesh Kumar",   "id": "9211335994"},
    {"name": "Yash",           "id": "9211335993"},
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _location = prefs.getString('location') ?? '';
      _post     = prefs.getString('post') ?? '';

      final loc   = _location.toLowerCase();
      final post  = _post.toLowerCase();
      _isAdmin    = post == 'administrator';
      _isSubAdmin = post.contains('sub') && post.contains('admin');

      if (_isAdmin) {
        _allowedWorkers = List.from(fieldWorkers);
      } else if (_isSubAdmin) {
        if (loc.contains('sultanpur')) {
          _allowedWorkers = fieldWorkers.where((fw) =>
          fw['name']!.toLowerCase().contains('sumit') ||
              fw['name']!.toLowerCase().contains('ravi')  ||
              fw['name']!.toLowerCase().contains('faizan')).toList();
        } else if (loc.contains('rajpur') ||
            loc.contains('chhattarpur')   ||
            loc.contains('chattar')        ||
            loc.contains('chhattar')) {
          _allowedWorkers = fieldWorkers.where((fw) =>
          fw['name']!.toLowerCase().contains('jitesh') ||
              fw['name']!.toLowerCase().contains('yash')).toList();
        } else {
          _allowedWorkers = [];
        }
      }

      if (_isAdmin || _isSubAdmin) {
        _groupedData.clear();
        for (final fw in _allowedWorkers) {
          _groupedData[fw['id']!] = [];
          try {
            final response = await AgreementService.fetchRenewalAgreements(
                number: fw['id']!);
            _groupedData[fw['id']!] = response.data;
          } catch (e) {
            debugPrint('Failed to fetch for ${fw['name']}: $e');
          }
        }
      } else {
        final result = await AgreementService.fetchRenewalAgreements(
            number: widget.fieldWorkerNumber);
        _agreements = result.data;
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
        backgroundColor: Colors.black,
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
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // ── ADMIN / SUB-ADMIN VIEW ──────────────────────────────────────
    if (_isAdmin || _isSubAdmin) {
      final bool allEmpty = _allowedWorkers.isEmpty ||
          _allowedWorkers.every((fw) => (_groupedData[fw['id']!] ?? []).isEmpty);

      if (allEmpty) {
        return const Center(child: Text('No expired agreements found.'));
      }

      // Vertical list of workers, each with a horizontal card scroll
      return RefreshIndicator(
        onRefresh: _initializeData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: _allowedWorkers.length,
          itemBuilder: (context, workerIndex) {
            final fw = _allowedWorkers[workerIndex];
            final workerAgreements = _groupedData[fw['id']!] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Worker Header Hamesha Show Hoga
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.purple,
                        child: Text(
                          fw['name']![0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fw['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${workerAgreements.length} agreements',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Data Hai To Cards Show Karo
                if (workerAgreements.isNotEmpty)
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: workerAgreements.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 400,
                          child: _AgreementCard(
                            data: workerAgreements[index],
                            workerNumber: fw['id']!,
                          ),
                        );
                      },
                    ),
                  )

                // Data Nahi Hai To Message Show Karo
                else
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                    Center(
                      child:
                      Image.asset(AppImages.error,height: 40,),
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      );
    }

    // ── NORMAL FIELD WORKER VIEW ────────────────────────────────────
    if (_agreements.isEmpty) {
      return const Center(child: Text('No expired agreements found.'));
    }

    return RefreshIndicator(
      onRefresh: _initializeData,
      child: SizedBox(
        height: 480, // ✅ Card ki actual height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,                  // ✅ Horizontal scroll
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: _agreements.length,
          itemBuilder: (context, index) => SizedBox(
            width: 300, // ✅ Har card ki fixed width
            child: _AgreementCard(
              data: _agreements[index],
              workerNumber: widget.fieldWorkerNumber,
            ),
          ),
        ),
      ),
    );

  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Agreement Card
// ─────────────────────────────────────────────────────────────────────────────

class _AgreementCard extends StatelessWidget {
  final RenewalAgreementData data;
  final String workerNumber;

  const _AgreementCard({
    required this.data,
    required this.workerNumber,
  });

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
    const String baseUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status row ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                color: Color(0xFF4CAF50), size: 8),
                            SizedBox(width: 5),
                            Text('ACTIVE',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
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

                  const SizedBox(height: 12),

                  // ── Thumbnail + Agreement type ────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: data.ownerAadharFront.isNotEmpty
                            ? Image.network(
                          '$baseUrl${data.ownerAadharFront}',
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                            : _placeholder(),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          data.agreementType,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(color: Colors.grey.shade500, height: 20),

                  // ── Rent + Shifting Date ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MONTHLY RENT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 0.8,
                                )),
                            const SizedBox(height: 6),
                            Text('₹${data.monthlyRent} /mo',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SHIFTING DATE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade500,
                                  letterSpacing: 0.8,
                                )),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 14, color: Colors.purple),
                                const SizedBox(width: 5),
                                Text(_formatDate(data.shiftingDate),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.purple,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _InfoRow(
                      label: 'Owner',
                      value:
                      '${data.ownerName.trim()} (${data.ownerRelation} ${data.relationPersonNameOwner.trim()})'),
                  _InfoRow(
                      label: 'Tenant',
                      value:
                      '${data.tenantName.trim()} (${data.tenantRelation} ${data.relationPersonNameTenant.trim()})'),
                  _InfoRow(label: 'Security',    value: '₹${data.security}'),
                  _InfoRow(label: 'Maintenance', value: data.maintaince),
                  _InfoRow(label: 'Meter',       value: data.meter),
                  if (data.renewalDate != null)
                    _InfoRow(
                        label: 'Renewal Date',
                        value: _formatDate(data.renewalDate)),

                  const SizedBox(height: 10),

                  Text('ID: #${data.id}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepOrange,
                        letterSpacing: 0.5,
                      )),
                  const SizedBox(height: 10),

                  // ── VIEW DOCUMENT button ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminRenewalAgreementDetails(data: data),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new,
                          size: 18, color: Colors.white),
                      label: const Text('VIEW DOCUMENT',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom strip ────────────────────────────────────────────
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade50,
          //     border:
          //     Border(top: BorderSide(color: Colors.grey.shade200)),
          //     borderRadius: const BorderRadius.only(
          //       bottomLeft: Radius.circular(16),
          //       bottomRight: Radius.circular(16),
          //     ),
          //   ),
          //   padding:
          //   const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       SizedBox(
          //         width: 52,
          //         height: 28,
          //         child: Stack(
          //           children: [
          //             Positioned(
          //               left: 0,
          //               child: CircleAvatar(
          //                 radius: 14,
          //                 backgroundColor: Colors.blueGrey.shade300,
          //                 child: Text(
          //                   data.ownerName.trim().isNotEmpty
          //                       ? data.ownerName.trim()[0]
          //                       : 'O',
          //                   style: const TextStyle(
          //                       fontSize: 11,
          //                       fontWeight: FontWeight.w700,
          //                       color: Colors.white),
          //                 ),
          //               ),
          //             ),
          //             Positioned(
          //               left: 20,
          //               child: CircleAvatar(
          //                 radius: 14,
          //                 backgroundColor: Colors.indigo.shade300,
          //                 child: Text(
          //                   data.tenantName.trim().isNotEmpty
          //                       ? data.tenantName.trim()[0]
          //                       : 'T',
          //                   style: const TextStyle(
          //                       fontSize: 11,
          //                       fontWeight: FontWeight.w700,
          //                       color: Colors.white),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Text('ID: #${data.id}',
          //           style: TextStyle(
          //             fontSize: 11,
          //             fontWeight: FontWeight.w700,
          //             color: Colors.grey.shade500,
          //             letterSpacing: 0.5,
          //           )),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 56,
    height: 56,
    color: const Color(0xFFDDE3F0),
    child: const Icon(Icons.home_work_outlined,
        color: Colors.blueGrey, size: 28),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Row
// ─────────────────────────────────────────────────────────────────────────────

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
            child: Text('$label:',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                )),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF1A1A2E)),
            ),
          ),
        ],
      ),
    );
  }
}