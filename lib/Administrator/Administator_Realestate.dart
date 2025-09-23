import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../ui_decoration_tools/constant.dart';
import 'Add_Assign_Tenant_Demand/See_All_Realestate.dart';
import 'Administater_Realestate_Details.dart';

class Catid {
  final int id;
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
  final String squareFit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldWorkerAddress;
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
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final int subid;

  const Catid({
    required this.id,
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
    required this.squareFit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldWorkerAddress,
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
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['P_id'] is int
          ? json['P_id']
          : int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,
      propertyPhoto: json['property_photo']?.toString() ?? '',
      locations: json['locations']?.toString() ?? '',
      flatNumber: json['Flat_number']?.toString() ?? '',
      buyRent: json['Buy_Rent']?.toString() ?? '',
      residenceCommercial: json['Residence_Commercial']?.toString() ?? '',
      apartmentName: json['Apartment_name']?.toString() ?? '',
      apartmentAddress: json['Apartment_Address']?.toString() ?? '',
      typeOfProperty: json['Typeofproperty']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      showPrice: json['show_Price']?.toString() ?? '',
      lastPrice: json['Last_Price']?.toString() ?? '',
      askingPrice: json['asking_price']?.toString() ?? '',
      floor: json['Floor_']?.toString() ?? '',
      totalFloor: json['Total_floor']?.toString() ?? '',
      balcony: json['Balcony']?.toString() ?? '',
      squareFit: json['squarefit']?.toString() ?? '',
      maintance: json['maintance']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      fieldWorkerAddress: json['fieldworkar_address']?.toString() ?? '',
      roadSize: json['Road_Size']?.toString() ?? '',
      metroDistance: json['metro_distance']?.toString() ?? '',
      highwayDistance: json['highway_distance']?.toString() ?? '',
      mainMarketDistance: json['main_market_distance']?.toString() ?? '',
      meter: json['meter']?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
      ownerNumber: json['owner_number']?.toString() ?? '',
      currentDates: json['current_dates']?.toString() ?? '',
      availableDate: json['available_date']?.toString() ?? '',
      kitchen: json['kitchen']?.toString() ?? '',
      bathroom: json['bathroom']?.toString() ?? '',
      lift: json['lift']?.toString() ?? '',
      facility: json['Facility']?.toString() ?? '',
      furnishedUnfurnished: json['furnished_unfurnished']?.toString() ?? '',
      fieldWorkerName: json['field_warkar_name']?.toString() ?? '',
      liveUnlive: json['live_unlive']?.toString() ?? '',
      fieldWorkerNumber: json['field_workar_number']?.toString() ?? '',
      registryAndGpa: json['registry_and_gpa']?.toString() ?? '',
      loan: json['loan']?.toString() ?? '',
      longitude: json['Longitude']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      videoLink: json['video_link']?.toString() ?? '',
      fieldWorkerCurrentLocation:
      json['field_worker_current_location']?.toString() ?? '',
      careTakerName: json['care_taker_name']?.toString() ?? '',
      careTakerNumber: json['care_taker_number']?.toString() ?? '',
      subid: json['subid'] is int
          ? json['subid']
          : int.tryParse(json['subid']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "P_id": id,
      "property_photo": propertyPhoto,
      "locations": locations,
      "Flat_number": flatNumber,
      "Buy_Rent": buyRent,
      "Residence_Commercial": residenceCommercial,
      "Apartment_name": apartmentName,
      "Apartment_Address": apartmentAddress,
      "Typeofproperty": typeOfProperty,
      "Bhk": bhk,
      "show_Price": showPrice,
      "Last_Price": lastPrice,
      "asking_price": askingPrice,
      "Floor_": floor,
      "Total_floor": totalFloor,
      "Balcony": balcony,
      "squarefit": squareFit,
      "maintance": maintance,
      "parking": parking,
      "age_of_property": ageOfProperty,
      "fieldworkar_address": fieldWorkerAddress,
      "Road_Size": roadSize,
      "metro_distance": metroDistance,
      "highway_distance": highwayDistance,
      "main_market_distance": mainMarketDistance,
      "meter": meter,
      "owner_name": ownerName,
      "owner_number": ownerNumber,
      "current_dates": currentDates,
      "available_date": availableDate,
      "kitchen": kitchen,
      "bathroom": bathroom,
      "lift": lift,
      "Facility": facility,
      "furnished_unfurnished": furnishedUnfurnished,
      "field_warkar_name": fieldWorkerName,
      "live_unlive": liveUnlive,
      "field_workar_number": fieldWorkerNumber,
      "registry_and_gpa": registryAndGpa,
      "loan": loan,
      "Longitude": longitude,
      "Latitude": latitude,
      "video_link": videoLink,
      "field_worker_current_location": fieldWorkerCurrentLocation,
      "care_taker_name": careTakerName,
      "care_taker_number": careTakerNumber,
      "subid": subid,
    };
  }
}

class ADministaterShow_realestete extends StatefulWidget {
  static const administaterShowRealEstate = "/administater_show_realestate";

