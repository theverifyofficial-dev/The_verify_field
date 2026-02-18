import 'package:flutter/material.dart';
import '../Building.dart';

class BuildingDetailScreen extends StatelessWidget {
  final BuildingModel building;

  const BuildingDetailScreen({super.key, required this.building});

  static final Color primary = Color(0xFF22C55E);
  static const String myFont = 'PoppinsMedium';

  /// ================= SAFE VALUE =================
  String safe(dynamic v, {String fallback = "-"}) {
    if (v == null) return fallback;

    final value = v.toString().trim();

    if (value.isEmpty) return fallback;
    if (value.toLowerCase() == "null") return fallback;

    return value;
  }

  /// ================= THEME HELPERS =================
  Color getBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : const Color(0xFFF2F2F7);

  Color getCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black87
          : Colors.white;

  Color getText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : const Color(0xFF1C1C1E);

  Color getSub(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white60
          : Colors.black54;

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/$path";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBg(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// ================= APP BAR =================
          SliverAppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: primary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              "COMMERCIAL PROPERTY REPORT",
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: primary,
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

                  /// HERO IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      img(safe(building.image, fallback: "")),
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 260,
                        color: Colors.black12,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= PROPERTY OVERVIEW =================
                  _sectionLabel("PROPERTY OVERVIEW"),
                  _card(context, [
                    _dataRow(context, "Location", building.place,highlight: true),
                    _dataRow(context, "Buy / Rent", building.buyRent),
                    _dataRow(context, "Type", building.residenceCommercial),
                    _dataRow(context, "Total Floors", building.totalFloor),
                    _dataRow(context, "Age of Property", building.ageOfProperty),
                  ]),

                  /// ================= STRUCTURAL =================
                  _sectionLabel("FACILITY"),
                  _card(context, [
                    _dataRow(context, "Lift", building.lift),
                    _dataRow(context, "Parking", building.parking),
                    _dataRow(context, "Facilities", building.facilities),
                    _dataRow(context, "Road Size", building.roadSize),
                    _dataRow(context, "Metro Name", building.metroName),
                    _dataRow(context, "Metro Distance", building.metroDistance),
                    _dataRow(context, "Market Distance", building.mainMarketDistance),
                    _dataRow(context, "Locality", building.localityList),
                    _dataRow(context, "Address", building.yourAddress),
                  ]),

                  /// ================= CONTACT =================
                  _sectionLabel("CONTACT INFO"),
                  _card(context, [
                    _dataRow(context, "Owner Name", building.ownerName, highlight: true),
                    _dataRow(context, "Owner Number", building.ownerNumber),
                    _dataRow(context, "Vehicle Number", building.ownerVehicleNumber),
                    const Divider(height: 22),
                    _dataRow(context, "Caretaker Name", building.caretakerName),
                    _dataRow(context, "Caretaker Number", building.caretakerNumber),
                  ]),


                  /// ================= FIELD WORKER =================
                  _sectionLabel("FIELD WORKER"),
                  _card(context, [
                    _dataRow(context, "Field Worker", building.fieldWorkerName, highlight: true),
                    _dataRow(context, "Worker Number", building.fieldWorkerNumber),
                    _dataRow(context, "Worker Address", building.fieldWorkerAddress),
                  ]),

                  /// ================= META =================
                  _card(context, [
                    _dataRow(context, "Source ID", building.id.toString()),
                  ]),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: getCard(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  /// ================= DATA ROW =================
  Widget _dataRow(BuildContext context, String t, dynamic v,
      {bool highlight = false}) {
    final value = safe(v);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              t,
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                color: getSub(context),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: highlight ? primary : getText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION LABEL =================
  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Text(
      t,
      style: TextStyle(
        fontFamily: myFont,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: primary,
        letterSpacing: 1.2,
      ),
    ),
  );
}
