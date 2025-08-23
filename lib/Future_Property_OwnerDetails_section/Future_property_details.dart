import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../property_preview.dart';
import '../ui_decoration_tools/constant.dart';
import '../model/futureProperty_Slideer.dart';
import 'Add_FutureProperty_Images.dart';
import 'Duplicate_Property.dart';
import 'Edit_futureproperty/Edit_Building.dart';
import 'Update_future_building.dart';
import 'add_flat_form.dart';
import 'New_Update/under_flats_infutureproperty.dart';

class Catid1 {
  final int id;
  final String Building_Name;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String sqft;
  final String tyope;
  final String floor_ ;
  final String maintence ;
  final String buy_Rent ;
  final String Building_information;
  final String Parking;
  final String balcony;
  final String facility;
  final String Furnished;
  final String kitchen;
  final String Baathroom;
  final String Date;

  Catid1(
      {required this.id, required this.Building_Name, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Date});

  factory Catid1.FromJson(Map<String, dynamic>json){
    return Catid1(id: json['PVR_id'],
        Building_Name: json['Building_information'],
        Building_Address: json['Address_'],
        Building_Location: json['Place_'],
        Building_image: json['Realstate_image'],
        Longitude: json['Longtitude'],
        Latitude: json['Latitude'],
        Rent: json['Property_Number'],
        Verify_price: json['Gas_meter'],
        BHK: json['Bhk_Squarefit'],
        sqft: json['City'],
        tyope: json['Typeofproperty'],
        floor_: json['floor_'],
        maintence: json['maintenance'],
        buy_Rent: json['Buy_Rent'],
        Building_information: json['Building_information'],
        balcony: json['balcony'],
        Parking: json['Parking'],
        facility: json['Lift'],
        Furnished: json['Furnished'],
        kitchen: json['kitchen'],
        Baathroom: json['Baathroom'],
        Date: json['date_']);
  }
}

class FutureProperty2 {
  final int id;
  final String images;
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;
  final String place;
  final String buyRent;
  final String typeOfProperty;
  final String selectBhk;
  final String floorNumber;
  final String squareFeet;
  final String propertyNameAddress;
  final String buildingInformationFacilities;
  final String propertyAddressForFieldworker;
  final String ownerVehicleNumber;
  final String yourAddress;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String currentDate;
  final String longitude;
  final String latitude;
  final String roadSize;
  final String metroDistance;
  final String metroName;
  final String mainMarketDistance;
  final String ageOfProperty;
  final String lift;
  final String parking;
  final String totalFloor;
  final String apartmentName; // optional, API may not have
  final String facility;
  final String currentLocation; // optional, API may not have
  final String residenceCommercial;

  FutureProperty2({
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
    required this.fieldworkerName,
    required this.fieldworkerNumber,
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
    required this.apartmentName,
    required this.facility,
    required this.currentLocation,
    required this.residenceCommercial,
  });