  final bool fromNotification;
  final String? flatId;

  const ADministaterShow_realestete({
    super.key,
    this.fromNotification = false,
    this.flatId,

  });

  @override
  State<ADministaterShow_realestete> createState() => _ADministaterShow_realesteteState();
}

class _ADministaterShow_realesteteState extends State<ADministaterShow_realestete> {
  final _formKey = GlobalKey<FormState>();

  void _showBottomSheet(BuildContext context) {

    List<String> timing = [
      "Residential",
      "Plots",
      "Commercial",
    ];
    ValueNotifier<int> timingIndex = ValueNotifier(0);

    String displayedData = "Press a button to display data";

    void updateData(String newData) {
      setState(() {
        displayedData = newData;
      });
    }

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 5,right: 5,top: 0, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(3),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.grey),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      Tab(text: 'Residential'),
                      Tab(text: 'Commercial'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    Filter_Options(),
                    Commercial_Filter()
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String _number = '';



  Future<List<Catid>> av() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat?field_workar_number=11&live_unlive=Live",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("av error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat?field_workar_number=9711775300&live_unlive=Live",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData1() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
            "?field_workar_number=9711275300&live_unlive=Live",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData2() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
            "?field_workar_number=9971172204&live_unlive=Live",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData_rajpur() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
            "?field_workar_number=9818306096&live_unlive=Live",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  String? _highlightedFlatId;
  bool _hasHighlighted = false;
  List<Catid> _properties = [];
  bool _didAutoScroll = false;
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;
  final Map<String, GlobalKey> _cardKeys = {};

// ✅ API load flags
  bool _apiAvLoaded = false;
  bool _apiFetchDataLoaded = false;
  bool _apiFetchData1Loaded = false;
  bool _apiFetchData2Loaded = false;
  bool _apiRajpurLoaded = false;

// ✅ Vertical scrolling of main CustomScrollView
  final ScrollController _verticalController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final flatId = args?['flatId'];

      if (flatId != null) {
        setState(() {
          _highlightedFlatId = flatId.toString();
        });

        // ✅ Scroll after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToHighlighted();
        });
      }
    });
  }

  /// ✅ Trigger scroll only after all APIs loaded
  void _tryScrollToHighlighted() {
    if (_apiAvLoaded &&
        _apiFetchDataLoaded &&
        _apiFetchData1Loaded &&
        _apiFetchData2Loaded &&
        _apiRajpurLoaded &&
        _highlightedFlatId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlighted();
      });
    }
  }

  /// ✅ Ensure visible vertically
  void _scrollToHighlighted() {
    if (_highlightedFlatId != null && !_hasScrolled) {
      final key = _cardKeys[_highlightedFlatId!];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
        _hasScrolled = true;
      }
    }
  }

  Future<void> _scrollAfterAllLoaded() async {
    await Future.wait([
      fetchData(),
      fetchData1(),
      fetchData2(),
      av(),
      fetchData_rajpur(),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlighted());
  }

  Future<void> _loaduserdata() async {
    final data = await av();
    if (mounted) {
      setState(() {
        _properties = data;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  bool _isDeleting = false;
  //Delete api
  Future<void> DeletePropertyById(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
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
      body: Form(
        key: GlobalKey<FormState>(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FutureBuilder<List<Catid>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _apiFetchDataLoaded = true;
                        _tryScrollToHighlighted();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child:
                              Lottie.asset(AppImages.loadingHand, height: 400),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load properties'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No properties available'));
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Your header UI
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Sumit kasaniya' ,   style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFamily: "PoppinsBold",
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface,
                              ),),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              See_All_Realestate(
                                                  id: '9711775300'),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text('View All',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                          ) ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.blue[700],
                                            size: 14),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔹 Horizontal list
                            SizedBox(
                              height: 440,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final property = snapshot.data![index];
                                  final flatId = property.id.toString();

                                  // 🔑 assign key here
                                  _cardKeys.putIfAbsent(
                                      flatId, () => GlobalKey());

                                  return PropertyCard(
                                    cardKey: _cardKeys[flatId],
                                    // ✅ attach key
                                    property: property,
                                    displayIndex: snapshot.data!.length - index,
                                    isHighlighted: flatId == _highlightedFlatId,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Administater_View_Details(
                                            idd: property.id.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
                childCount: 1,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FutureBuilder<List<Catid>>(
                    future: fetchData1(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _apiFetchData1Loaded = true;
                        _tryScrollToHighlighted();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child:
                              Lottie.asset(AppImages.loadingHand, height: 400),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load properties',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_work_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No properties available',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontFamily: "Poppins",
                                    ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final data = snapshot.data!;
                        final scrollController = ScrollController();

                        // ✅ auto-scroll if highlightedFlatId exists
                        if (_highlightedFlatId != null) {
                          final foundIndex = data.indexWhere(
                              (p) => p.id.toString() == _highlightedFlatId);
                          if (foundIndex != -1) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (scrollController.hasClients) {
                                scrollController.animateTo(
                                  foundIndex * 250, // 250 = card width approx
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            });
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ravi Kumar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "PoppinsBold",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              See_All_Realestate(
                                                  id: '9711275300'),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'View All',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 14,
                                            color: Colors.blue[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 440,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, idx) {
                                  final property = data[idx];
                                  return PropertyCard(
                                    property: property,
                                    displayIndex: data.length - idx,
                                    isHighlighted: property.id.toString() ==
                                        _highlightedFlatId,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Administater_View_Details(
                                            idd: property.id.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
                childCount: 1,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FutureBuilder<List<Catid>>(
                    future: fetchData2(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _apiFetchData2Loaded = true;
                        _tryScrollToHighlighted();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child:
                              Lottie.asset(AppImages.loadingHand, height: 400),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load properties',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_work_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No properties available',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontFamily: "Poppins",
                                    ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final data = snapshot.data!;
                        final scrollController = ScrollController();

                        // ✅ Auto-scroll if highlightedFlatId matches
                        if (_highlightedFlatId != null) {
                          final foundIndex = data.indexWhere(
                              (p) => p.id.toString() == _highlightedFlatId);
                          if (foundIndex != -1) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (scrollController.hasClients) {
                                scrollController.animateTo(
                                  foundIndex * 250, // approx card width
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            });
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Faizan Khan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "PoppinsBold",
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              See_All_Realestate(
                                                  id: '9971172204'),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'View All',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 14,
                                            color: Colors.blue[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 440,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, idx) {
                                  final property = data[idx];
                                  return PropertyCard(
                                    property: property,
                                    displayIndex: data.length - idx,
                                    isHighlighted: property.id.toString() ==
                                        _highlightedFlatId,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Administater_View_Details(
                                            idd: property.id.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
                childCount: 1,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return FutureBuilder<List<Catid>>(
                    future: fetchData_rajpur(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _apiRajpurLoaded = true;
                        _tryScrollToHighlighted();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Lottie.asset(AppImages.loadingHand, height: 400),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Failed to load properties',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontFamily: "Poppins",
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_work_outlined, size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No properties available',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final data = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rajpur Properties',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "PoppinsBold",
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => See_All_Realestate(id: '9818306096'),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'View All',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blue[700]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 440,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final property = data[index];
                                  return PropertyCard(
                                    key: _cardKeys.putIfAbsent(property.id.toString(), () => GlobalKey()), // ✅ key for each card
                                    property: property,
                                    displayIndex: data.length - index,
                                    isHighlighted: property.id.toString() == _highlightedFlatId,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Administater_View_Details(idd: property.id.toString()),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),

    );
  }
// Helper Widget for Feature Pills
  Widget _buildFeaturePill(IconData icon, String text, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: iconColor,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
  void _loaduserdata1() async {
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
class PropertyCard extends StatelessWidget {
  final Catid property;
  final int displayIndex;
  final VoidCallback onTap;
  final bool isHighlighted;
  final Key? cardKey;

  const PropertyCard({
    super.key,
    required this.property,
    required this.displayIndex,
    required this.onTap,
    this.isHighlighted = false,
    this.cardKey,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.45;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        key: cardKey,
        duration: const Duration(milliseconds: 400),
        width: screenWidth * 0.75,
        margin: const EdgeInsets.only(right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? Colors.red : Colors.transparent,
            width: isHighlighted ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Property image
            _buildImage(context, property, imageHeight),

            // 📝 Property details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocation(context, property),
                    const SizedBox(height: 12),
                    _buildFeatures(property),
                    const SizedBox(height: 16),
                    _buildDescription(context, property, displayIndex),
                    const SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey[200]),
                    const SizedBox(height: 8),
                    _buildFooter(context, property),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


// ---------------------- IMAGE ----------------------
  Widget _buildImage(BuildContext context, Catid property, double imageHeight) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Stack(
          children: [
            /// Background Image
            CachedNetworkImage(
              imageUrl:
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
              fit: BoxFit.cover,
              width: double.infinity,
              height: imageHeight,
              placeholder: (context, url) => Container(
                color: Colors.grey[100],
                child: Center(
                  child: Image.asset(AppImages.loader, height: 50, width: 50),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[100],
                child: const Icon(
                  Icons.home_work_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),

            /// Price overlay
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "₹ ${property.showPrice}", // <-- replace `price` with actual field
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "PoppinsBold",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ---------------------- LOCATION ----------------------
  Widget _buildLocation(BuildContext context, Catid property) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            property.locations,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

// ---------------------- FEATURES ----------------------
  Widget _buildFeatures(Catid property) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFeaturePill(Icons.category_outlined, property.typeOfProperty.toUpperCase(), Colors.blue[100]!, Colors.blue[800]!),
        _buildFeaturePill(Icons.currency_rupee_outlined, property.buyRent.toUpperCase(), Colors.green[100]!, Colors.green[800]!),
        _buildFeaturePill(Icons.bed_outlined, property.bhk.toUpperCase(), Colors.orange[100]!, Colors.orange[800]!),
        _buildFeaturePill(Icons.stairs_outlined, "${property.floor}", Colors.purple[100]!, Colors.purple[800]!),
      ],
    );
  }

// ---------------------- DESCRIPTION ----------------------
  Widget _buildDescription(BuildContext context, Catid property, int displayIndex) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.apartmentAddress,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Property No: $displayIndex",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

// ---------------------- FOOTER ----------------------
  Widget _buildFooter(BuildContext context, Catid property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ID: ${property.id}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
        Text(
          property.availableDate,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[600],
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }

// ---------------------- FEATURE PILL ----------------------
  Widget _buildFeaturePill(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontFamily: "Poppins")),
        ],
      ),
    );
  }
// ---------------------- MAIN CARD ----------------------
  Widget _buildPropertyCard(BuildContext context, Catid property, int displayIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.75; // 75% of screen width
    final imageHeight = cardWidth * 0.6;  // proportional height for image

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Property image
          _buildImage(context, property, imageHeight),

          // 📝 Property details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocation(context, property),
                  const SizedBox(height: 12),
                  _buildFeatures(property),
                  const SizedBox(height: 16),
                  _buildDescription(context, property, displayIndex),

                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey[200]),
                  const SizedBox(height: 8),

                  _buildFooter(context, property),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
