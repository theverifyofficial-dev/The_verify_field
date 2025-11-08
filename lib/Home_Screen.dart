import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Upcoming/Parent_Upcoming.dart';
import 'package:verify_feild_worker/profile.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Add_Rented_Flat/Add_Rented_Flat_Tabbar.dart';
import 'Add_Rented_Flat/Field_Worker_Target.dart';
import 'Administrator/agreement_details.dart';
import 'Future_Property_OwnerDetails_section/Future_Property.dart';
import 'Home_Screen_click/New_Real_Estate.dart';
import 'Home_Screen_click/live_tabbar.dart';
import 'Propert_verigication_Document/Show_tenant.dart';
import 'Rent Agreement/Dashboard_screen.dart';
import 'Rent Agreement/history_tab.dart';
import 'Social_Media_links.dart';
import 'Statistics/Progressbar.dart';
import 'Statistics/Target_MainPage.dart';
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

class _Home_ScreenState extends State<Home_Screen> {

  late String formattedDate;
  DateTime now = DateTime.now();

  String _fieldworkarnumber = '';

  String? userName;
  String? userNumber;


  @override
  void initState() {
    super.initState();
    _loaduserdata();
    loadUserName();
    // Future.microtask(() => hitAgreementRenewalAPI());
    _requestLocationPermissionAndGetLocation();
    //initializeService();
  }

  Future<void> hitAgreementRenewalAPI() async {

    const String url = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement_renewal_cron.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print("✅ Agreement renewal API triggered successfully.");
        print("Response: ${response.body}");
      } else {
        print("⚠️ API failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error hitting agreement renewal API: $e");
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
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        print("Latitude: ${position.latitude}");
        print("Longitude: ${position.longitude}");

      });
      await _saveLocationToPrefs(_latitude!, _longitude!);

    } else if (status.isDenied) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Permission Required"),
          content: Text("Location permission is required to proceed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Permission.location.request();
              },
              child: Text("Allow"),
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
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/count_police_verification_rent_target_by_fnumber_random_text?feildworkar_number=asda&random_text=asda");
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
       backgroundColor: isDark ? Colors.black45 : Colors.grey.shade200,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            //Navigator.pop(context);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileDashboard()));
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            // UserSearchPage()
            ProfilePage()
            ));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8,),
              Icon(
                PhosphorIcons.user_circle,
                color: Colors.white,
                size: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${userName}',style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),
                ],
              ),

            ],
          ),
        ),
        actions:  [
          IconButton(
            icon: Icon(
              ThemeSwitcher.of(context)?.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.yellow

            ),
            onPressed: () {
              ThemeSwitcher.of(context)?.toggleTheme();
            },
          ),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LinksPage()));
            },
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    const Text('🌐'),
                  ],
                ),
                const Text('Web'),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TargetHeaderCard(context),

            const SizedBox(height: 20),

            // ---- 1️⃣ First List Section ----
            _SectionTitle("Future Property"),
            _ListCard(
              image: AppImages.futureProperty,
              title: "Future Property",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FrontPage_FutureProperty()),
              ),
            ),

            const SizedBox(height: 16),

            // ---- 2️⃣ First Grid Section ----
            // _SectionTitle("Live & Upcoming Flats"),
            _DashboardGrid([
              {
                "image": AppImages.verify_Property,
                "title": "Live Property",
                "onTap": () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LiveTabbar())),
              },
              {
                "image": AppImages.realestatefeild,
                "title": "Upcoming Flats",
                "onTap": () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const ParentUpcoming())),
              },
              {
                "image": AppImages.police,
                "title": "All Rented Flat",
                "onTap": () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddRentedFlatTabbar())),
              },
              // {
              //   "image": AppImages.websiteIssue,
              //   "title": "Web Query",
              //   "onTap": () => Navigator.push(
              //       context, MaterialPageRoute(builder: (_) => const WebQueryPage())),
              // },
            ]),

            const SizedBox(height: 16),

            // ---- 3️⃣ Second List Section ----
            _SectionTitle("Agreements & Tenant"),
            _ListCard(
              image: AppImages.agreement,
              title: "Property Agreement",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryTab()),
              ),
            ),
            const SizedBox(height: 12),
            _ListCard(
              image: AppImages.tenant,
              title: "Tenant Demands",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainPage_TenandDemand()),
              ),
            ),

            const SizedBox(height: 16),

            // ---- 4️⃣ Second Grid Section ----
            _SectionTitle("More Features"),
            _DashboardGrid([
              {
                "image": AppImages.documents,
                "title": "Verification Property",
                "onTap": () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ShowProperty())),
              },
            ]),
          ],
        ),
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


class _AnimatedDashboardCard extends StatefulWidget {
  final BuildContext context;
  final String image;
  final String title;
  final VoidCallback onTap;

  const _AnimatedDashboardCard({
    required this.context,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  _AnimatedDashboardCardState createState() => _AnimatedDashboardCardState();
}


class _AnimatedDashboardCardState extends State<_AnimatedDashboardCard> {
  bool _isPressed = false;
  Color? _glowColor;

  @override
  void initState() {
    super.initState();
    _extractColor();
  }

  Future<void> _extractColor() async {
    final palette = await PaletteGenerator.fromImageProvider(
      AssetImage(widget.image),
    );
    setState(() {
      _glowColor = palette.dominantColor?.color ?? Colors.blueAccent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = _glowColor ?? Colors.blueAccent;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.42,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.white, Colors.grey.shade200] // light cards on dark theme
                  : [Color(0xFF1E1E1E), Color(0xFF2C2C2C)], // dark grey cards on light theme
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.25)
                    : Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✨ Soft Image Glow Only
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glow.withOpacity(0.25), // 🔥 toned down glow
                      blurRadius: 12,
                      spreadRadius: 0.8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  // invert text color to match inverted card background
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _TargetHeaderCard(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Target_MainPage()),
      );
    },
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark?
          [Colors.grey.shade100, Colors.white]
              : [Color(0xFF1E1E1E), Color(0xFF2C2C2C)], // dark grey cards on light theme
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔥 Animated Glow with Image
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.blueAccent.withOpacity(0.4)
                          : Colors.blue.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  AppImages.target, // your target image asset here
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Target",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tap to view progress",
                  style: TextStyle(
                    fontSize: 13.5,
                    color: (isDark ? Colors.black : Colors.white).withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ],
      ),
    ),
  );
}


Widget _SectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
        color: Colors.blueAccent,
      ),
    ),
  );
}

Widget _ListCard({
  required String image,
  required String title,
  required VoidCallback onTap,
}) {
  return FutureBuilder<PaletteGenerator>(
    future: PaletteGenerator.fromImageProvider(AssetImage(image)),
    builder: (context, snapshot) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final glowColor =
          snapshot.data?.dominantColor?.color ?? Colors.blueAccent;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.white, Colors.grey.shade200] // light cards on dark theme
                  : [Color(0xFF1E1E1E), Color(0xFF2C2C2C)], // dark grey cards on light theme
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),


            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.25)
                    : Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ✨ Subtle glow around image only
              Container(
                width: 90,
                height: 90,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(image, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    // invert text color to match inverted card background
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: isDark ? Colors.black45 : Colors.white60,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _DashboardGrid(List<Map<String, dynamic>> items) {
  return AnimationLimiter(
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 500),
          columnCount: 2,
          child: ScaleAnimation(
            scale: 0.5,
            child: FadeInAnimation(
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: _AnimatedDashboardCard(
                  context: navigatorKey.currentContext!, // or just use context
                  image: item["image"],
                  title: item["title"],
                  onTap: item["onTap"],
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );
}
