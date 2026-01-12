import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Action_Form_New.dart';
import 'Add_Tenent_New.dart';
import 'UpdateTenantNew.dart';
import 'Update_Action_Form_New.dart';

class Property {
  final int pId;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeOfProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String caretakerName;
  final String caretakerNumber;
  final String ownerSideCommission;
  final int subid;
  final String? sourceId;
  // ✅ New fields
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;
  final String dates;
  final String tims;
  final String status_for_update_fields;

  Property({
    required this.pId,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeOfProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squarefit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.subid,
    required this.rent,
    required this.security,
    required this.commission,
    required this.extraExpense,
    required this.advancePayment,
    required this.totalBalance,
    required this.secondAmount,
    required this.finalAmount,
    required this.dates,
    required this.ownerSideCommission,
    required this.tims,
    required this.sourceId,
    required this.status_for_update_fields,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      pId: json["P_id"] ?? 0,
      propertyPhoto: json["property_photo"] ?? "",
      locations: json["locations"] ?? "",
      flatNumber: json["Flat_number"] ?? "",
      buyRent: json["Buy_Rent"] ?? "",
      residenceCommercial: json["Residence_Commercial"] ?? "",
      apartmentName: json["Apartment_name"] ?? "",
      apartmentAddress: json["Apartment_Address"] ?? "",
      typeOfProperty: json["Typeofproperty"] ?? "",
      bhk: json["Bhk"] ?? "",
      showPrice: json["show_Price"] ?? "",
      lastPrice: json["Last_Price"] ?? "",
      askingPrice: json["asking_price"] ?? "",
      floor: json["Floor_"] ?? "",
      totalFloor: json["Total_floor"] ?? "",
      balcony: json["Balcony"] ?? "",
      squarefit: json["squarefit"] ?? "",
      maintance: json["maintance"] ?? "",
      parking: json["parking"] ?? "",
      ageOfProperty: json["age_of_property"] ?? "",
      fieldworkarAddress: json["fieldworkar_address"] ?? "",
      roadSize: json["Road_Size"] ?? "",
      metroDistance: json["metro_distance"] ?? "",
      highwayDistance: json["highway_distance"] ?? "",
      mainMarketDistance: json["main_market_distance"] ?? "",
      meter: json["meter"] ?? "",
      ownerName: json["owner_name"] ?? "",
      ownerNumber: json["owner_number"] ?? "",
      ownerSideCommission: json["owner_side_commition"] ?? "",
      currentDates: json["current_dates"] ?? "",
      availableDate: json["available_date"] ?? "",
      kitchen: json["kitchen"] ?? "",
      bathroom: json["bathroom"] ?? "",
      lift: json["lift"] ?? "",
      facility: json["Facility"] ?? "",
      furnishedUnfurnished: json["furnished_unfurnished"] ?? "",
      fieldWorkerName: json["field_warkar_name"] ?? "",
      liveUnlive: json["live_unlive"] ?? "",
      fieldWorkerNumber: json["field_workar_number"] ?? "",
      registryAndGpa: json["registry_and_gpa"] ?? "",
      loan: json["loan"] ?? "",
      longitude: json["Longitude"] ?? "",
      latitude: json["Latitude"] ?? "",
      videoLink: json["video_link"] ?? "",
      caretakerName: json["care_taker_name"] ?? "",
      caretakerNumber: json["care_taker_number"] ?? "",
      subid: json["subid"],
      rent: json["Rent"] ?? "",
      security: json["Security"] ?? "",
      commission: json["Commission"] ?? "",
      extraExpense: json["Extra_Expense"] ?? "",
      advancePayment: json["Advance_Payment"] ?? "",
      totalBalance: json["Total_Balance"] ?? "",
      secondAmount: json["second_amount"] ?? "",
      finalAmount: json["final_amount"] ?? "",
      dates: json["dates"] ?? "",
      tims: json["tims"] ?? "",
      sourceId: json["source_id"] ?? "",
      status_for_update_fields: json["status_for_update_fields"] ?? "",

    );
  }
}

class Tenant {
  final int id;
  final String status;
  // Tenant
  final String tenantName;
  final String tenantNumber;
  final String shiftingDate;
  final String paymentModeForTenant;

