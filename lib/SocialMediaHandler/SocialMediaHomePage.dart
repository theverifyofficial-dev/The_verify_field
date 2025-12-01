import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Home_Screen_click/All_view_details.dart';
import '../Home_Screen_click/New_Real_Estate.dart';
import '../Propert_verigication_Document/Show_tenant.dart';
import '../add_properties_firstpage.dart';
import '../profile.dart';
import '../ui_decoration_tools/app_images.dart';
import 'VideoSubmitPage.dart';

class SocialMediaHomePage extends StatefulWidget {
  final String? highlightPropertyId;
   SocialMediaHomePage({super.key,
     this.highlightPropertyId,
  });
  @override
  State<SocialMediaHomePage> createState() => _AllLiveProperty();
}
class _AllLiveProperty extends State<SocialMediaHomePage> {

  List<NewRealEstateShowDateModel> _allProperties = [];
  List<NewRealEstateShowDateModel> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  String _number = '';
  int propertyCount = 0;
  String? selectedLabel;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final filtered = _allProperties.where((item) {
      return (item.pId ?? '').toString().toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredProperties = filtered;
      propertyCount = filtered.length;
    });
  }

  Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/demo_check_ap_for_editor.php",
    );
    // final url = Uri.parse(
    //   "https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/show_api_main_realestate_all_data.php?all=1",
    // );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    final decoded = json.decode(response.body);

    // Most backends wrap results like { success: true, data: [...] }
    final raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;

    // Normalize to a List<Map<String,dynamic>>
    final List<Map<String, dynamic>> listResponse;
    if (raw is List) {
      listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (raw is Map) {
      listResponse = [Map<String, dynamic>.from(raw)];
    } else {
      listResponse = const [];
    }

    // Sort by P_id desc, even if P_id comes as String sometimes
    int _asInt(dynamic v) =>
        v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);

    listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));

    return listResponse
        .map((data) => NewRealEstateShowDateModel.fromJson(data))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata(); // fetch _number from SharedPreferences

    _loaduserdata().then((_) {
      _fetchInitialData(); // Call your API after loading user data
    });
  }
  String _name = '';
  String _aadhar = '';
  Map<int, String> submittedStatus = {};
  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('name') ?? '';      // FName
    _number = prefs.getString('number') ?? '';  // FNumber
    _aadhar = prefs.getString('post') ?? '';    // FAadharCard

    print("Loaded Name: $_name");
    print("Loaded Number: $_number");
    print("Loaded Aadhar: $_aadhar");

    await _fetchProperties();
    for (var property in _allProperties) {
      final saved = await loadStatus(property.pId ?? 0);
      if (saved != null) {
        submittedStatus[property.pId!] = saved;
        // 🔥 HIGHLIGHT & SCROLL when notification comes
        if (widget.highlightPropertyId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            int index = _filteredProperties.indexWhere(
                  (item) => item.pId.toString() == widget.highlightPropertyId,
            );

            print("🔥 Highlight in Social Page: ${widget.highlightPropertyId}");
            print("📍 Found index: $index");

            if (index != -1) {
              _scrollController.animateTo(
                index * 500, // height approx
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
              );
            }
          });
        }

      }
    }

  }
  Future<void> saveStatus(int id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("video_status_$id", status);
  }
  Future<String?> loadStatus(int id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("video_status_$id");
  }
  Future<String?> submitVideo({
    required int id,
    required String byName,
    required String role,
    required String text,
  }) async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/video_editor.php");

    try {
      final response = await http.post(url, body: {
        "action": "editor_received",
        "id": id.toString(),
        "by_name": byName,
        "role": role,
        "text": text,
      });

      print("📤 SENT: action = editor_received, id=$id, by=$byName, role=$role, text=$text");
      print("📩 RESPONSE: ${response.body}");

      final jsonBody = jsonDecode(response.body);

      if (jsonBody["ok"] == true) {
        final status = jsonBody["data"]["messages"][0]["status_after"];
        return status;   // 🔥 return the status string
      }

      return null;
    } catch (e) {
      print("❌ API ERROR: $e");
      return null;
    }
  }

  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(_number);
      setState(() {
        _allProperties = data;
        _filteredProperties = data;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(""); // Call your API
      setState(() {
        // _originalData = data;
        // _filteredData = data;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel!="";
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
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
        actions: [
          IconButton(onPressed: _fetchProperties, icon: Icon(CupertinoIcons.refresh)),
          SizedBox(width: 20,),
        ],
      ),
      body:
      _isLoading
          ? Center(child: Image.asset(AppImages.loader,height: 50,))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search properties by ID',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                  ),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (propertyCount > 0 && _isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [

                  Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Total : $propertyCount",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),

                ],
              ),
            ),
          _filteredProperties.isEmpty
              ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No properties found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try a different search term",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
              : Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProperties,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {

                  final property = _filteredProperties[index];
                  return StreamBuilder<http.Response>(
                    stream: Stream.periodic(const Duration(seconds: 5))
                        .asyncMap((_) => http.get(Uri.parse(
                      "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${_filteredProperties[index].pId??0}",
                    ))),
                    builder: (context, snapshot) {
                      bool isRedDot = false;

                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          isRedDot = body is List && body.isNotEmpty && body[0]['logg'] == 0;
                        } catch (_) {}
                      }

                      final Map<String, dynamic> fields = {
                        "Images": property.propertyPhoto,
                        "Owner Name": property.ownerName,
                        "Owner Number": property.ownerNumber,
                        "Caretaker Name": property.careTakerName,
                        "Caretaker Number": property.careTakerNumber,
                        "Place": property.locations,
                        "Buy/Rent": property.buyRent,
                        "Property Name/Address": property.apartmentAddress,
                        "Property Address (Fieldworker)":
                        property.fieldWorkerAddress,
                        // "Owner Vehicle Number": property.ownerVehicleNumber,
                        // "Your Address": property.fieldWorkerCurrentLocation,
                        "Field Worker Name": property.fieldWorkerName,
                        "Field Worker Number": property.fieldWorkerNumber,
                        "Current Date": property.currentDates,
                        "Longitude": property.longitude,
                        "Latitude": property.latitude,
                        "Road Size": property.roadSize,
                        "Metro Distance": property.metroDistance,
                        "Metro Name": property.highwayDistance,
                        "Main Market Distance": property.mainMarketDistance,
                        "Age of Property": property.ageOfProperty,
                        "Lift": property.lift,
                        "Parking": property.parking,
                        "Total Floor": property.totalFloor,
                        "Residence/Commercial": property.typeOfProperty,
                        "Facility": property.facility,
                        "Video": property.video,
                      };

                      final missingFields = fields.entries
                          .where((entry) {
                        final value = entry.value;
                        if (value == null) return true;
                        if (value is String && value.trim().isEmpty) return true;
                        return false;
                      })
                          .map((entry) => entry.key)
                          .toList();
                      String rawStatus = property.videoStatus?.trim().toLowerCase() ?? "";
                      bool isPending = rawStatus.isEmpty; // NULL OR EMPTY
                      final hasMissingFields = missingFields.isNotEmpty;
                      String status = property.videoStatus?.trim().toLowerCase() ?? "";
                      bool isSubmitted = status == "video submitted" || status == "received";
                      return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('id_Building', _filteredProperties[index].pId??0);
                                prefs.setString('id_Longitude', _filteredProperties[index].longitude.toString());
                                prefs.setString('id_Latitude', _filteredProperties[index].latitude.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllViewDetails(id: _filteredProperties[index].pId??0),
                                  ),
                                );
                                print(_filteredProperties[index].pId??0);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    side: property.pId.toString() == widget.highlightPropertyId
                                        ? const BorderSide(color: Colors.red, width: 3)   // 🔥 RED HIGHLIGHT
                                        : BorderSide.none,
                      // :const BorderSide(color: Colors.red, width: 3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  shadowColor:  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,

                                  color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.white,
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 450,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).highlightColor,
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),

                                              child: Image.network(
                                                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${_filteredProperties[index].propertyPhoto}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Center(
                                                  child: Icon(Icons.home, size: 50, color: Theme.of(context).hintColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: Wrap(
                                              spacing: 8,
                                              children: [
                                                _buildFeatureItem(
                                                  context: context,
                                                  text: "Live Property ID : ${_filteredProperties[index].pId}",
                                                  borderColor: Colors.grey.shade700,
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.blue,
                                                  shadowColor: Colors.white60,
                                                ),  _buildFeatureItem(
                                                  context: context,
                                                  //
                                                  text: "For: ${_filteredProperties[index].buyRent}" ?? "Property",
                                                  borderColor: Colors.green.shade400,
                                                  backgroundColor: Colors.green.shade100,
                                                  textColor: Colors.green.shade700,
                                                  shadowColor: Colors.green.shade100,
                                                ),

                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              if (hasMissingFields) ...[
                                                SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.41,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[50],
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.redAccent, width: 1),
                                                    ),
                                                    child: Text(
                                                      "⚠ Missing fields: ${missingFields.join(", ")}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ]
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "₹${_filteredProperties[index].showPrice??"-"
                                                      ".0"}"
                                                  ,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    fontFamily: "PoppinsBold",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  _filteredProperties[index].locations ?? "",
                                                  style: TextStyle(
                                                    fontFamily: "PoppinsBold",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 4, // horizontal spacing between items
                                              runSpacing: 8, // vertical spacing between lines
                                              alignment: WrapAlignment.start,
                                              children: [
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.king_bed,
                                                  text: "${_filteredProperties[index].bhk}",
                                                  borderColor: Colors.purple.shade200,
                                                  backgroundColor: Colors.purple.shade50,
                                                  textColor: Colors.purple.shade700,
                                                  shadowColor: Colors.purple.shade100,
                                                ),
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.apartment,
                                                  text: "${_filteredProperties[index].floor}",
                                                  borderColor: Colors.teal.shade200,
                                                  backgroundColor: Colors.teal.shade50,
                                                  textColor: Colors.teal.shade700,
                                                  shadowColor: Colors.teal.shade100,
                                                ),
                                                // _buildFeatureItem(
                                                //   context: context,
                                                //   icon: Icons.receipt_rounded,
                                                //   text: "Flat No. ${_filteredProperties[index].flatNumber}",
                                                //   borderColor: Colors.red.shade200,
                                                //   backgroundColor: Colors.red.shade50,
                                                //   textColor: Colors.red.shade700,
                                                //   shadowColor: Colors.red.shade100,
                                                // ),

                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.home_work,
                                                  text: _filteredProperties[index].typeOfProperty ?? "",
                                                  borderColor: Colors.orange.shade200,
                                                  backgroundColor: Colors.orange.shade50,
                                                  textColor: Colors.orange.shade700,
                                                  shadowColor: Colors.orange.shade100,
                                                ),



                                              ],
                                            ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                          children: [

                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  String raw = (property.videoStatus ?? "").trim().toLowerCase();

                                                  bool isPending = raw.isEmpty;
                                                  bool isSubmitted = raw == "video submitted";
                                                  bool isWorkerReason = raw == "reason";
                                                  bool isRequested = raw == "video requested by editor";
                                                  bool isEditingStarted = raw == "video recived and editing started";
                                                  bool isUploaded = raw == "video uploaded";

                                                  // -----------------------------------------------------
                                                  // 🔥 If editor should upload final YouTube link
                                                  // -----------------------------------------------------
                                                  if (isEditingStarted && !isUploaded) {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => SubmitVideoPage(
                                                          propertyId: property.pId ?? 0,
                                                          status: raw,
                                                          action: "upload_video_link",
                                                          userName: _name,
                                                          userRole: _aadhar,
                                                        ),
                                                      ),
                                                    );

                                                    _fetchProperties();
                                                    return;
                                                  }

                                                  // -----------------------------------------------------
                                                  // 🔥 If final link already uploaded → view only
                                                  // -----------------------------------------------------
                                                  if (isUploaded) {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => SubmitVideoPage(
                                                          propertyId: property.pId ?? 0,
                                                          status: raw,
                                                          action: "view_only",
                                                          userName: _name,
                                                          userRole: _aadhar,
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  // -----------------------------------------------------
                                                  // 🔥 Normal editor messaging flow
                                                  // -----------------------------------------------------
                                                  String actionToSend = "editor_reply";

                                                  if (isSubmitted || isWorkerReason || isRequested) {
                                                    actionToSend = "editor_received";
                                                  }

                                                  final result = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => SubmitVideoPage(
                                                        propertyId: property.pId ?? 0,
                                                        status: raw,
                                                        action: actionToSend,
                                                        userName: _name,
                                                        userRole: _aadhar,
                                                      ),
                                                    ),
                                                  );

                                                  if (result == true) {
                                                    _fetchProperties();
                                                  }
                                                },

                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: () {
                                                      String st = (property.videoStatus ?? "").trim().toLowerCase();
                                                      if (st.isEmpty) return Colors.red;
                                                      if (st == "video submitted") return Colors.blue;
                                                      if (st == "reason") return Colors.blue;
                                                      if (st == "video requested by editor") return Colors.orange;
                                                      if (st == "video recived and editing started") return Colors.orange;
                                                      if (st == "video uploaded") return Colors.purple;
                                                      return Colors.red;
                                                    }(),
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: () {
                                                        String st = (property.videoStatus ?? "").trim().toLowerCase();
                                                        if (st.isEmpty) return Colors.red;
                                                        if (st == "video submitted") return Colors.blue;
                                                        if (st == "reason") return Colors.blue;
                                                        if (st == "video requested by editor") return Colors.orange;
                                                        if (st == "video recived and editing started") return Colors.orange;
                                                        if (st == "video uploaded") return Colors.purple;
                                                        return Colors.red;
                                                      }(),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        (property.videoStatus ?? "").trim().toLowerCase() == "video submitted"
                                                            ? Icons.check_circle
                                                            : Icons.error_outline,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          (property.videoStatus ?? "").trim().isEmpty
                                                              ? "Editor Request"
                                                              : property.videoStatus!,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                        // space between the two containers
                                                Expanded(
                                                  child: _AddedByItem(
                                                    context: context,
                                                    text: "Added by : ${_filteredProperties[index].fieldWorkerName}",
                                                    borderColor: Colors.red.shade400,
                                                    backgroundColor: Colors.red.shade200,
                                                    textColor: Colors.white,
                                                    shadowColor: Colors.white60,

                                                  ),
                                                ),
                                          ],),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                      );
                    },
                  );

                },
              ),
            ),
          ),
        ],
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 30,left: 8,right: 8),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(6),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black.withOpacity(0.2),
      //           blurRadius: 10,
      //           offset: const Offset(0, 5),
      //         ),
      //       ],
      //       gradient: LinearGradient(
      //         colors: [Colors.blueAccent, Colors.lightBlueAccent],
      //         begin: Alignment.centerLeft,
      //         end: Alignment.centerRight,
      //       ),
      //     ),
      //     child: ElevatedButton.icon(
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterProperty()));
      //         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPropertiesFirstPage()));
      //       },
      //       icon: const Icon(Icons.add, color: Colors.white),
      //       label: const Text(
      //         'Add Property',
      //         style: TextStyle(
      //           fontSize: 17,
      //           fontFamily: "PoppinsBold",
      //           fontWeight: FontWeight.w600,
      //           letterSpacing: 0.5,
      //           color: Colors.white,
      //         ),
      //       ),
      //       style: ElevatedButton.styleFrom(
      //         elevation: 0, // Shadow handled by container
      //         backgroundColor: Colors.transparent,
      //         shadowColor: Colors.transparent,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(16),
      //         ),
      //         padding: const EdgeInsets.symmetric(vertical: 16),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }


  Color _getPropertyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'rent':
        return Colors.green;
      case 'buy':
        return Colors.blueAccent;
      case 'lease':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required String text,
    required Color borderColor,
    IconData? icon, // 👈 optional now
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final width = MediaQuery.of(context).size.width;

    // Scale text, padding, and icon size relative to screen width
    double fontSize = width < 350 ? 10 : (width < 500 ? 12 : 14);
    double horizontalPadding = width < 350 ? 8 : (width < 500 ? 12 : 14);
    double verticalPadding = width < 350 ? 6 : (width < 500 ? 8 : 12);
    double iconSize = width < 350 ? 14 : (width < 500 ? 16 : 18);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? borderColor).withOpacity(0.10),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[ // 👈 only shows if passed
            Icon(
              icon,
              size: iconSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : (textColor ?? Colors.black),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : (textColor ?? Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
Widget _AddedByItem({
    required BuildContext context,
    required String text,
    required Color borderColor,
    IconData? icon, // 👈 optional now
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final width = MediaQuery.of(context).size.width;

    // Scale text, padding, and icon size relative to screen width
    double fontSize = width < 350 ? 10 : (width < 500 ? 12 : 14);
    double horizontalPadding = width < 350 ? 8 : (width < 500 ? 12 : 14);
    double verticalPadding = width < 350 ? 6 : (width < 500 ? 8 : 12);
    double iconSize = width < 350 ? 14 : (width < 500 ? 16 : 18);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? borderColor).withOpacity(0.10),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[ // 👈 only shows if passed
            Icon(
              icon,
              size: iconSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : (textColor ?? Colors.black),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : (textColor ?? Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
