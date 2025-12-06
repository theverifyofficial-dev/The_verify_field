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
import '../ui_decoration_tools/app_images.dart';
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
  final String typeofProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintenance;
  final String parking;
  final String ageOfProperty;
  final String fieldWorkerAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String? videoStatus;        // NEW
  final String ownerName;
  final String ownerNumber;
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishing;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String fieldWorkerCurrentLocation;
  final String caretakerName;
  final String caretakerNumber;
  final String longitude;
  final String latitude;
  final String videoLink;
  final int subid;
  final String? sourceId; // NEW, nullable

  Catid({
    required this.id,
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
    required this.maintenance,
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
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishing,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.fieldWorkerCurrentLocation,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.subid,
    this.sourceId, // NEW
    this.videoStatus, // NEW
  });

  static String _s(dynamic v) => v?.toString() ?? '';
  static int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: _i(json['P_id']),
      propertyPhoto: _s(json['property_photo']),
      locations: _s(json['locations']),
      flatNumber: _s(json['Flat_number']),
      buyRent: _s(json['Buy_Rent']),
      residenceCommercial: _s(json['Residence_Commercial']),
      apartmentName: _s(json['Apartment_name']),
      apartmentAddress: _s(json['Apartment_Address']),
      typeofProperty: _s(json['Typeofproperty']),
      bhk: _s(json['Bhk']),
      showPrice: _s(json['show_Price']),
      lastPrice: _s(json['Last_Price']),
      askingPrice: _s(json['asking_price']),
      floor: _s(json['Floor_']),
      totalFloor: _s(json['Total_floor']),
      balcony: _s(json['Balcony']),
      squarefit: _s(json['squarefit']),
      maintenance: _s(json['maintance']),
      parking: _s(json['parking']),
      ageOfProperty: _s(json['age_of_property']),
      fieldWorkerAddress: _s(json['fieldworkar_address']),
      roadSize: _s(json['Road_Size']),
      metroDistance: _s(json['metro_distance']),
      highwayDistance: _s(json['highway_distance']),
      mainMarketDistance: _s(json['main_market_distance']),
      meter: _s(json['meter']),
      ownerName: _s(json['owner_name']),
      ownerNumber: _s(json['owner_number']),
      currentDate: _s(json['current_dates']),
      // your API sometimes sends ISO datetime; we keep it as raw string
      availableDate: _s(json['available_date']),
      kitchen: _s(json['kitchen']),
      bathroom: _s(json['bathroom']),
      lift: _s(json['lift']),
      facility: _s(json['Facility']),
      furnishing: _s(json['furnished_unfurnished']),
      fieldWorkerName: _s(json['field_warkar_name']),
      liveUnlive: _s(json['live_unlive']),
      fieldWorkerNumber: _s(json['field_workar_number']),
      registryAndGpa: _s(json['registry_and_gpa']),
      loan: _s(json['loan']),
      fieldWorkerCurrentLocation: _s(json['field_worker_current_location']),
      caretakerName: _s(json['care_taker_name']),
      caretakerNumber: _s(json['care_taker_number']),
      longitude: _s(json['Longitude']),
      latitude: _s(json['Latitude']),
      videoLink: _s(json['video_link']),
      subid: _i(json['subid']),
      sourceId: json['source_id']?.toString(), // NEW
      videoStatus: _s(json['video_status']),
    );
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


  String _name = '';
  String _number = '';
  String _location = '';
  String _post = '';

