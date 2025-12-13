import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui_decoration_tools/app_images.dart';
import '../../../model/realestateSlider.dart';
import '../../property_preview.dart';

class Property {
  final int pId;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeofProperty;
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
  final String fieldWarkarName;
  final String liveUnlive;
  final String fieldWorkarNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;

  Property({
    required this.pId,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeofProperty,
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
    required this.fieldWarkarName,
    required this.liveUnlive,
    required this.fieldWorkarNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      pId: int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeofProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      fieldworkarAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDates: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWarkarName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      fieldWorkarNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'P_id': pId,
      'property_photo': propertyPhoto,
      'locations': locations,
      'Flat_number': flatNumber,
      'Buy_Rent': buyRent,
      'Residence_Commercial': residenceCommercial,
      'Apartment_name': apartmentName,
      'Apartment_Address': apartmentAddress,
      'Typeofproperty': typeofProperty,
      'Bhk': bhk,
      'show_Price': showPrice,
      'Last_Price': lastPrice,
      'asking_price': askingPrice,
      'Floor_': floor,
      'Total_floor': totalFloor,
      'Balcony': balcony,
      'squarefit': squarefit,
      'maintance': maintance,
      'parking': parking,
      'age_of_property': ageOfProperty,
      'fieldworkar_address': fieldworkarAddress,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'highway_distance': highwayDistance,
      'main_market_distance': mainMarketDistance,
      'meter': meter,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'current_dates': currentDates,
      'available_date': availableDate,
      'kitchen': kitchen,
      'bathroom': bathroom,
      'lift': lift,
      'Facility': facility,
      'furnished_unfurnished': furnishedUnfurnished,
      'field_warkar_name': fieldWarkarName,
      'live_unlive': liveUnlive,
      'field_workar_number': fieldWorkarNumber,
      'registry_and_gpa': registryAndGpa,
      'loan': loan,
      'Longitude': longitude,
      'Latitude': latitude,
      'video_link': videoLink,
      'field_worker_current_location': fieldWorkerCurrentLocation,
      'care_taker_name': careTakerName,
      'care_taker_number': careTakerNumber,
      'subid': subid,
    };
  }
}

class Catid111 {
  final int id;
  final String images;
  final String ownername;
  final String ownernumber;
  final String caretakername;
  final String caretakernumber;
  final String place;
  final String buy_rent;
  final String typeofproperty;
  final String bhk;
  final String floor_no;
  final String flat_no;
  final String square_feet;
  final String propertyname_adress;
  final String building_information_facilitys;
  final String property_adress_for_fieldworkar;
  final String owner_vehical_number;
  final String your_address;
  final String fieldworkar_name;
  final String fieldworkar_number;
  final String current_dates;

  Catid111({
    required this.id,
    required this.images,
    required this.ownername,
    required this.ownernumber,
    required this.caretakername,
    required this.caretakernumber,
    required this.place,
    required this.buy_rent,
    required this.typeofproperty,
    required this.bhk,
    required this.floor_no,
    required this.flat_no,
    required this.square_feet,
    required this.propertyname_adress,
    required this.building_information_facilitys,
    required this.property_adress_for_fieldworkar,
    required this.owner_vehical_number,
    required this.your_address,
    required this.fieldworkar_name,
    required this.fieldworkar_number,
    required this.current_dates,
  });

  factory Catid111.FromJson(Map<String, dynamic> json) {
    return Catid111(
      id: json['id'],
      images: json['images'],
      ownername: json['ownername'],
      ownernumber: json['ownernumber'],
      caretakername: json['caretakername'],
      caretakernumber: json['caretakernumber'],
      place: json['place'],
      buy_rent: json['buy_rent'],
      typeofproperty: json['typeofproperty'],
      bhk: json['bhk'],
      floor_no: json['floor_no'],
      flat_no: json['flat_no'],
      square_feet: json['square_feet'],
      propertyname_adress: json['propertyname_adress'],
      building_information_facilitys: json['building_information_facilitys'],
      property_adress_for_fieldworkar: json['property_adress_for_fieldworkar'],
      owner_vehical_number: json['owner_vehical_number'],
      your_address: json['your_address'],
      fieldworkar_name: json['fieldworkar_name'],
      fieldworkar_number: json['fieldworkar_number'],
      current_dates: json['current_dates'],
    );
  }
}

class Catid1 {
  final int id;
  final String tenant_name;
  final String tenant_phone_number;
  final String flat_rent;
  final String shifting_date;
  final String members;
  final String email;
  final String tenant_vichal_details;
  final String work_profile;
  final String bhk;
  final String type_of_property;
  final int sub_id;

