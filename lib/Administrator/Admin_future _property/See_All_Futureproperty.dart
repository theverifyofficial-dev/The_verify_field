import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../../ui_decoration_tools/app_images.dart';
import 'Future_Property_Details.dart';

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

  factory Catid.fromJson(Map<String, dynamic> json) {
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

class SeeAll_FutureProperty extends StatefulWidget {
  final String number;
  const SeeAll_FutureProperty({super.key, required this.number});

  @override
  State<SeeAll_FutureProperty> createState() => _SeeAll_FuturePropertyState();
}

class _SeeAll_FuturePropertyState extends State<SeeAll_FutureProperty> {
  String _number = '';
  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    _loaduserdata(); // this is cheap

    // Boot once: fetch data + counters in parallel,
    // but keep loader on screen for at least 2 seconds.
    _bootstrap();
  }
  Future<void> _bootstrap() async {
    // start both: a 2s delay and your real fetches
    final minSplash = Future.delayed(const Duration(seconds: 2));

    final dataFetch = () async {
      await fetchData();               // buildings list
      // if you insist on global counters at top, fetch them here in parallel
      await Future.wait([
        fetchTotalFlats(),
        fetchFlatsStatus(),
      ]);
      // do NOT prefetch live/unlive for every building here; that’s what made it slow.
      // You already fetch live/unlive lazily in the chip handler.
    }();

    // wait for both to complete
    await Future.wait([minSplash, dataFetch]);

    if (!mounted) return;
    setState(() => _isLoading = false);
  }


  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  final Map<int, bool> _liveMap = {};        // subid -> true if any flat is live
  final Map<int, int> _totalFlatsMap = {};   // subid -> total flats count
  bool _prefetching = false;
  List<Catid> _allProperties = [];
  List<Catid> _filteredProperties = [];
  Timer? _debounce;
  TextEditingController _searchController = TextEditingController();
  String selectedLabel = '';
  int propertyCount = 0;
  bool _isLoading = true;
  Future<void> _prefetchStatusesForAll() async {
    final futures = _allProperties.map((p) async {
      try {
        final res = await http.get(Uri.parse(
          'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${p.id}',
        ));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          bool anyLive = false;
          if (data is List && data.isNotEmpty) {
            for (var d in data) {
              if (d['live_unlive'] == 'Live' && (d['logs'] as num) > 0) {
                anyLive = true;
                break;
              }
            }
          }
          _liveMap[p.id] = anyLive; // true if any live, else false
        } else {
          _liveMap[p.id] = false; // be conservative
        }
      } catch (_) {
        _liveMap[p.id] = false;
      }
    }).toList();

    await Future.wait(futures);
  }


  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<Catid> filtered;

      if (query.isEmpty) {
        filtered = List.from(_allProperties);
        selectedLabel = ''; // optional reset
      } else if (query == "Missing Field") {
        // ✅ Show items if ANY field is null or empty (except ignored fields)
        filtered = _allProperties.where((item) {
          return (item.images == null || item.images!.trim().isEmpty) ||
              (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
              (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
              (item.caretakerName == null || item.caretakerName!.trim().isEmpty) ||
              (item.caretakerNumber == null || item.caretakerNumber!.trim().isEmpty) ||
              (item.place == null || item.place!.trim().isEmpty) ||
              (item.buyRent == null || item.buyRent!.trim().isEmpty) ||
              (item.propertyNameAddress == null || item.propertyNameAddress!.trim().isEmpty) ||
              (item.propertyAddressForFieldworker == null || item.propertyAddressForFieldworker!.trim().isEmpty) ||
              (item.ownerVehicleNumber == null || item.ownerVehicleNumber!.trim().isEmpty) ||
              (item.yourAddress == null || item.yourAddress!.trim().isEmpty) ||
              (item.fieldWorkerName == null || item.fieldWorkerName!.trim().isEmpty) ||
              (item.fieldWorkerNumber == null || item.fieldWorkerNumber!.trim().isEmpty) ||
              (item.currentDate == null || item.currentDate!.trim().isEmpty) ||
              (item.longitude == null || item.longitude!.trim().isEmpty) ||
              (item.latitude == null || item.latitude!.trim().isEmpty) ||
              (item.roadSize == null || item.roadSize!.trim().isEmpty) ||
              (item.metroDistance == null || item.metroDistance!.trim().isEmpty) ||
              (item.metroName == null || item.metroName!.trim().isEmpty) ||
              (item.mainMarketDistance == null || item.mainMarketDistance!.trim().isEmpty) ||
              (item.ageOfProperty == null || item.ageOfProperty!.trim().isEmpty) ||
              (item.lift == null || item.lift!.trim().isEmpty) ||
              (item.parking == null || item.parking!.trim().isEmpty) ||
              (item.totalFloor == null || item.totalFloor!.trim().isEmpty) ||
              (item.residenceCommercial == null || item.residenceCommercial!.trim().isEmpty) ||
              (item.facility == null || item.facility!.trim().isEmpty);
        }).toList();
      } else {
        // 🔍 Normal search
        filtered = _allProperties.where((item) {
          return (item.id.toString()).toLowerCase().contains(query) ||
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              (item.caretakerName ?? '').toLowerCase().contains(query) ||
              (item.place ?? '').toLowerCase().contains(query) ||
              (item.buyRent ?? '').toLowerCase().contains(query) ||
              (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
              (item.selectBhk ?? '').toLowerCase().contains(query) ||
              (item.floorNumber ?? '').toLowerCase().contains(query) ||
              (item.squareFeet ?? '').toLowerCase().contains(query) ||
              (item.propertyNameAddress ?? '').toLowerCase().contains(query) ||
              (item.residenceCommercial ?? '').toLowerCase().contains(query) ||
              (item.ownerNumber ?? '').toLowerCase().contains(query) ||
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber?? '').toLowerCase().contains(query) ||
              (item.buildingInformationFacilities ?? '').toLowerCase().contains(query) ||
              (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
              (item.yourAddress ?? '').toLowerCase().contains(query) ||
              (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
              (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
              (item.currentDate ?? '').toLowerCase().contains(query) ||
              (item.longitude ?? '').toLowerCase().contains(query) ||
              (item.latitude ?? '').toLowerCase().contains(query) ||
              (item.roadSize ?? '').toLowerCase().contains(query) ||
              (item.metroDistance ?? '').toLowerCase().contains(query) ||
              (item.metroName ?? '').toLowerCase().contains(query) ||
              (item.mainMarketDistance ?? '').toLowerCase().contains(query) ||
              (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
              (item.lift ?? '').toLowerCase().contains(query) ||
              (item.parking ?? '').toLowerCase().contains(query) ||
              (item.totalFloor ?? '').toLowerCase().contains(query) ||
              (item.residenceCommercial ?? '').toLowerCase().contains(query) ||
              (item.facility ?? '').toLowerCase().contains(query);
        }).toList();
      }

      setState(() {
        _filteredProperties = filtered;
        propertyCount = filtered.length;

        _recalculateSummary();
      });
    });
  }
  bool _blank(String? s) => s == null || s.trim().isEmpty;
  bool isLoading = true;

  List<String> _missingFieldsFor(Catid i) {
    final m = <String>[];
    final checks = <String, String?>{
      "Image": i.images,
      "Owner Name": i.ownerName,
      "Owner Number": i.ownerNumber,
      "Caretaker Name": i.caretakerName,
      "Caretaker Number": i.caretakerNumber,
      "Place": i.place,
      "Buy/Rent": i.buyRent,
      "Type of Property": i.typeOfProperty,
      "BHK": i.selectBhk,
      "Floor Number": i.floorNumber,
      "Square Feet": i.squareFeet,
      "Property Name/Address": i.propertyNameAddress,
      "Building Facilities": i.buildingInformationFacilities,
      "Address (Fieldworker)": i.propertyAddressForFieldworker,
      "Owner Vehicle Number": i.ownerVehicleNumber,
      "Your Address": i.yourAddress,
      "Field Worker Name": i.fieldWorkerName,
      "Field Worker Number": i.fieldWorkerNumber,
      "Current Date": i.currentDate,
      "Longitude": i.longitude,
      "Latitude": i.latitude,
      "Road Size": i.roadSize,
      "Metro Distance": i.metroDistance,
      "Metro Name": i.metroName,
      "Main Market Distance": i.mainMarketDistance,
      "Age of Property": i.ageOfProperty,
      "Lift": i.lift,
      "Parking": i.parking,
      "Total Floor": i.totalFloor,
      "Residence/Commercial": i.residenceCommercial,
      "Facility": i.facility,
    };
    checks.forEach((k, v) { if (_blank(v)) m.add(k); });
    return m;
  }

  bool _hasMissing(Catid i) => _missingFieldsFor(i).isNotEmpty;
  int bookFlats = 0;

  // ✅ Fetch API only once
  Future<void> fetchData() async {
    try {
      final url = Uri.parse(
          "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=${widget.number}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List listResponse = json.decode(response.body);
        listResponse.sort((a, b) => b['id'].compareTo(a['id']));

        setState(() {
          _allProperties = listResponse.map((data) => Catid.fromJson(data)).toList();
          _filteredProperties = _allProperties;
          propertyCount = _allProperties.length;
          _isLoading = false;
        });
        await _prefetchStatusesForAll();
      } else {
        throw Exception("Unexpected error occurred!");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      setState(() => _isLoading = false);
    }
  }
  Future<String> _fetchTotalFlatsForBuilding(int subid) async {
    try {
      final res = await http.get(Uri.parse(
        'https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$subid',
      ));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body is List && body.isNotEmpty) {
          // API usually returns [{ "logg": <int> }]
          final v = body[0]['logg'];
          return (v == null) ? "-" : v.toString();
        }
      }
      return "-";
    } catch (_) {
      return "-";
    }
  }
  int? totalFlats;
  int liveFlats = 0;
  Future<void> fetchFlatsStatus() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${widget.number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        int book = 0;
        int live = 0;

        for (var item in data) {
          if (item['live_unlive'] == "Book") {
            book = item['subid'] ?? 0;
          } else if (item['live_unlive'] == "Live") {
            live = item['subid'] ?? 0;
          }
        }

        setState(() {
          bookFlats = book;
          liveFlats = live;
          isLoading = false;
        });
      } else {
        setState(() {
          bookFlats = 0;
          liveFlats = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching flats status: $e");
      setState(() {
        bookFlats = 0;
        liveFlats = 0;
        isLoading = false;
      });
    }
  }

  Future<void> fetchTotalFlats() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${widget.number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns a list, take the first element's subid
        final subid = data.isNotEmpty ? data[0]['subid'] : 0;

        setState(() {
          totalFlats = subid;
          isLoading = false;
        });
      } else {
        setState(() {
          totalFlats = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        totalFlats = 0;
        isLoading = false;
      });
      print("Error fetching total flats: $e");
    }
  }
  Map<String, bool> _emptyBuildingMap = {}; // id → true if empty
  bool _prefetchingEmpty = false;
  Future<void> _prefetchEmptyStatus() async {
    _emptyBuildingMap.clear();

    try {
      final futures = _allProperties.map((item) async {
        try {
          final url = Uri.parse(
            'https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=${item.id}',
          );

          final res = await http.get(url);

          if (res.statusCode == 200) {
            final body = jsonDecode(res.body);

            int count = 0; // default

            if (body is List && body.isNotEmpty) {
              count = int.tryParse(body[0]['logg'].toString()) ?? 0;
            }

            // Empty = logg = 0
            _emptyBuildingMap[item.id.toString()] = (count == 0);
          }
        } catch (_) {
          _emptyBuildingMap[item.id.toString()] = false;
        }
      });

      await Future.wait(futures);
    } catch (e) {
      print("Empty building fetch error: $e");
    }
  }
  void _recalculateSummary() {
    totalFlats = _filteredProperties.length;

    liveFlats = _filteredProperties.where((item) {
      return _liveMap[item.id] == true;
    }).length;

    bookFlats = _filteredProperties.where((item) {
      return _liveMap[item.id] == false;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ?  Center(child: Lottie.asset(AppImages.loadingHand, height: 400),)
          :
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Search TextField
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.grey[100]!, Colors.grey[50]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search properties...',
                        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(Icons.search_rounded, color: Colors.grey.shade700, size: 24),
                        ),
                        suffixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: _searchController.text.isNotEmpty
                              ? IconButton(
                            key: const ValueKey('clear'),
                            icon: Icon(Icons.close_rounded, color: Colors.grey.shade700, size: 22),
                            onPressed: () {
                              _searchController.clear();
                              selectedLabel = '';
                              _filteredProperties = _allProperties;
                              propertyCount = _allProperties.length;
                              setState(() {});
                            },
                          )
                              : const SizedBox(key: ValueKey('empty')),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      // ✅ Complete search + filter logic
                      onChanged: (value) {
                        String query = value.toLowerCase();

                        List<Catid> filtered = _allProperties.where((item) {
                          return (item.propertyNameAddress?.toLowerCase().contains(query) ?? false) ||
                              (item.place?.toLowerCase().contains(query) ?? false) ||
                              (item.buyRent?.toLowerCase().contains(query) ?? false) ||
                              (item.ownerName?.toLowerCase().contains(query) ?? false) ||
                              (item.fieldWorkerName?.toLowerCase().contains(query) ?? false);
                        }).toList();

                        // Apply button filters if selected
                        if (selectedLabel == 'Missing Field') {
                          filtered = filtered.where((item) {
                            return (item.images == null || item.images!.trim().isEmpty) ||
                                (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
                                (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
                                (item.caretakerName == null || item.caretakerName!.trim().isEmpty);
                          }).toList();
                        }
                        else if (selectedLabel == 'Rent' || selectedLabel == 'Buy' || selectedLabel == 'Commercial') {
                          filtered = filtered.where((item) {
                            if (selectedLabel == 'Commercial') {
                              return (item.residenceCommercial?.toLowerCase() ?? '') == 'commercial';
                            } else {
                              return (item.buyRent?.toLowerCase() ?? '') == selectedLabel.toLowerCase();
                            }
                          }).toList();
                        }

                        setState(() {
                          _filteredProperties = filtered;
                          propertyCount = filtered.length;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔘 Filter Buttons Row

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Buy', 'Rent', 'Commercial', 'Live', 'Unlive', 'Empty Field','Empty Building']
                        .map((label) {
                      final isSelected = label == selectedLabel;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Toggle off
                            if (selectedLabel == label) {
                              setState(() {
                                selectedLabel = '';
                                _searchController.clear();
                                _filteredProperties = List.from(_allProperties);
                                propertyCount = _filteredProperties.length;
                              });
                              return;
                            }

                            // If Live/Unlive is requested, make sure we have the cache first.
                            if (label == 'Live' || label == 'Unlive') {
                              if (_prefetching) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Fetching live status… try again in a moment')),
                                );
                                return;
                              }
                              if (_liveMap.isEmpty) {
                                setState(() => _prefetching = true);
                                await _prefetchStatusesForAll();
                                if (!mounted) return;
                                setState(() => _prefetching = false);
                              }
                            }

                            List<Catid> filtered = List.from(_allProperties);

                            switch (label) {
                              case 'Commercial':
                                filtered = filtered
                                    .where((item) =>
                                (item.residenceCommercial?.toLowerCase() ?? '') ==
                                    'commercial')
                                    .toList();
                                break;

                              case 'Buy':
                              case 'Rent':
                                filtered = filtered
                                    .where((item) =>
                                (item.buyRent?.toLowerCase() ?? '') ==
                                    label.toLowerCase())
                                    .toList();
                                break;

                              case 'Live':
                              // Only items explicitly marked live in the cache
                                filtered = filtered
                                    .where((item) => _liveMap[item.id] == true)
                                    .toList();
                                break;

                              case 'Unlive':
                              // Everything not explicitly live (false or null)
                                filtered = filtered
                                    .where((item) => _liveMap[item.id] != true)
                                    .toList();
                                break;

                              case 'Empty Field':
                                filtered = _allProperties.where(_hasMissing).toList();
                                break;


                              case 'Empty Building':
                                if (_prefetchingEmpty) {
                                  print('Checking empty buildings… try again');
                                  break;
                                }

                                if (_emptyBuildingMap.isEmpty) {
                                  setState(() => _prefetchingEmpty = true);
                                  await _prefetchEmptyStatus();
                                  if (!mounted) return;
                                  setState(() => _prefetchingEmpty = false);
                                }

                                filtered = filtered.where((item) {
                                  return _emptyBuildingMap[item.id.toString()] == true;
                                }).toList();
                                break;
                              default:
                                break;
                            }

                            setState(() {
                              selectedLabel = label;
                              // DO NOT write the label into the search box (it triggers onChanged and wipes your filter)
                              // _searchController.text = label;   <-- removed on purpose
                              _filteredProperties = filtered;
                              propertyCount = filtered.length;

                              _recalculateSummary();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ Property count pill
                if (propertyCount > 0)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).brightness==Brightness.dark?Colors.transparent: Colors.grey,width: 1.5),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                "$propertyCount building found",
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14,color: Colors.black),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchController.clear();
                                    selectedLabel = '';
                                    _filteredProperties = _allProperties;
                                    propertyCount = _allProperties.length; // ✅ reset to total
                                  });
                                },
                                child: const Icon(Icons.close, size: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        isLoading
                            ? Text("")
                            : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Text(
                                "Total Flats: ${totalFlats ?? 0}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),

                        isLoading
                            ? Text("")
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            // Live Flats Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Live Flats: $liveFlats",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Book Flats Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Rent Out: $bookFlats",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // 📌 Property List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProperties.isEmpty
                ? const Center(
              child: Text(
                "No Building Found!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            )
                : ListView.builder(
              itemCount: _filteredProperties.length,
              itemBuilder: (context, index) {
                final item = _filteredProperties[index];
                final missingFields = _missingFieldsFor(item);
                final hasMissingFields = missingFields.isNotEmpty;
                return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Future_Property_details(idd: item.id.toString()),
                          //   ),
                          // );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Administater_Future_Property_details(
                                    buildingId: item.id.toString() ?? '',
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                // 🔹 Image with overlay + badge
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.images}",
                                        height: 400,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: Image.asset(AppImages.loader, height: 50),
                                        ),
                                        errorWidget: (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: FutureBuilder(
                                        future: http.get(Uri.parse(
                                            'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${item.id}')),
                                        builder: (context, snapshot) {
                                          String label = "Unlive: 0"; // default text
                                          Color color = Colors.red.withOpacity(0.8); // default color

                                          if (snapshot.connectionState == ConnectionState.done &&
                                              snapshot.hasData &&
                                              !snapshot.hasError) {
                                            final data = jsonDecode(snapshot.data!.body);

                                            bool anyLive = false;
                                            if (data is List && data.isNotEmpty) {
                                              for (var item in data) {
                                                if (item['live_unlive'] == 'Live' && (item['logs'] as num) > 0) {
                                                  anyLive = true;
                                                  break; // any single live is enough
                                                }
                                              }
                                            }

                                            if (anyLive) {
                                              // If any flat is live, show live logs
                                              final liveItem = data.firstWhere(
                                                    (item) => item['live_unlive'] == 'Live',
                                                orElse: () => null,
                                              );
                                              label = "Live: ${liveItem?['logs'] ?? 0}";
                                              color = Colors.green.withOpacity(0.8);
                                            } else {
                                              // If no flat is live, always show Unlive: 0
                                              label = "Unlive: 0";
                                              color = Colors.red.withOpacity(0.8);
                                            }
                                          }

                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: color,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              label,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 10),
                                // Tags Row
                                Row(
                                  children: [

                                    _buildTag(item.buyRent ?? "", Colors.green),
                                    const SizedBox(width: 10),
                                    _buildTag(item.place ?? "", Colors.blue),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Icon(PhosphorIcons.push_pin,
                                        size: 12, color: Colors.red),
                                    SizedBox(width: 4),
                                    Text(
                                      "Property Address (Fieldworker)",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.propertyAddressForFieldworker ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildTag("Field Worker : ${item.fieldWorkerName}", Colors.purple),
                                    SizedBox(width: 4),
                                    _buildTag("ID: ${item.id}", Colors.orange),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                FutureBuilder<String>(
                                  future: _fetchTotalFlatsForBuilding(item.id),
                                  builder: (context, snap) {
                                    final totalFlats = snap.connectionState == ConnectionState.done && snap.hasData
                                        ? (snap.data ?? "-")
                                        : "..."; // loading state

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _buildCompactDetailItem("🏠 Building ID", "${item.id}", context),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildCompactDetailItem("+ Total Flat", totalFlats, context),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                // ⚠ Missing fields
                                if (hasMissingFields)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.redAccent, width: 1),
                                    ),
                                    child: Text(
                                      "⚠ Missing fields: ${missingFields.join(", ")}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      )

    );
  }
  Widget _buildCompactDetailItem(String title, String value,BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // more space
      decoration: BoxDecoration(
        color:  Colors.grey.shade100,

        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(

          children: [
            Text(
              "$title: ",
              style: TextStyle(
                fontSize: 14, // bigger text
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color:
                  Theme.of(context).brightness==Brightness.dark?
                  Colors.black:
                  Colors.white,
                  // shadows: [
                  //   Shadow(
                  //     blurRadius: 1,
                  //     // offset: Offset(2, 2),
                  //     color: Theme.of(context).brightness == Brightness.dark
                  //         ? Colors.amber
                  //         : Colors.black87,
                  //   )
                  // ],
                  fontSize: 15, // bigger text
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w500,
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
}
