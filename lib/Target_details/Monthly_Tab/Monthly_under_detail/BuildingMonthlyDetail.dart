import 'package:flutter/material.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_under_detail/Monthly_Building.dart';

class BuildingMonthlyDetailScreen extends StatelessWidget {
  final MonthlyBuilding p;

  const BuildingMonthlyDetailScreen({
    super.key,
    required this.p,
  });

  static const Color primary = Color(0xFFD747FF);
  static const String font = "PoppinsMedium";

  String safe(String? v) {
    if (v == null) return "—";
    if (v.trim().isEmpty) return "—";
    if (v.toLowerCase() == "null") return "—";
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA);

    final cardColor =
    isDark ? const Color(0xFF1A1A1A) : Colors.white;

    final textColor =
    isDark ? Colors.white : const Color(0xFF111827);

    final subText =
    isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// ================= IMAGE HEADER =================
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const BackButton(color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Image.network(
                    "https://verifyserve.social/Second%20PHP%20FILE/"
                        "new_future_property_api_with_multile_images_store/${p.image}",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey),
                  ),

                  /// 🔥 Gradient Depth (Premium Feel)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 PROPERTY TITLE
                  Text(
                    safe(p.propertyName),
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: font,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${safe(p.place)} • ${safe(p.localityList)}",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: font,
                      color: subText,
                    ),
                  ),

                  const SizedBox(height: 26),

                  /// ================= BASIC INFO =================
                  _sectionCard(
                    context,
                    "PROPERTY OVERVIEW",
                    [
                      _dataRow(context, "Address", p.propertyAddress, true),
                      _dataRow(context, "Listing Type", p.buyRent),
                      _dataRow(context, "Category", p.residenceType),
                      _dataRow(context, "Total Floors", p.totalFloor),
                      _dataRow(context, "Age of Property", p.ageOfProperty),
                      _dataRow(context, "Metro Distance", p.metroDistance),
                      _dataRow(context, "Metro Name", p.metroName),
                      _dataRow(context, "Market Distance", p.marketDistance),
                    ],
                    cardColor,
                    subText,
                    textColor,
                  ),

                  /// ================= FACILITY =================
                  _sectionCard(
                    context,
                    "FACILITY",
                    [
                      _dataRow(context, "Parking", p.parking),
                      _dataRow(context, "Lift", p.lift),
                      _dataRow(context, "Road Size", p.roadSize),
                      _dataRow(context, "Facilities", p.facility),
                    ],
                    cardColor,
                    subText,
                    textColor,
                  ),

                  /// ================= CONTACT =================
                  _sectionCard(
                    context,
                    "CONTACT DETAILS",
                    [
                      _dataRow(context, "Owner Name", p.ownerName, true),
                      _dataRow(context, "Owner Number", p.ownerNumber),
                      const Divider(height: 22),
                      _dataRow(context, "Caretaker Name", p.caretakerName),
                      _dataRow(context, "Caretaker Number", p.caretakerNumber),
                    ],
                    cardColor,
                    subText,
                    textColor,
                  ),

                  /// ================= FIELD WORKER =================
                  _sectionCard(
                    context,
                    "FIELD WORKER",
                    [
                      _dataRow(context, "Name", p.fieldWorkerName, true),
                      _dataRow(context, "Number", p.fieldWorkerNumber),
                    ],
                    cardColor,
                    subText,
                    textColor,
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION CARD =================
  Widget _sectionCard(
      BuildContext context,
      String title,
      List<Widget> children,
      Color cardColor,
      Color subText,
      Color textColor,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontFamily: font,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  /// ================= DATA ROW =================
  Widget _dataRow(
      BuildContext context,
      String title,
      String? value, [
        bool highlight = false,
      ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: font,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              safe(value),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12.5,
                fontFamily: font,
                fontWeight: FontWeight.w600,
                color: highlight ? primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}