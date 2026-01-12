import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Add_Rented_Flat/Action_Form.dart';
import '../../Add_Rented_Flat/Add_Tenent.dart';
import '../../Add_Rented_Flat/FieldWorker_Booking_Page_Details.dart';
import '../../constant.dart';
import 'AdministatorPropertyDetailPage.dart';
class Property {
  final int pId;
  final String? sourceId;
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
  final String ownerCommission;
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
  final String statusForFinalPayment;
  final String statusForSecondPayment;
  final dynamic subid;

  // ✅ New fields
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;

  Property({
    required this.pId,
    required this.sourceId,
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
    required this.ownerCommission,
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
    required this.finalAmount,
    required this.secondAmount,
    required this.statusForFinalPayment,
    required this.statusForSecondPayment,
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
      ownerCommission: json["owner_side_commition"] ?? "",
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
      statusForSecondPayment: json["status_for_second_payment"] ?? "",
      statusForFinalPayment: json["status_for_final_payment"] ?? "",
      sourceId: json["source_id"] ?? "",
    );
  }
}

class OwnerData {
  int id;
  String ownerName;
  String ownerNumber;
  String paymentMode;
  String advanceAmount;
  String rent;
  String securitys;
  String subid;
  String status;

  OwnerData({
    required this.id,
    required this.ownerName,
    required this.ownerNumber,
    required this.paymentMode,
    required this.advanceAmount,
    required this.rent,
    required this.securitys,
    required this.subid,
    required this.status,
  });

  factory OwnerData.fromJson(Map<String, dynamic> json) => OwnerData(
    id: json["id"] ?? 0,
    ownerName: json["owner_name"] ?? "-",
    ownerNumber: json["owner_number"] ?? "-",
    paymentMode: json["payment_mode"] ?? "-",
    advanceAmount: json["advance_amount"] ?? "0",
    rent: json["rent"] ?? "0",
    securitys: json["securitys"] ?? "0",
    subid: json["subid"] ?? "-",
    status: json["status"] ?? "-",
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_name": ownerName,
    "owner_number": ownerNumber,
    "payment_mode": paymentMode,
    "advance_amount": advanceAmount,
    "rent": rent,
    "securitys": securitys,
    "subid": subid,
    "status": status,
  };
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

class AdministatiorFieldWorkerBookingPage extends StatefulWidget {
  const AdministatiorFieldWorkerBookingPage({super.key});

  @override
  State<AdministatiorFieldWorkerBookingPage> createState() => _AdministatiorFieldWorkerBookingPageState();
}

class _AdministatiorFieldWorkerBookingPageState extends State<AdministatiorFieldWorkerBookingPage> {

