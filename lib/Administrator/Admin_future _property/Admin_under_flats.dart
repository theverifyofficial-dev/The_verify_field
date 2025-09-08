import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../ui_decoration_tools/constant.dart';
import '../../../model/realestateSlider.dart';
import '../../property_preview.dart';


class Property {
  final int pId;
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
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWarkarName;
  final String liveUnlive;
  final String fieldWorkarNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;

  Property({
    required this.pId,
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
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWarkarName,
    required this.liveUnlive,
    required this.fieldWorkarNumber,
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

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      pId: json['P_id'],
      propertyPhoto: json['property_photo'],
      locations: json['locations'],
      flatNumber: json['Flat_number'],
      buyRent: json['Buy_Rent'],
      residenceCommercial: json['Residence_Commercial'],
      apartmentName: json['Apartment_name'],
      apartmentAddress: json['Apartment_Address'],
      typeofProperty: json['Typeofproperty'],
      bhk: json['Bhk'],
      showPrice: json['show_Price'],
      lastPrice: json['Last_Price'],
      askingPrice: json['asking_price'],
      floor: json['Floor_'],
      totalFloor: json['Total_floor'],
      balcony: json['Balcony'],
      squarefit: json['squarefit'],
      maintance: json['maintance'],
      parking: json['parking'],
      ageOfProperty: json['age_of_property'].toString(), // Clean this if needed
      fieldworkarAddress: json['fieldworkar_address'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      highwayDistance: json['highway_distance'],
      mainMarketDistance: json['main_market_distance'],
      meter: json['meter'],
      ownerName: json['owner_name'],
      ownerNumber: json['owner_number'],
      currentDates: json['current_dates'],
      availableDate: json['available_date'],
      kitchen: json['kitchen'],
      bathroom: json['bathroom'],
      lift: json['lift'],
      facility: json['Facility'],
      furnishedUnfurnished: json['furnished_unfurnished'],
      fieldWarkarName: json['field_warkar_name'],
      liveUnlive: json['live_unlive'],
      fieldWorkarNumber: json['field_workar_number'],
      registryAndGpa: json['registry_and_gpa'],
      loan: json['loan'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      videoLink: json['video_link'],
      fieldWorkerCurrentLocation: json['field_worker_current_location'],
      careTakerName: json['care_taker_name'],
      careTakerNumber: json['care_taker_number'],
      subid: json['subid'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'P_id': pId,
      'property_photo': propertyPhoto,
      'locations': locations,
      'Flat_number': flatNumber,
      'Buy_Rent': buyRent,
      'Residence_Commercial': residenceCommercial,
      'Apartment_name': apartmentName,
      'Apartment_Address': apartmentAddress,
      'Typeofproperty': typeofProperty,
      'Bhk': bhk,
      'show_Price': showPrice,
      'Last_Price': lastPrice,
      'asking_price': askingPrice,
      'Floor_': floor,
      'Total_floor': totalFloor,
      'Balcony': balcony,
      'squarefit': squarefit,
      'maintance': maintance,
      'parking': parking,
      'age_of_property': ageOfProperty,
      'fieldworkar_address': fieldworkarAddress,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'highway_distance': highwayDistance,
      'main_market_distance': mainMarketDistance,
      'meter': meter,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'current_dates': currentDates,
      'available_date': availableDate,
      'kitchen': kitchen,
      'bathroom': bathroom,
      'lift': lift,
      'Facility': facility,
      'furnished_unfurnished': furnishedUnfurnished,
      'field_warkar_name': fieldWarkarName,
      'live_unlive': liveUnlive,
      'field_workar_number': fieldWorkarNumber,
      'registry_and_gpa': registryAndGpa,
      'loan': loan,
      'Longitude': longitude,
      'Latitude': latitude,
      'video_link': videoLink,
      'field_worker_current_location': fieldWorkerCurrentLocation,
      'care_taker_name': careTakerName,
      'care_taker_number': careTakerNumber,
      'subid': subid,
    };
  }
}


class Catid111 {
  final int id;
  final String images;
  final String ownername;
  final String ownernumber;
  final String caretakername;
  final String caretakernumber;
  final String place;
  final String buy_rent;
  final String typeofproperty;
  final String bhk;
  final String floor_no;
  final String flat_no;
  final String square_feet;
  final String propertyname_adress;
  final String building_information_facilitys;
  final String property_adress_for_fieldworkar;
  final String owner_vehical_number;
  final String your_address;
  final String fieldworkar_name;
  final String fieldworkar_number;
  final String current_dates;

  Catid111(
      {required this.id,required this.images,required this.ownername,required this.ownernumber,required this.caretakername,required this.caretakernumber
        ,required this.place,required this.buy_rent,required this.typeofproperty,required this.bhk,required this.floor_no
        ,required this.flat_no,required this.square_feet,required this.propertyname_adress,required this.building_information_facilitys,required this.property_adress_for_fieldworkar
        ,required this.owner_vehical_number,required this.your_address,required this.fieldworkar_name,required this.fieldworkar_number,required this.current_dates});

  factory Catid111.FromJson(Map<String, dynamic>json){
    return Catid111(id: json['id'],
        images: json['images'], ownername: json['ownername'],
        ownernumber: json['ownernumber'], caretakername: json['caretakername'],
        caretakernumber: json['caretakernumber'],
        place: json['place'], buy_rent: json['buy_rent'],
        typeofproperty: json['typeofproperty'], bhk: json['bhk'],
        floor_no: json['floor_no'],
        flat_no: json['flat_no'], square_feet: json['square_feet'],
        propertyname_adress: json['propertyname_adress'], building_information_facilitys: json['building_information_facilitys'],
        property_adress_for_fieldworkar: json['property_adress_for_fieldworkar'],
        owner_vehical_number: json['owner_vehical_number'], your_address: json['your_address'],
        fieldworkar_name: json['fieldworkar_name'], fieldworkar_number: json['fieldworkar_number'],
        current_dates: json['current_dates']);
  }
}

class Catid1 {
  final int id;
  final String tenant_name;
  final String tenant_phone_number;
  final String flat_rent;
  final String shifting_date;
  final String members;
  final String email;
  final String tenant_vichal_details;
  final String work_profile;
  final String bhk;
  final String type_of_property;
  final int sub_id;

  Catid1(
      {required this.id,required this.tenant_name,required this.tenant_phone_number,required this.flat_rent,required this.shifting_date,required this.members
        ,required this.email,required this.tenant_vichal_details,required this.work_profile,required this.bhk,required this.type_of_property
        ,required this.sub_id});

  factory Catid1.FromJson(Map<String, dynamic>json){
    return Catid1(
        id: json['id'],
        tenant_name: json['tenant_name'], tenant_phone_number: json['tenant_phone_number'],
        flat_rent: json['flat_rent'], shifting_date: json['shifting_date'],
        members: json['members'],
        email: json['email'], tenant_vichal_details: json['tenant_vichal_details'],
        work_profile: json['work_profile'], bhk: json['bhk'],
        type_of_property: json['type_of_property'],
        sub_id: json['sub_id']);
  }
}

class Admin_underflat_futureproperty extends StatefulWidget {
  String id;
  String Subid;
  Admin_underflat_futureproperty({super.key, required this.id,required this.Subid});

  @override
  State<Admin_underflat_futureproperty> createState() => Admin_underflat_futurepropertyState();
}

class Admin_underflat_futurepropertyState extends State<Admin_underflat_futureproperty> {

  Future<List<RealEstateSlider1>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_multiple_images?subid=${widget.id}'));
    print(" Multi Image ID: ${widget.id}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return RealEstateSlider1(
          rimg: item['images'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
  Property?property;
  Future<List<Property>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_details_page?id=${widget.id}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Property.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }


  Future<List<Catid1>> fetchData1() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_tenant_in_future_property?sub_id=${widget.id}");
    final Response = await http.get(url);
    print("Tenant : ${Response.body}");
    if (Response.statusCode == 200) {
      List listresponce = json.decode(Response.body);
      return listresponce.map(( data) => Catid1.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }



  Future<void> _loadAllData() async {
    setState(() {
      _sliderFuture = fetchCarouselData();
      _propertyFuture = fetchData();
      _catidFuture = fetchData1();
    });
  }

  Future<void> _refreshData() async {
    await _loadAllData();
  }
  String liveUnliveStatus = 'Flat'; // default value, can be 'Flat' or 'book'

  @override
  void initState() {
    super.initState();

    _loadAllData();
  }


  late Future<List<RealEstateSlider1>> _sliderFuture;
  late Future<List<Property>> _propertyFuture;
  late Future<List<Catid1>> _catidFuture;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
      ),

      body: RefreshIndicator(
        onRefresh: _refreshData,

        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                FutureBuilder<List<Property>>(
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
                              SizedBox(height: 30,),
                              // Lottie.asset("assets/images/no data.json",width: 450),
                              Text("No Flat Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
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
                              int displayIndex = abc.data!.length - len;
                              return GestureDetector(
                                onTap: () async {

                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            FutureBuilder<List<RealEstateSlider1>>(
                                              future: fetchCarouselData(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting)
                                                  return Center(child: CircularProgressIndicator());

                                                if (snapshot.hasError)
                                                  return Center(child: Text("Error: ${snapshot.error}"));

                                                final images = snapshot.data!;
                                                return CarouselSlider(
                                                  options: CarouselOptions(
                                                    height: 350,
                                                    autoPlay: true,
                                                    enlargeCenterPage: false,
                                                    autoPlayInterval: const Duration(seconds: 2),
                                                  ),
                                                  items: images.map((item) {
                                                    // print('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}');
                                                    return Builder(
                                                      builder: (BuildContext context) {
                                                        return GestureDetector(
                                                          onTap: (){
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (_) => PropertyPreview(
                                                                  ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Image.network("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}", fit: BoxFit.cover),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                                 SizedBox(height: 10,),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      const BorderRadius.all(Radius.circular(10)),
                                                      child: Container(
                                                        height: 190,
                                                        width: 320,
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
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [

                                                  Row(
                                                    children: [
                                                      SizedBox(width: 10,),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(width: 1, color: Colors.red),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.red.withOpacity(0.5),
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
                                                            Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            Text(""+abc.data![len].typeofProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(width: 1, color: Colors.red),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.red.withOpacity(0.5),
                                                                blurRadius: 10,
                                                                offset: Offset(0, 0),
                                                                blurStyle: BlurStyle.outer
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(""+abc.data![len].floor/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Show Price | Asking Price | Last Price",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 180,
                                                        child: Text(""+abc.data![len].showPrice+"  |  "+abc.data![len].lastPrice+"  |  "+abc.data![len].askingPrice,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 14,

                                                              color: Colors.green,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Sqft | Balcony & Parking",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 180,
                                                        child: Text(""+abc.data![len].squarefit+"  |  "+abc.data![len].balcony+"  |  "+abc.data![len].parking+" Parking" ,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Flat Information & facility",
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 180,
                                                        child: Text(""+abc.data![len].facility,
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
                                                    height: 20,
                                                  ),
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
                                                        width: 10,
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
                                            SizedBox(
                                              height: 10,
                                            ),

                                            Center(
                                              child: Text("Property owner",style: TextStyle(fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),),
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              children: [
                                                Container(
                                                  width: 150,
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
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].ownerName,
                                                        maxLines: 2,/*+abc.data![len].Building_Name.toUpperCase()*/
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 20,
                                                ),

                                                GestureDetector(
                                                  onTap: (){

                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Call Property Owner'),
                                                        content: Text('Do you really want to Call Owner?'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('No'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              FlutterPhoneDirectCaller.callNumber('${abc.data![len].ownerNumber}');
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ?? false;
                                                  },
                                                  child: Container(
                                                    width: 150,
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
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].ownerNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 12,
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
                                              height: 10,
                                            ),

                                            Center(
                                              child: Text("CareTaker Info",style: TextStyle(fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),),
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              children: [
                                                Container(
                                                  width: 150,
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
                                                  child:
                                                      Text(""+abc.data![len].careTakerName/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                ),

                                                SizedBox(
                                                  width: 20,
                                                ),

                                                GestureDetector(
                                                  onTap: (){
                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Call Property CareTaker'),
                                                        content: Text('Do you really want to Call CareTaker?'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('No'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              FlutterPhoneDirectCaller.callNumber('${abc.data![len].careTakerNumber}');
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ?? false;
                                                  },
                                                  child: Container(
                                                    width: 150,
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
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].careTakerNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 14,
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
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(PhosphorIcons.push_pin,size: 13,color: Colors.red,),
                                                SizedBox(width: 5,),
                                                Text("Property Name & Address",
                                                  style: TextStyle(
                                                      fontSize: 16,
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
                                                  child: Text(""+abc.data![len].apartmentAddress,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Property Floor | Flat Number",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                                  width: 180,
                                                  child: Text(""+abc.data![len].floor+"  |  "+abc.data![len].flatNumber,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Flat facilities",
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                                  child: Text(""+abc.data![len].facility,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Furnished | Furnished Items",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 16,
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
                                                  child: Text(""+abc.data![len].furnishedUnfurnished+"  |  "+abc.data![len].apartmentName,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Kitchen | Bathroom",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                                  child: Text(""+abc.data![len].kitchen+" Kitchen  |  "+abc.data![len].bathroom+" Bathroom",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Feild Worker Address",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                                  child: Text(""+abc.data![len].fieldworkarAddress,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            SizedBox(height: 20,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.red),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.red.withOpacity(0.5),
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
                                                      Text("Property Id = "+abc.data![len].pId.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Center(
                                              child: Text("Feild Worker",style: TextStyle(fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),),
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.yellow),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.yellow.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].fieldWarkarName/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 20,
                                                ),

                                                Container(
                                                  width: 150,
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.yellow),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.yellow.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].fieldWorkarNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Residence Commercial : "+abc.data![len].residenceCommercial,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Maintance : "+abc.data![len].maintance,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ), SizedBox(height: 10,),
                                            Text("Road Size : "+abc.data![len].roadSize,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ), SizedBox(height: 10,),
                                            Text("Age Of Property : "+abc.data![len].ageOfProperty,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ), SizedBox(height: 10,),
                                            Text("Metro Name : "+abc.data![len].highwayDistance,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ), SizedBox(height: 10,),
                                            Text("Metro Distance : "+abc.data![len].metroDistance,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Main Market Distance : "+abc.data![len].mainMarketDistance,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Meter : "+abc.data![len].meter,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Lift : "+abc.data![len].lift,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Registry And Gpa : "+abc.data![len].registryAndGpa??"",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Loan : "+abc.data![len].loan??"",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 10,),
                                            Text("Flat Available Date : "+abc.data![len].availableDate,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Property Added Date",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                                  child: Text(""+abc.data![len].currentDates,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    }
                ),

                FutureBuilder<List<Catid1>>(
                    future: fetchData1(),
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
                              SizedBox(height: 30,),
                              Text("No Tenant Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
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
                                onTap: () async {},
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [


                                            SizedBox(
                                              height: 10,
                                            ),

                                            Center(
                                              child: Text("Property Tenant",style: TextStyle(fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),),
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.lightBlue),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.lightBlue.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].tenant_name,
                                                        maxLines: 2,/*+abc.data![len].Building_Name.toUpperCase()*/
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 20,
                                                ),

                                                GestureDetector(
                                                  onTap: (){

                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Call Property Owner'),
                                                        content: Text('Do you really want to Call Owner?'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('No'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              //FlutterPhoneDirectCaller.callNumber('${abc.data![len].Owner_number}');
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ?? false;
                                                  },
                                                  child: Container(
                                                    width: 150,
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.lightBlue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.lightBlue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].tenant_phone_number/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 12,
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
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(PhosphorIcons.push_pin,size: 13,color: Colors.red,),
                                                SizedBox(width: 5,),
                                                Text("Tenant Work profile",
                                                  style: TextStyle(
                                                      fontSize: 16,
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
                                                  child: Text(""+abc.data![len].work_profile,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.yellow),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.yellow.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].shifting_date/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 20,
                                                ),

                                                Container(
                                                  width: 150,
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.yellow),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.yellow.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].members+" Members"/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Sub id",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 14,
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
                                                  width: 120,
                                                  child: Text(""+abc.data![len].sub_id.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