  factory FutureProperty2.fromJson(Map<String, dynamic> json) {
    return FutureProperty2(
      id: json['id'],
      images: json['images'] ?? '',
      ownerName: json['ownername'] ?? '',
      ownerNumber: json['ownernumber'] ?? '',
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',
      typeOfProperty: json['typeofproperty'] ?? '',
      selectBhk: json['select_bhk'] ?? '',
      floorNumber: json['floor_number'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      propertyNameAddress: json['propertyname_address'] ?? '',
      buildingInformationFacilities: json['building_information_facilitys'] ?? '',
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'] ?? '',
      ownerVehicleNumber: json['owner_vehical_number'] ?? '',
      yourAddress: json['your_address'] ?? '',
      fieldworkerName: json['fieldworkarname'] ?? '',
      fieldworkerNumber: json['fieldworkarnumber'] ?? '',
      currentDate: json['current_date_'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      metroName: json['metro_name'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      lift: json['lift'] ?? '',
      parking: json['parking'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      apartmentName: json['apartment_name'] ?? '', // default empty
      facility: json['facility'] ?? '',
      currentLocation: json['your_address'] ?? '', // use your_address as fallback
      residenceCommercial: json['Residence_commercial'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'ownername': ownerName,
      'ownernumber': ownerNumber,
      'caretakername': caretakerName,
      'caretakernumber': caretakerNumber,
      'place': place,
      'buy_rent': buyRent,
      'typeofproperty': typeOfProperty,
      'select_bhk': selectBhk,
      'floor_number': floorNumber,
      'sqyare_feet': squareFeet,
      'propertyname_address': propertyNameAddress,
      'building_information_facilitys': buildingInformationFacilities,
      'property_address_for_fieldworkar': propertyAddressForFieldworker,
      'owner_vehical_number': ownerVehicleNumber,
      'your_address': yourAddress,
      'fieldworkarname': fieldworkerName,
      'fieldworkarnumber': fieldworkerNumber,
      'current_date_': currentDate,
      'longitude': longitude,
      'latitude': latitude,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'metro_name': metroName,
      'main_market_distance': mainMarketDistance,
      'age_of_property': ageOfProperty,
      'lift': lift,
      'parking': parking,
      'total_floor': totalFloor,
      'apartment_name': apartmentName,
      'facility': facility,
      'field_worker_current_location': currentLocation,
      'Residence_commercial': residenceCommercial,
    };
  }
}


class Ground {
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
  final String squarefit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
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
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;

  Ground({
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
    required this.squarefit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
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
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });

  factory Ground.fromJson(Map<String, dynamic> json) {
    return Ground(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeOfProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldworkarAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid'] ?? '',
    );
  }
}

class Future_Property_details extends StatefulWidget {
  String idd;
  Future_Property_details({super.key, required this.idd});

  @override
  State<Future_Property_details> createState() => _Future_Property_detailsState();
}

class _Future_Property_detailsState extends State<Future_Property_details> {

  Future<List<Ground>> fetchData_Ground() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=G%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_first() async {
      var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=1%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_second() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/second_floor_base_show_mainrealestae?Floor_=2%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_third() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=3%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_four() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=4%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_five() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=5%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_six() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=6%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_seven() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=7%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<FutureProperty2>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=${widget.idd}");
    // var url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php?id=${widget.idd}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      listResponse.sort((a, b) => b['id'].compareTo(a['id']));
      return listResponse.map((data) => FutureProperty2.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_addimages_by_subid_?subid=${widget.idd}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel_F(
          dimage: item['img'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<String> name = [];
  late Future<Map<String, dynamic>> _allDataFuture;

  @override
  void initState() {
    super.initState();
    _allDataFuture = _fetchAllData(); // all data loaded together
  }

  Future<Map<String, dynamic>> _fetchAllData() async {
    try {
      // Run all API calls in parallel
      final results = await Future.wait([
        fetchData_Ground(),
        fetchData_first(),
        fetchData_second(),
        fetchData_third(),
        fetchData_four(),
        fetchData_five(),
        fetchData_six(),
        fetchData_seven(),
        fetchData(),
        fetchCarouselData(),
      ]);

      return {
        'groundList': results[0],
        'firstList': results[1],
        'secondList': results[2],
        'thirdList': results[3],
        'fourthList': results[4],
        'fifthList': results[5],
        'sixList': results[6],
        'sevenList': results[7],
        'catidList': results[8],
        'imageList': results[9],
      };
    } catch (e) {
      print("Error fetching all data: $e");
      throw Exception('Failed to load all data');
    }
  }

  List<Ground> groundList = [];
  List<Ground> firstList = [];
  List<Ground> secondList = [];
  List<Ground> thirdList = [];
  List<Ground> fourthList = [];
  List<Ground> fifthList = [];
  List<Ground> sixList = [];
  List<Ground> sevenList = [];

  List<FutureProperty2> catidList = [];
  List<DocumentMainModel_F> imageList = [];
  Future<void> _refreshAllData() async {
    try {
      final ground = await fetchData_Ground();
      final first = await fetchData_first();
      final second = await fetchData_second();
      final third = await fetchData_third();
      final fourth = await fetchData_four();
      final fifth = await fetchData_five();
      final sixth = await fetchData_six();
      final seven = await fetchData_seven();
      final catids = await fetchData();
      final images = await fetchCarouselData();

      setState(() {
        groundList = ground;
        firstList = first;
        secondList = second;
        thirdList = third;
        fourthList = fourth;
        fifthList = fifth;
        sixList = sixth;
        sevenList = seven;
        catidList = catids;
        imageList = images;
      });
    } catch (e) {
      print('Refresh Error: $e');
      // Optionally show a toast or Snackbar
    }
  }
  String data = 'Initial Data';

  Future<void> _handleMenuItemClick(String value) async {
    // Handle the menu item click
    print("You clicked: $value");
    if (value == 'Edit Property') {
      final result = await fetchData(); // Only call once
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateRealEstateProperty(
            propertyId: int.parse(widget.idd),
          ),
        ),
      );
    }

    if (value.toString() == 'Add Property Images') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FuturePropertyFileUploadPage(
                idd: widget.idd, // No need to parse
              ),
        ),
      );
    }
    // if (value.toString() == 'Duplicate Property') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DuplicateProperty(
    //         propertyId: int.tryParse(widget.idd) ?? 0,
    //         // sId: int.tryParse() ?? 0,
    //       ),
    //     ),
    //   );
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
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
          PopupMenuButton<String>(
            onSelected: _handleMenuItemClick,
            itemBuilder: (BuildContext context) {
              return {'Edit Property','Add Property Images',/*'Duplicate Property'*/}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _refreshAllData,

        child: CustomScrollView(
          slivers: [


            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return FutureBuilder<List<DocumentMainModel_F>>(
                    future: fetchCarouselData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Data Found!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 500,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                viewportFraction: 0.9,
                                aspectRatio: 16 / 9,
                                initialPage: 0,
                              ),
                              items: snapshot.data!.map((item) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PropertyPreview(
                                              ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                            ),
                                          ),
                                        );

                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Image.asset(
                                              AppImages.loading,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget: (context, error, stackTrace) =>
                                                Image.asset(
                                                  AppImages.imageNotFound,
                                                  fit: BoxFit.cover,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
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

                  return FutureBuilder<List<FutureProperty2>>(
                      future: fetchData(),
                      builder: (context,abc){
                        if(abc.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }
                        else if(abc.hasError){
                          return Text('${abc.error}');
                        }
                        else if (abc.data == null || abc.data!.isEmpty) {
                          // If the list is empty, show an empty image
                          return Center(
                            child: Column(
                              children: [
                                // Lottie.asset("assets/images/no data.json",width: 450),
                                Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                              ],
                            ),
                          );
                        }
                        else{

                          return ListView.builder(
                              itemCount: 1,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context,int len){
                                return GestureDetector(
                                  onTap: () async {

                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20,),
                                      Card(
                                        color: Colors.grey.shade100,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.green),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.green.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),

                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].place/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),


                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.green),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.green.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),

                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                  ),
                                                  Text("Id : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 0.5
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Owner Name | Owner Number",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(width: 1, color: Colors.green),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.green.withOpacity(0.5),
                                                                blurRadius: 10,
                                                                offset: Offset(0, 0),
                                                                blurStyle: BlurStyle.outer
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            // Icon(Iconsax.sort_copy,size: 15,),
                                                            //w SizedBox(width: 10,),
                                                            Text(""+abc.data![len].ownerName/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: 0.5
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: (){

                                                          showDialog<bool>(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              title: Text("Contact "+abc.data![len].ownerNumber),
                                                              content: Text('Do you really want to Contact? '+abc.data![len].ownerNumber ),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                              actions: <Widget>[

                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        DateTime now = DateTime.now();
                                                                        /*formattedDate = "${now.day}-${now.month}-${now.year}";
                                                                        formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                                                        fetchdata_add_responce('Try to contact on Whatsapp', widget.id, 'Date: $formattedDate Time: $formattedTime');*/
                                                                        if(Platform.isAndroid){
                                                                          String url = 'whatsapp://send?phone="+91${abc.data![len].ownerNumber}"&text="Hello"';
                                                                          await launchUrl(Uri.parse(url));
                                                                        }else {
                                                                          String url = 'https://wa.me/${abc.data![len].ownerNumber}';
                                                                          await launchUrl(Uri.parse(url));
                                                                        }

                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.grey.shade800,
                                                                      ),
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(top: 15,bottom: 15),
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                          const BorderRadius.all(Radius.circular(10)),
                                                                          child: Container(
                                                                            height: 60,
                                                                            width: 60,
                                                                            child: CachedNetworkImage(
                                                                              imageUrl:
                                                                              AppImages.whatsaap,
                                                                              fit: BoxFit.cover,
                                                                              placeholder: (context, url) => Image.asset(
                                                                                AppImages.whatsaap,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              errorWidget: (context, error, stack) =>
                                                                                  Image.asset(
                                                                                    AppImages.whatsaap,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(

                                                                      onPressed: () async {

                                                                        /*DateTime now = DateTime.now();
                                                                        formattedDate = "${now.day}-${now.month}-${now.year}";
                                                                        formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                                                        fetchdata_add_responce('Try for Calling', widget.id, 'Date: $formattedDate Time: $formattedTime');*/

                                                                        /*if (await canLaunchUrl(Uri.parse('${abc.data![len].demand_number}'))) {
                                                                      await launchUrl(Uri.parse('${abc.data![len].demand_number}'));
                                                                    } else {
                                                                      throw 'Could not launch ${abc.data![len].demand_number}';
                                                                    }*/
                                                                        FlutterPhoneDirectCaller.callNumber('${abc.data![len].ownerNumber}');
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.grey.shade800,
                                                                      ),
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(top: 15,bottom: 15),
                                                                        child: ClipRRect(
                                                                          borderRadius:
                                                                          const BorderRadius.all(Radius.circular(10)),
                                                                          child: Container(
                                                                            height: 60,
                                                                            width: 60,
                                                                            child: CachedNetworkImage(
                                                                              imageUrl:
                                                                              AppImages.call,
                                                                              fit: BoxFit.cover,
                                                                              placeholder: (context, url) => Image.asset(
                                                                                AppImages.call,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              errorWidget: (context, error, stack) =>
                                                                                  Image.asset(
                                                                                    AppImages.call,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],),


                                                              ],
                                                            ),
                                                          ) ?? false;
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.green),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.green.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].ownerNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Caretaker Name | Caretaker Number",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.purple),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.purple.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].caretakerName/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  GestureDetector(
                                                    onTap: (){

                                                      showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text('Call Property Caretaker'),
                                                          content: Text('Do you really want to Call Caretaker?'),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                FlutterPhoneDirectCaller.callNumber('${abc.data![len].caretakerNumber}');
                                                              },
                                                              child: Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ?? false;
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(width: 1, color: Colors.purple),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.purple.withOpacity(0.5),
                                                              blurRadius: 10,
                                                              offset: Offset(0, 0),
                                                              blurStyle: BlurStyle.outer
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          // Icon(Iconsax.sort_copy,size: 15,),
                                                          //w SizedBox(width: 10,),
                                                          Text(""+abc.data![len].caretakerNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500,
                                                                letterSpacing: 0.5
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Property Address For Feild Workers",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(""+abc.data![len].propertyAddressForFieldworker,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Property Address",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(""+abc.data![len].propertyNameAddress,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Additional Information",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text("Total Floor : "+abc.data![len].totalFloor,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 4,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                                Column(
                                                children: [
                                //                   Container(
                                //                     padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                //                     decoration: BoxDecoration(
                                //                       borderRadius: BorderRadius.circular(5),
                                //                       border: Border.all(width: 1, color: Colors.blue),
                                //                       boxShadow: [
                                //                         BoxShadow(
                                //                             color: Colors.blue.withOpacity(0.5),
                                //                             blurRadius: 10,
                                //                             offset: Offset(0, 0),
                                //                             blurStyle: BlurStyle.outer
                                //                         ),
                                //                       ],
                                //                     ),
                                //                     child: Row(
                                //                       children: [
                                //                         // Icon(Iconsax.sort_copy,size: 15,),
                                //                         //SizedBox(width: 10,),
                                //                         Expanded(
                                //                           child: Text(""+abc.data![len].facility/*+abc.data![len].Building_Name.toUpperCase()*/,
                                //                             style: TextStyle(
                                //                                 fontSize: 13,
                                //                                 color: Colors.black,
                                //                                 fontWeight: FontWeight.w500,
                                //                                 letterSpacing: 0.5
                                //                             ),
                                //                             overflow: TextOverflow.ellipsis,
                                //                             maxLines: 2,
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //
                                //                   SizedBox(
                                //                     height: 10,
                                //                   ),
                                //
                                //                   Container(
                                //                   padding: const EdgeInsets.symmetric(horizontal: 10),
                                //                   decoration: BoxDecoration(
                                //                   borderRadius: BorderRadius.circular(5),
                                //                   border: Border.all(width: 1, color: Colors.blue),
                                //                   boxShadow: [
                                //                   BoxShadow(
                                //                   color: Colors.blue.withOpacity(0.5),
                                //                   blurRadius: 10,
                                //                   offset: const Offset(0, 0),
                                //                   blurStyle: BlurStyle.outer,
                                //                   ),
                                //                   ],
                                //                   ),
                                //                   child: Text(
                                //                   abc.data![len].propertyNameAddress,
                                // style: const TextStyle(
                                // fontSize: 13,
                                // color: Colors.black,
                                // fontWeight: FontWeight.w500,
                                // letterSpacing: 0.5,
                                // ),
                                // ),
                                // ),
                                //                   Container(
                                //                     padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                //                     decoration: BoxDecoration(
                                //                       borderRadius: BorderRadius.circular(5),
                                //                       border: Border.all(width: 1, color: Colors.blue),
                                //                       boxShadow: [
                                //                         BoxShadow(
                                //                             color: Colors.blue.withOpacity(0.5),
                                //                             blurRadius: 10,
                                //                             offset: Offset(0, 0),
                                //                             blurStyle: BlurStyle.outer
                                //                         ),
                                //                       ],
                                //                     ),
                                //                     child: Row(
                                //                       children: [
                                //                         // Icon(Iconsax.sort_copy,size: 15,),
                                //                         //SizedBox(width: 10,),
                                //                         Expanded(
                                //                           child: Text(""+abc.data![len].facility/*+abc.data![len].Building_Name.toUpperCase()*/,
                                //                             style: TextStyle(
                                //                                 fontSize: 13,
                                //                                 color: Colors.black,
                                //                                 fontWeight: FontWeight.w500,
                                //                                 letterSpacing: 0.5
                                //                             ),
                                //                             overflow: TextOverflow.ellipsis,
                                //                             maxLines: 2,
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //
                                //                   SizedBox(
                                //                     height: 10,
                                //                   ),
                                //
                                //                   Container(
                                //                   padding: const EdgeInsets.symmetric(horizontal: 10),
                                //                   decoration: BoxDecoration(
                                //                   borderRadius: BorderRadius.circular(5),
                                //                   border: Border.all(width: 1, color: Colors.blue),
                                //                   boxShadow: [
                                //                   BoxShadow(
                                //                   color: Colors.blue.withOpacity(0.5),
                                //                   blurRadius: 10,
                                //                   offset: const Offset(0, 0),
                                //                   blurStyle: BlurStyle.outer,
                                //                   ),
                                //                   ],
                                //                   ),
                                //                   child: Text(
                                //                   abc.data![len].propertyNameAddress,
                                // style: const TextStyle(
                                // fontSize: 13,
                                // color: Colors.black,
                                // fontWeight: FontWeight.w500,
                                // letterSpacing: 0.5,
                                // ),
                                // ),
                                // ),

                                                ],
                                              ),
                                              SizedBox(height: 6,),
                                              Text("Building Add Date : "+abc.data![len].currentDate/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Text("Road Size : "+abc.data![len].roadSize/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Text("Metro Name : "+abc.data![len].metroName/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Text("Metro Distance : "+abc.data![len].metroDistance/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Text("Main Market Distance: "+abc.data![len].mainMarketDistance/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Text("Age of Property: "+abc.data![len].ageOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                              SizedBox(height: 6,),
                                              Text("lift : "+abc.data![len].lift/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }


                      }

                  );
                },
                childCount: 1, // Number of categories
              ),
            ),

            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_Ground(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Ground Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );
print(abc.data![len].subid);
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(" "+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        )



                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),


                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),

            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_first(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'First Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid.toString()}',))
                                          );
                                          print("${abc.data![len].id.toString()}");
                                          print("${abc.data![len].id}");
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(

                                                 padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(" "+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        )



                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),


                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),

            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_second(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Second Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     print('Subid is: ${abc.data![0].subid}');
                                //   },
                                //   child: Text('Subid: ${abc.data![0].subid}'),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );
                                          print(abc.data![len].subid.toString());
                                          print(abc.data![len].id.toString());
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(" "+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        )



                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // ElevatedButton(
                                            //   style: ElevatedButton.styleFrom(
                                            //     backgroundColor: Colors.deepPurple, // button background color
                                            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            //     shape: RoundedRectangleBorder(
                                            //       borderRadius: BorderRadius.circular(12), // rounded corners
                                            //     ),
                                            //     elevation: 5,
                                            //     shadowColor: Colors.deepPurpleAccent,
                                            //   ),
                                            //   onPressed: () async {
                                            //     final int propertyId = abc.data![len].id;
                                            //
                                            //     final url = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/dublicate_data.php');
                                            //
                                            //     try {
                                            //       final response = await http.post(
                                            //         url,
                                            //         body: {'P_id': propertyId.toString()},
                                            //       );
                                            //
                                            //       if (response.statusCode == 200) {
                                            //         print('API response: ${response.body}');
                                            //         ScaffoldMessenger.of(context).showSnackBar(
                                            //           const SnackBar(content: Text('Duplicate request sent successfully!')),
                                            //         );
                                            //       } else {
                                            //         print('Failed to send data: ${response.statusCode}');
                                            //         ScaffoldMessenger.of(context).showSnackBar(
                                            //           const SnackBar(content: Text('Failed to send duplicate request')),
                                            //         );
                                            //       }
                                            //     } catch (e) {
                                            //       print('Error sending data: $e');
                                            //       ScaffoldMessenger.of(context).showSnackBar(
                                            //         const SnackBar(content: Text('Error occurred while sending request')),
                                            //       );
                                            //     }
                                            //   },
                                            //   child: const Text(
                                            //     'Duplicate',
                                            //     style: TextStyle(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.bold,
                                            //       color: Colors.white,
                                            //       letterSpacing: 1.2,
                                            //     ),
                                            //   ),
                                            // )


                                          ],
                                        ),
                                      ),


                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),

            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_third(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Third Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );

                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(" "+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        )



                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),


                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_four(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Forth Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );

                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(" "+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text("Floor Number"+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        )



                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),


                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),

            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_five(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Fifth Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          print("'${abc.data![len].id}'");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );

                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text("Flat Number"+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),


                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),
            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_six(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    ' Sixth Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          print("'${abc.data![len].id}'");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );

                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text("Flat Number"+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),
            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_seven(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Seventh  Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          print("'${abc.data![len].id}'");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                          );

                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              const BorderRadius.all(Radius.circular(10)),
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                child: CachedNetworkImage(
                                                                  imageUrl:
                                                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                  fit: BoxFit.cover,
                                                                  placeholder: (context, url) => Image.asset(
                                                                    AppImages.loading,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  errorWidget: (context, error, stack) =>
                                                                      Image.asset(
                                                                        AppImages.imageNotFound,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(width: 5,),

                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Property no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text("Flat Number"+abc.data![len].flatNumber,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Floor no",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  child: Text(""+abc.data![len].floor,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),



                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            Row(
                                                              children: [
                                                                Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                SizedBox(width: 2,),
                                                                Text("Date",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 110,
                                                                  child: Text(""+abc.data![len].availableDate,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 4,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),

                                                    SizedBox(height: 6,),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //SizedBox(width: 10,),
                                                              Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 6,
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              // Icon(Iconsax.sort_copy,size: 15,),
                                                              //w SizedBox(width: 10,),
                                                              Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),


                                                        Container(
                                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(width: 1, color: Colors.blue),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors.blue.withOpacity(0.5),
                                                                  blurRadius: 10,
                                                                  offset: Offset(0, 0),
                                                                  blurStyle: BlurStyle.outer
                                                              ),
                                                            ],
                                                          ),
                                                          child:
                                                              Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5
                                                                ),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
                childCount: 1, // Number of categories
              ),
            ),
          ],
        ),
      ),

        bottomNavigationBar: FutureBuilder<Map<String, dynamic>>(
          future: _fetchAllData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            else if (snapshot.data == null ||
                (snapshot.data!['catidList'] as List).isEmpty) {
              // If the list is empty, show empty message
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No Data Found!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              final catidList = snapshot.data!['catidList'] as List<FutureProperty2>;

              return ListView.builder(
                itemCount: 1, // only first element like before
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int len) {
                  print('apartment address: ${catidList[len].propertyNameAddress}');
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),

                    onPressed: () {
                      final data = catidList[len];
                      print('id: ${widget.idd}');
                      print('Owner_name: ${data.ownerName}');
                      print('Owner_num: ${data.ownerNumber}');
                      print('Caretaker_name: ${data.caretakerName}');
                      print('Caretaker_num: ${data.caretakerNumber}');
                      print('market_dis: ${data.mainMarketDistance}');
                      print('metro_name: ${data.metroName}');
                      print('metro_dis: ${data.metroDistance}');
                      print('road_size: ${data.roadSize}');
                      print('age_property: ${data.ageOfProperty}');
                      print('apartment_address: ${data.propertyNameAddress}');
                      print('apartment_name: ${data.propertyNameAddress}');
                      print('field_address: ${data.propertyAddressForFieldworker}');
                      print('current_loc: ${data.currentDate}');
                      print('place: ${data.place}');
                      print('lift: ${data.lift}');
                      print('totalFloor: ${data.totalFloor}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Add_Flatunder_futureproperty(
                            id: widget.idd,
                            Owner_name: data.ownerName,
                            Owner_num: data.ownerNumber,
                            Caretaker_name: data.caretakerName,
                            Caretaker_num: data.caretakerNumber,
                            market_dis: data.mainMarketDistance,
                            metro_name: data.metroName,
                            metro_dis: data.metroDistance,
                            road_size: data.roadSize,
                            age_property: data.ageOfProperty,
                            apartment_address: data.propertyNameAddress,
                            apartment_name: data.propertyNameAddress,
                            field_address: data.propertyAddressForFieldworker,
                            current_loc: data.currentDate,
                            place: data.place,
                            lift: data.lift,
                            totalFloor: data.totalFloor,
                            Residence_commercial: data.residenceCommercial,
                            facility: data.facility,
                            google_loc: data.currentLocation,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Add Flats',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                },
              );
            }
          },
        )
      );
  }
}
