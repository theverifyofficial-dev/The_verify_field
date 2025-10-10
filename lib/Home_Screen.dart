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
    _requestLocationPermissionAndGetLocation();
    //initializeService();
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
  _AgreementURL() async {
    final Uri url = Uri.parse('https://theverify.in/example.html');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
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
            // Animated Header
            AnimationConfiguration.synchronized(
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Your original card grid with enhanced animations
            AnimationLimiter(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(8, (index) {
                  // Keep your original cardData list exactly as you had it
                  final List<Map<String, dynamic>> cardData = [
                    {
                      "image": AppImages.verify_Property,
                      "title": "Add Real Estate",
                      "onTap": () =>
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Show_New_Real_Estate())),
                    },

                    {
                      "image": AppImages.documents,
                      "title": "Verification",
                      "onTap": () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ShowProperty())),
                    },

                    {
                      "image": AppImages.futureProperty,
                      "title": "Future\n Property",
                      "onTap": () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FrontPage_FutureProperty(),
                          ),
                        );
                      },
                    },

                    {
                      "image": AppImages.tenant,
                      "title": "Tenant\n Demands",
                      "onTap": () {
                        uploadImageWithTitle();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainPage_TenandDemand()));
                      },
                    },

                    {
                      "image": AppImages.agreement,
                      "title": "Property Agreement",
                      "onTap": () =>
                          //_AgreementURL(),
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HistoryTab()
                    )),
                    },

                    {
                      "image": AppImages.police,
                      "title": "All Rented \nFlat",
                      "onTap": () {
                        uploadImageWithTitle();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddRentedFlatTabbar()));
                      },
                    },
                    {
                      "image": AppImages.websiteIssue,
                      "title": "Web \nQuery",
                      "onTap": () {
                        uploadImageWithTitle();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WebQueryPage()));
                      },
                    },
                    {
                      "image": AppImages.realestatefeild,
                      "title": "Upcoming\nFlats",
                      "onTap": () {
                        uploadImageWithTitle();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => const WebQueryPage()));
                      },
                    },

                  ];

                  final item = cardData[index];

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
                            context: context,
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
            ),
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
// Your original dashboardCard widget with animations added
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.95 : 1.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.42,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white12
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 65,
                width: 65,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white12
                        : Colors.grey.shade400,
                    width: 1,
                  ),
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}