  String _fieldworkarnumber = '';
  static Map<dynamic, DateTime>? _lastTapTimes;

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_book_flat_for_admin.php");
    // print("User Name :"+"${userName}");
    // print("User Number :"+"${userNumber}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded["success"] == true) {
        List data = decoded["data"];
        return data.map((e) => Property.fromJson(e)).toList().reversed.toList();
      }
    }
    throw Exception("Failed to load data");
  }
  Future<List<Tenant>> fetchTenants(int subId) async {
    final response = await http.get(
      Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_tenant_and_owner_api.php?subid=$subId",
      ),
    );

    debugPrint("🔵 STATUS CODE: ${response.statusCode}");
    debugPrint("🔵 RAW RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["success"] == true) {
        List data = jsonResponse["data"];
        debugPrint("🟢 TENANT COUNT: ${data.length}");
        return data.map((e) => Tenant.fromJson(e)).toList();
      } else {
        throw Exception("API success = false");
      }
    } else {
      throw Exception("Failed to load tenants");
    }
  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    loadUserName();
    //initializeService();
  }

  String? userName;
  String? userNumber;
  String? userStoredFAadharCard;

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedFAadharCard = prefs.getString('post');
    // debugPrint("User Name: $storedName");
    // debugPrint("User Number: $storedNumber");
    // debugPrint("User FAadharCard: $storedFAadharCard");
    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
        userStoredFAadharCard = storedFAadharCard;

      });
    }
  }
  Future<void> _onRefresh() async {
    setState(() {
      fetchBookingData();
    });
  }
  Future<List<OwnerData>> fetchPersonDetail(int subid) async {
    final url = Uri.parse('https://verifyserve.social/PHP_Files/owner_tenant_api.php?subid=$subid');
    final response = await http.get(url);

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        final data = decoded['data'] as List<dynamic>;
        print("Decoded Owner Data: $data"); // ✅ Check decoded list
        return data.map((e) => OwnerData.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch owner data");
    }
  }
  double _toD(dynamic v) {
    final s = (v ?? '').toString().trim();
    return double.tryParse(s.replaceAll(RegExp(r'[^\d\.-]'), '')) ?? 0;
  }

  String _cur(num n) => "₹ ${n.toStringAsFixed(0)}";
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body: FutureBuilder<List<Property>>(
          future: fetchBookingData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No booking data available",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }

            final bookingList = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];

                // ✅ SHOW BUY + RENT BOTH
                final type = item.buyRent.trim().toLowerCase();
                if (type != "buy" && type != "rent") {
                  return const SizedBox.shrink();
                }
                return bookingTransactionCard(context, item);
              },
            );
          },
        ),
      ),
    );
  }
  double remainingAmount(Property p) {
    double toD(String v) =>
        double.tryParse(v.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;

    return (toD(p.totalBalance)
        - toD(p.advancePayment)
        - toD(p.secondAmount)
        - toD(p.finalAmount))
        .clamp(0, double.infinity);
  }
  Widget _idChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? color.withOpacity(0.25)
            : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : color,
        ),
      ),
    );
  }

  Widget bookingTransactionCard(
      BuildContext context,
      Property item,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remaining = remainingAmount(item);
    bool isEnabled = isValidItem(item);

    return GestureDetector(
      onTap: () {
        print(item.pId.toString());
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PropertyDetailPage(propertyId: item.pId.toString());
        }));
      },


      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== ID CHIPS =====
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _idChip("Building ID: ${item.subid}", Colors.indigo, isDark ),
                  _idChip("Flat ID: ${item.sourceId ?? "-"}", Colors.purple, isDark),
                  _idChip("Flat No: ${item.flatNumber}", Colors.teal, isDark),
                ],
              ),

              const SizedBox(height: 8),

              /// ===== TOP ROW =====
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl:
                      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                      height: 72,
                      width: 72,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey.shade300),
                      errorWidget: (_, __, ___) =>
                          Icon(Icons.home, size: 40, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// CONTENT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE + PRICE
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${item.bhk} ${item.typeOfProperty ?? ""}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDark? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              "₹ ${item.showPrice}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: "PoppinsMedium",
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        /// LOCATION
                        Text(
                          item.locations ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 8),



                        /// STATUS + TRANSACTION ID
                        Row(
                          children: [
                            Text(
                              "Txn ID: #${item.pId}",
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: "PoppinsBold",
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade500,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),

              const SizedBox(height: 10),

              /// ===== REMAINING ROW =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Remaining Balance",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    formatINR(remaining),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // /// ===== CTA ROW =====
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         print(item.pId.toString());
              //         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //           return PropertyDetailPage(propertyId: item.pId.toString());
              //         }));
              //       },
              //       child: Container(
              //         padding:
              //         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              //         decoration: BoxDecoration(
              //           color: isDark
              //               ? Colors.blueGrey.shade800
              //               : Colors.blue.shade50,
              //           borderRadius: BorderRadius.circular(20),
              //           border: Border.all(color: Colors.blue.shade300),
              //         ),
              //         child: Row(
              //           children: const [
              //             Icon(
              //               Icons.account_balance_wallet,
              //               size: 14,
              //               color: Colors.blue,
              //             ),
              //             SizedBox(width: 6),
              //             Text(
              //               "View Financial Details",
              //               style: TextStyle(
              //                 fontSize: 11,
              //                 fontWeight: FontWeight.w700,
              //                 color: Colors.blue,
              //               ),
              //             ),
              //             SizedBox(width: 4),
              //             Icon(
              //               Icons.chevron_right,
              //               size: 16,
              //               color: Colors.blue,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),
              if(userStoredFAadharCard=="Sub Administrator")
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isEnabled
                        ? () async {
                      const int cooldownSeconds = 3;
                      _lastTapTimes ??= {};

                      DateTime now = DateTime.now();

                      if (_lastTapTimes![item.pId] != null &&
                          now.difference(_lastTapTimes![item.pId]!).inSeconds < cooldownSeconds) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Already submitted")),
                        );
                        return;
                      }

                      _lastTapTimes![item.pId] = now;

                      try {
                        final response = await http.post(
                          Uri.parse(
                            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/new_pending_rentout_api.php",
                          ),
                          body: {
                            "P_id": item.pId.toString(),
                          },
                        );

                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Accepted Successfully ✅")),
                          );
                          _onRefresh();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed: ${response.statusCode}")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    }
                        : null, // 🔒 disabled when data missing

                    child: Text(
                      isEnabled ? "Accept" : "Fill required fields",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  String formatINR(num value) {
    final f = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return f.format(value);
  }
  bool isValidItem(Property item) {
    return item.rent.isNotEmpty &&
        item.security.isNotEmpty &&
        item.commission.isNotEmpty &&
        item.totalBalance.isNotEmpty &&
        item.advancePayment.isNotEmpty;
  }


  Widget _buildMiniChip(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExpansionSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200, width: 1),
        ),
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: Icon(icon, size: 18,
                color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: Icon(Icons.expand_more, size: 16,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow2(String label, String value, {bool isBold = false, Color? color, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonSection(String title, List<Widget> details, Color bgColor, {required bool isDarkMode}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...details,
        ],
      ),
    );
  }

  Widget _buildPersonDetail(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Not provided",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, bool isDarkMode) {
    if (status.toLowerCase().contains('pending'))
      return isDarkMode ? Colors.orange.shade700 : Colors.orange;
    if (status.toLowerCase().contains('completed') || status.toLowerCase().contains('done'))
      return isDarkMode ? Colors.green.shade700 : Colors.green;
    if (status.toLowerCase().contains('rent'))
      return isDarkMode ? Colors.purple.shade700 : Colors.purple;
    if (status.toLowerCase().contains('buy'))
      return isDarkMode ? Colors.blue.shade700 : Colors.blue;
    return isDarkMode ? Colors.grey.shade600 : Colors.grey;
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }
}

String _formatDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return "-";
  try {
    final dt = DateFormat('yyyy-MM-dd').parse(rawDate);
    return DateFormat('dd MMM yyyy').format(dt);
  } catch (_) {
    try {
      final dt2 = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(dt2);
    } catch (_) {
      return rawDate;
    }
  }

}
