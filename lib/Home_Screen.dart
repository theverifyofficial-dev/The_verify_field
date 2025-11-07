import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Add_commercial_property.dart';
import 'package:verify_feild_worker/Upcoming/Parent_Upcoming.dart';
import 'package:verify_feild_worker/profile.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Add_Rented_Flat/Add_Rented_Flat_Tabbar.dart';
import 'Add_Rented_Flat/Field_Worker_Target.dart';
import 'Administrator/agreement_details.dart';
import 'Future_Property_OwnerDetails_section/Future_Property.dart';
import 'Home_Screen_click/New_Real_Estate.dart';
import 'Propert_verigication_Document/Show_tenant.dart';
import 'Rent Agreement/Dashboard_screen.dart';
import 'Rent Agreement/history_tab.dart';
import 'Social_Media_links.dart';
import 'Tenant_Details_Demand/MainPage_Tenantdemand_Portal.dart';
import 'Web_query/web_query.dart' hide SlideAnimation, ScaleAnimation;
import 'add_properties_firstpage.dart';
import 'main.dart';

class Catid1122 {
  final int id;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String BHK;
  final String tyope;
  final String floor_ ;
  final String buy_Rent ;
  final String Building_information;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String vehicleNo;
  final String property_address_for_fieldworkar;
  final String date;

  Catid1122(
      {required this.id, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.BHK, required this.tyope, required this.floor_, required this.buy_Rent,
        required this.Building_information,required this.Ownername,required this.Owner_number, required this.Caretaker_name,required this.Caretaker_number,required this.vehicleNo,required this.property_address_for_fieldworkar,required this.date});

  factory Catid1122.FromJson(Map<String, dynamic>json){
    return Catid1122(id: json['id'],
        Building_Address: json['propertyname_address'],
        Building_Location: json['place'],
        Building_image: json['images'],
        Longitude: json['longitude'],
        Latitude: json['latitude'],
        BHK: json['select_bhk'],
        tyope: json['typeofproperty'],
        floor_: json['floor_number'],
        buy_Rent: json['buy_rent'],
        Building_information: json['building_information_facilitys'],
        Ownername: json['ownername'],
        Owner_number: json['ownernumber'],
        Caretaker_name: json['caretakername'],
        Caretaker_number: json['caretakernumber'],
        vehicleNo: json['owner_vehical_number'],
        property_address_for_fieldworkar: json['property_address_for_fieldworkar'],
        date: json['current_date_']);
  }
}

class Catid {
  final int id;

  Catid(
      {required this.id});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['logg']);
  }
}

