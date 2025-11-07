import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';


class CommercialListPage extends StatelessWidget {
  const CommercialListPage({super.key, this.fieldWorkerNumber = '11'});

  final String fieldWorkerNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<CommercialProperty>>(
        future: CommercialApi.fetch(fieldWorkerNumber),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final data = snap.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No commercial properties found.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final property = data[index];
              final img = property.imageUrl();

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 90,
                          height: 90,
                          child: img == null
                              ? const Icon(Icons.storefront,
                              size: 50, color: Colors.grey)
                              : CachedNetworkImage(
                            imageUrl: img,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                            errorWidget: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.listingType ?? 'No Listing Type',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              property.location ?? 'No Location',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.apartment,
                                    size: 16, color: Colors.indigo),
                                const SizedBox(width: 4),
                                Text(
                                  property.propertyType ?? 'N/A',
                                  style:
                                  const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.square_foot,
                                    size: 16, color: Colors.indigo),
                                const SizedBox(width: 4),
                                Text(
                                  'Area: ${property.buildUpArea ?? 'N/A'}',
                                  style:
                                  const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.layers,
                                    size: 16, color: Colors.indigo),
                                const SizedBox(width: 4),
                                Text(
                                  'Floors: ${property.totalFloor ?? 'N/A'}',
                                  style:
                                  const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}

/// ----------------- MODEL + API -----------------

class CommercialProperty {
  final int? id;
  final String? image;
  final String? listingType;
  final String? location;
  final String? currentLocation;
  final String? propertyType;
  final String? availableDate;
  final String? buildUpArea;
  final String? carpetArea;
  final String? dimensions;
  final String? height;
  final String? width;
  final String? totalFloor;
  final String? parkingFacility;
  final String? amenities;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? longitude;
  final String? latitude;

  CommercialProperty({
    this.id,
    this.image,
    this.listingType,
    this.location,
    this.currentLocation,
    this.propertyType,
    this.availableDate,
    this.buildUpArea,
    this.carpetArea,
    this.dimensions,
    this.height,
    this.width,
    this.totalFloor,
    this.parkingFacility,
    this.amenities,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.longitude,
    this.latitude,
  });

  factory CommercialProperty.fromJson(Map<String, dynamic> json) {
    return CommercialProperty(
      id: _toInt(json['id']),
      image: json['image_'] as String?,
      listingType: json['listing_type'] as String?,
      location: json['location_'] as String?,
      currentLocation: json['current_location'] as String?,
      propertyType: json['property_type'] as String?,
      availableDate: json['avaible_date'] as String?,
      buildUpArea: json['build_up_area'] as String?,
      carpetArea: json['carpet_area'] as String?,
      dimensions: json['dimmensions_'] as String?,
      height: json['height_'] as String?,
      width: json['width_'] as String?,
      totalFloor: json['total_floor'] as String?,
      parkingFacility: json['parking_faciltiy'] as String?,
      amenities: json['amenites_'] as String?,
      fieldWorkerName: json['field_workar_name'] as String?,
      fieldWorkerNumber: json['field_workar_number'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
    );
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  String? imageUrl({String? baseUrl}) {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) return image;
    final base =
        baseUrl ?? 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/';
    return Uri.parse(base).resolve(image!).toString();
  }
}

class CommercialApi {
  static Uri endpoint(String fieldWorkerNumber) {
    final base =
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_api_commercial_property.php';
    return Uri.parse(base)
        .replace(queryParameters: {'field_workar_number': fieldWorkerNumber});
  }

  static Future<List<CommercialProperty>> fetch(String fieldWorkerNumber,
      {Duration timeout = const Duration(seconds: 15)}) async {
    final uri = endpoint(fieldWorkerNumber);
    final resp = await http
        .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
        .timeout(timeout);

    if (resp.statusCode != 200) {
      throw HttpException(
          'HTTP ${resp.statusCode}: ${resp.reasonPhrase ?? 'Unknown'}',
          uri: uri);
    }

    final decoded = json.decode(resp.body);

    if (decoded is Map && decoded.containsKey('data')) {
      final list = decoded['data'] as List;
      return list
          .map((e) => CommercialProperty.fromJson(e as Map<String, dynamic>))
          .toList()
          .reversed
          .toList(); // ✅ reversed list (latest first)
    } else {
      return [];
    }
  }
}
