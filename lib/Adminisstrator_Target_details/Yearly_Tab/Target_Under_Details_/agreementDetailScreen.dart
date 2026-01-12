import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Agreement_External.dart'; // <-- apna model import

class AgreementExternalDetail extends StatelessWidget {
  final Agreement agreement;

  const AgreementExternalDetail({super.key, required this.agreement});

  // ===== COLORS =====
  static const bgDark = Color(0xFF0E1621);
  static const cardDark = Color(0xFF121E2B);
  static const primaryBlue = Color(0xFF2F80FF);
  static const softBlue = Color(0xFF1E3A5F);
  static const textLight = Color(0xFFEAF1FF);
  static const textGrey = Color(0xFF9FB3C8);

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [

          /// ================= HEADER =================
          Container(
            height: 320,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A5F), Color(0xFF0E1621)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: agreement.tenantImage.isNotEmpty
                ? Image.network(
              img(agreement.tenantImage),
              fit: BoxFit.cover,
            )
                : const Center(
              child: Icon(Icons.picture_as_pdf,
                  size: 90, color: Colors.white70),
            ),
          ),

          /// ================= TOP BAR =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(Icons.arrow_back, () => Navigator.pop(context)),
                  Row(
                    children: [
                      _circleBtn(Icons.picture_as_pdf, () {
                        if (agreement.agreementPdf.isNotEmpty) {
                          openLink(img(agreement.agreementPdf));
                        }
                      }),
                      const SizedBox(width: 8),
                      _circleBtn(Icons.call, () {
                        openLink("tel:${agreement.ownerMobile}");
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),

          /// ================= DETAILS SHEET =================
          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.72,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: bgDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView(
                  controller: controller,
                  children: [

                    /// TAG
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: softBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          agreement.agreementType,
                          style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ADDRESS
                    Text(
                      agreement.rentedAddress,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textLight),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Shifting Date: ${agreement.shiftingDate}",
                      style: const TextStyle(color: textGrey),
                    ),

                    const SizedBox(height: 14),

                    /// PRICE + STATS
                    Row(
                      children: [
                        Text(
                          "₹ ${agreement.monthlyRent} / month",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textLight),
                        ),
                        const Spacer(),
                        _miniInfo(agreement.bhk, "BHK"),
                        _miniInfo(agreement.floor, "Floor"),
                        _miniInfo(agreement.parking, "Parking"),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// RENT INFO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoCard("Security", "₹${agreement.security}"),
                        _infoCard("Inst.", "₹${agreement.installmentSecurity}"),
                        _infoCard("Meter", "₹${agreement.customMeterUnit}"),
                        _infoCard("Maint.", "₹${agreement.customMaintenanceCharge}"),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// OWNER
                    _sectionTitle("Owner Details"),
                    _personCard(
                      name:
                      "${agreement.ownerName} (${agreement.ownerRelation} ${agreement.ownerRelationPerson})",
                      phone: agreement.ownerMobile,
                      icon: Icons.person,
                    ),
                    _locationCard(agreement.ownerAddress),
                    _chip("Aadhar: ${agreement.ownerAadhar}"),

                    const SizedBox(height: 14),

                    /// TENANT
                    _sectionTitle("Tenant Details"),
                    _personCard(
                      name:
                      "${agreement.tenantName} (${agreement.tenantRelation} ${agreement.tenantRelationPerson})",
                      phone: agreement.tenantMobile,
                      icon: Icons.person_outline,
                    ),
                    _locationCard(agreement.tenantAddress),
                    _chip("Aadhar: ${agreement.tenantAadhar}"),

                    const SizedBox(height: 18),

                    /// PROPERTY
                    _sectionTitle("Property Info"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip("Meter: ${agreement.meter}"),
                        _chip("Maintenance: ${agreement.maintenance}"),
                        _chip("Furniture: ${agreement.furniture}"),
                        _chip("Parking: ${agreement.parking}"),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// COMPANY
                    if (agreement.companyName != null &&
                        agreement.companyName!.isNotEmpty) ...[
                      _sectionTitle("Company"),
                      _locationCard(agreement.companyName!),
                      if (agreement.gstNo != null) _chip("GST: ${agreement.gstNo}"),
                      if (agreement.panNo != null) _chip("PAN: ${agreement.panNo}"),
                    ],

                    const SizedBox(height: 18),

                    /// FIELD WORKER
                    _sectionTitle("Field Worker"),
                    _chip(
                        "${agreement.fieldWorkerName} (${agreement.fieldWorkerNumber})"),

                    const SizedBox(height: 18),

                    /// DOCUMENTS
                    _sectionTitle("Documents"),
                    Row(
                      children: [
                        Expanded(child: Image.network(img(agreement.ownerAadharFront))),
                        const SizedBox(width: 6),
                        Expanded(child: Image.network(img(agreement.ownerAadharBack))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: Image.network(img(agreement.tenantAadharFront))),
                        const SizedBox(width: 6),
                        Expanded(child: Image.network(img(agreement.tenantAadharBack))),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return CircleAvatar(
      backgroundColor: Colors.black45,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }

  Widget _miniInfo(String v, String t) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Column(
        children: [
          Text(v,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: textLight)),
          Text(t, style: const TextStyle(fontSize: 12, color: textGrey)),
        ],
      ),
    );
  }

  Widget _infoCard(String t, String v) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(v,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: textLight, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(t, style: const TextStyle(color: textGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        t,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: textLight),
      ),
    );
  }

  Widget _chip(String t) {
    return Container(
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(t, style: const TextStyle(color: textGrey)),
    );
  }

  Widget _personCard({
    required String name,
    required String phone,
    required IconData icon,
  }) {
    return Card(
      color: cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(name, style: const TextStyle(color: textLight)),
        subtitle: Text(phone, style: const TextStyle(color: textGrey)),
        trailing: const Icon(Icons.call, color: primaryBlue),
      ),
    );
  }

  Widget _locationCard(String address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(address, style: const TextStyle(color: textGrey)),
    );
  }
}