class Home_Screen extends StatefulWidget {
  static const route = "/Home_Screen";
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> with TickerProviderStateMixin {

  late String formattedDate;
  DateTime now = DateTime.now();

  String _fieldworkarnumber = '';

  String? userName;
  String? userNumber;

  int rentPropertiesCount = 0;
  int agreementCount = 0;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _loaduserdata();
    loadUserName();
    _requestLocationPermissionAndGetLocation();
    _loadStats();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    try {
      final rentData = await fetchData();
      final agreementData = await fetchData_aggrement();
      if (mounted) {
        setState(() {
          rentPropertiesCount = rentData.isNotEmpty ? rentData.first.id : 0;
          agreementCount = agreementData.isNotEmpty ? agreementData.first.id : 0;
        });
      }
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  double? _latitude;
  double? _longitude;
  Future<void> _saveLocationToPrefs(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }
  Future<void> _requestLocationPermissionAndGetLocation() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          print("Latitude: ${position.latitude}");
          print("Longitude: ${position.longitude}");
        });
      }
      await _saveLocationToPrefs(_latitude!, _longitude!);
    } else if (status.isDenied) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text("Location permission is required to proceed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Permission.location.request();
              },
              child: const Text("Allow"),
            ),
          ],
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  Future<List<Catid>> fetchData() async{
    formattedDate = "${now.month}/${now.year}";
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/count_rent_proerty?feildworkar_number=$_fieldworkarnumber&random_text=${formattedDate.toString()}");
    final responce=await http.get(url);
    if(responce.statusCode==200){
      print(_fieldworkarnumber.toString());
      print(formattedDate.toString());
      List listresponce=json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid1122>> fetchData_Logg() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=$_fieldworkarnumber");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid1122.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData_aggrement() async{
    formattedDate = "${now.month}/${now.year}";
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/count_police_verification_rent_target_by_fnumber_random_text?feildworkar_number=$_fieldworkarnumber&random_text=${formattedDate.toString()}");
    final responce=await http.get(url);
    if(responce.statusCode==200){
      print(_fieldworkarnumber.toString());
      print(formattedDate.toString());
      List listresponce=json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occured!');
    }
  }


  Future<void> uploadImageWithTitle() async {
    String uploadUrl = 'https://verifyserve.social/PHP_Files/update_assign_tenant_demand/delete.php'; // Replace with your API endpoint
    FormData formData = FormData.fromMap({
      "looking_type": "Month",
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {

        print('Upload successful: ${response.data}');
      } else {

        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
      Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print('Error occurred: $e');
    }
  }


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
  _AgreementURL() async {
    final Uri url = Uri.parse('https://theverify.in/example.html');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Responsive values
    final horizontalPadding = isTablet ? 32.0 : 20.0;
    final verticalSpacing = isTablet ? 16.0 : 12.0;
    final cardAspectRatio = screenWidth < 400 ? 1.2 : 1.0; // Slightly taller for premium feel
    final gridCrossAxisCount = isTablet ? 3 : 2; // Responsive grid columns

    // Premium theme: Enhanced gradients, shadows, and colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryGradient = LinearGradient(
      colors: [Colors.purple.shade700, Colors.indigo.shade800, Colors.blue.shade900],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Different gradients for each card
    final List<LinearGradient> cardGradients = [
      LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade900]),
      LinearGradient(colors: [Colors.green.shade600, Colors.green.shade900]),
      LinearGradient(colors: [Colors.orange.shade900, Colors.orange.shade900]),
      LinearGradient(colors: [Colors.purple.shade900, Colors.purple.shade600]),
      LinearGradient(colors: [Colors.red.shade900, Colors.red.shade900]),
      LinearGradient(colors: [Colors.teal.shade600, Colors.indigo.shade300]),
      LinearGradient(colors: [Colors.indigo.shade600, Colors.indigo.shade900]),
      LinearGradient(colors: [Colors.blueAccent, Colors.blueAccent]),
      LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade600]),
    ];

    final List<Map<String, dynamic>> cardData = [
      {
        "image": AppImages.verify_Property,
        "title": "Live Property",
        "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const Show_New_Real_Estate())),
        "gradient": cardGradients[0],
      },
      {
        "image": AppImages.documents,
        "title": "Verification",
        "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ShowProperty())),
        "gradient": cardGradients[1],
      },
      {
        "image": AppImages.futureProperty,
        "title": "Future Property",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FrontPage_FutureProperty(),
          ),
        ),
        "gradient": cardGradients[2],
      },
      {
        "image": AppImages.tenant,
        "title": "Tenant Demands",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const MainPage_TenandDemand()));
        },
        "gradient": cardGradients[3],
      },
      {
        "image": AppImages.agreement,
        "title": "Property Agreement",
        "onTap": () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => const HistoryTab()
        )),
        "gradient": cardGradients[4],
      },
      {
        "image": AppImages.police,
        "title": "All Rented Flat",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddRentedFlatTabbar()));
        },
        "gradient": cardGradients[5],
      },
      {
        "image": AppImages.websiteIssue,
        "title": "Web Query",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const WebQueryPage()));
        },
        "gradient": cardGradients[6],
      },
      {
        "image": AppImages.realestatefeild,
        "title": "Upcoming Flats",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ParentUpcoming()));
        },
        "gradient": cardGradients[7],
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Top Header without curve - straight container with gradient
          SizedBox(
            height: 250, // Fixed height to prevent overflow
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: primaryGradient),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0),
                  child: Column(
                    children: [
                      // Top Row: Profile, Logo with premium styling
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Enhanced Profile with glow effect
                            Hero(
                              tag: 'profile',
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    PhosphorIcons.user_circle,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            // Premium Logo with subtle animation
                            Expanded(
                              child: Center(
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 1000),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(
                                        opacity: value,
                                        child: Image.asset(AppImages.transparent, height: 40,),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Notification icon on right for balance and premium touch
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) => LinksPage()));
                                  },
                                  icon: const Icon(
                                      PhosphorIcons.globe_stand,
                                      color: Colors.white, size: 24)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      // Enhanced Stats Row with premium cards - Compact without greeting
                      Expanded(
                        child: ClipRect(
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.15),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _PremiumStatCard(
                                          icon: Icons.home_outlined,
                                          label: 'Properties Sold',
                                          value: rentPropertiesCount.toString(),
                                          gradient: LinearGradient(
                                            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                                          ),
                                        ),
                                        _PremiumStatCard(
                                          icon: Icons.home_outlined,
                                          label: 'Properties Sold',
                                          value: rentPropertiesCount.toString(),
                                          gradient: LinearGradient(
                                            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                                          ),
                                        ),
                                        _PremiumStatCard(
                                          icon: Icons.home_outlined,
                                          label: 'Properties Sold',
                                          value: rentPropertiesCount.toString(),
                                          gradient: LinearGradient(
                                            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        _PremiumStatCard(
                                          icon: Icons.description_outlined,
                                          label: 'Agreements',
                                          value: agreementCount.toString(),
                                          gradient: LinearGradient(
                                            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        _PremiumStatCard(
                                          icon: Icons.trending_up_outlined,
                                          label: 'Targets',
                                          value: '85%',
                                          gradient: LinearGradient(
                                            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Dashboard Section with 16 padding - Now in Expanded for scrolling grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12), // Space after header
                  Text(
                    'Dashboard',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                      letterSpacing: 0.8,

                    ),
                  ),
                  // Enhanced Grid with better animations and shadows - Now scrollable
                  Expanded(
                    child: AnimationLimiter(
                      child: GridView.count(
                        physics: const AlwaysScrollableScrollPhysics(),
                        crossAxisCount: gridCrossAxisCount, // Responsive crossAxisCount
                        crossAxisSpacing: verticalSpacing,
                        mainAxisSpacing: verticalSpacing,
                        childAspectRatio: cardAspectRatio,
                        children: List.generate(8, (index) {
                          final item = cardData[index];

                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            columnCount: gridCrossAxisCount, // Match responsive column count for animation
                            child: ScaleAnimation(
                              scale: 0.8,
                              child: FadeInAnimation(
                                child: SlideAnimation(
                                  horizontalOffset: 30.0,
                                  verticalOffset: 0.0,
                                  child: _PremiumDashboardCard(
                                    image: item["image"],
                                    title: item["title"],
                                    onTap: item["onTap"],
                                    gradient: item["gradient"],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }
}

class _PremiumStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _PremiumStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60, // Fixed width to prevent overflow
      child: Container(
        padding: const EdgeInsets.all(8), // Reduced padding for compactness
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20, shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumDashboardCard extends StatefulWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  final Gradient gradient;

  const _PremiumDashboardCard({
    required this.image,
    required this.title,
    required this.onTap,
    required this.gradient,
  });

  @override
  _PremiumDashboardCardState createState() => _PremiumDashboardCardState();
}

class _PremiumDashboardCardState extends State<_PremiumDashboardCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = widget.gradient.colors.first;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient.colors.map((c) => c.withOpacity(0.40)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
              if (_isPressed)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
            border: Border.all(
              color: accentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: accentColor.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Enhanced Image Container with glow
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradient.colors.map((c) => c.withOpacity(0.2)).toList(),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.contain,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Premium Title with better typography
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 12,
                        letterSpacing: 0.3,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}