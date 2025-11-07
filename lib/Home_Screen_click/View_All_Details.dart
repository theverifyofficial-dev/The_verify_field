import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/realestateSlider.dart';
import 'Real-Estate.dart';

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
  final String? sourceId;

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
    this.sourceId,
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

// Image Preview Screen
class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const ImagePreviewScreen({Key? key, required this.imageUrl, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: tag,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
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
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=$_id&looking=Book'));

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Show_Real_Estate()),
            (route) => route.isFirst,
      );
    }
  }

  Future<List<RealEstateSlider>> fetchCarouselData(int id) async {
    final url = 'https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is String) {
        final innerData = json.decode(data);
        return (innerData as List).map((item) => RealEstateSlider.fromJson(item)).toList();
      }
      return (data as List).map((item) => RealEstateSlider.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  Future<List<Catid>> fetchData(int id) async {
    final url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_api_for_details_page_in_main_realestate.php?P_id=$id");
    final response = await http.get(url);

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

    if (properties.isNotEmpty) {
      setState(() {
        firstProperty = properties.first;
      });
    }

    return properties;
  }

  List<String> name = [];
  int _id = 0;
  Future<List<Catid>>? _propertyFuture;
  Future<List<RealEstateSlider>>? _galleryFuture;
  Catid? firstProperty;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loaduserdata();
      if (_id != 0) {
        setState(() {
          _propertyFuture = fetchData(widget.id);
          _galleryFuture = fetchCarouselData(_id);
        });
      }
    });
  }

  Future<void> _loaduserdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int loadedId = prefs.getInt('id_Building') ?? 0;
      setState(() {
        _id = loadedId;
      });
    } catch (e) {
      setState(() {
        _id = 0;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _propertyFuture = fetchData(widget.id);
      _galleryFuture = fetchCarouselData(_id);
      _isRefreshing = false;
    });
  }

  // Helper Methods
  Future<bool> _checkCallPermission() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      status = await Permission.phone.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  void _showCallConfirmation(BuildContext parentContext, String name, String number) {
    String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.contact_phone, size: 50, color: Colors.blue),
              SizedBox(height: 10),
              Text('Contact $name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Choose how you want to connect'),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.call, color: Colors.white),
                      label: Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        bool granted = await _checkCallPermission();
                        if (!granted) return;
                        await _makePhoneCall(cleanNumber, parentContext);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.message, color: Colors.white),
                      label: Text('WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await _openWhatsApp(cleanNumber, parentContext);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
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
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isLoading = false;

            Future<void> _submit() async {
              final link = _videoController.text.trim();
              if (link.isEmpty) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(
                  SnackBar(content: Text("Please enter a video link.")),
                );
                return;
              }

              setModalState(() => isLoading = true);
              try {
                final apiUrl = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_video_in_main_realetstae.php");
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
                    SnackBar(content: Text("Failed to add video. (${response.statusCode})")),
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
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text("Add Video Link", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16),
                  TextField(
                    controller: _videoController,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintText: "Paste YouTube or video URL",
                      prefixIcon: Icon(Icons.video_library_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading ? null : () => Navigator.of(sheetContext).pop(),
                        child: Text("Cancel"),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading ? CircularProgressIndicator(strokeWidth: 2) : Text("Submit"),
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

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.book, color: Colors.blue),
                title: Text('Book Property'),
                onTap: () {
                  Navigator.pop(context);
                  Book_property();
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: Colors.purple),
                title: Text('Add Video'),
                onTap: () {
                  Navigator.pop(context);
                  if (firstProperty != null) {
                    _showAddVideoSheet(context, firstProperty!.id);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.refresh, color: Colors.green),
                title: Text('Refresh Data'),
                onTap: () {
                  Navigator.pop(context);
                  _refreshData();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF0A0A0A) : Color(0xFFFAFAFA),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.blue,
        backgroundColor: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header Section with AppBar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black54 : Colors.white54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDarkMode ? Colors.white : Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black54 : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.more_vert_rounded, color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: () => _showMenuOptions(context),
                  ),
                ),
              ],
              expandedHeight: 380,
              flexibleSpace: FutureBuilder<List<Catid>>(
                future: _propertyFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final property = snapshot.data!.first;
                    return _PropertyHeader(property: property, isDarkMode: isDarkMode);
                  }
                  return _ShimmerHeader(isDarkMode: isDarkMode);
                },
              ),
            ),

            // Content Section
            SliverToBoxAdapter(
              child: FutureBuilder<List<Catid>>(
                future: _propertyFuture,
                builder: (context, propertySnapshot) {
                  if (propertySnapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  } else if (propertySnapshot.hasError) {
                    return _buildErrorState(propertySnapshot.error.toString());
                  } else if (propertySnapshot.data == null || propertySnapshot.data!.isEmpty) {
                    return _buildEmptyState(isDarkMode);
                  } else {
                    final property = propertySnapshot.data!.first;
                    return _PropertyContent(
                      property: property,
                      isDarkMode: isDarkMode,
                      galleryFuture: _galleryFuture,
                      onCall: _showCallConfirmation,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _PremiumBottomBar(
        onEdit: () {
          _showEditOptions(context);
        },
        onAddImages: () {
          _showAddImagesOptions(context);
        },
        isDarkMode: isDarkMode,
      ),
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Update Property Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit Basic Information'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Edit Basic Information Feature')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.price_change, color: Colors.green),
                title: Text('Update Price'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Update Price Feature')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.orange),
                title: Text('Edit Description'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Edit Description Feature')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddImagesOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Images", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Camera Feature')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gallery Feature')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.cloud_upload, color: Colors.orange),
                title: Text('Upload Multiple Images'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Multiple Upload Feature')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) => _ShimmerListItem(),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 400,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text("Something went wrong", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _refreshData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Try Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      height: 400,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text("No Property Found", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("The property details are not available", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyHeader extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;

  const _PropertyHeader({required this.property, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final hasVideo = property.videoLink != null && property.videoLink!.isNotEmpty;

    return Stack(
      children: [
        Container(
          height: 380,
          width: double.infinity,
          child: hasVideo
              ? VideoPlayerWidget(videoUrl: property.videoLink!)
              : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImagePreviewScreen(
                    imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                    tag: 'main_image',
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                child: Icon(Icons.home_work, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          height: 380,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Price and Location Overlay
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${property.showPrice}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      property.buyRent.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                property.locations,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PropertyContent extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;
  final Future<List<RealEstateSlider>>? galleryFuture;
  final Function(BuildContext, String, String) onCall;

  const _PropertyContent({
    required this.property,
    required this.isDarkMode,
    required this.galleryFuture,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Property Quick Details
          _PropertyQuickDetails(property: property, isDarkMode: isDarkMode),
          SizedBox(height: 16),

          // Property Details List
          _PropertyDetailsList(property: property, isDarkMode: isDarkMode),
          SizedBox(height: 16),

          // Exact Location Section
          _ExactLocationSection(property: property, isDarkMode: isDarkMode),
          SizedBox(height: 16),

          // Gallery
          _PremiumGallerySection(galleryFuture: galleryFuture, isDarkMode: isDarkMode),
          SizedBox(height: 16),

          // Additional Information
          _AdditionalInfoSection(property: property, isDarkMode: isDarkMode),
          SizedBox(height: 16),

          // Contact Information
          _ContactSection(property: property, isDarkMode: isDarkMode, onCall: onCall),
          SizedBox(height: 16),

          // Field Worker Information
          _FieldWorkerSection(property: property, isDarkMode: isDarkMode, onCall: onCall),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ExactLocationSection extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;

  const _ExactLocationSection({required this.property, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on_rounded, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text(
              "Exact Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (property.latitude.isNotEmpty && property.longitude.isNotEmpty) {
              final url = 'https://www.google.com/maps/search/?api=1&query=${property.latitude},${property.longitude}';
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location coordinates not available')),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [Color(0xFF1A1A1A), Color(0xFF2D2D2D)]
                    : [Colors.white, Color(0xFFF8F9FA)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.map_rounded, color: Colors.white, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "View on Google Maps",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        property.fieldWorkerCurrentLocation.isNotEmpty
                            ? property.fieldWorkerCurrentLocation
                            : property.locations,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PropertyQuickDetails extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;

  const _PropertyQuickDetails({required this.property, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Color(0xFF1A1A1A), Color(0xFF2D2D2D)]
              : [Colors.white, Color(0xFFF8F9FA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.bed_rounded,
            value: "${property.bhk} BHK",
            label: "Bedrooms",
            color: Colors.blue,
          ),
          _StatItem(
            icon: Icons.bathtub_rounded,
            value: "${property.bathroom}",
            label: "Bathrooms",
            color: Colors.green,
          ),
          _StatItem(
            icon: Icons.square_foot_rounded,
            value: "${property.squarefit}",
            label: "Sq. Ft.",
            color: Colors.orange,
          ),
          _StatItem(
            icon: Icons.construction_rounded,
            value: "${property.ageOfProperty}",
            label: "Age",
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _PropertyDetailsList extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;

  const _PropertyDetailsList({required this.property, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final details = [
      _DetailItem("Property Type", property.typeofProperty, Icons.type_specimen_rounded, Colors.blue),
      _DetailItem("Flat Number", property.flatNumber, Icons.numbers_rounded, Colors.green),
      _DetailItem("Floor", "${property.floor}/${property.totalFloor}", Icons.flood_rounded, Colors.orange),
      _DetailItem("Parking", property.parking, Icons.local_parking_rounded, Colors.purple),
      _DetailItem("Lift", property.lift, Icons.elevator_rounded, Colors.red),
      _DetailItem("Kitchen", property.kitchen, Icons.kitchen_rounded, Colors.teal),
      _DetailItem("Furnishing", property.furnishing, Icons.chair_rounded, Colors.brown),
      _DetailItem("Balcony", property.balcony, Icons.balcony_rounded, Colors.lightGreen),
      _DetailItem("Maintenance", "₹${property.maintenance}/month", Icons.settings_rounded, Colors.indigo),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Property Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: details.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final item = details[index];
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 20, color: item.color),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                trailing: Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DetailItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _DetailItem(this.title, this.value, this.icon, this.color);
}

class _PremiumGallerySection extends StatelessWidget {
  final Future<List<RealEstateSlider>>? galleryFuture;
  final bool isDarkMode;

  const _PremiumGallerySection({required this.galleryFuture, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_library_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Gallery",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        FutureBuilder<List<RealEstateSlider>>(
          future: galleryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(
                    width: 280,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                height: 150,
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library_rounded, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("No images available", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final image = snapshot.data![index];
                    final imageUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.mImages}";
                    final tag = 'gallery_image_$index';

                    return Container(
                      width: 300,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Hero(
                              tag: tag,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.photo_rounded, color: Colors.grey, size: 50),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _AdditionalInfoSection extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;

  const _AdditionalInfoSection({required this.property, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final additionalInfo = [
      _InfoItem("Available From", formatDate(property.availableDate), Icons.calendar_today_rounded, Colors.blue),
      _InfoItem("Price Details", "Ask: ₹${property.askingPrice} | Last: ₹${property.lastPrice}", Icons.price_change_rounded, Colors.green),
      _InfoItem("Metro Distance", property.metroDistance, Icons.train_rounded, Colors.orange),
      _InfoItem("Highway Distance", property.highwayDistance, Icons.highlight_rounded, Colors.red),
      _InfoItem("Market Distance", property.mainMarketDistance, Icons.shopping_cart_rounded, Colors.purple),
      _InfoItem("Road Size", property.roadSize, Icons.aod_rounded, Colors.teal),
      _InfoItem("Meter Type", property.meter, Icons.electrical_services_rounded, Colors.indigo),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.more_horiz_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Additional Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: additionalInfo.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
            itemBuilder: (context, index) {
              final item = additionalInfo[index];
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon, size: 20, color: item.color),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                trailing: Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }
}

class _InfoItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _InfoItem(this.title, this.value, this.icon, this.color);
}

class _ContactSection extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;
  final Function(BuildContext, String, String) onCall;

  const _ContactSection({required this.property, required this.isDarkMode, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.contact_phone_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              "Contact Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        _PremiumContactCard(
          name: property.ownerName,
          phone: property.ownerNumber,
          role: "Owner",
          color: Colors.amber,
          onCall: () => onCall(context, property.ownerName, property.ownerNumber),
        ),
        if (property.caretakerName.isNotEmpty) ...[
          SizedBox(height: 12),
          _PremiumContactCard(
            name: property.caretakerName,
            phone: property.caretakerNumber,
            role: "Caretaker",
            color: Colors.purple,
            onCall: () => onCall(context, property.caretakerName, property.caretakerNumber),
          ),
        ],
      ],
    );
  }
}

class _PremiumContactCard extends StatelessWidget {
  final String name;
  final String phone;
  final String role;
  final Color color;
  final VoidCallback onCall;

  const _PremiumContactCard({
    required this.name,
    required this.phone,
    required this.role,
    required this.color,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.05), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role.toUpperCase(),
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold, letterSpacing: 1)),
                SizedBox(height: 6),
                Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(phone, style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Row(
            children: [
              _ContactButton(
                icon: Icons.phone_rounded,
                color: Colors.green,
                onPressed: onCall,
              ),
              SizedBox(width: 8),
              _ContactButton(
                icon: Icons.message_rounded,
                color: Color(0xFF25D366),
                onPressed: () {
                  // WhatsApp functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ContactButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class _FieldWorkerSection extends StatelessWidget {
  final Catid property;
  final bool isDarkMode;
  final Function(BuildContext, String, String) onCall;

  const _FieldWorkerSection({required this.property, required this.isDarkMode, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Color(0xFF1A1A1A), Color(0xFF2D2D2D)]
              : [Colors.white, Color(0xFFF8F9FA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.engineering_rounded, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Field Worker", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(property.fieldWorkerName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(property.fieldWorkerNumber, style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(
                  property.fieldWorkerAddress,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _ContactButton(
            icon: Icons.phone_rounded,
            color: Colors.green,
            onPressed: () => onCall(context, property.fieldWorkerName, property.fieldWorkerNumber),
          ),
        ],
      ),
    );
  }
}

class _PremiumBottomBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAddImages;
  final bool isDarkMode;

  const _PremiumBottomBar({required this.onEdit, required this.onAddImages, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit_document, size: 20),
                label: Text('UPDATE DATA'),
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_photo_alternate_rounded, size: 20),
                label: Text('ADD IMAGES'),
                onPressed: onAddImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer Effects
class _ShimmerHeader extends StatelessWidget {
  final bool isDarkMode;

  const _ShimmerHeader({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      height: 80,
    );
  }
}

// Video Player Widget
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

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
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
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
    return ClipRRect(
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      ),
    );
  }
}