// ---- Shared helpers ----
  List<Map<String, dynamic>> _normalizeList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } else if (raw is Map) {
      return [Map<String, dynamic>.from(raw)];
    }
    return const <Map<String, dynamic>>[];
  }

  dynamic _unwrapBody(dynamic decoded) {
    // Handle { success: true, data: [...] }
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    // Handle .asmx pattern: { "d": "[{...}]" } or { "d": {...} }
    if (decoded is Map<String, dynamic> && decoded.containsKey('d')) {
      final d = decoded['d'];
      try {
        return d is String ? json.decode(d) : d;
      } catch (_) {
        return d; // if not decodable, return as-is
      }
    }
    // Otherwise assume the decoded JSON is already the payload
    return decoded;
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
      _location = prefs.getString('location') ?? '';
      _post = prefs.getString('post') ?? '';
    });

    print("===== SHARED PREF DATA LOADED =====");
    print("Name: $_name");
    print("Number: $_number");
    print("Location: $_location");
    print("Post: $_post");
    print("===================================");
  }

  Future<List<Catid>> _fetchCommon(Uri url) async {
    final resp = await http.get(url);
    if (resp.statusCode != 200) {
      throw Exception("HTTP ${resp.statusCode}: ${resp.body}");
    }

    final decoded = json.decode(resp.body);
    final payload = _unwrapBody(decoded);
    final list = _normalizeList(payload);

    // Newest first by P_id if present
    int asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? '') ?? 0);
    list.sort((a, b) => asInt(b['P_id']).compareTo(asInt(a['P_id'])));

    return list.map((e) => Catid.fromJson(e)).toList();
  }

  Future<List<Catid>> av() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
          "?field_workar_number=11&live_unlive=Live",
    );
    return _fetchCommon(url);
  }

  Future<List<Catid>> fetchData() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
          "?field_workar_number=9711775300&live_unlive=Live",
    );
    return _fetchCommon(url);
  }

  Future<List<Catid>> fetchData1() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
          "?field_workar_number=9711275300&live_unlive=Live",
    );
    return _fetchCommon(url);
  }

  Future<List<Catid>> fetchData2() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
          "?field_workar_number=9971172204&live_unlive=Live",
    );
    return _fetchCommon(url);
  }

  Future<List<Catid>> fetchData_manishProperty() async {
    final url = Uri.parse(
      "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
          "?field_workar_number=8130209217&live_unlive=Live",
    );
    return _fetchCommon(url);
  }
  Future<List<Catid>> fetchData_abheyProperty() async {
    final url = Uri.parse(
      "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat?field_workar_number=9675383184&live_unlive=Live",
    );
    return _fetchCommon(url);
  }

  String? _highlightedFlatId;
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

    // Load user data immediately when screen opens
    _loaduserdata();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final flatId = args?['flatId'];

      if (flatId != null) {
        setState(() {
          _highlightedFlatId = flatId.toString();
        });

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



  @override
  void dispose() {
    _scrollController.dispose();
    _verticalController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final loc = _location.trim().toLowerCase();

    final post = _post.trim().toLowerCase();

    bool isSubAdmin = post == "sub administrator";
    bool isAdmin = post == "administrator";

    return Scaffold(
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
            if (isAdmin || loc == "sultanpur")
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
                              height: 450,
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
            if (isAdmin || loc == "sultanpur")
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
                              height: 450,
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
            if (isAdmin || loc == "sultanpur")
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
                              height: 450,
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

            if (isAdmin || loc.contains("rajpur") || loc.contains("chhattar"))
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return FutureBuilder<List<Catid>>(
                      future: fetchData_manishProperty(), // Manish API
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          _apiRajpurLoaded = true;
                          _tryScrollToHighlighted();
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Lottie.asset(AppImages.loadingHand, height: 400),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Failed to load properties"));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No properties available"));
                        }

                        final data = snapshot.data!;
                        final scrollController = ScrollController();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Manish",
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
                                          builder: (context) =>
                                              See_All_Realestate(id: '8130209217'),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View All",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_forward_ios_rounded,
                                            size: 14, color: Colors.blue),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 450,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, idx) {
                                  final property = data[idx];
                                  final idKey = property.id.toString();

                                  _cardKeys.putIfAbsent(idKey, () => GlobalKey());

                                  return PropertyCard(
                                    cardKey: _cardKeys[idKey],
                                    property: property,
                                    displayIndex: data.length - idx,
                                    isHighlighted: idKey == _highlightedFlatId,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Administater_View_Details(
                                                  idd: property.id.toString()),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  childCount: 1,
                ),
              ),
            if (isAdmin || loc.contains("rajpur") || loc.contains("chhattar"))
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return FutureBuilder<List<Catid>>(
                      future: fetchData_abheyProperty(), // Manish API
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          _apiRajpurLoaded = true;
                          _tryScrollToHighlighted();
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Lottie.asset(AppImages.loadingHand, height: 400),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Failed to load properties"));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No properties available"));
                        }

                        final data = snapshot.data!;
                        final scrollController = ScrollController();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Abhey",
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
                                          builder: (context) =>
                                              See_All_Realestate(id: '9675383184'),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View All",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_forward_ios_rounded,
                                            size: 14, color: Colors.blue),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 450,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, idx) {
                                  final property = data[idx];
                                  final idKey = property.id.toString();

                                  _cardKeys.putIfAbsent(idKey, () => GlobalKey());

                                  return PropertyCard(
                                    cardKey: _cardKeys[idKey],
                                    property: property,
                                    displayIndex: data.length - idx,
                                    isHighlighted: idKey == _highlightedFlatId,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Administater_View_Details(
                                                  idd: property.id.toString()),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.red : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          elevation: 4,
          shadowColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isHighlighted
              ? Colors.red.withOpacity(0.01)
              : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(context),
              _buildContentSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // IMAGE + TOP TAGS SECTION
  // ---------------------------------------------------------
  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 450,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: Theme.of(context).highlightColor,
          ),
          child: Image.network(
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Icon(Icons.home, size: 50, color: Theme.of(context).hintColor),
            ),
          ),
        ),

        // TOP TAGS
        Positioned(
          top: 12,
          right: 12,
          child: Wrap(
            spacing: 8,
            children: [
              _pillTag(
                text: "Live Property ID : ${property.id}",
                textColor: Colors.blue,
                bg: Colors.white,
                border: Colors.grey.shade700,
              ),
              _pillTag(
                text: "For: ${property.buyRent}",
                textColor: Colors.green.shade700,
                bg: Colors.green.shade100,
                border: Colors.green.shade400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // CONTENT SECTION
  // ---------------------------------------------------------
  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRICE + LOCATION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹${property.showPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "PoppinsBold",
                  color: Colors.black,
                ),
              ),
              Text(
                property.locations,
                style: const TextStyle(
                  fontFamily: "PoppinsBold",
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // FEATURE TAGS
          Wrap(
            spacing: 4,
            runSpacing: 8,
            children: [
              _iconPill(
                icon: Icons.king_bed,
                text: property.bhk,
                bg: Colors.purple.shade50,
                border: Colors.purple.shade200,
                textColor: Colors.purple.shade700,
              ),

              _iconPill(
                icon: Icons.apartment,
                text: property.floor,
                bg: Colors.teal.shade50,
                border: Colors.teal.shade200,
                textColor: Colors.teal.shade700,
              ),

              _iconPill(
                icon: Icons.receipt_long,
                text: "Flat No. ${property.flatNumber}",
                bg: Colors.red.shade50,
                border: Colors.red.shade200,
                textColor: Colors.red.shade700,
              ),

              _iconPill(
                icon: Icons.house_outlined,
                text: property.typeofProperty,
                bg: Colors.orange.shade50,
                border: Colors.orange.shade200,
                textColor: Colors.orange.shade700,
              ),

              if (property.subid != null && property.subid != "0")
                _pillTag(
                  text: "Building ID : ${property.subid}",
                  textColor: Colors.deepOrange.shade700,
                  bg: Colors.deepOrange.shade100,
                  border: Colors.deepOrange.shade400,
                ),

              _pillTag(
                text: "Building Flat ID : ${property.id}",
                textColor: Colors.blue.shade700,
                bg: Colors.blue.shade100,
                border: Colors.blue.shade400,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // VIDEO STATUS BUTTON (IF ANY)
          if (property.videoStatus != null && property.videoStatus!.isNotEmpty)
            _videoStatusButton(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SMALL FEATURE PILL WITHOUT ICON
  // ---------------------------------------------------------
  Widget _pillTag({
    required String text,
    required Color textColor,
    required Color bg,
    required Color border,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // FEATURE PILL WITH ICON
  // ---------------------------------------------------------
  Widget _iconPill({
    required IconData icon,
    required String text,
    required Color bg,
    required Color border,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // VIDEO STATUS WIDGET
  // ---------------------------------------------------------
  Widget _videoStatusButton(BuildContext context) {
    String status = property.videoStatus!.toLowerCase().trim();

    Color bg;
    if (status == "") bg = Colors.red;
    else if (status == "video submitted") bg = Colors.green;
    else if (status == "video requested by editor") bg = Colors.blue;
    else if (status == "video recived and editing started") bg = Colors.orange;
    else if (status == "video uploaded") bg = Colors.purple;
    else bg = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            status == "video submitted" ? Icons.check_circle : Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            property.videoStatus!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
