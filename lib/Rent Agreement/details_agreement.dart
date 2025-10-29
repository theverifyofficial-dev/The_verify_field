import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Custom_Widget/Custom_backbutton.dart';

class AgreementDetailPage extends StatefulWidget {
  final String agreementId;
  const AgreementDetailPage({super.key, required this.agreementId});

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgreementDetail();
  }

  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=${widget.agreementId}"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint("🔹 API Response: $decoded");
        if (decoded["status"] == "success" && decoded["count"] > 0) {
          setState(() {
            agreement = decoded["data"][0];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  // ====== THEME-AWARE DESIGN SYSTEM ======
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _surface => Theme.of(context).colorScheme.surface;
  Color get _onSurface => Theme.of(context).colorScheme.onSurface;
  Color get _background => Theme.of(context).colorScheme.background;
  Color get _muted => Theme.of(context).colorScheme.onSurface.withOpacity(.6);
  Color get _cardBorder => Theme.of(context).dividerColor.withOpacity(.3);

  // Dynamic gradient based on theme
  List<Color> get _backgroundGradient {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [
      _primary.withOpacity(.3),
      _primary.withOpacity(.15),
      _background,
    ]
        : [
      _primary.withOpacity(.8),
      _primary.withOpacity(.4),
      Colors.white,
    ];
  }

  Color get _appBarTextColor {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.white;
  }

  Color get _headerCardColor {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _surface : Colors.white.withOpacity(.95);
  }

  // Enhanced badge with theme support
  Widget _badge(String text, {IconData? icon, Color? color, Color? textColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = color ?? _primary;
    final txtColor = textColor ?? (isDark ? bgColor : bgColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [bgColor.withOpacity(.2), bgColor.withOpacity(.1)]
              : [bgColor.withOpacity(.15), bgColor.withOpacity(.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: bgColor.withOpacity(isDark ? .4 : .3)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark
            ? [
          BoxShadow(
            color: bgColor.withOpacity(.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : [
          BoxShadow(
            color: bgColor.withOpacity(.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: txtColor),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced section card with theme support
  Widget _sectionCard({
    required String title,
    required List<Widget> children,
    IconData icon = Icons.folder_open_outlined,
    Color? accentColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = accentColor ?? _primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorder),
        boxShadow: isDark
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(.3),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced header with gradient accent
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [accent.withOpacity(.15), accent.withOpacity(.08)]
                    : [accent.withOpacity(.08), accent.withOpacity(.02)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withOpacity(.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // Enhanced detail row with theme support
  Widget _detailRow({required String label, required String value, bool isImage = false}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? _onSurface.withOpacity(.05) : _onSurface.withOpacity(.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _muted,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            color: _cardBorder,
          ),
          Expanded(
            child: isImage
                ? _imageThumb(value)
                : SelectableText(
              value,
              style: TextStyle(
                color: _onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced image thumbnail with theme support
  Widget _imageThumb(String path) {
    if (path.trim().isEmpty) return const SizedBox.shrink();
    final full = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    full,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 300,
                      color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 50, color: isDark ? Colors.grey[400]! : Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: isDark ? Colors.grey[400]! : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: isDark ? Colors.black54 : Colors.white54,
                  child: IconButton(
                    icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        width: 120,
        height: 90,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? .3 : .1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                full,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  child: Icon(Icons.broken_image, color: isDark ? Colors.grey[400]! : Colors.grey),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: _primary,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(.3)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Status indicator widget with theme support
  Widget _buildStatusIndicator() {
    final status = agreement?['status']?.toString().toLowerCase() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color statusColor;
    IconData statusIcon;
    String statusText = agreement?['status']?.toString() ?? 'Unknown';

    switch (status) {
      case 'approved':
        statusColor = isDark ? Colors.green[300]! : Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = isDark ? Colors.red[300]! : Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'pending':
        statusColor = isDark ? Colors.orange[300]! : Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = isDark ? Colors.grey[400]! : Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [statusColor.withOpacity(.2), statusColor.withOpacity(.1)]
              : [statusColor.withOpacity(.1), statusColor.withOpacity(.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(isDark ? .4 : .3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agreement Status',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (agreement?['messages']?.toString().isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    agreement!['messages']?.toString() ?? '',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = agreement;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          '${a?["agreement_type"] ?? "Agreement"} Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _appBarTextColor,
          ),
        ),
        leading: const SquareBackButton(),
        // actions: [
        //   if (a != null)
        //     Container(
        //       margin: const EdgeInsets.only(right: 16),
        //       child: CircleAvatar(
        //         backgroundColor: isDark ? Colors.white.withOpacity(.2) : Colors.white.withOpacity(.3),
        //         child: IconButton(
        //           icon: Icon(Icons.share, color: _appBarTextColor, size: 20),
        //           onPressed: () {
        //             // Add share functionality
        //           },
        //         ),
        //       ),
        //     ),
        // ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _backgroundGradient,
            stops: const [0.0, 0.3, 0.7],
          ),
        ),
        child: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: _primary),
              const SizedBox(height: 16),
              Text(
                'Loading Agreement Details...',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : a == null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: isDark ? Colors.white70 : Colors.white.withOpacity(.8),
              ),
              const SizedBox(height: 16),
              Text(
                'No details found',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with badges
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _headerCardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? .2 : .1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agreement #${widget.agreementId}',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a['agreement_type']?.toString() ?? 'Agreement',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if ((a['Bhk'] ?? '').toString().isNotEmpty)
                          _badge('${a['Bhk']} BHK', icon: Icons.home_outlined),
                        if ((a['monthly_rent'] ?? '').toString().isNotEmpty)
                          _badge('₹${a['monthly_rent']}/month', icon: Icons.currency_rupee),
                        if ((a['securitys'] ?? '').toString().isNotEmpty)
                          _badge('₹${a['securitys']} Security', icon: Icons.security),
                        if ((a['floor'] ?? '').toString().isNotEmpty)
                          _badge('Floor ${a['floor']}', icon: Icons.flood_rounded),
                      ],
                    ),
                  ],
                ),
              ),

              // Status indicator
              if (a['status'] != null) ...[
                _buildStatusIndicator(),
                const SizedBox(height: 16),
              ],

              // Horizontal scrollable cards for main details
              SizedBox(
                height: 450,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 340,
                      child: _sectionCard(
                        title: "Owner Details",
                        icon: Icons.person_outline,
                        accentColor: Colors.blue,
                        children: [
                          _detailRow(label: "Owner Name", value: a['owner_name'] ?? ''),
                          _detailRow(
                            label: "Relation",
                            value: "${a['owner_relation'] ?? ''} ${a['relation_person_name_owner'] ?? ''}",
                          ),
                          _detailRow(label: "Address", value: a['parmanent_addresss_owner'] ?? ''),
                          _detailRow(label: "Mobile", value: a['owner_mobile_no'] ?? ''),
                          _detailRow(label: "Aadhar", value: a['owner_addhar_no'] ?? ''),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 340,
                      child: _sectionCard(
                        title: a['agreement_type'] == 'Commercial Agreement'
                            ? 'Director Details'
                            : 'Tenant Details',
                        icon: Icons.verified_user_outlined,
                        accentColor: Colors.green,
                        children: [
                          _detailRow(
                            label: a['agreement_type'] == 'Commercial Agreement'
                                ? 'Director Name'
                                : 'Tenant Name',
                            value: a['tenant_name'] ?? '',
                          ),
                          _detailRow(
                            label: "Relation",
                            value: "${a['tenant_relation'] ?? ''} ${a['relation_person_name_tenant'] ?? ''}",
                          ),
                          _detailRow(label: "Address", value: a['permanent_address_tenant'] ?? ''),
                          _detailRow(label: "Mobile", value: a['tenant_mobile_no'] ?? ''),
                          _detailRow(label: "Aadhar", value: a['tenant_addhar_no'] ?? ''),
                          if (a['agreement_type'] == 'Commercial Agreement') ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.green.withOpacity(.1)
                                    : Colors.green.withOpacity(.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(isDark ? .3 : .2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _detailRow(label: "Company Name", value: a['company_name'] ?? ''),
                                  _detailRow(label: "GST Number", value: a['gst_no'] ?? ''),
                                  _detailRow(label: "PAN Number", value: a['pan_no'] ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 340,
                      child: _sectionCard(
                        title: "Property Details",
                        icon: Icons.assignment_outlined,
                        accentColor: Colors.orange,
                        children: [
                          _detailRow(label: "Property ID", value: a['property_id']?.toString() ?? ''),
                          _detailRow(label: "BHK", value: a['Bhk']?.toString() ?? ''),
                          _detailRow(label: "Floor", value: a['floor']?.toString() ?? ''),
                          _detailRow(label: "Rented Address", value: a['rented_address'] ?? ''),
                          _detailRow(label: "Monthly Rent", value: a['monthly_rent'] != null ? '₹${a['monthly_rent']}' : ''),
                          _detailRow(label: "Security", value: a['securitys'] != null ? '₹${a['securitys']}' : ''),
                          _detailRow(
                            label: "Installment Security",
                            value: a['installment_security_amount'] != null
                                ? '₹${a['installment_security_amount']}'
                                : '',
                          ),
                          _detailRow(label: "Meter", value: a['meter']?.toString() ?? ''),
                          _detailRow(label: "Custom Unit", value: a['custom_meter_unit'] ?? ''),
                          _detailRow(label: "Maintenance", value: a['maintaince'] ?? ''),
                          _detailRow(label: "Parking", value: a['parking'] ?? ''),
                          _detailRow(
                            label: "Shifting Date",
                            value: a['shifting_date']?.toString().contains('T') == true
                                ? a['shifting_date'].toString().split('T')[0]
                                : (a['shifting_date']?.toString() ?? ''),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Field Worker Section
              _sectionCard(
                title: "Field Worker",
                icon: Icons.handyman_outlined,
                accentColor: Colors.purple,
                children: [
                  _detailRow(label: "Name", value: a['Fieldwarkarname'] ?? ''),
                  _detailRow(label: "Number", value: a['Fieldwarkarnumber'] ?? ''),
                ],
              ),

              // Documents Section
              _sectionCard(
                title: "Documents",
                icon: Icons.photo_library_outlined,
                accentColor: Colors.indigo,
                children: [
                  Text(
                    'Click on any document to view full size',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(children: [
                    _detailRow(label: "Owner Aadhaar Front", value: a['owner_aadhar_front'] ?? '', isImage: true),
                    _detailRow(label: "Owner Aadhaar Back", value: a['owner_aadhar_back'] ?? '', isImage: true),
                    _detailRow(label: "Tenant Aadhaar Front", value: a['tenant_aadhar_front'] ?? '', isImage: true),
                    _detailRow(label: "Tenant Aadhaar Back", value: a['tenant_aadhar_back'] ?? '', isImage: true),
                    _detailRow(label: "Tenant Photo", value: a['tenant_image'] ?? '', isImage: true),
                    if (a['agreement_type'] == 'Commercial Agreement') ...[
                      _detailRow(label: "GST Photo", value: a['gst_photo'] ?? '', isImage: true),
                      _detailRow(label: "PAN Photo", value: a['pan_photo'] ?? '', isImage: true),
                    ],
                  ]),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}