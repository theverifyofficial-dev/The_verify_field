import 'dart:convert';
import 'dart:ui';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Model.dart';
import 'package:verify_feild_worker/property_preview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Add_Rented_Flat/Book_Flat_For_FieldWorker.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/realestateSlider.dart';
import 'Add_image_under_property.dart';
import 'Add_images_in_Realestate.dart';
import 'Delete_Image.dart';
import 'Edit_Page_Realestate.dart';
import 'Add_multi_image_in_Realestate.dart';
import 'Edit_Property_SecondPage.dart';
import 'Real-Estate.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:xml/xml.dart' as xml;

import 'Reverse_in_Futureproperty.dart';
import 'Update_realEstate_form.dart';

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
      sourceId: json['source_id']?.toString(),
    );
  }
}

class View_Details extends StatefulWidget {
  final int id;
  const View_Details({super.key, required this.id});
  @override
  State<View_Details> createState() => _View_DetailsState();
}

class _View_DetailsState extends State<View_Details> {
  Future<void> Book_property() async {
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=$_id&looking=Book'));
    if (responce.statusCode == 200) {
      print(responce.body);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_Real_Estate()), (route) => route.isFirst);
      }
    } else {
      print('Failed Registration');
    }
  }

  Future<List<RealEstateSlider>> fetchCarouselData(int id) async {
    final url = 'https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$id';
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is String) {
        final innerData = json.decode(data);
        return (innerData as List)
            .map((item) => RealEstateSlider.fromJson(item))
            .toList();
      }
      return (data as List)
          .map((item) => RealEstateSlider.fromJson(item))
          .toList();
    } else if (response.statusCode == 404) {
      // No data found for this subid, return empty list instead of throwing
      return [];
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  Future<List<Catid>> fetchData(int id) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_api_for_details_page_in_main_realestate.php?P_id=$id",
    );
    final response = await http.get(url).timeout(const Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }
    final decoded = json.decode(response.body);
    final dynamic raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;
    final List<Map<String, dynamic>> listResponse;
    if (raw is List) {
      listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (raw is Map) {
      listResponse = [Map<String, dynamic>.from(raw)];
    } else {
      listResponse = const [];
    }
    final properties = listResponse.map((e) => Catid.fromJson(e)).toList();
    // >>> store firstProperty for later navigation
    if (properties.isNotEmpty) {
      if (mounted) {
        setState(() {
          firstProperty = properties.first;
        });
      }
    }
    return properties;
  }

  bool _isDeleting = false;
  //Delete api
  Future<void> DeletePropertybyid(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
    final response = await http.get(url).timeout(const Duration(seconds: 30));
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
  // final result = await fetchData();
  List<String> name = [];
  // late final int iid;
  int _id = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loaduserdata();
      if (_id != 0) {
        setState(() {
          _propertyFuture = fetchData(widget.id);
          _galleryFuture = fetchCarouselData(_id); // pass _id here
        });
      } else {
        print('Invalid ID loaded: $_id');
      }
    });
  }
  Future<void> _loaduserdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int loadedId = prefs.getInt('id_Building') ?? 0;
      print('Loaded ID from SharedPreferences: $loadedId');
      setState(() {
        _id = loadedId;
      });
    } catch (e) {
      print('Error loading ID: $e');
      setState(() {
        _id = 0;
      });
    }
  }
  Future<List<Catid>>? _propertyFuture;
  Future<List<RealEstateSlider>>? _galleryFuture;
  final PageController _galleryController = PageController();
  int _currentGalleryIndex = 0;
  void _refreshData() {
    setState(() {
      _propertyFuture = fetchData(widget.id);
      _galleryFuture = fetchCarouselData(_id);
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }
  String data = 'Initial Data';
  Catid? firstProperty;
  // final result = await profile();

  // Place this inside your _View_DetailsState class
  void _showAddVideoSheet(BuildContext context, int propertyId) {
    final TextEditingController _videoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> _submit() async {
              final link = _videoController.text.trim();

              if (link.isEmpty) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  SnackBar(content: Text("Please enter a video link.")),
                );
                return;
              }

              final uri = Uri.tryParse(link);
              if (uri == null ||
                  !(uri.hasScheme &&
                      (uri.scheme == 'http' || uri.scheme == 'https'))) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  SnackBar(content: Text("Please enter a valid http/https URL.")),
                );
                return;
              }

              setModalState(() => isLoading = true);

              try {
                final apiUrl = Uri.parse(
                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_video_in_main_realetstae.php");
                final response = await http.post(apiUrl, body: {
                  "P_id": propertyId.toString(),
                  "video_link": link,
                });

                if (response.statusCode == 200) {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Video added successfully.")),
                  );

                  setState(() {
                    _propertyFuture = fetchData(propertyId);
                  });
                } else {
                  ScaffoldMessenger.of(sheetContext).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Failed to add video. (${response.statusCode})")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              } finally {
                setModalState(() => isLoading = false);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Text(
                    "Add Video Link",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: _videoController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintText: "Paste YouTube or video URL",
                      prefixIcon: Icon(Icons.video_library_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.of(sheetContext).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor:
                          Theme.of(context).colorScheme.secondary,
                        ),
                        child: Text("Cancel"),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _checkCallPermission() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      status = await Permission.phone.request();
    }
    if (status.isPermanentlyDenied) {
      // Open app settings
      openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date); // e.g., 02 Aug 2025
    } catch (e) {
      return "Invalid Date";
    }
  }

  void _showCallConfirmation(BuildContext parentContext, String name, String number) {
    // Remove any non-digit characters from number
    String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(parentContext).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.contact_phone_rounded,
                  size: 32,
                  color: Colors.blue[600],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                'Contact $name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(parentContext).textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Choose how you want to connect',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(parentContext).textTheme.bodyMedium?.color,
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Call Button
                  Expanded(
                    child: _buildActionButton(
                      context: parentContext,
                      icon: Icons.call_rounded,
                      label: 'Call',
                      color: Colors.green,
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        bool granted = await _checkCallPermission();
                        if (!granted) {
                          _showPermissionSnackbar(parentContext);
                          return;
                        }
                        await _makePhoneCall(cleanNumber, parentContext);
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // WhatsApp Button
                  Expanded(
                    child: _buildActionButton(
                      context: parentContext,
                      icon: Icons.message_rounded,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await _openWhatsApp(cleanNumber, parentContext);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(parentContext).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String number, BuildContext context) async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
      if (res != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not initiate call')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _openWhatsApp(String number, BuildContext context) async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not installed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening WhatsApp: ${e.toString()}')),
      );
    }
  }

  void _showPermissionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Call permission denied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    // Responsive values
    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == "rented") {
                // >>> correct the condition and guard null
                if (firstProperty != null) {
                  final pid = firstProperty!.id.toString();
                  final sid = firstProperty!.subid.toString();
                  debugPrint('P_id : $pid');
                  debugPrint('Subid : $sid');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RentedPropertyPage(
                        id: pid,
                        subid: sid,
                      ),
                    ),
                  );
                } else {
                  debugPrint('P_id : ${firstProperty!.id.toString()}');
                  debugPrint('Subid : ${firstProperty!.subid.toString()}');
                  // either still loading or API returned nothing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Property not loaded yet.")),
                  );
                }
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "rented", child: Text("Book property")),
            ],
          ),
        ],

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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          // Wait for futures to complete to reflect changes in UI
          if (_propertyFuture != null && _galleryFuture != null) {
            await Future.wait([
              _propertyFuture!,
              _galleryFuture!,
            ]);
          }
        },
        child: FutureBuilder<List<Catid>>(
          future: _propertyFuture,
          builder: (context, propertySnapshot) {
            if (propertySnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight * 0.4,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (propertySnapshot.hasError) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(child: Text('Error: ${propertySnapshot.error}')),
              );
            } else if (propertySnapshot.data == null || propertySnapshot.data!.isEmpty) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50 * fontScale, color: Colors.grey),
                      SizedBox(height: verticalPadding * 2),
                      Text("No Property Found!",
                          style: TextStyle(fontSize: 16 * fontScale, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            } else {
              final prop = propertySnapshot.data!.first;
              firstProperty = prop;
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Hero Image Section
                        Stack(
                          children: [
                            Container(
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
                                child: (prop.videoLink != null && prop.videoLink!.isNotEmpty)
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: VideoPlayerWidget(videoUrl: prop.videoLink!),
                                )
                                    : CachedNetworkImage(
                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, size: 50 * fontScale, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            // Back Button - already in AppBar, but if needed
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
                        // Price and Maintenance Chips
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              /// PRICE BOX
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: verticalPadding,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.85),
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
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),

                              /// MAINTENANCE BOX — FULL TEXT SHOW!
                              Expanded(
                                flex: 2,  // <- Maintenance ko zyada space mil jayega
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: verticalPadding,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${prop.maintenance} Maintenance", // Full visible
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,        // FULL TEXT SHOW
                                      overflow: TextOverflow.visible, // No cutting
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Property Info Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding * 1.5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prop.locations,
                                style: TextStyle(
                                  fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              SizedBox(height: verticalPadding * 1.2),
                              LayoutBuilder(builder: (context, constraints) {

                                final available = constraints.maxWidth;
                                final spacing = chipSpacing * 1.5;
                                final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
                                final rawWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;
                                final chipWidth = rawWidth.clamp(64.0, available).toDouble();

                                final chipsData = <Map<String, dynamic>>[

                                  {'icon': Icons.install_desktop_sharp, 'text': 'Live Property Id: ${prop.id}', 'color': Colors.lightGreen},
                                  {'icon': Icons.bedroom_parent, 'text': prop.bhk ?? '', 'color': Colors.purple},
                                  {'icon': Icons.apartment_sharp, 'text': 'Building Id: ${prop.subid}', 'color': Colors.lightBlue},

                                  if ((prop.sourceId ?? '').isNotEmpty && prop.sourceId != 'null')
                                    {'icon': Icons.file_open, 'text': 'Building Flat Id: ${prop.sourceId}', 'color': Colors.deepOrange},

                                ].where((e) {

                                  final t = (e['text'] as String?)?.trim() ?? '';
                                  return t.isNotEmpty && t != 'null';

                                }).toList();

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: verticalPadding * 1.2,
                                  children: chipsData.map((e) {
                                    return SizedBox(
                                      width: chipWidth,
                                      child: _buildChip(
                                        e['icon'] as IconData,
                                        e['text'] as String,
                                        e['color'] as Color,
                                        context,
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                              SizedBox(height: verticalPadding * 2),
                            ],
                          ),
                        ),

                        // Image Carousel
                        FutureBuilder<List<RealEstateSlider>>(
                          future: _galleryFuture,
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
                                    items: images.map((item) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => PropertyPreview(
                                                    ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.mImages}",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.mImages}",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
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
                        // Property Details Section
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
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              _buildResponsiveInfoGrid(_getPropertyDetailsRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding), context, isSmallScreen, isTablet),
                            ],
                          ),
                        ),
                        // Building Facility Section
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
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              if (_getBuildingFacilityRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _getBuildingFacilityRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding),
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        // Contact Information Section
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
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding * 2),
                              if (prop.ownerNumber.isNotEmpty)
                                _buildContactCard("OWNER", prop.ownerName, prop.ownerNumber, bgColor: Colors.green, context: context, onCall: () => _showCallConfirmation(context, prop.ownerName, prop.ownerNumber)),
                              if (prop.caretakerNumber.isNotEmpty)
                                _buildContactCard("CARETAKER", prop.caretakerName, prop.caretakerNumber, bgColor: Colors.purple, context: context, onCall: () => _showCallConfirmation(context, prop.caretakerName, prop.caretakerNumber)),
                            ],
                          ),
                        ),
                        // Additional Information Section
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
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _getAdditionalInfoRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding),
                              ),
                            ],
                          ),
                        ),
                        // Bottom spacing for bottom nav
                        SizedBox(height: screenHeight * 0.15),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: firstProperty != null ? Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Future_Property_details(
                        idd: firstProperty!.subid.toString(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.purple.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.move_up_sharp, size: 22),
                label: const Text(
                  "Go to Building",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(width: 12),
            if (firstProperty!.videoLink == null || firstProperty!.videoLink!.isEmpty)
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.video_call, size: 20 * fontScale),
                  label: Text("Add Video", style: TextStyle(fontSize: 14 * fontScale)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => _showAddVideoSheet(context, firstProperty!.id),
                ),
              ),
          ],
        ),
      ) : null,
    );
  }

  // Helper methods adapted from upper code
  Widget _buildInfoRow(IconData icon, Color iconColor, String title, String value, bool isSmallScreen, bool isDarkMode) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();
    final Color cardColor = Colors.white;
    final Color borderColor = isDarkMode ? Colors.grey.shade700.withOpacity(0.2) : Colors.grey.shade200;
    final Color titleColor = isDarkMode ? Colors.black87 : Colors.grey.shade700;
    final Color valueColor = isDarkMode ? Colors.black87 : Colors.black87;
    final Color iconBg = iconColor.withOpacity(0.10);
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: isDarkMode
            ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]
            : null,
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


  Widget _buildContactCard(String role, String name, String number, {Color? bgColor, required BuildContext context, required VoidCallback onCall}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = _maskPhoneNumber(number);
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
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
                    role == "OWNER" ? Icons.person
                        : role == "CARETAKER" ? Icons.support_agent
                        : role == "FIELD WORKER" ? Icons.engineering
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
                          color: isDarkMode ? Colors.black : Colors.black87,
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
                onTap: onCall,
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
                            onTap: () => _openWhatsApp(number, context),
                            child: Icon(PhosphorIcons.whatsapp_logo_bold, color: Colors.green, size: isSmallScreen ? 20.0 : 24.0),
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
  Widget _buildSimpleInfoCard(String title, String value, IconData icon, Color cardColor, {bool isSmallScreen = false, bool isDarkMode = false}) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();
    final Widget card = Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
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
                      color: isDarkMode ? Colors.black : Colors.black87,
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
    return card;
  }
  Widget _buildChip(IconData icon, String text, Color color, BuildContext context) {
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
          SizedBox(width: 4),
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
  Widget  _buildResponsiveInfoGrid(List<Widget> infoRows, BuildContext context, bool isSmallScreen, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        // Adjusted threshold: Use single column for very small screens (<360), two columns for medium+ (including tablets)
        // For tablets, ensure even wider spacing and more balanced split
        final columnSpacing = isTablet ? 16.0 : (isSmallScreen ? 8.0 : 12.0);
        final half = (infoRows.length / 2).ceil();
        final leftColumn = infoRows.sublist(0, half);
        final rightColumn = infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
        if (screenWidth <= 360) {
          // Single column for very small screens to avoid overflow
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: infoRows,
            ),
          );
        } else {
          // Two columns for tablets and medium screens
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: columnSpacing / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leftColumn,
                    ),
                  ),
                ),
                if (rightColumn.isNotEmpty)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: columnSpacing / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rightColumn,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  List<Widget> _getPropertyDetailsRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding) {
    List<Widget> rows = [];

    // Helper function to safely get value or "Not Available"
    String safeValue(String? value, [String suffix = ""]) {
      if (value == null || value.trim().isEmpty || value.trim().toLowerCase() == "null" || value.trim() == "0") {
        return "Not Available";
      }
      return value.trim() + suffix;
    }

    // Helper for date fields
    String safeDate(String? dateStr) {
      if (dateStr == null || dateStr.trim().isEmpty || dateStr.trim().toLowerCase() == "null") {
        return "Not Available";
      }
      try {
        final date = DateTime.parse(dateStr.trim());
        return formatDate(dateStr.trim()); // your existing formatDate function
      } catch (e) {
        return "Not Available";
      }
    }

    // 15. Metro Station (highwayDistance)
    rows.add(_buildInfoRow(
      Icons.directions_car,
      Colors.red,
      "Metro Station",
      safeValue(prop.highwayDistance),
      isSmallScreen,
      isDarkMode,
    ));

    // 13. Market Distance
    rows.add(_buildInfoRow(
      Icons.store_mall_directory,
      Colors.purple,
      "Market Distance",
      safeValue(prop.mainMarketDistance),
      isSmallScreen,
      isDarkMode,
    ));

    // 2. Floor (Floor / Total Floor)
    String floorText = "Not Available";
    if (prop.floor != null && prop.floor.trim().isNotEmpty && prop.floor.trim() != "null") {
      floorText = prop.floor.trim();
    }
    if (prop.totalFloor != null && prop.totalFloor.trim().isNotEmpty && prop.totalFloor.trim() != "null") {
      floorText += (floorText != "Not Available" ? " / ${prop.totalFloor.trim()}" : prop.totalFloor.trim());
    }
    rows.add(_buildInfoRow(
      Icons.layers,
      Colors.green,
      "Floor",
      floorText,
      isSmallScreen,
      isDarkMode,
    ));

    // 6. Type of Property
    rows.add(_buildInfoRow(
      Icons.home_work,
      Colors.orange,
      "Type of Property",
      safeValue(prop.typeofProperty),
      isSmallScreen,
      isDarkMode,
    ));

    // 7. Square Feet
    rows.add(_buildInfoRow(
      Icons.square_foot,
      Colors.teal,
      "Sq. Ft.",
      safeValue(prop.squarefit),
      isSmallScreen,
      isDarkMode,
    ));

    // 19. Registry & GPA
    rows.add(_buildInfoRow(
      Icons.description,
      Colors.blue,
      "Registry & GPA",
      safeDate(prop.registryAndGpa),
      isSmallScreen,
      isDarkMode,
    ));

    // 12. Furnishing
    rows.add(_buildInfoRow(
      Icons.chair,
      Colors.pink,
      "Furnishing",
      safeValue(prop.furnishing),
      isSmallScreen,
      isDarkMode,
    ));

    // 14. Metro Distance
    rows.add(_buildInfoRow(
      Icons.train,
      Colors.orange,
      "Metro Distance",
      safeValue(prop.metroDistance),
      isSmallScreen,
      isDarkMode,
    ));

    // 18. Road Size
    String roadSize = safeValue(prop.roadSize, " Feet");
    if (roadSize == "Not Available Feet") roadSize = "Not Available";
    rows.add(_buildInfoRow(
      Icons.straighten,
      Colors.teal,
      "Road Size",
      roadSize,
      isSmallScreen,
      isDarkMode,
    ));

    // 16. Flat Number
    rows.add(_buildInfoRow(
      Icons.format_list_numbered,
      Colors.green,
      "Flat Number",
      safeValue(prop.flatNumber),
      isSmallScreen,
      isDarkMode,
    ));

    // 17. Age of Property
    rows.add(_buildInfoRow(
      Icons.history,
      Colors.brown,
      "Age of Property",
      safeValue(prop.ageOfProperty),
      isSmallScreen,
      isDarkMode,
    ));

    // 21. Residence / Commercial
    rows.add(_buildInfoRow(
      Icons.domain,
      Colors.amber,
      "Residence / Commercial",
      safeValue(prop.residenceCommercial),
      isSmallScreen,
      isDarkMode,
    ));

    // 20. Loan
    rows.add(_buildInfoRow(
      Icons.account_balance,
      Colors.blue,
      "Loan",
      safeDate(prop.loan),
      isSmallScreen,
      isDarkMode,
    ));

    return rows;
  }

  List<Widget> _getBuildingFacilityRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding) {
    List<Widget> rows = [];
    if ((prop.facility ?? '').isNotEmpty) {
      rows.add(_buildInfoRow(Icons.local_hospital, Colors.amber, "Building Facility", prop.facility, isSmallScreen, isDarkMode));
    }
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;
    if ((prop.apartmentName ?? '').isNotEmpty) {
      rows.add(_buildInfoRow(Icons.local_hospital, Colors.green, "Flat Facility", prop.apartmentName, isSmallScreen, isDarkMode));
    }
    // final double verticalPadding = isSmallScreen ? 2.0 : 4.0;
    // Row 1: Kitchen and Bathroom
    List<Widget> row1Cards = [];
    if ((prop.kitchen ?? '').isNotEmpty) {
      row1Cards.add(_buildSimpleInfoCard("Kitchen", prop.kitchen, Icons.kitchen, Colors.pink, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if ((prop.bathroom ?? '').isNotEmpty) {
      row1Cards.add(_buildSimpleInfoCard("Bathroom", prop.bathroom, Icons.bathroom, Colors.lightBlue, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if (row1Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row1Cards, context, verticalPadding),
      ));
    }
    // Row 2: Parking, Lift, and Meter
    List<Widget> row2Cards = [];
    if ((prop.parking ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Parking", prop.parking, Icons.local_parking, Colors.purple, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if ((prop.lift ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Lift", "${prop.lift.toLowerCase() == 'yes' ? 'Available' : 'Not Available'}", Icons.elevator, Colors.red, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }

    if ((prop.balcony ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Balcony", prop.balcony, Icons.balcony, Colors.purple, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }

    if ((prop.meter ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Meter", "${prop.meter}/- per unit.", Icons.electric_meter, Colors.blue, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row2Cards, context, verticalPadding),
      ));
    }
    return rows;
  }
  Widget _buildAdaptiveRows(List<Widget> cards, BuildContext context, double verticalPadding) {
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth;
      final spacing = MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0;
      final runSpacing = verticalPadding;
      // Decide how many items fit horizontally
      final int itemsPerRow = available >= 800
          ? 4
          : available >= 520
          ? 3
          : 2;
      final itemWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;
      // If only one card, give it full width
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
  List<Widget> _getAdditionalInfoRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding) {
    List<Widget> rows = [];
    // Current Date
    if ((prop.currentDate ?? '').isNotEmpty) {
      rows.add(_buildSimpleInfoCard("Property Added Date", formatDate(prop.currentDate), Icons.date_range, Colors.indigo, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    // Asking Price and Last Price Row
    List<Widget> priceWidgets = [];
    // if ((prop.askingPrice ?? '').isNotEmpty) {
    //   priceWidgets.add(Expanded(
    //     child: _buildSimpleInfoCard("Asking Price", prop.askingPrice, Icons.currency_rupee, Colors.green, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
    //   ));
    // }
    // if ((prop.lastPrice ?? '').isNotEmpty) {
    //   if (priceWidgets.isNotEmpty) {
    //     priceWidgets.add(SizedBox(width: isSmallScreen ? 6.0 : 8.0));
    //   }
    //   priceWidgets.add(Expanded(
    //     child: _buildSimpleInfoCard("Last Price", prop.lastPrice, Icons.currency_rupee, Colors.pink, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
    //   ));
    // }
    if (priceWidgets.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
          child: Row(children: priceWidgets),
        ),
      );
    }
    // Video Link (Additional Information section में यह code लगाएं)

    String videoLink = (prop.videoLink ?? '').trim();
    bool hasVideoLink = videoLink.isNotEmpty && videoLink.toLowerCase() != "null";

    if (hasVideoLink) {
      // Valid video link available → clickable with underlined blue text
      rows.add(
        GestureDetector(
          onTap: () => _launchVideo(videoLink, context),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
            padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 32.0 : 36.0,
                  height: isSmallScreen ? 32.0 : 36.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: isSmallScreen ? 18.0 : 20.0,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8.0 : 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Video Link",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10.0 : 11.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        videoLink,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue, // link color
                          decoration: TextDecoration.underline, // underline
                          decorationColor: Colors.blue,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: Colors.blue,
                  size: isSmallScreen ? 18.0 : 20.0,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // No video link → show "Not Available"
      rows.add(
        _buildSimpleInfoCard(
          "Video Link",
          "Not Available",
          Icons.play_circle_outline,
          Colors.grey,
          isSmallScreen: isSmallScreen,
          isDarkMode: isDarkMode,
        ),
      );
    }
    // Additional Information या जहाँ आप यह field add कर रहे हैं, वहाँ यह code लगाएं

// Field Worker Current Location
    String currentLocation = prop.fieldWorkerCurrentLocation ?? '';

    if (currentLocation.trim().isEmpty || currentLocation.trim().toLowerCase() == "null") {
      // Not Available case
      rows.add(
        _buildSimpleInfoCard(
          "Current Location",
          "Not Available",
          Icons.location_on_outlined,
          Colors.red,  // grey color to indicate unavailable
          isSmallScreen: isSmallScreen,
          isDarkMode: isDarkMode,
        ),
      );
    } else {
      // Valid location available
      rows.add(
        GestureDetector(
          onTap: () {
            // अगर यह location link है (जैसे Google Maps URL) या video है, तो launch करें
            // यहाँ _launchVideo की जगह आप _launchURL या map launcher भी use कर सकते हैं
            _launchVideo(currentLocation.trim(), context); // या आपका custom launcher
          },
          child: _buildSimpleInfoCard(
            "Current Location",
            currentLocation.trim(),
            Icons.location_on,
            Colors.red,
            isSmallScreen: isSmallScreen,
            isDarkMode: isDarkMode,
          ),
        ),
      );
    }
    // Fieldworker Info Card
    rows.add(_buildFieldworkerInfoCard(prop, context, isSmallScreen, isDarkMode));
    return rows;
  }
  Widget _buildFieldworkerInfoCard(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode) {
    final String name = prop.fieldWorkerName ?? '';
    final String number = prop.fieldWorkerNumber ?? '';
    final String address = prop.fieldWorkerAddress ?? '';
    final String location = prop.fieldWorkerCurrentLocation ?? '';
    if (name.isEmpty && number.isEmpty && address.isEmpty && location.isEmpty) {
      return const SizedBox.shrink();
    }
    final Color cardColor = Colors.blue;
    final Color bgColor = Colors.blue;
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Role and Name
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
                        color: isDarkMode ? Colors.black : Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6.0 : 8.0),
          // Number (if available)
          if (number.isNotEmpty)
            GestureDetector(
              onTap: () => _showCallConfirmation(context, name, number),
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
                        _maskPhoneNumber(number),
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
                          onTap: () => _openWhatsApp(number, context),
                          child: Icon(PhosphorIcons.whatsapp_logo_bold, color: Colors.green, size: isSmallScreen ? 20.0 : 24.0),
                        ),
                        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                        Icon(Icons.call, color: bgColor, size: isSmallScreen ? 20.0 : 24.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Address (if available)
          if (address.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: _buildSimpleInfoCard("Fieldworker Address", address, Icons.location_on, Colors.lime, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
            ),
          // Current Location (if available)
          if (location.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: _buildSimpleInfoCard("Fieldworker Location", location, Icons.my_location, Colors.lightBlue, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
            ),
        ],
      ),
    );
  }

  String _maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String firstPart = number.substring(0, 3);
    String lastPart = number.substring(number.length - 4);
    return '$firstPart****$lastPart';
  }

  Future<void> _launchVideo(String url, BuildContext context) async {
    final Uri videoUri = Uri.parse(url);
    if (await canLaunchUrl(videoUri)) {
      await launchUrl(videoUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot launch video")),
        );
      }
    }
  }

  String _formatDate(String? dateString) {
    return formatDate(dateString);
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        isLive: false,
        forceHD: false,
        disableDragSeek: false,
        hideControls: true,
        hideThumbnail: false,
        loop: false,
        showLiveFullscreenButton: false,
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // code to run when exiting full screen, if any
      },
      builder: (context, player) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            child: player,
          ),
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
        onReady: () {
          print("Player is ready.");
        },
      ),
    );
  }
}
void openWhatsApp(String phoneNumber) {
  if (defaultTargetPlatform == TargetPlatform.android) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('whatsapp://send?phone=$cleanNumber'),
      package: 'com.whatsapp',
    );
    intent.launch();
  } else {
    // For iOS or others fallback to url_launcher or show message
    print('WhatsApp open only supported on Android with this method');
  }
}