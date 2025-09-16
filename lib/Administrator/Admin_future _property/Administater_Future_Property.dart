import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Home_Screen_click/Commercial_property_Filter.dart';
import '../../Home_Screen_click/Filter_Options.dart';
import '../../ui_decoration_tools/constant.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';
import 'package:intl/intl.dart';

class Catid {
  final int id;
  final String? images;
  final String? ownerName;
  final String? ownerNumber;
  final String? caretakerName;
  final String? caretakerNumber;
  final String? place;
  final String? buyRent;
  final String? typeOfProperty;
  final String? selectBhk;
  final String? floorNumber;
  final String? squareFeet;
  final String? propertyNameAddress;
  final String? buildingInformationFacilities;
  final String? propertyAddressForFieldworker;
  final String? ownerVehicleNumber;
  final String? yourAddress;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? currentDate;
  final String? longitude;
  final String? latitude;
  final String? roadSize;
  final String? metroDistance;
  final String? metroName;
  final String? mainMarketDistance;
  final String? ageOfProperty;
  final String? lift;
  final String? parking;
  final String? totalFloor;
  final String? residenceCommercial;
  final String? facility;

  Catid({
    required this.id,
    required this.images,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.selectBhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyNameAddress,
    required this.buildingInformationFacilities,
    required this.propertyAddressForFieldworker,
    required this.ownerVehicleNumber,
    required this.yourAddress,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.currentDate,
    required this.longitude,
    required this.latitude,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.mainMarketDistance,
    required this.ageOfProperty,
    required this.lift,
    required this.parking,
    required this.totalFloor,
    required this.residenceCommercial,
    required this.facility,
  });

  factory Catid.FromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['id'] ?? 0,
      images: json['images'],
      ownerName: json['ownername'],
      ownerNumber: json['ownernumber'],
      caretakerName: json['caretakername'],
      caretakerNumber: json['caretakernumber'],
      place: json['place'],
      buyRent: json['buy_rent'],
      typeOfProperty: json['typeofproperty'],
      selectBhk: json['select_bhk'],
      floorNumber: json['floor_number'],
      squareFeet: json['sqyare_feet'],
      propertyNameAddress: json['propertyname_address'],
      buildingInformationFacilities: json['building_information_facilitys'],
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'],
      ownerVehicleNumber: json['owner_vehical_number'],
      yourAddress: json['your_address'],
      fieldWorkerName: json['fieldworkarname'],
      fieldWorkerNumber: json['fieldworkarnumber'],
      currentDate: json['current_date_'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      metroName: json['metro_name'],
      mainMarketDistance: json['main_market_distance'],
      ageOfProperty: json['age_of_property'],
      lift: json['lift'],
      parking: json['parking'],
      totalFloor: json['total_floor'],
      residenceCommercial: json['Residence_commercial'],
      facility: json['facility'],
    );
  }
}

class ADministaterShow_FutureProperty extends StatefulWidget {
  static const administaterShowFutureProperty = '/administaterShowFutureProperty';
  final bool fromNotification;
  final String? buildingId;
  const ADministaterShow_FutureProperty({super.key ,
    this.fromNotification = false,
    this.buildingId,});

  @override
  State<ADministaterShow_FutureProperty> createState() => _ADministaterShow_FuturePropertyState();
}

class _ADministaterShow_FuturePropertyState extends State<ADministaterShow_FutureProperty> {


  String _number = '';
  String? _highlightedBuildingId;
  bool _hasScrolled = false;

  final Map<String, GlobalKey> _cardKeys = {};
  final ScrollController _horizontalController = ScrollController();

