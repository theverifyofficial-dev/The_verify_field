import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant.dart';
import 'FieldWorker_Booking_Page_Details.dart';
class Property {
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
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String caretakerName;
  final String caretakerNumber;
  final dynamic subid;

  Property({
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
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.subid,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json["P_id"] ?? 0,
      propertyPhoto: json["property_photo"] ?? "",
      locations: json["locations"] ?? "",
      flatNumber: json["Flat_number"] ?? "",
      buyRent: json["Buy_Rent"] ?? "",
      residenceCommercial: json["Residence_Commercial"] ?? "",
      apartmentName: json["Apartment_name"] ?? "",
      apartmentAddress: json["Apartment_Address"] ?? "",
      typeOfProperty: json["Typeofproperty"] ?? "",
      bhk: json["Bhk"] ?? "",
      showPrice: json["show_Price"] ?? "",
      lastPrice: json["Last_Price"] ?? "",
      askingPrice: json["asking_price"] ?? "",
      floor: json["Floor_"] ?? "",
      totalFloor: json["Total_floor"] ?? "",
      balcony: json["Balcony"] ?? "",
      squarefit: json["squarefit"] ?? "",
      maintance: json["maintance"] ?? "",
      parking: json["parking"] ?? "",
      ageOfProperty: json["age_of_property"] ?? "",
      fieldworkarAddress: json["fieldworkar_address"] ?? "",
      roadSize: json["Road_Size"] ?? "",
      metroDistance: json["metro_distance"] ?? "",
      highwayDistance: json["highway_distance"] ?? "",
      mainMarketDistance: json["main_market_distance"] ?? "",
      meter: json["meter"] ?? "",
      ownerName: json["owner_name"] ?? "",
      ownerNumber: json["owner_number"] ?? "",
      currentDates: json["current_dates"] ?? "",
      availableDate: json["available_date"] ?? "",
      kitchen: json["kitchen"] ?? "",
      bathroom: json["bathroom"] ?? "",
      lift: json["lift"] ?? "",
      facility: json["Facility"] ?? "",
      furnishedUnfurnished: json["furnished_unfurnished"] ?? "",
      fieldWorkerName: json["field_warkar_name"] ?? "",
      liveUnlive: json["live_unlive"] ?? "",
      fieldWorkerNumber: json["field_workar_number"] ?? "",
      registryAndGpa: json["registry_and_gpa"] ?? "",
      loan: json["loan"] ?? "",
      longitude: json["Longitude"] ?? "",
      latitude: json["Latitude"] ?? "",
      videoLink: json["video_link"] ?? "",
      caretakerName: json["care_taker_name"] ?? "",
      caretakerNumber: json["care_taker_number"] ?? "",
      subid: json["subid"],
    );
  }
}


class FieldWorkerBookingPage extends StatefulWidget {
  const FieldWorkerBookingPage({super.key});

  @override
  State<FieldWorkerBookingPage> createState() => _FieldWorkerBookingPageState();
}

class _FieldWorkerBookingPageState extends State<FieldWorkerBookingPage> {
  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_book_flat_by_fieldworkar.php?field_workar_number=11");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded["success"] == true) {
        List data = decoded["data"];
        return data
            .map((e) => Property.fromJson(e))
            .toList()
            .reversed
            .toList();
      }
    }
    throw Exception("Failed to load data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Property>>(
          future: fetchBookingData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No booking data available"));
            }

            final bookingList = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return PropertyDetailPage(propertyId: item.id.toString(),);
                    }));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// --- Top Row (BHK + Price)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTag(item.bhk, Colors.blue),
                            _buildTag("₹ ${item.showPrice}", Colors.red),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// --- Property Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(AppImages.loading, fit: BoxFit.cover),
                              errorWidget: (context, error, stack) =>
                                  Image.asset(AppImages.imageNotFound, fit: BoxFit.cover),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// --- Tags Row (Type, Location, Buy/Rent)
                        Row(
                          children: [
                            _buildTag(item.typeOfProperty, Colors.green),
                            const SizedBox(width: 8),
                            _buildTag(item.locations, Colors.cyan),
                            const SizedBox(width: 8),
                            _buildTag(item.buyRent, Colors.deepPurple),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// --- Date & ID Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(item.currentDates),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "ID: ${item.id}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),


    );
  }
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: color),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
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
          letterSpacing: 0.5,
        ),
      ),
    );
  }
  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "-";
    try {
      final dt = DateFormat('yyyy-MM-dd').parse(rawDate);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      try {
        final dt2 = DateTime.parse(rawDate);
        return DateFormat('dd MMM yyyy').format(dt2);
      } catch (_) {
        return rawDate;
      }
    }
  }
}
