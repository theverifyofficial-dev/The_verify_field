import 'package:flutter/material.dart';
import '../Building.dart';

class BuildingDetailScreen extends StatelessWidget {
  final BuildingModel building;

  const BuildingDetailScreen({super.key, required this.building});

  static const bgDark = Color(0xFF0E1621);
  static const cardDark = Color(0xFF121E2B);
  static const primaryBlue = Color(0xFF2F80FF);
  static const softBlue = Color(0xFF1E3A5F);
  static const textLight = Color(0xFFEAF1FF);
  static const textGrey = Color(0xFF9FB3C8);

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/$path";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [

          /// IMAGE
          SizedBox(
            height: 320,
            width: double.infinity,
            child: Image.network(img(building.image), fit: BoxFit.cover),
          ),

          /// TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleBtn(Icons.arrow_back, () => Navigator.pop(context)),
                  Row(
                    children: [
                      _circleBtn(Icons.share, () {}),
                      const SizedBox(width: 8),
                      _circleBtn(Icons.bookmark_border, () {}),
                    ],
                  )
                ],
              ),
            ),
          ),

          /// DETAILS
          DraggableScrollableSheet(
            initialChildSize: 0.70,
            minChildSize: 0.70,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: softBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "FOR ${building.buyRent.toUpperCase()}",
                          style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// TITLE
                    Text(
                      building.propertyName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textLight),
                    ),

                    const SizedBox(height: 4),
                    Text(building.place, style: const TextStyle(color: textGrey)),

                    const SizedBox(height: 14),

                    /// INFO
                    Row(
                      children: [
                        _miniInfo(building.bhk, "BHK"),
                        _miniInfo(building.totalFloor, "Floor"),
                        _miniInfo(building.squareFeet, "Sqft"),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _section("Property Details"),
                    _row("Type", building.typeOfProperty),
                    _row("Residential/Commercial", building.residenceCommercial),
                    _row("Road Size", building.roadSize),
                    _row("Age", building.ageOfProperty),
                    _row("Lift", building.lift),
                    _row("Parking", building.parking),

                    const Divider(),

                    _section("Location"),
                    _row("Metro", "${building.metroName} (${building.metroDistance})"),
                    _row("Market", building.mainMarketDistance),
                    _row("Locality", building.localityList),
                    _row("Address", building.yourAddress),

                    const Divider(),

                    _section("Owner & Caretaker"),
                    _row("Owner", building.ownerName),
                    _row("Owner No", building.ownerNumber),
                    _row("Caretaker", building.caretakerName),
                    _row("Caretaker No", building.caretakerNumber),
                    _row("Vehicle", building.ownerVehicleNumber),

                    const Divider(),

                    _section("Field Worker"),
                    _row("Name", building.fieldWorkerName),
                    _row("Number", building.fieldWorkerNumber),
                    _row("Property Address", building.fieldWorkerAddress),

                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return CircleAvatar(
      backgroundColor: Colors.black45,
      child: IconButton(icon: Icon(icon, color: Colors.white), onPressed: onTap),
    );
  }

  Widget _miniInfo(String v, String t) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Text(v, style: const TextStyle(fontWeight: FontWeight.bold, color: textLight)),
          Text(t, style: const TextStyle(fontSize: 12, color: textGrey)),
        ],
      ),
    );
  }

  Widget _section(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, color: textLight)),
    );
  }

  Widget _row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(t, style: const TextStyle(color: textGrey))),
          Expanded(child: Text(v, style: const TextStyle(color: textLight))),
        ],
      ),
    );
  }
}
