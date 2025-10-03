import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
class PropertyDetail {
  final String id;
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
  final String squareFit;
  final String maintenance;
  final String parking;
  final String ageOfProperty;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String liveUnlive;

  PropertyDetail({
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
    required this.squareFit,
    required this.maintenance,
    required this.parking,
    required this.ageOfProperty,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.liveUnlive,
  });

  factory PropertyDetail.fromJson(Map<String, dynamic> json) {
    return PropertyDetail(
      id: json["P_id"].toString(),
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
      squareFit: json["squarefit"] ?? "",
      maintenance: json["maintance"] ?? "",
      parking: json["parking"] ?? "",
      ageOfProperty: json["age_of_property"] ?? "",
      kitchen: json["kitchen"] ?? "",
      bathroom: json["bathroom"] ?? "",
      lift: json["lift"] ?? "",
      facility: json["Facility"] ?? "",
      furnishedUnfurnished: json["furnished_unfurnished"] ?? "",
      liveUnlive: json["live_unlive"] ?? "",
    );
  }
}


class PropertyDetailPage extends StatefulWidget {
  final String propertyId;

  const PropertyDetailPage({super.key, required this.propertyId});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  late Future<PropertyDetail> propertyDetail;

  @override
  void initState() {
    super.initState();
    propertyDetail = fetchPropertyDetail(widget.propertyId);
  }
  Future<PropertyDetail> fetchPropertyDetail(String pId) async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/details_page_for_book_flat.php?P_id=$pId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded["status"] == "success" && decoded["data"] != null) {
        return PropertyDetail.fromJson(decoded["data"][0]);
      }
    }
    throw Exception("Failed to load property detail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Detail"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<PropertyDetail>(
        future: propertyDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No property data found"));
          }
          final property = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
                const SizedBox(height: 16),

                // Basic Info
                Text(
                  "${property.bhk} | ${property.typeOfProperty} | ${property.buyRent}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  property.locations,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Price Info
                Row(
                  children: [
                    _infoChip("Price", property.showPrice, Colors.red),
                    const SizedBox(width: 8),
                    _infoChip("Floor", property.floor, Colors.blue),
                    const SizedBox(width: 8),
                    _infoChip("BHK", property.bhk, Colors.green),
                  ],
                ),
                const SizedBox(height: 12),

                // Apartment Info
                _sectionTitle("Apartment Details"),
                Text(property.apartmentName),
                const SizedBox(height: 8),
                Text("Address: ${property.apartmentAddress}"),
                const SizedBox(height: 12),

                // Additional Info
                _sectionTitle("Facilities"),
                Text(property.facility),
                const SizedBox(height: 8),
                _sectionTitle("Kitchen & Bathroom"),
                Text("Kitchen: ${property.kitchen}"),
                Text("Bathroom: ${property.bathroom}"),
                const SizedBox(height: 8),

                _sectionTitle("Other Details"),
                Text("Lift: ${property.lift}"),
                Text("Parking: ${property.parking}"),
                Text("Square Fit: ${property.squareFit}"),
                Text("Maintenance: ${property.maintenance}"),
                Text("Furnished: ${property.furnishedUnfurnished}"),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color)),
      child: Text(
        "$title: $value",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