  // Owner
  final String ownerName;
  final String ownerNumber;
  final String paymentModeForOwner;

  // Visitor
  final String vist_field_workar_name;
  final String vist_field_workar_number;
  // Relation
  final String subId;

  Tenant({
    required this.id,
    required this.tenantName,
    required this.tenantNumber,
    required this.shiftingDate,
    required this.paymentModeForTenant,
    required this.ownerName,
    required this.ownerNumber,
    required this.paymentModeForOwner,
    required this.subId,
    required this.status,
    required this.vist_field_workar_name,
    required this.vist_field_workar_number
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: (json['id'] as num?)?.toInt() ?? 0,

      tenantName: json['tenant_name'] ?? '',
      tenantNumber: json['tenant_number'] ?? '',
      shiftingDate: json['shifting_date'] ?? '',
      paymentModeForTenant: json['payment_mode_for_tenant'] ?? '',

      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      paymentModeForOwner: json['payment_mode_for_owner'] ?? '',
      vist_field_workar_name: json['vist_field_workar_name'] ?? '',
      vist_field_workar_number: json['vist_field_workar_number'] ?? '',
      status: json['status'] ?? "",
      subId: json['subid']?.toString() ?? '',
    );
  }
}
class FieldWorkerBookingFinancialDetailPage extends StatefulWidget {
  final int propertyId;

  const FieldWorkerBookingFinancialDetailPage({
    super.key,
    required this.propertyId,
  });

  @override
  State<FieldWorkerBookingFinancialDetailPage> createState() =>
      _FieldWorkerBookingFinancialDetailPageState();
}

/* ====================== STATE ====================== */

