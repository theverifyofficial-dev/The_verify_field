import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import 'Insurence_form.dart';

// ── Model (same as before) ───────────────────────────────────
class InsurancePlan {
  final String subid;
  final String companyName;
  final String title;
  final String vehicleValue;
  final String price;
  final String logo;

  const InsurancePlan({
    required this.subid,
    required this.companyName,
    required this.title,
    required this.vehicleValue,
    required this.price,
    required this.logo,
  });

  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      subid: json['subid'] ?? '',
      companyName: json['company_name'] ?? '',
      title: json['tittle'] ?? '',
      vehicleValue: json['vehicle_value'] ?? '',
      price: json['Price'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

// ── Screen ───────────────────────────────────────────────────
class InsurancePlansScreen extends StatefulWidget {
  final String Id; // ← subid pass karo parent se

  const InsurancePlansScreen({
    super.key,
    required this.Id,

  });

  @override
  State<InsurancePlansScreen> createState() => _InsurancePlansScreenState();
}

class _InsurancePlansScreenState extends State<InsurancePlansScreen> {
  List<InsurancePlan> plans = [];
  bool _isLoading = true;
  String? _errorMessage;

  static const String _apiUrl =
      'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/show_api_for_contaion.php';
  static const String _logoBaseUrl =
      'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/insurance_uploads/';

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {

    print(widget.Id);
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          plans = jsonData.map((e) => InsurancePlan.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load plans. Please try again.';
        _isLoading = false;
      });
    }
  }

  Color _getBrandColor(int index) {
    const colors = [
      Color(0xFF117A65), Color(0xFFF48120), Color(0xFF1A5276),
      Color(0xFF00529B), Color(0xFFED1C24), Color(0xFF28B463),
      Color(0xFF1F8A70), Color(0xFF8E44AD), Color(0xFFE74C3C),
      Color(0xFF2E86C1),
    ];
    return colors[index % colors.length];
  }

  String _getInitial(String companyName) =>
      companyName.isEmpty ? '?' : companyName[0].toUpperCase();

  String _formatPrice(String price) {
    try {
      final num value = num.parse(price);
      if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
      if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(1)}K';
      return '₹$price';
    } catch (_) {
      return '₹$price';
    }
  }

  // ── Theme helpers ─────────────────────────────────────────
  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _bgColor => _isDark
      ? const Color(0xFF0D0F14)
      : const Color(0xFFF7F9FB);

  Color get _cardColor => _isDark
      ? const Color(0xFF1C1F28)
      : Colors.white;

  Color get _primaryText => _isDark
      ? const Color(0xFFE8EAF0)
      : const Color(0xFF191C1E);

  Color get _secondaryText => _isDark
      ? const Color(0xFF9A9CAA)
      : const Color(0xFF434654);

  Color get _borderColor => _isDark
      ? const Color(0xFF2C2F3E)
      : const Color(0xFFC3C6D6).withOpacity(0.25);

  Color get _accentBlue =>
      _isDark ? const Color(0xFF4D8AFF) : const Color(0xFF003D9B);

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      extendBody: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:
      _isDark ? const Color(0xFF0D0F14) : Colors.black.withOpacity(0.85),
      elevation: 0,
      title: Image.asset(AppImages.transparent, height: 40),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _isDark
              ? const Color(0xFF2C2F3E)
              : const Color(0xFFC3C6D6).withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                color: _isDark ? Colors.redAccent : Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_errorMessage!,
                style: TextStyle(color: _secondaryText)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPlans,
              style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue),
              child: const Text('Retry',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPlans,
      color: _accentBlue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance Plans',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: _primaryText,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tailored coverage for your life's most valuable assets. "
                  "Secure your future with the industry's most trusted providers.",
              style: TextStyle(
                fontSize: 14,
                color: _secondaryText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ...plans.asMap().entries.map(
                  (entry) => _buildPlanCard(entry.value, entry.key),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(InsurancePlan plan, int index) {
    final brandColor = _getBrandColor(index);
    final logoUrl = _logoBaseUrl + plan.logo;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: _isDark
                ? Colors.black.withOpacity(0.3)
                : const Color(0xFF191C1E).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Logo + Company Name ──
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: brandColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    logoUrl,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.white,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          _getInitial(plan.companyName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    plan.companyName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _accentBlue,       // ← theme-aware
                      letterSpacing: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              plan.title,
              style: TextStyle(
                fontSize: 13,
                color: _secondaryText,          // ← theme-aware
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),

            // ── Price + CTA ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VEHICLE Price',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: _secondaryText,   // ← theme-aware
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatPrice(plan.price),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _primaryText,     // ← theme-aware
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("SubID: ${plan.subid}");
                    final shouldRefresh = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InsuranceForm(
                          plan: plan,
                          subid: widget.Id,), // ← plan pass karo
                      ),
                    );
                    if (shouldRefresh == true) _fetchPlans();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentBlue,  // ← theme-aware
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: _accentBlue.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Process',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}