  Catid1({
    required this.id,
    required this.tenant_name,
    required this.tenant_phone_number,
    required this.flat_rent,
    required this.shifting_date,
    required this.members,
    required this.email,
    required this.tenant_vichal_details,
    required this.work_profile,
    required this.bhk,
    required this.type_of_property,
    required this.sub_id,
  });

  factory Catid1.FromJson(Map<String, dynamic> json) {
    return Catid1(
      id: json['id'] ?? 0,
      tenant_name: json['tenant_name'] ?? '',
      tenant_phone_number: json['tenant_phone_number'] ?? '',
      flat_rent: json['flat_rent'] ?? '',
      shifting_date: json['shifting_date'] ?? '',
      members: json['members'] ?? '',
      email: json['email'] ?? '',
      tenant_vichal_details: json['tenant_vichal_details'] ?? '',
      work_profile: json['work_profile'] ?? '',
      bhk: json['bhk'] ?? '',
      type_of_property: json['type_of_property'] ?? '',
      sub_id: json['sub_id'] ?? 0,
    );
  }
}

class Admin_underflat_futureproperty extends StatefulWidget {
  String id;
  String Subid;
  Admin_underflat_futureproperty({super.key, required this.id, required this.Subid});

  @override
  State<Admin_underflat_futureproperty> createState() => Admin_underflat_futurepropertyState();
}

class Admin_underflat_futurepropertyState extends State<Admin_underflat_futureproperty> {
  Future<List<RealEstateSlider1>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_multiple_images?subid=${widget.id}'));
    print(" Multi Image ID: ${widget.id}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return RealEstateSlider1(
          rimg: item['images'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Property? property;

  Future<List<Property>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_details_page?id=${widget.id}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Property.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid1>> fetchData1() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_tenant_in_future_property?sub_id=${widget.id}");
    final Response = await http.get(url);
    print("Tenant : ${Response.body}");
    if (Response.statusCode == 200) {
      List listresponce = json.decode(Response.body);
      return listresponce.map((data) => Catid1.FromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> _loadAllData() async {
    setState(() {
      _sliderFuture = fetchCarouselData();
      _propertyFuture = fetchData();
      _catidFuture = fetchData1();
    });
  }

  Future<void> _refreshData() async {
    await _loadAllData();
  }

  String liveUnliveStatus = 'Flat'; // default value, can be 'Flat' or 'book'

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  late Future<List<RealEstateSlider1>> _sliderFuture;
  late Future<List<Property>> _propertyFuture;
  late Future<List<Catid1>> _catidFuture;

  Future<void> openWhatsApp(String number) async {
    try {
      String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
      if (!cleanNumber.startsWith('91')) {
        cleanNumber = '91$cleanNumber';
      }

      final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$cleanNumber");
      final Uri whatsappWebUri = Uri.parse("https://wa.me/$cleanNumber");

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WhatsApp is not installed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening WhatsApp: ${e.toString()}')),
        );
      }
    }
  }

  void showCallConfirmationDialog(String role, String name, String number) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Call $role'),
        content: Text('Do you really want to call ${name.isNotEmpty ? name : role}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              await FlutterPhoneDirectCaller.callNumber(number);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  String maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String firstPart = number.substring(0, 3);
    String lastPart = number.substring(number.length - 4);
    return '$firstPart****$lastPart';
  }

  Widget buildInfoRow(IconData icon, Color iconColor, String title, String value) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final Color cardColor = Colors.white;
    final Color borderColor = Colors.grey.shade200;
    final Color titleColor = Colors.grey.shade700;
    final Color valueColor = Colors.black87;
    final Color iconBg = iconColor.withOpacity(0.10);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
          ),
          SizedBox(width: isSmallScreen ? 6.0 : 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10.0 : 11.0,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11.0 : 12.0,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactCard(String role, String name, String number, {Color? bgColor}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = maskPhoneNumber(number);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isSmallScreen ? 32.0 : 36.0,
                  height: isSmallScreen ? 32.0 : 36.0,
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    role == "OWNER"
                        ? Icons.person
                        : role == "CARETAKER"
                        ? Icons.support_agent
                        : role == "FIELD WORKER"
                        ? Icons.engineering
                        : role == "TENANT"
                        ? Icons.people
                        : Icons.person,
                    color: Colors.white,
                    size: isSmallScreen ? 16.0 : 18.0,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10.0 : 11.0,
                          fontWeight: FontWeight.w600,
                          color: cardColor,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                      Text(
                        name.isNotEmpty ? name : "Not Available",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 6.0 : 8.0),
            if (number.isNotEmpty)
              GestureDetector(
                onTap: () => showCallConfirmationDialog(role, name, number),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: cardColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          maskedNumber,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13.0 : 14.0,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => openWhatsApp(number),
                            child: Icon(PhosphorIcons.whatsapp_logo_bold, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                          ),
                          SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                          Icon(Icons.call, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "Not Available",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11.0 : 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSimpleInfoCard(String title, String value, IconData icon, Color cardColor, {VoidCallback? onTap}) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final Widget card = Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 32.0 : 36.0,
              height: isSmallScreen ? 32.0 : 36.0,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 16.0 : 18.0,
              ),
            ),
            SizedBox(width: isSmallScreen ? 6.0 : 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 11.0,
                      fontWeight: FontWeight.w600,
                      color: cardColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13.0 : 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }

  Widget _buildAdaptiveRows(List<Widget> cards, double verticalPadding) {
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth;
      final spacing = MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0;
      final runSpacing = verticalPadding;
      final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
      final itemWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: cards.map((card) {
          final width = cards.length == 1 ? available : itemWidth;
          return SizedBox(width: width, child: card);
        }).toList(),
      );
    });
  }

