import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Plot_detail.dart';

class PlotListPage extends StatelessWidget {
  const PlotListPage({super.key, this.fieldworkerNumber = '11'});

  final String fieldworkerNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PlotProperty>>(
        future: PlotPropertyApi.fetchForFieldworker(fieldworkerNumber),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No Data Found'));
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final p = items[index];
              final img = p.imageUrl();

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return PlotPropertyDisplayPage();
                  }));
                  // Handle item tap if needed
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: img == null
                            ? const Icon(Icons.landscape,
                            color: Colors.grey, size: 50)
                            : CachedNetworkImage(
                          imageUrl: img,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.red),
                        ),
                      ),
                    ),
                    title: Text(
                      p.plotStatus ?? 'No Status',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        [
                          if (p.plotSize?.isNotEmpty == true)
                            'Plot Size: ${p.plotSize}',
                          if (p.plotPrice?.isNotEmpty == true)
                            'Price: ${p.plotPrice}',
                          if (p.roadSize?.isNotEmpty == true)
                            'Road: ${p.roadSize}',
                          if (p.fieldAddress?.isNotEmpty == true)
                            'Address: ${p.fieldAddress}',
                        ].join('\n'),
                        style: const TextStyle(color: Colors.black54, height: 1.3),
                      ),
                    ),
                    trailing: Text(
                      '#${p.id ?? ''}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
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

// 🧱 MODEL + API BELOW

class PlotProperty {
  final int? id;
  final String? plotSize;
  final String? plotFrontSize;
  final String? plotSideSize;
  final String? roadSize;
  final String? plotOpen;
  final String? ageOfProperty;
  final String? waterConnection;
  final String? electricPrice;
  final String? plotPrice;
  final String? plotStatus;
  final String? singleImage;
  final String? propertyChain;
  final String? fieldAddress;
  final String? mainAddress;
  final String? currentLocation;
  final String? longitude;
  final String? latitude;
  final String? fieldworkerName;
  final String? fieldworkerNumber;
  final String? propertyRent;

  PlotProperty({
    this.id,
    this.plotSize,
    this.plotFrontSize,
    this.plotSideSize,
    this.roadSize,
    this.plotOpen,
    this.ageOfProperty,
    this.waterConnection,
    this.electricPrice,
    this.plotPrice,
    this.plotStatus,
    this.singleImage,
    this.propertyChain,
    this.fieldAddress,
    this.mainAddress,
    this.currentLocation,
    this.longitude,
    this.latitude,
    this.fieldworkerName,
    this.fieldworkerNumber,
    this.propertyRent,
  });

  factory PlotProperty.fromJson(Map<String, dynamic> json) => PlotProperty(
    id: _toInt(json['id']),
    plotSize: json['plot_size'] as String?,
    plotFrontSize: json['plot_front_size'] as String?,
    plotSideSize: json['plot_side_size'] as String?,
    roadSize: json['road_size'] as String?,
    plotOpen: json['plot_open'] as String?,
    ageOfProperty: json['age_of_property'] as String?,
    waterConnection: json['water_connection'] as String?,
    electricPrice: json['electric_price'] as String?,
    plotPrice: json['plot_price'] as String?,
    plotStatus: json['plot_status'] as String?,
    singleImage: json['single_image'] as String?,
    propertyChain: json['property_chain'] as String?,
    fieldAddress: json['field_address'] as String?,
    mainAddress: json['main_address'] as String?,
    currentLocation: json['current_location'] as String?,
    longitude: json['longitude'] as String?,
    latitude: json['latitude'] as String?,
    fieldworkerName: json['fieldworkar_name'] as String?,
    fieldworkerNumber: json['fieldworkar_number'] as String?,
    propertyRent: json['property_rent'] as String?,
  );

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  /// Auto-builds full URL if needed
  String? imageUrl({String? baseUrl}) {
    if (singleImage == null || singleImage!.isEmpty) return null;
    if (singleImage!.startsWith('http')) return singleImage;
    final base =
        baseUrl ?? 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/';
    return Uri.parse(base).resolve(singleImage!).toString();
  }
}

class PlotPropertyApi {
  static Uri endpointForFieldworker(String fieldworkerNumber) {
    final base =
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/plot_form_show_api_for_feildworkar.php';
    return Uri.parse(base)
        .replace(queryParameters: {'fieldworkar_number': fieldworkerNumber});
  }

  static Future<List<PlotProperty>> fetchForFieldworker(String fieldworkerNumber,
      {Duration timeout = const Duration(seconds: 15)}) async {
    final uri = endpointForFieldworker(fieldworkerNumber);
    final response = await http
        .get(uri, headers: {HttpHeaders.acceptHeader: 'application/json'})
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw HttpException('HTTP ${response.statusCode}', uri: uri);
    }

    final body = response.body;
    final decoded = json.decode(body);

    if (decoded is Map && decoded.containsKey('data')) {
      final List list = decoded['data'];
      return list
          .map((e) => PlotProperty.fromJson(e as Map<String, dynamic>))
          .toList()
          .reversed
          .toList();

    } else {
      return [];
    }
  }
}