class _FieldWorkerBookingFinancialDetailPageState
    extends State<FieldWorkerBookingFinancialDetailPage> {
  late Future<_PageData> _future;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await loadUserName();     // ✅ wait for prefs
    _future = _loadAll();     // ✅ now userNumber exists
    setState(() {});          // ✅ rebuild UI
  }

  String? userName;
  String? userNumber;
  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
      });
    }
  }
  /* ====================== API ====================== */

  Future<_PageData> _loadAll() async {
    // ================= PROPERTY API =================
    final propUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_book_flat_by_fieldworkar.php?field_workar_number=${userNumber}";

    final propRes = await http.get(Uri.parse(propUrl));

    debugPrint("🟦 PROPERTY API URL: $propUrl");
    debugPrint("🟦 PROPERTY STATUS CODE: ${propRes.statusCode}");
    debugPrint("🟦 PROPERTY RAW RESPONSE:");
    debugPrint(propRes.body);

    if (propRes.statusCode != 200) {
      throw "Property API HTTP error";
    }

    final propJson = json.decode(propRes.body);

    if (propJson["success"] != true) {
      throw "Property API success = false";
    }

    final property = (propJson["data"] as List)
        .map((e) => Property.fromJson(e))
        .firstWhere(
          (p) => p.pId == widget.propertyId,
      orElse: () => throw "Property ID not found in API list",
    );

    debugPrint("✅ PROPERTY FOUND: P_ID = ${property.pId}, SUBID = ${property.subid}");

    // ================= TENANT API =================
    final tenantUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_tenant_and_owner_api.php?subid=${property.pId}";

    final tenantRes = await http.get(Uri.parse(tenantUrl));

    debugPrint("🟩 TENANT API URL: $tenantUrl");
    debugPrint("🟩 TENANT STATUS CODE: ${tenantRes.statusCode}");
    debugPrint("🟩 TENANT RAW RESPONSE:");
    debugPrint(tenantRes.body);

    if (tenantRes.statusCode != 200) {
      throw "Tenant API HTTP error";
    }

    final tenantJson = json.decode(tenantRes.body);

    final tenants = tenantJson["success"] == true
        ? (tenantJson["data"] as List)
        .map((e) => Tenant.fromJson(e))
        .toList()
        : <Tenant>[];

    debugPrint("✅ TENANT COUNT: ${tenants.length}");

    if (tenants.isNotEmpty) {
      debugPrint(
          "👤 TENANT NAME: ${tenants.first.tenantName}, OWNER: ${tenants.first.ownerName}");
    }

    return _PageData(property, tenants.isEmpty ? null : tenants.first);
  }

  /* ====================== HELPERS ====================== */

  double _d(String v) =>
      double.tryParse(v.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;

  /* ====================== UI ====================== */
  Property? _property;
  Tenant? _tenant;

  bool get hasTenant =>
      _tenant != null && _tenant!.status.isNotEmpty;

  bool get isUpdated =>
      _property?.status_for_update_fields.trim() == "fields updated";
  Future<void> _onRefresh() async {
    await _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Details")),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<_PageData>(
          future: _future,
          builder: (context, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (s.hasError) {
              return Center(child: Text("Error: ${s.error}"));
            }

            final p = s.data!.property;
            final t = s.data!.tenant;

            _property = p;
            _tenant = t;

            final total = _d(p.totalBalance);
            final paid = _d(p.advancePayment) +
                _d(p.secondAmount) +
                _d(p.finalAmount);

            final remaining =
            (total - paid).clamp(0, double.infinity).toDouble();

            return Stack(
              children: [
                /// ===== MAIN CONTENT =====
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  child: Column(
                    children: [
                      _summaryCard(p),
                      const SizedBox(height: 16),
                      _propertyCard(p),
                      const SizedBox(height: 16),
                      _financialSection(p, paid, remaining),
                      const SizedBox(height: 16),
                      _peopleSection(t),
                    ],
                  ),
                ),

                /// ===== FIXED BOTTOM BUTTONS =====
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: _bottomButtons(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /* ====================== SECTIONS ====================== */

  Widget _summaryCard(Property p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness==Brightness.dark?Colors.indigo.shade900:Colors.indigo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("TRANSACTION ID", style: TextStyle(color: Colors.white)),
        Text("#TRX-${p.pId}",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Total Amount", style: TextStyle(color: Colors.white)),
        Text(
          NumberFormat.currency(
            locale: 'en_IN',
            symbol: '₹ ',
            decimalDigits: 0,
          ).format(
            double.tryParse(p.totalBalance.toString()) ?? 0,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }

  Widget _propertyCard(Property p) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl:
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.propertyPhoto}",
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Wrap(spacing: 6, children: [
              _chip(p.bhk),
              _chip(p.typeOfProperty),
              _chip(p.locations),
              _chip("Flat No.  ${p.flatNumber}"),
            ]),
            const SizedBox(height: 8),
            Text(p.apartmentAddress, style: const TextStyle(fontSize: 13),textAlign: TextAlign.start,),
          ]),
        ),
      ]),
    );
  }

  String formatINR(num value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
  /// ================= AMOUNT TILE =================
  Widget _amountBox(String title, String value) {
    final amount = double.tryParse(
      value.replaceAll(RegExp(r'[^\d.]'), ''),
    ) ??
        0;

    final formatted = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    ).format(amount);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formatted,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DOT ROW =================
  Widget _dotRow(String label, String value) {
    final amount = double.tryParse(
      value.replaceAll(RegExp(r'[^\d.]'), ''),
    ) ??
        0;

    final formatted = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    ).format(amount);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 6,
            color: isDark ? Colors.grey.shade400 : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            formatted,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _financialSection(Property p, double paid, double remaining) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue.withOpacity(0.15),
                child: const Icon(Icons.account_balance_wallet,
                    color: Colors.blue, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                "Financial Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                "Remaining ${NumberFormat.currency(
                  locale: 'en_IN',
                  symbol: '₹ ',
                  decimalDigits: 0,
                ).format(remaining)}",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),

            ],
          ),

          const SizedBox(height: 16),

          /// TOP AMOUNT BOXES
          Row(
            children: [
              _amountBox("Monthly Rent", p.rent),
              const SizedBox(width: 12),
              _amountBox("Security Dep.", p.security),
            ],
          ),

          const SizedBox(height: 16),

          _dotRow("Commission (Tenant)", p.commission),
          _dotRow("Commission (Owner)", p.ownerSideCommission),
          _dotRow("Extra Expense", p.extraExpense),

          const Divider(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Advance Paid",
                  style: TextStyle(color:Theme.of(context).brightness==Brightness.dark? Colors.grey.shade400:Colors.black,fontWeight: FontWeight.w600)),
              Text(
                formatINR(paid),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _peopleSection(Tenant? t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.purple.withOpacity(0.15),
                child: const Icon(Icons.group,
                    color: Colors.purple, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                "People Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

            ],
          ),

          const SizedBox(height: 16),

          if (t == null)
            const Text("No tenant data")
          else ...[
            _personTile(
              "Owner",
              t.ownerName,
              t.ownerNumber,
              Colors.blue,
              paymentMode: t.paymentModeForOwner,
            ),
            _personTile(
              "Tenant",
              t.tenantName,
              t.tenantNumber,
              Colors.green,
              paymentMode: t.paymentModeForTenant,
              shiftingDate: t.shiftingDate,
            ),
            _personTile(
              "Visitor",
              t.vist_field_workar_name,
              t.vist_field_workar_number,
              Colors.orange,
            ),

          ]
        ],
      ),
    );
  }
  Widget _personTile(
      String role,
      String name,
      String phone,
      Color color, {
        String? paymentMode,
        String? shiftingDate,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : Colors.black;
    final secondaryText =
    isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== AVATAR =====
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(Icons.person, color: color, size: 20),
          ),
          const SizedBox(width: 12),

          /// ===== DETAILS =====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + ROLE
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// PHONE
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: secondaryText,
                  ),
                ),

                /// OPTIONAL INFO (INLINE)
                if ((paymentMode != null && paymentMode.isNotEmpty) ||
                    (shiftingDate != null && shiftingDate.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        if (paymentMode != null && paymentMode.isNotEmpty)
                          _infoChip(
                            Icons.payments_outlined,
                            paymentMode,
                            secondaryText,
                          ),
                        if (paymentMode != null &&
                            paymentMode.isNotEmpty &&
                            shiftingDate != null &&
                            shiftingDate.isNotEmpty)
                          const SizedBox(width: 12),
                        if (shiftingDate != null && shiftingDate.isNotEmpty)
                          _infoChip(
                            Icons.event_outlined,
                            shiftingDate,
                            secondaryText,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _infoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }



  Widget _bottomButtons() {
    // 🛑 safety check
    if (_property == null) return const SizedBox();

    final p = _property!;
    final t = _tenant;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [

          /// ================= TENANT BUTTON =================
          Expanded(
            child: ElevatedButton.icon(
              icon: Icon(
                hasTenant ? Icons.edit : Icons.person_add,
                size: 18,
                color: Colors.white,
              ),
              label: Text(hasTenant ? "Update Tenant" : "Add Tenant",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontFamily: "Poppins"),),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                hasTenant ? Colors.deepOrange : Colors.green,
              ),
              onPressed: () {
                if (hasTenant) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateTenantPageNew(
                        propertyId: p.pId.toString(),
                        tenentId: t!.id.toString(),
                      ),
                    ),
                  ).then((r) {
                    if (r == true) _init();
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddTenantPageNew(
                        id: p.pId.toString(),
                      ),
                    ),
                  ).then((r) {
                    if (r == true) _init();
                  });
                }
              },
            ),
          ),

          const SizedBox(width: 12),

          /// ================= BILL BUTTON =================
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.receipt, size: 18,color: Colors.white,),
              label: Text(isUpdated ? "Update Bill" : "Add Bill",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontFamily: "Poppins"),),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isUpdated ? Colors.deepOrange : Colors.blue,
              ),
              onPressed: () {
                if (isUpdated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateActionFormNew(
                        userNumber: userNumber!,
                        propertyId: p.pId.toString(),
                      ),
                    ),
                  ).then((r) {
                    if (r == true) _init();
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActionFormNew(
                        propertyId: p.pId.toString(),
                      ),
                    ),
                  ).then((r) {
                    if (r == true) _init();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /* ====================== SMALL WIDGETS ====================== */

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }

  Widget _row(String l, String v,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child:
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l),
        Text("₹ $v",
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                color: color)),
      ]),
    );
  }

  Widget _person(String role, String name, String phone) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text("$name ($role)"),
      subtitle: Text(phone),
    );
  }

  Widget _chip(String t) => Chip(label: Text(t));
}

/* ====================== MODELS ====================== */

class _PageData {
  final Property property;
  final Tenant? tenant;
  _PageData(this.property, this.tenant);
}
