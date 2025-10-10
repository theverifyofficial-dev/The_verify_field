import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Propert_verigication_Document/Show_tenant.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_New_Property.dart';
import 'Add_RealEstate.dart';
import 'Add_image_under_property.dart';
import 'Commercial_property_Filter.dart';
import 'Filter_Options.dart';
import 'View_All_Details.dart';

class RealEstateShowDateModel {
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

  RealEstateShowDateModel(
      {required this.id, required this.Building_Name, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Date});

  factory RealEstateShowDateModel.FromJson(Map<String, dynamic>json){
    return RealEstateShowDateModel(id: json['PVR_id'],
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

class Show_Real_Estate extends StatefulWidget {
  const Show_Real_Estate({super.key});

  @override
  State<Show_Real_Estate> createState() => _Show_Real_EstateState();
}

class _Show_Real_EstateState extends State<Show_Real_Estate> {

  String _number = '';
  String _SUbid = '';
  int propertyCount = 0;

  List<RealEstateShowDateModel> _allProperties = [];
  List<RealEstateShowDateModel> _filteredProperties = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final filtered = _allProperties.where((item) {
      return item.Building_Location.toLowerCase().contains(query) ||
          item.id.toString().toLowerCase().contains(query) ||
          item.Building_Name.toLowerCase().contains(query) ||
          item.Building_Address.toLowerCase().contains(query) ||
          item.Building_Location.toLowerCase().contains(query) ||
          item.Building_image.toLowerCase().contains(query) ||
          item.Longitude.toLowerCase().contains(query) ||
          item.Latitude.toLowerCase().contains(query) ||
          item.Rent.toLowerCase().contains(query) ||
          item.Verify_price.toLowerCase().contains(query) ||
          item.BHK.toLowerCase().contains(query) ||
          item.sqft.toLowerCase().contains(query) ||
          item.tyope.toLowerCase().contains(query) ||
          item.floor_.toLowerCase().contains(query) ||
          item.maintence.toLowerCase().contains(query) ||
          item.buy_Rent.toLowerCase().contains(query) ||
          item.Building_information.toLowerCase().contains(query) ||
          item.Parking.toLowerCase().contains(query) ||
          item.balcony.toLowerCase().contains(query) ||
          item.facility.toLowerCase().contains(query) ||
          item.Furnished.toLowerCase().contains(query) ||
          item.kitchen.toLowerCase().contains(query) ||
          item.Baathroom.toLowerCase().contains(query) ||
          item.Date.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredProperties = filtered;
      propertyCount = filtered.length; // ✅ Set the count here
    });
  }

  Future<List<RealEstateShowDateModel>> fetchData(id) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=$_number&looking=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
      return listresponce.map((data) => RealEstateShowDateModel.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata(); // fetch _number from SharedPreferences

    _loaduserdata().then((_) {
      _fetchInitialData(); // Call your API after loading user data
    });
  }
  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';
    await _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(_number);
      setState(() {
        _allProperties = data;
        _filteredProperties = data;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => _isLoading = false);
    }
  }


  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(""); // Call your API
      setState(() {
        // _originalData = data;
        // _filteredData = data;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }


  bool _isDeleting = false;

  String? selectedLabel;

  void _setSearchText(String label, String text) {
    setState(() {
      selectedLabel = label;
      _searchController.text = text;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),

      );
      // propertyCount = _getMockPropertyCount(text); // Mock or real count

    });

    print("Search for: $text");
  }
  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel!="";
  }


  //Delete api
  Future<void> DeletePropertyById(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {
      setState(() {
        _isDeleting = false;
        //ShowVehicleNumbers(id);
        //showVehicleModel?.vehicleNo;
      });
      print(response.body.toString());
      print('Item deleted successfully');
    } else {
      print('Error deleting item. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
        surfaceTintColor: Colors.black,
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
      body:
      _isLoading
          ? Center(child: Image.asset(AppImages.loader,height: 50,))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search properties...',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                  ),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Rent', 'Buy', 'Commercial'].map((label) {
                final bool isSelected = label == selectedLabel;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => _setSearchText(label, label),
                      child: Text(label,style: TextStyle(
                          color: isSelected
                              ? Colors.white  // Always white when selected
                              : Colors.black,
                          fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        // color:
                        isSelected ? Colors.blue : Colors.grey.shade300,

                        // Theme.of(context).brightness==Brightness.dark?Colors.white12:Colors.black26,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (propertyCount > 0 && _isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "$propertyCount properties found",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              selectedLabel = '';
                              _filteredProperties = _allProperties;
                              propertyCount = 0;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          _filteredProperties.isEmpty
              ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No properties found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try a different search term",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
              : Expanded(
            child: RefreshIndicator(

              onRefresh: _fetchProperties,
              child: ListView.builder(
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];
                  return StreamBuilder<http.Response>(
                    stream: Stream.periodic(const Duration(seconds: 5))
                        .asyncMap((_) => http.get(Uri.parse(
                      "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${property.id}",
                    ))),
                    builder: (context, snapshot) {
                      bool isRedDot = false;

                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          isRedDot = body is List && body.isNotEmpty && body[0]['logg'] == 0;
                        } catch (_) {}
                      }

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setInt('id_Building', _filteredProperties[index].id);
                              prefs.setString('id_Longitude', _filteredProperties[index].Longitude.toString());
                              prefs.setString('id_Latitude', _filteredProperties[index].Latitude.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => View_Details(id: _filteredProperties[index].id),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).highlightColor,
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        ),
                                        child: Image.network(
                                          "https://verifyserve.social/${_filteredProperties[index].Building_image}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Center(
                                            child: Icon(Icons.home, size: 50, color: Theme.of(context).hintColor),
                                          ),
                                        ),
                                      ),
                                      // if (isRedDot)
                                      //   Positioned(
                                      //     top: 10,
                                      //     left: 10,
                                      //     child: Container(
                                      //       width: 14,
                                      //       height: 14,
                                      //       decoration: BoxDecoration(
                                      //         color: Colors.red,
                                      //         shape: BoxShape.circle,
                                      //       ),
                                      //     ),
                                      //   ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _getPropertyTypeColor(_filteredProperties[index].buy_Rent),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            _filteredProperties[index].buy_Rent ?? "Property",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: "PoppinsBold",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _filteredProperties[index].Verify_price != null &&
                                                  _filteredProperties[index].Verify_price!.isNotEmpty
                                                  ? "₹${_filteredProperties[index].Verify_price}"
                                                  : "₹${_filteredProperties[index].Rent}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                fontFamily: "PoppinsBold",
                                                color: Theme.of(context).textTheme.titleLarge?.color,
                                              ),
                                            ),
                                            Text(
                                              _filteredProperties[index].Building_Location ?? "",
                                              style: TextStyle(
                                                fontFamily: "PoppinsBold",
                                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildFeatureItem(context, Icons.king_bed, "${_filteredProperties[index].BHK}"),
                                            _buildFeatureItem(context, Icons.apartment, "${_filteredProperties[index].floor_}"),
                                            _buildFeatureItem(context, Icons.home_work, _filteredProperties[index].tyope ?? ""),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                },
              ),
            ),
          ),
        ],
      ),

        bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Add_Realestate()));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPropertiesFirstPage()));

            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Building',
              style: TextStyle(
                fontSize: 17,
                fontFamily: "PoppinsBold",
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0, // Shadow handled by container
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),


    );
  }
  Color _getPropertyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'rent':
        return Colors.green;
      case 'buy':
        return Colors.blueAccent;
      case 'lease':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade700,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }

}