  List<Catid> _catidList = [];
  ScrollController _verticalController = ScrollController();

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=9711775300"); //sumit
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData1() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=9711275300"); //ravi
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData2() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=9971172204"); //faizan
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> av() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=11"); //faizan
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }
  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _loadData();

    // Firebase notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.containsKey('building_id')) {
        String buildingId = message.data['building_id'];
        debugPrint("📩 Notification Building ID: $buildingId");

        _loadDataAndScroll(buildingId);
      }
    });

    // Agar background ya terminated state se aaye
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey('building_id')) {
        String buildingId = message.data['building_id'];
        debugPrint("📩 Opened App with Building ID: $buildingId");

        _loadDataAndScroll(buildingId);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && args["fromNotification"] == true && args["buildingId"] != null) {
        _highlightedBuildingId = args["buildingId"].toString();
        debugPrint("👉 Notification opened with buildingId: $_highlightedBuildingId");

        // Load data and scroll to highlighted property
        _loadDataAndScroll(_highlightedBuildingId!);
      } else {
        // Normal page load
        _loadData();
      }
    });

  }

  Widget buildHorizontalList(List<Catid> data) {
    return Container(
      height: 520,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, i) {
          final prop = data[i];
          final key = _cardKeys.putIfAbsent(prop.id.toString(), () => GlobalKey());

          // Assign key if not exists
          if (!_cardKeys.containsKey(prop.id.toString())) {
            _cardKeys[prop.id.toString()] = GlobalKey();
          }
          return Container(
            key: key,
            width: 340,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _highlightedBuildingId == prop.id.toString()
                    ? Colors.red
                    : Colors.grey[200]!,
                width: _highlightedBuildingId == prop.id.toString() ? 3 : 1,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Administater_Future_Property_details(
                      idd: prop.id.toString(),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl:
                      "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${prop.images ?? ""}",
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(prop.ownerName ?? 'Unknown Owner'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadDataAndScroll(String buildingId) async {
    // 1. Agar widget unmounted hai → return karo
    if (!mounted) return;

    // 2. Update highlighted ID
    setState(() {
      _highlightedBuildingId = buildingId;
    });

    // 3. Fetch API data
    final data1 = await fetchData();
    final data2 = await fetchData1();
    final data3 = await fetchData2();
    final data4 = await av();

    if (!mounted) return; // again check

    setState(() {
      _catidList1 = data1;
      _catidList2 = data2;
      _catidList3 = data3;
      _catidList4 = data4;

      for (var p in [..._catidList1, ..._catidList2, ..._catidList3, ..._catidList4]) {
        if (!_cardKeys.containsKey(p.id.toString())) {
          _cardKeys[p.id.toString()] = GlobalKey();
        }
      }});

    // 4. Scroll AFTER build is finished
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToHighlightedVertical();
      }
    });
  }
  Future<void> _scrollToHighlighted() async {
    if (_highlightedBuildingId == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _cardKeys[_highlightedBuildingId!];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );

        // Horizontal scroll inside ListView
        final index = [..._catidList1, ..._catidList2, ..._catidList3, ..._catidList4]
            .indexWhere((p) => p.id.toString() == _highlightedBuildingId);

        if (index != -1) {
          _horizontalController.animateTo(
            index * 352.0, // card width + margin
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        // Retry after 200ms if widget not yet built
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollToHighlighted();
        });
      }
    });
  }

  void _scrollToHighlightedHorizontal() {
    if (_highlightedBuildingId == null || _hasScrolled) return;

    final index =
    _catidList.indexWhere((e) => e.id?.toString() == _highlightedBuildingId);

    if (index != -1) {
      _horizontalController.animateTo(
        index * 352.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _hasScrolled = true;
    }
  }
  Future<void> _loadData() async {
    try {
      final data1 = await fetchData();
      final data2 = await fetchData1();
      final data3 = await fetchData2();
      final data4 = await av();

      if (!mounted) return;

      setState(() {
        _catidList1 = data1;
        _catidList2 = data2;
        _catidList3 = data3;
        _catidList4 = data4;

        // Assign keys once for all properties
        for (var p in [..._catidList1, ..._catidList2, ..._catidList3, ..._catidList4]) {
          if (!_cardKeys.containsKey(p.id.toString())) {
            _cardKeys[p.id.toString()] = GlobalKey();
          }
        }
      });

      // Auto scroll if highlighted
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToHighlightedVertical();
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }
  void _scrollToHighlightedVertical() {
    if (_highlightedBuildingId == null) return;

    final key = _cardKeys[_highlightedBuildingId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
      debugPrint("✅ Scrolled to $_highlightedBuildingId");
    } else {
      debugPrint("⚠️ Widget not found yet for $_highlightedBuildingId");

      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToHighlightedVertical();
      });
    }
  }



  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  List<Catid> _catidList1 = [];
  List<Catid> _catidList2 = [];
  List<Catid> _catidList3 = [];
  List<Catid> _catidList4 = [];


  bool _isDeleting = false;

  //Delete api
  Future<void> DeletePropertybyid(itemId) async {
    final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {
      setState(() {
        _isDeleting = false;
        //ShowVehicleNumbers(id);
        //showVehicleModel?.vehicleNo;
      });
      print(response.body.toString());
      print('Item deleted successfully');
    } else {
      print('Error deleting item. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
  String formatDate(String date) {
    try {
      return DateFormat("dd/MMM/yyyy").format(DateTime.parse(date));
    } catch (e) {
      return date; // fallback if parsing fails
    }
  }


  Widget buildSection(String title, List<Catid> data, String seeAllId) {
    // Assign a key for vertical scrolling
    final sectionKey = _cardKeys.isNotEmpty && _cardKeys.containsKey(data.first.id.toString())
        ? _cardKeys[data.first.id.toString()]
        : GlobalKey();

    // Store the key for future scrolls
    _cardKeys[data.first.id.toString()] = sectionKey!;

    return Container(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          SeeAll_FutureProperty(id: seeAllId)));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('See All',
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                ),
              ),
            ],
          ),
          buildHorizontalList(data),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(

      // backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        // actions:  [
        //   GestureDetector(
        //     onTap: () {
        //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Filter_Options()));
        //       _showBottomSheet(context);
        //     },
        //     child: const Icon(
        //       PhosphorIcons.faders,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        controller: _verticalController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_catidList1.isNotEmpty) buildHorizontalList(_catidList1),
            if (_catidList2.isNotEmpty) buildHorizontalList(_catidList2),
            if (_catidList3.isNotEmpty) buildHorizontalList(_catidList3),
            if (_catidList4.isNotEmpty) buildHorizontalList(_catidList4),
          ],
        ),
      ),
    );

  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }

  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }


}