  List<Widget> getBuildingFacilityRows(Property prop) {
    List<Widget> rows = [];
    if (prop.facility.isNotEmpty) {
      rows.add(buildInfoRow(Icons.local_hospital, Colors.amber, "Building Facility", prop.facility));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;

    // Row 1: Kitchen and Bathroom
    List<Widget> row1Cards = [];
    if (prop.kitchen.isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard("Kitchen", prop.kitchen, Icons.kitchen, Colors.pink));
    }
    if (prop.bathroom.isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard("Bathroom", prop.bathroom, Icons.bathroom, Colors.lightBlue));
    }
    if (row1Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row1Cards, verticalPadding),
      ));
    }

    // Row 2: Parking, Lift, Meter
    List<Widget> row2Cards = [];
    if (prop.parking.isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Parking", prop.parking, Icons.local_parking, Colors.purple));
    }
    if (prop.lift.isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Lift", prop.lift, Icons.elevator, Colors.red));
    }
    if (prop.meter.isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Meter", prop.meter, Icons.electric_meter, Colors.blue));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row2Cards, verticalPadding),
      ));
    }

    return rows;
  }

  List<Widget> getFlatFacilityRows(Property prop) {
    List<Widget> rows = [];
    if (prop.apartmentName.isNotEmpty) {
      rows.add(buildInfoRow(Icons.local_hospital, Colors.amber, "Flat Facility", prop.facility));
    }
    return rows;
  }

  Widget buildFieldworkerInfoCard(Property prop) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final String name = prop.fieldWarkarName;
    final String number = prop.fieldWorkarNumber;
    final String address = prop.fieldworkarAddress;
    final String location = prop.fieldWorkerCurrentLocation;

    if (name.isEmpty && number.isEmpty && address.isEmpty && location.isEmpty) {
      return const SizedBox.shrink();
    }

    final Color cardColor = Colors.blue;
    final Color bgColor = Colors.blue;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: isSmallScreen ? 32.0 : 36.0,
                height: isSmallScreen ? 32.0 : 36.0,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.engineering,
                  color: Colors.white,
                  size: isSmallScreen ? 16.0 : 18.0,
                ),
              ),
              SizedBox(width: isSmallScreen ? 6.0 : 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FIELD WORKER",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10.0 : 11.0,
                        fontWeight: FontWeight.w600,
                        color: bgColor,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                    Text(
                      name.isNotEmpty ? name : "Not Available",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13.0 : 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6.0 : 8.0),
          // Number
          if (number.isNotEmpty)
            GestureDetector(
              onTap: () => showCallConfirmationDialog("FIELD WORKER", name, number),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: bgColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        maskPhoneNumber(number),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: bgColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => openWhatsApp(number),
                          child: Icon(PhosphorIcons.whatsapp_logo_bold, color: bgColor, size: isSmallScreen ? 20.0 : 24.0),
                        ),
                        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                        Icon(Icons.call, color: bgColor, size: isSmallScreen ? 20.0 : 24.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Address
          if (address.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: buildSimpleInfoCard("Fieldworker Address", address, Icons.location_on, Colors.lime),
            ),
          // Location
          if (location.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: GestureDetector(
                onTap: () async {
                  final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$location");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    // Handle error
                  }
                },
                child: buildSimpleInfoCard("Fieldworker Location", location, Icons.my_location, Colors.lightBlue),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildResponsiveInfoGrid(List<Widget> infoRows) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        if (screenWidth > 350) {
          final half = (infoRows.length / 2).ceil();
          final leftColumn = infoRows.sublist(0, half);
          final rightColumn = infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: leftColumn,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8.0 : 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rightColumn,
                ),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: infoRows,
          );
        }
      },
    );
  }

  List<Widget> getPropertyDetailsRows(Property prop) {
    List<Widget> rows = [];

    if (prop.metroDistance.isNotEmpty) {
      rows.add(buildInfoRow(Icons.train, Colors.orange, "Metro Station", prop.metroDistance));
    }

    if (prop.mainMarketDistance.isNotEmpty) {
      rows.add(buildInfoRow(Icons.store, Colors.purple, "Market Distance", prop.mainMarketDistance));
    }

    if (prop.registryAndGpa.isNotEmpty) {
      rows.add(buildInfoRow(Icons.document_scanner, Colors.purple, "Registry & GPA", prop.registryAndGpa));
    }

    if (prop.typeofProperty.isNotEmpty) {
      rows.add(buildInfoRow(Icons.category, Colors.deepOrange, "Type of Property", prop.typeofProperty));
    }

    if (prop.availableDate.isNotEmpty) {
      rows.add(buildInfoRow(Icons.calendar_today, Colors.blue, "Available From", prop.availableDate));
    }

    if (prop.roadSize.isNotEmpty) {
      rows.add(buildInfoRow(Icons.straighten, Colors.teal, "Road Size", "${prop.roadSize} Feet"));
    }

    if (prop.highwayDistance.isNotEmpty) {
      rows.add(buildInfoRow(Icons.directions_car, Colors.red, "Metro Distance", prop.highwayDistance));
    }



    if (prop.loan.isNotEmpty) {
      rows.add(buildInfoRow(Icons.balance, Colors.purple, "Loan", prop.loan));
    }

    if (prop.flatNumber.isNotEmpty) {
      rows.add(buildInfoRow(Icons.format_list_numbered, Colors.green, "Flat Number", prop.flatNumber));
    }

    if (prop.apartmentAddress.isNotEmpty) {
      rows.add(buildInfoRow(Icons.location_on, Colors.pink, "Apartment Address", prop.apartmentAddress));
    }

    return rows;
  }

  List<Widget> getAdditionalInfoRows(Property prop) {
    List<Widget> rows = [];

    if (prop.currentDates.isNotEmpty) {
      rows.add(buildSimpleInfoCard("Current Date", prop.currentDates, Icons.date_range, Colors.indigo));
    }

    // Asking & Last Price row
    List<Widget> priceWidgets = [];
    if (prop.askingPrice.isNotEmpty) {
      priceWidgets.add(
        Expanded(
          child: buildSimpleInfoCard("Asking Price", prop.askingPrice, Icons.currency_rupee, Colors.green),
        ),
      );
    }
    if (prop.lastPrice.isNotEmpty) {
      if (priceWidgets.isNotEmpty) {
        priceWidgets.add(SizedBox(width: MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0));
      }
      priceWidgets.add(
        Expanded(
          child: buildSimpleInfoCard("Last Price", prop.lastPrice, Icons.currency_rupee, Colors.pink),
        ),
      );
    }
    if (priceWidgets.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 2.0 : 4.0),
          child: Row(children: priceWidgets),
        ),
      );
    }

    if (prop.videoLink.isNotEmpty) {
      rows.add(
        GestureDetector(
          onTap: () {
            // Implement launchVideo if needed
          },
          child: buildSimpleInfoCard("Video Link", prop.videoLink, Icons.video_library, Colors.red),
        ),
      );
    }

    rows.add(buildFieldworkerInfoCard(prop));

    return rows;
  }

  Widget buildChip(IconData icon, String text, Color color) {
    if (text.isEmpty) return const SizedBox.shrink();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 14.0 : 16.0, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallScreen ? 9.0 : 10.0,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Property>>(
          future: _propertyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight * 0.4,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50 * fontScale, color: Colors.white),
                      SizedBox(height: verticalPadding * 2),
                      Text(
                        "No Property Found!",
                        style: TextStyle(fontSize: 16 * fontScale, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final prop = snapshot.data![0];
              property = prop;

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Hero Image
                        Stack(
                          children: [
                            SizedBox(
                              height: imageHeight,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PropertyPreview(
                                        ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  key: ValueKey('${prop.pId}_${prop.propertyPhoto}'),
                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, size: 50 * fontScale, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            // Status Chip
                            Positioned(
                              bottom: isSmallScreen ? 8.0 : 16.0,
                              right: horizontalPadding,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    prop.buyRent,
                                    style: TextStyle(
                                      fontSize: (isSmallScreen ? 16.0 : 18.0) * fontScale,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: verticalPadding * 2),
                        // Price + Maintenance
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '₹ ${prop.showPrice}',
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: horizontalPadding * 0.8),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${prop.maintance} Maintance",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Location + Chips
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding * 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prop.locations,
                                style: TextStyle(
                                  fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: verticalPadding * 1.2),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final available = constraints.maxWidth;
                                  final spacing = chipSpacing * 1.5;
                                  final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
                                  final chipWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

                                  final chipsData = [
                                    {'icon': Icons.bedroom_parent, 'text': prop.bhk, 'color': Colors.blue},
                                    {'icon': Icons.kitchen, 'text': prop.kitchen, 'color': Colors.green},
                                    {'icon': Icons.chair, 'text': prop.furnishedUnfurnished, 'color': Colors.purple},
                                    {'icon': Icons.apartment, 'text': prop.residenceCommercial, 'color': Colors.amber},
                                  ].where((e) => (e['text'] as String).isNotEmpty).toList();

                                  return Wrap(
                                    spacing: spacing,
                                    runSpacing: verticalPadding * 1.2,
                                    children: chipsData.map((e) {
                                      return SizedBox(
                                        width: chipWidth,
                                        child: buildChip(e['icon'] as IconData, "${e['text']}", e['color'] as Color),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              SizedBox(height: verticalPadding * 2),
                            ],
                          ),
                        ),
                        // Carousel
                        FutureBuilder<List<RealEstateSlider1>>(
                          future: _sliderFuture,
                          builder: (context, sliderSnapshot) {
                            if (sliderSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(height: carouselHeight * 0.4);
                            }
                            if (sliderSnapshot.hasError || sliderSnapshot.data == null || sliderSnapshot.data!.isEmpty) {
                              return const SizedBox();
                            }
                            final images = sliderSnapshot.data!;
                            final viewportFraction = isSmallScreen ? 0.85 : (isTablet ? 0.7 : 0.8);

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: carouselHeight,
                                      autoPlay: true,
                                      enlargeCenterPage: false,
                                      autoPlayInterval: const Duration(seconds: 3),
                                      viewportFraction: viewportFraction,
                                    ),
                                    items: images.asMap().entries.map((entry) {
                                      final item = entry.value;
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => PropertyPreview(
                                                    ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    color: Colors.grey[300],
                                                    child: const Center(child: CircularProgressIndicator()),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.error, size: 50, color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // Property Details
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Property Details",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              buildResponsiveInfoGrid(getPropertyDetailsRows(prop)),
                            ],
                          ),
                        ),
                        // Building Facility
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_hospital, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Building Facility",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              if (getBuildingFacilityRows(prop).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: getBuildingFacilityRows(prop),
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        // Contact Information
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.contact_page, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Contact Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding * 2),
                              buildContactCard("OWNER", prop.ownerName, prop.ownerNumber, bgColor: Colors.green),
                              buildContactCard("CARETAKER", prop.careTakerName, prop.careTakerNumber, bgColor: Colors.purple),
                            ],
                          ),
                        ),
                        // Additional Info
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Additional Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: getAdditionalInfoRows(prop),
                              ),
                            ],
                          ),
                        ),
                        // Tenant Info
                        FutureBuilder<List<Catid1>>(
                          future: _catidFuture,
                          builder: (context, tenantSnapshot) {
                            if (tenantSnapshot.connectionState == ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.all(horizontalPadding),
                                child: const Center(child: CircularProgressIndicator()),
                              );
                            } else if (tenantSnapshot.hasError || tenantSnapshot.data == null || tenantSnapshot.data!.isEmpty) {
                              return const SizedBox();
                            } else {
                              final tenants = tenantSnapshot.data!;
                              return Container(
                                margin: EdgeInsets.all(horizontalPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                      child: Row(
                                        children: [
                                          Icon(Icons.people, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                          SizedBox(width: horizontalPadding),
                                          Text(
                                            "Tenant Information",
                                            style: TextStyle(
                                              fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: verticalPadding * 2),
                                    // Loop for multiple tenants
                                    ...tenants.map((tenant) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: buildContactCard(
                                        "TENANT",
                                        tenant.tenant_name,
                                        tenant.tenant_phone_number,
                                        bgColor: Colors.green,
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: screenHeight * (isSmallScreen ? 0.1 : 0.08)),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}