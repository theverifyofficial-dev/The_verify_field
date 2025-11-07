// import 'dart:async';
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constant.dart';
// import 'View_All_Details.dart';
//
// class NewRealEstateShowDateModel {
//   final int? pId;
//   final int? sId;
//   final String? sourceId;
//   final String? propertyPhoto;
//   final String? locations;
//   final String? flatNumber;
//   final String? buyRent;
//   final String? residenceCommercial;
//   final String? apartmentName;
//   final String? apartmentAddress;
//   final String? typeOfProperty;
//   final String? bhk;
//   final String? showPrice;
//   final String? lastPrice;
//   final String? askingPrice;
//   final String? floor;
//   final String? totalFloor;
//   final String? balcony;
//   final String? squarefit;
//   final String? maintance;
//   final String? parking;
//   final String? ageOfProperty;
//   final String? fieldWorkerAddress;
//   final String? roadSize;
//   final String? metroDistance;
//   final String? highwayDistance;
//   final String? mainMarketDistance;
//   final String? meter;
//   final String? ownerName;
//   final String? ownerNumber;
//   final String? currentDates;
//   final String? availableDate;
//   final String? kitchen;
//   final String? bathroom;
//   final String? lift;
//   final String? facility;
//   final String? furnishedUnfurnished;
//   final String? fieldWorkerName;
//   final String? fieldWorkerNumber;
//   final String? liveUnlive;
//   final String? registryAndGpa;
//   final String? loan;
//   final String? longitude;
//   final String? latitude;
//   final String? fieldWorkerCurrentLocation;
//   final String? careTakerName;
//   final String? careTakerNumber;
//   final String? video;
//
//   NewRealEstateShowDateModel({
//     this.pId,
//     this.sId,
//     this.sourceId,
//     this.propertyPhoto,
//     this.locations,
//     this.flatNumber,
//     this.buyRent,
//     this.residenceCommercial,
//     this.apartmentName,
//     this.apartmentAddress,
//     this.typeOfProperty,
//     this.bhk,
//     this.showPrice,
//     this.lastPrice,
//     this.askingPrice,
//     this.floor,
//     this.totalFloor,
//     this.balcony,
//     this.squarefit,
//     this.maintance,
//     this.parking,
//     this.ageOfProperty,
//     this.fieldWorkerAddress,
//     this.roadSize,
//     this.metroDistance,
//     this.highwayDistance,
//     this.mainMarketDistance,
//     this.meter,
//     this.ownerName,
//     this.ownerNumber,
//     this.currentDates,
//     this.availableDate,
//     this.kitchen,
//     this.bathroom,
//     this.lift,
//     this.facility,
//     this.furnishedUnfurnished,
//     this.fieldWorkerName,
//     this.fieldWorkerNumber,
//     this.liveUnlive,
//     this.registryAndGpa,
//     this.loan,
//     this.longitude,
//     this.latitude,
//     this.fieldWorkerCurrentLocation,
//     this.careTakerName,
//     this.careTakerNumber,
//     this.video,
//   });
//
//   static int? _asInt(dynamic v) {
//     if (v == null) return null;
//     if (v is int) return v;
//     return int.tryParse(v.toString());
//   }
//
//   static String? _asStr(dynamic v) => v?.toString();
//
//   factory NewRealEstateShowDateModel.fromJson(Map<String, dynamic> json) {
//     return NewRealEstateShowDateModel(
//       pId: _asInt(json['P_id']),
//       sId: _asInt(json['subid']),
//       sourceId: _asStr(json['source_id']),
//       propertyPhoto: _asStr(json['property_photo']),
//       locations: _asStr(json['locations']),
//       flatNumber: _asStr(json['Flat_number']),
//       buyRent: _asStr(json['Buy_Rent']),
//       residenceCommercial: _asStr(json['Residence_Commercial']),
//       apartmentName: _asStr(json['Apartment_name']),
//       apartmentAddress: _asStr(json['Apartment_Address']),
//       typeOfProperty: _asStr(json['Typeofproperty']),
//       bhk: _asStr(json['Bhk']),
//       showPrice: _asStr(json['show_Price']),
//       lastPrice: _asStr(json['Last_Price']),
//       askingPrice: _asStr(json['asking_price']),
//       floor: _asStr(json['Floor_']),
//       totalFloor: _asStr(json['Total_floor']),
//       balcony: _asStr(json['Balcony']),
//       squarefit: _asStr(json['squarefit']),
//       maintance: _asStr(json['maintance']),
//       parking: _asStr(json['parking']),
//       ageOfProperty: _asStr(json['age_of_property']),
//       fieldWorkerAddress: _asStr(json['fieldworkar_address']),
//       roadSize: _asStr(json['Road_Size']),
//       metroDistance: _asStr(json['metro_distance']),
//       highwayDistance: _asStr(json['highway_distance']),
//       mainMarketDistance: _asStr(json['main_market_distance']),
//       meter: _asStr(json['meter']),
//       ownerName: _asStr(json['owner_name']),
//       ownerNumber: _asStr(json['owner_number']),
//       currentDates: _asStr(json['current_dates']),
//       availableDate: _asStr(json['available_date']),
//       kitchen: _asStr(json['kitchen']),
//       bathroom: _asStr(json['bathroom']),
//       lift: _asStr(json['lift']),
//       facility: _asStr(json['Facility']),
//       furnishedUnfurnished: _asStr(json['furnished_unfurnished']),
//       fieldWorkerName: _asStr(json['field_werror_name']),
//       fieldWorkerNumber: _asStr(json['field_workar_number']),
//       liveUnlive: _asStr(json['live_unlive']),
//       registryAndGpa: _asStr(json['registry_and_gpa']),
//       loan: _asStr(json['loan']),
//       longitude: _asStr(json['Longitude']),
//       latitude: _asStr(json['Latitude']),
//       fieldWorkerCurrentLocation: _asStr(json['field_worker_current_location']),
//       careTakerName: _asStr(json['care_taker_name']),
//       careTakerNumber: _asStr(json['care_taker_number']),
//       video: _asStr(json['video_link']),
//     );
//   }
// }
//
// class Show_New_Real_Estate extends StatefulWidget {
//   const Show_New_Real_Estate({super.key});
//
//   @override
//   State<Show_New_Real_Estate> createState() => _Show_New_Real_EstateState();
// }
//
// class _Show_New_Real_EstateState extends State<Show_New_Real_Estate> {
//   List<NewRealEstateShowDateModel> _allProperties = [];
//   List<NewRealEstateShowDateModel> _filteredProperties = [];
//   TextEditingController _searchController = TextEditingController();
//   FocusNode _searchFocusNode = FocusNode();
//
//   bool _isLoading = true;
//   bool _showSearchBar = false;
//   String _number = '';
//   int propertyCount = 0;
//   String? selectedLabel;
//   Timer? _debounce;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _loaduserdata();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       final query = _searchController.text.toLowerCase();
//       if (selectedLabel != null) {
//         var tempFiltered = _allProperties.where((item) {
//           return (item.buyRent ?? '').toLowerCase().contains(selectedLabel!.toLowerCase()) ||
//               (item.typeOfProperty ?? '').toLowerCase().contains(selectedLabel!.toLowerCase());
//         }).toList();
//         final filtered = tempFiltered.where((item) {
//           return (item.locations ?? '').toLowerCase().contains(query) ||
//               (item.apartmentAddress ?? '').toLowerCase().contains(query) ||
//               (item.pId ?? '').toString().toLowerCase().contains(query) ||
//               (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
//               (item.bhk ?? '').toLowerCase().contains(query) ||
//               (item.showPrice ?? '').toLowerCase().contains(query);
//         }).toList();
//         setState(() {
//           _filteredProperties = filtered;
//           propertyCount = filtered.length;
//         });
//       } else {
//         final filtered = _allProperties.where((item) {
//           return (item.locations ?? '').toLowerCase().contains(query) ||
//               (item.apartmentAddress ?? '').toLowerCase().contains(query) ||
//               (item.pId ?? '').toString().toLowerCase().contains(query) ||
//               (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
//               (item.bhk ?? '').toLowerCase().contains(query) ||
//               (item.showPrice ?? '').toLowerCase().contains(query);
//         }).toList();
//
//         setState(() {
//           _filteredProperties = filtered;
//           propertyCount = filtered.length;
//         });
//       }
//     });
//   }
//
//   Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
//     try {
//       final url = Uri.parse(
//         "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php?field_workar_number=$number&live_unlive=Live",
//       );
//
//       final response = await http.get(url);
//
//       if (response.statusCode != 200) {
//         throw Exception("HTTP ${response.statusCode}: ${response.body}");
//       }
//
//       final decoded = json.decode(response.body);
//       final raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;
//
//       final List<Map<String, dynamic>> listResponse;
//       if (raw is List) {
//         listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
//       } else if (raw is Map) {
//         listResponse = [Map<String, dynamic>.from(raw)];
//       } else {
//         listResponse = const [];
//       }
//
//       int _asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);
//
//       listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));
//
//       return listResponse.map((data) => NewRealEstateShowDateModel.fromJson(data)).toList();
//     } catch (e) {
//       print("❌ Error fetching data: $e");
//       return [];
//     }
//   }
//
//   Future<void> _loaduserdata() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       _number = prefs.getString('number') ?? '';
//       await _fetchProperties();
//     } catch (e) {
//       print("❌ Error loading user data: $e");
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _fetchProperties() async {
//     setState(() => _isLoading = true);
//     try {
//       final data = await fetchData(_number);
//       setState(() {
//         _allProperties = data;
//         _filteredProperties = data;
//         propertyCount = data.length;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("❌ Error fetching properties: $e");
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _setSearchText(String label, String text) {
//     setState(() {
//       selectedLabel = label;
//       _searchController.text = text;
//       _searchController.selection = TextSelection.fromPosition(
//         TextPosition(offset: _searchController.text.length),
//       );
//     });
//     _onSearchChanged();
//   }
//
//   void _toggleSearchBar() {
//     setState(() {
//       _showSearchBar = !_showSearchBar;
//       if (_showSearchBar) {
//         Future.delayed(Duration(milliseconds: 100), () {
//           _searchFocusNode.requestFocus();
//         });
//       } else {
//         _searchController.clear();
//         setState(() {
//           selectedLabel = null;
//           _filteredProperties = _allProperties;
//           propertyCount = _allProperties.length;
//         });
//       }
//     });
//   }
//
//   bool get _isSearchActive {
//     return _searchController.text.trim().isNotEmpty || (selectedLabel != null && selectedLabel!.isNotEmpty);
//   }
//
//   Color _getPropertyTypeColor(String? type) {
//     switch (type?.toLowerCase()) {
//       case 'rent':
//         return const Color(0xFF00C9A7);
//       case 'buy':
//         return const Color(0xFF845EC2);
//       case 'commercial':
//         return const Color(0xFFFF8066);
//       default:
//         return const Color(0xFF2D73D5);
//     }
//   }
//
//   Widget _buildPropertyCard(NewRealEstateShowDateModel property, BuildContext context, bool isRedDot) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: () async {
//         try {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setInt('id_Building', property.pId ?? 0);
//           prefs.setString('id_Longitude', (property.longitude ?? '').toString());
//           prefs.setString('id_Latitude', (property.latitude ?? '').toString());
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => View_Details(id: property.pId ?? 0),
//             ),
//           );
//         } catch (e) {
//           print("❌ Error navigating to details: $e");
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.all(1),
//         child: Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: isDark ? Color(0xFF1E293B) : Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image Section
//                 Stack(
//                   children: [
//                     // Property Image
//                     Container(
//                       height: 170,
//                       width: double.infinity,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(12),
//                           topRight: Radius.circular(12),
//                         ),
//                         child: CachedNetworkImage(
//                           imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto ?? ''}",
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => Container(
//                             color: _getPropertyTypeColor(property.buyRent).withOpacity(0.1),
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(_getPropertyTypeColor(property.buyRent)),
//                               ),
//                             ),
//                           ),
//                           errorWidget: (context, url, error) => Container(
//                             color: _getPropertyTypeColor(property.buyRent).withOpacity(0.1),
//                             child: Icon(
//                               Icons.home_work_outlined,
//                               size: 30,
//                               color: _getPropertyTypeColor(property.buyRent).withOpacity(0.3),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // Type Badge
//                     Positioned(
//                       top: 8,
//                       left: 8,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: _getPropertyTypeColor(property.buyRent),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           property.buyRent?.toUpperCase() ?? 'SALE',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // Red Dot Notification
//                     if (isRedDot)
//                       Positioned(
//                         top: 8,
//                         right: 8,
//                         child: Container(
//                           padding: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Text(
//                             property.pId as String,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//
//                 // Content Section - Only 3 main details + facility icons
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Price - Always first
//                       Text(
//                         "₹${_formatPrice(property.showPrice ?? '0')}",
//                         style: TextStyle(
//                           color: _getPropertyTypeColor(property.buyRent),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//
//                       SizedBox(height: 6),
//
//                       // BHK - Always second
//                       Text(
//                         "${property.bhk ?? 'Studio'}",
//                         style: TextStyle(
//                           color: theme.colorScheme.onSurface,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//
//                       SizedBox(height: 6),
//
//                       // Location - Always third
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.add_business,
//                             size: 12,
//                             color: theme.colorScheme.onSurface.withOpacity(0.6),
//                           ),
//                           SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               property. balcony?? 'facility',
//                               style: TextStyle(
//                                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 12,
//                             color: theme.colorScheme.onSurface.withOpacity(0.6),
//                           ),
//                           SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               property.locations ?? 'Location',
//                               style: TextStyle(
//                                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//
//                         ],
//                       ),
//
//                       SizedBox(height: 8),
//
//                       // Facility Icons - Only 2-3 important ones
//                       _buildFacilityIcons(property, theme),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFacilityIcons(NewRealEstateShowDateModel property, ThemeData theme) {
//     List<Widget> facilityWidgets = [];
//
//     // Add bathroom icon if available
//     if (property.bathroom != null && property.bathroom!.isNotEmpty) {
//       facilityWidgets.add(
//         _buildFacilityIcon(Icons.bathtub_outlined, '${property.bathroom} Bath'),
//       );
//     }
//
//     // Add parking icon if available
//     if (property.parking != null && property.parking!.isNotEmpty) {
//       facilityWidgets.add(
//         _buildFacilityIcon(Icons.local_parking_outlined, 'Parking'),
//       );
//     }
//
//     // Add lift icon if available
//     if (property.lift != null && property.lift!.isNotEmpty) {
//       facilityWidgets.add(
//         _buildFacilityIcon(Icons.elevator_outlined, 'Lift'),
//       );
//     }
//
//     // Add furnished icon if available
//     if (property.furnishedUnfurnished != null && property.furnishedUnfurnished!.isNotEmpty) {
//       facilityWidgets.add(
//         _buildFacilityIcon(Icons.chair_outlined, 'Furnished'),
//       );
//     }
//
//     // Limit to maximum 3 icons
//     if (facilityWidgets.length > 3) {
//       facilityWidgets = facilityWidgets.sublist(0, 3);
//     }
//
//     return facilityWidgets.isNotEmpty
//         ? Wrap(
//       spacing: 8,
//       runSpacing: 4,
//       children: facilityWidgets,
//     )
//         : SizedBox.shrink();
//   }
//
//   Widget _buildFacilityIcon(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           size: 12,
//           color: Colors.grey[600],
//         ),
//         SizedBox(width: 2),
//         Text(
//           text,
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatPrice(String price) {
//     try {
//       final number = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
//       if (number >= 10000000) {
//         return '${(number / 10000000).toStringAsFixed(1)}Cr';
//       } else if (number >= 100000) {
//         return '${(number / 100000).toStringAsFixed(1)}L';
//       } else if (number >= 1000) {
//         return '${(number / 1000).toStringAsFixed(1)}K';
//       }
//       return number.toString();
//     } catch (e) {
//       return price;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDark ? Color(0xFF0F172A) : Color(0xFFF8FAFC),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0F172A),
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(
//             Icons.arrow_back_rounded,
//             color: Colors.white,
//           ),
//         ),
//         title: Image.asset(AppImages.transparent, height: 35),
//         actions: [
//           IconButton(
//             onPressed: _toggleSearchBar,
//             icon: Icon(
//               _showSearchBar ? Icons.close_rounded : Icons.search_rounded,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Loading Properties...',
//               style: TextStyle(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       )
//           : Column(
//         children: [
//           // Animated Search Bar
//           AnimatedContainer(
//             duration: Duration(milliseconds: 300),
//             height: _showSearchBar ? 70 : 0,
//             child: _showSearchBar
//                 ? Padding(
//               padding: EdgeInsets.all(12),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   focusNode: _searchFocusNode,
//                   decoration: InputDecoration(
//                     hintText: 'Search by location, price, BHK...',
//                     prefixIcon: Icon(
//                       Icons.search_rounded,
//                       color: theme.colorScheme.primary,
//                     ),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                       icon: Icon(
//                         Icons.clear_rounded,
//                         color: theme.iconTheme.color?.withOpacity(0.6),
//                       ),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           selectedLabel = null;
//                           _filteredProperties = _allProperties;
//                           propertyCount = _allProperties.length;
//                         });
//                       },
//                     )
//                         : null,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     contentPadding: EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//                 : SizedBox.shrink(),
//           ),
//
//           // Simple Filter Tabs
//           Container(
//             height: 80,
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: ['Rent', 'Buy', 'Commercial'].map((label) {
//                 final bool isSelected = selectedLabel == label;
//                 return Expanded(
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     child: ElevatedButton(
//                       onPressed: () => _setSearchText(label, label),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: isSelected
//                             ? _getPropertyTypeColor(label)
//                             : isDark ? Color(0xFF374151) : Colors.grey[200],
//                         foregroundColor: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 0,
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                       ),
//                       child: Text(
//                         label,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//
//           // Results Count
//           if (_isSearchActive && propertyCount > 0)
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.green.withOpacity(0.1)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green, size: 14),
//                   SizedBox(width: 6),
//                   Text(
//                     "$propertyCount properties",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           // Properties List
//           Expanded(
//             child: _filteredProperties.isEmpty
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.search_off_rounded,
//                     size: 60,
//                     color: theme.colorScheme.outline.withOpacity(0.3),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     "No properties found",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: theme.colorScheme.onSurface.withOpacity(0.6),
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     "Try adjusting your search",
//                     style: TextStyle(
//                       color: theme.colorScheme.onSurface.withOpacity(0.5),
//                       fontSize: 12,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     onPressed: _fetchProperties,
//                     icon: Icon(Icons.refresh, size: 14),
//                     label: Text('Refresh'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: theme.colorScheme.primary,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : RefreshIndicator(
//               onRefresh: _fetchProperties,
//               color: theme.colorScheme.primary,
//               child: GridView.builder(
//                 padding: EdgeInsets.all(8),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 0,
//                   mainAxisSpacing: 1,
//                   childAspectRatio: 0.56, // Compact card size
//                 ),
//                 itemCount: _filteredProperties.length,
//                 itemBuilder: (context, index) {
//                   final property = _filteredProperties[index];
//                   return StreamBuilder<http.Response>(
//                     stream: Stream.periodic(Duration(seconds: 5))
//                         .asyncMap((_) => http.get(Uri.parse(
//                       "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${property.pId ?? 0}",
//                     ))),
//                     builder: (context, snapshot) {
//                       bool isRedDot = false;
//                       if (snapshot.hasData) {
//                         try {
//                           final body = jsonDecode(snapshot.data!.body);
//                           isRedDot = body is List && body.isNotEmpty && body[0]['logg'] == 0;
//                         } catch (_) {}
//                       }
//
//                       return _buildPropertyCard(property, context, isRedDot);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//____________________________________________________________________________

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'View_All_Details.dart';

class NewRealEstateShowDateModel {
  final int? pId;
  final int? sId;
  final String? sourceId;
  final String? propertyPhoto;
  final String? locations;
  final String? flatNumber;
  final String? buyRent;
  final String? residenceCommercial;
  final String? apartmentName;
  final String? apartmentAddress;
  final String? typeOfProperty;
  final String? bhk;
  final String? showPrice;
  final String? lastPrice;
  final String? askingPrice;
  final String? floor;
  final String? totalFloor;
  final String? balcony;
  final String? squarefit;
  final String? maintance;
  final String? parking;
  final String? ageOfProperty;
  final String? fieldWorkerAddress;
  final String? roadSize;
  final String? metroDistance;
  final String? highwayDistance;
  final String? mainMarketDistance;
  final String? meter;
  final String? ownerName;
  final String? ownerNumber;
  final String? currentDates;
  final String? availableDate;
  final String? kitchen;
  final String? bathroom;
  final String? lift;
  final String? facility;
  final String? furnishedUnfurnished;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? liveUnlive;
  final String? registryAndGpa;
  final String? loan;
  final String? longitude;
  final String? latitude;
  final String? fieldWorkerCurrentLocation;
  final String? careTakerName;
  final String? careTakerNumber;
  final String? video;

  NewRealEstateShowDateModel({
    this.pId,
    this.sId,
    this.sourceId,
    this.propertyPhoto,
    this.locations,
    this.flatNumber,
    this.buyRent,
    this.residenceCommercial,
    this.apartmentName,
    this.apartmentAddress,
    this.typeOfProperty,
    this.bhk,
    this.showPrice,
    this.lastPrice,
    this.askingPrice,
    this.floor,
    this.totalFloor,
    this.balcony,
    this.squarefit,
    this.maintance,
    this.parking,
    this.ageOfProperty,
    this.fieldWorkerAddress,
    this.roadSize,
    this.metroDistance,
    this.highwayDistance,
    this.mainMarketDistance,
    this.meter,
    this.ownerName,
    this.ownerNumber,
    this.currentDates,
    this.availableDate,
    this.kitchen,
    this.bathroom,
    this.lift,
    this.facility,
    this.furnishedUnfurnished,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.liveUnlive,
    this.registryAndGpa,
    this.loan,
    this.longitude,
    this.latitude,
    this.fieldWorkerCurrentLocation,
    this.careTakerName,
    this.careTakerNumber,
    this.video,
  });

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static String? _asStr(dynamic v) => v?.toString();

  factory NewRealEstateShowDateModel.fromJson(Map<String, dynamic> json) {
    return NewRealEstateShowDateModel(
      pId: _asInt(json['P_id']),
      sId: _asInt(json['subid']),
      sourceId: _asStr(json['source_id']),
      propertyPhoto: _asStr(json['property_photo']),
      locations: _asStr(json['locations']),
      flatNumber: _asStr(json['Flat_number']),
      buyRent: _asStr(json['Buy_Rent']),
      residenceCommercial: _asStr(json['Residence_Commercial']),
      apartmentName: _asStr(json['Apartment_name']),
      apartmentAddress: _asStr(json['Apartment_Address']),
      typeOfProperty: _asStr(json['Typeofproperty']),
      bhk: _asStr(json['Bhk']),
      showPrice: _asStr(json['show_Price']),
      lastPrice: _asStr(json['Last_Price']),
      askingPrice: _asStr(json['asking_price']),
      floor: _asStr(json['Floor_']),
      totalFloor: _asStr(json['Total_floor']),
      balcony: _asStr(json['Balcony']),
      squarefit: _asStr(json['squarefit']),
      maintance: _asStr(json['maintance']),
      parking: _asStr(json['parking']),
      ageOfProperty: _asStr(json['age_of_property']),
      fieldWorkerAddress: _asStr(json['fieldworkar_address']),
      roadSize: _asStr(json['Road_Size']),
      metroDistance: _asStr(json['metro_distance']),
      highwayDistance: _asStr(json['highway_distance']),
      mainMarketDistance: _asStr(json['main_market_distance']),
      meter: _asStr(json['meter']),
      ownerName: _asStr(json['owner_name']),
      ownerNumber: _asStr(json['owner_number']),
      currentDates: _asStr(json['current_dates']),
      availableDate: _asStr(json['available_date']),
      kitchen: _asStr(json['kitchen']),
      bathroom: _asStr(json['bathroom']),
      lift: _asStr(json['lift']),
      facility: _asStr(json['Facility']),
      furnishedUnfurnished: _asStr(json['furnished_unfurnished']),
      fieldWorkerName: _asStr(json['field_warkar_name']),
      fieldWorkerNumber: _asStr(json['field_workar_number']),
      liveUnlive: _asStr(json['live_unlive']),
      registryAndGpa: _asStr(json['registry_and_gpa']),
      loan: _asStr(json['loan']),
      longitude: _asStr(json['Longitude']),
      latitude: _asStr(json['Latitude']),
      fieldWorkerCurrentLocation: _asStr(json['field_worker_current_location']),
      careTakerName: _asStr(json['care_taker_name']),
      careTakerNumber: _asStr(json['care_taker_number']),
      video: _asStr(json['video_link']),
    );
  }
}

class Show_New_Real_Estate extends StatefulWidget {
  const Show_New_Real_Estate({super.key});

  @override
  State<Show_New_Real_Estate> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<Show_New_Real_Estate> {
  List<NewRealEstateShowDateModel> _allProperties = [];
  List<NewRealEstateShowDateModel> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  bool _isLoading = true;
  bool _showSearchBar = false;
  String _number = '';
  int propertyCount = 0;
  String? selectedLabel;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.toLowerCase();
      if (selectedLabel != null) {
        var tempFiltered = _allProperties.where((item) {
          return (item.buyRent ?? '').toLowerCase().contains(selectedLabel!.toLowerCase()) ||
              (item.typeOfProperty ?? '').toLowerCase().contains(selectedLabel!.toLowerCase());
        }).toList();
        final filtered = tempFiltered.where((item) {
          return (item.locations ?? '').toLowerCase().contains(query) ||
              (item.apartmentAddress ?? '').toLowerCase().contains(query) ||
              (item.pId ?? '').toString().toLowerCase().contains(query) ||
              (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
              (item.bhk ?? '').toLowerCase().contains(query) ||
              (item.showPrice ?? '').toLowerCase().contains(query);
        }).toList();
        setState(() {
          _filteredProperties = filtered;
          propertyCount = filtered.length;
        });
      } else {
        final filtered = _allProperties.where((item) {
          return (item.locations ?? '').toLowerCase().contains(query) ||
              (item.apartmentAddress ?? '').toLowerCase().contains(query) ||
              (item.pId ?? '').toString().toLowerCase().contains(query) ||
              (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
              (item.bhk ?? '').toLowerCase().contains(query) ||
              (item.showPrice ?? '').toLowerCase().contains(query);
        }).toList();

        setState(() {
          _filteredProperties = filtered;
          propertyCount = filtered.length;
        });
      }
    });
  }

  Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php?field_workar_number=$number&live_unlive=Live",
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }

      final decoded = json.decode(response.body);
      final raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;

      final List<Map<String, dynamic>> listResponse;
      if (raw is List) {
        listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
      } else if (raw is Map) {
        listResponse = [Map<String, dynamic>.from(raw)];
      } else {
        listResponse = const [];
      }

      int _asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);

      listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));

      return listResponse.map((data) => NewRealEstateShowDateModel.fromJson(data)).toList();
    } catch (e) {
      print("❌ Error fetching data: $e");
      return [];
    }
  }

  Future<void> _loaduserdata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _number = prefs.getString('number') ?? '';
      await _fetchProperties();
    } catch (e) {
      print("❌ Error loading user data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(_number);
      setState(() {
        _allProperties = data;
        _filteredProperties = data;
        propertyCount = data.length;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching properties: $e");
      setState(() => _isLoading = false);
    }
  }

  void _setSearchText(String label, String text) {
    setState(() {
      selectedLabel = label;
      _searchController.text = text;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    });
    _onSearchChanged();
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (_showSearchBar) {
        Future.delayed(Duration(milliseconds: 100), () {
          _searchFocusNode.requestFocus();
        });
      } else {
        _searchController.clear();
        setState(() {
          selectedLabel = null;
          _filteredProperties = _allProperties;
          propertyCount = _allProperties.length;
        });
      }
    });
  }

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || (selectedLabel != null && selectedLabel!.isNotEmpty);
  }

  Color _getPropertyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'rent':
        return const Color(0xFF00C9A7);
      case 'buy':
        return const Color(0xFF845EC2);
      case 'commercial':
        return const Color(0xFFFF8066);
      default:
        return const Color(0xFF2D73D5);
    }
  }

  Widget _buildPropertyCard(NewRealEstateShowDateModel property, BuildContext context, bool isRedDot) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('id_Building', property.pId ?? 0);
          prefs.setString('id_Longitude', (property.longitude ?? '').toString());
          prefs.setString('id_Latitude', (property.latitude ?? '').toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => View_Details(id: property.pId ?? 0),
            ),
          );
        } catch (e) {
          print("❌ Error navigating to details: $e");
        }
      },
      child: Container(
        margin: EdgeInsets.all(8),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    // Property Image
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto ?? ''}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: _getPropertyTypeColor(property.buyRent).withOpacity(0.1),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(_getPropertyTypeColor(property.buyRent)),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: _getPropertyTypeColor(property.buyRent).withOpacity(0.1),
                            child: Icon(
                              Icons.home_work_outlined,
                              size: 40,
                              color: _getPropertyTypeColor(property.buyRent).withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Type Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPropertyTypeColor(property.buyRent),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          property.buyRent?.toUpperCase() ?? 'SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // Red Dot Notification
                    // if (isRedDot)
                    //   Positioned(
                    //     top: 8,
                    //     right: 8,
                    //     child: Container(
                    //       padding: EdgeInsets.all(4),
                    //       decoration: BoxDecoration(
                    //         color: Colors.red,
                    //         shape: BoxShape.circle,
                    //       ),
                    //       child: Icon(
                    //         Icons.notifications_active,
                    //         color: Colors.white,
                    //         size: 10,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),

                // Content Section - Vertical Layout
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text(
                        "₹${_formatPrice(property.showPrice ?? '0')}",
                        style: TextStyle(
                          color: _getPropertyTypeColor(property.buyRent),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8),

                      // BHK and Type
                      Row(
                        children: [
                          Icon(
                            Icons.hotel,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${property.bhk ?? 'Studio'}",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 12),
                          if (property.typeOfProperty != null && property.typeOfProperty!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPropertyTypeColor(property.buyRent).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                property.typeOfProperty!,
                                style: TextStyle(
                                  color: _getPropertyTypeColor(property.buyRent),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.locations ?? 'Location not specified',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Facility
                      if (property.facility != null && property.facility!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.add_business,
                              size: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                property.facility!,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 12),

                      // Facility Icons - Horizontal Row
                      _buildColorfulFacilityIcons(property, theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorfulFacilityIcons(NewRealEstateShowDateModel property, ThemeData theme) {
    List<Widget> facilityWidgets = [];

    // Bathroom
    if (property.bathroom != null && property.bathroom!.isNotEmpty) {
      facilityWidgets.add(_buildColorfulFacilityChip(
        Icons.bathtub,
        '${property.bathroom} Bath',
        Color(0xFFE8EAF6),
        Color(0xFF3F51B5),
      ));
    }

    // Parking
    if (property.parking != null && property.parking!.isNotEmpty) {
      facilityWidgets.add(_buildColorfulFacilityChip(
        Icons.local_parking,
        'Parking',
        Color(0xFFE0F2F1),
        Color(0xFF00796B),
      ));
    }

    // Lift
    if (property.lift != null && property.lift!.isNotEmpty) {
      facilityWidgets.add(_buildColorfulFacilityChip(
        Icons.elevator,
        'Lift',
        Color(0xFFFCE4EC),
        Color(0xFFC2185B),
      ));
    }

    // Furnished
    if (property.furnishedUnfurnished != null && property.furnishedUnfurnished!.isNotEmpty) {
      facilityWidgets.add(_buildColorfulFacilityChip(
        Icons.chair,
        'Furnished',
        Color(0xFFFFF8E1),
        Color(0xFFFF8F00),
      ));
    }

    // Balcony
    if (property.balcony != null && property.balcony!.isNotEmpty) {
      facilityWidgets.add(_buildColorfulFacilityChip(
        Icons.balcony,
        'Balcony',
        Color(0xFFE1F5FE),
        Color(0xFF0288D1),
      ));
    }

    // Kitchen
    if (property.kitchen != null && property.kitchen!.isNotEmpty) {
      facilityWidgets.add(_buildColorfulFacilityChip(
        Icons.kitchen,
        'Kitchen',
        Color(0xFFFFEBEE),
        Color(0xFFD32F2F),
      ));
    }

     return facilityWidgets.isNotEmpty
         ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Amenities',
        //   style: TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w700,
        //     color: Colors.grey[700],
        //   ),
        // ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: facilityWidgets,
        ),
      ],
    )
         : SizedBox.shrink();
  }

  Widget _buildColorfulFacilityChip(IconData icon, String text, Color bgColor, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: iconColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final number = int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (number >= 10000000) {
        return '${(number / 10000000).toStringAsFixed(1)}Cr';
      } else if (number >= 100000) {
        return '${(number / 100000).toStringAsFixed(1)}L';
      } else if (number >= 1000) {
        return '${(number / 1000).toStringAsFixed(1)}K';
      }
      return number.toString();
    } catch (e) {
      return price;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF0F172A) : Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Image.asset(AppImages.transparent, height: 35),
        actions: [
          IconButton(
            onPressed: _toggleSearchBar,
            icon: Icon(
              _showSearchBar ? Icons.close_rounded : Icons.search_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
            SizedBox(height: 16),
            Text(
              'Loading Properties...',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          // Animated Search Bar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _showSearchBar ? 70 : 0,
            child: _showSearchBar
                ? Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search by location, price, BHK...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: theme.iconTheme.color?.withOpacity(0.6),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          selectedLabel = null;
                          _filteredProperties = _allProperties;
                          propertyCount = _allProperties.length;
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),
          ),

          // Simple Filter Tabs
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['Rent', 'Buy', 'Commercial'].map((label) {
                final bool isSelected = selectedLabel == label;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => _setSearchText(label, label),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? _getPropertyTypeColor(label)
                            : isDark ? Color(0xFF374151) : Colors.grey[200],
                        foregroundColor: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Results Count
          if (_isSearchActive && propertyCount > 0)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 14),
                  SizedBox(width: 6),
                  Text(
                    "$propertyCount properties",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

          // Properties List - Changed to ListView for vertical layout
          Expanded(
            child: _filteredProperties.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 60,
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "No properties found",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Try adjusting your search",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _fetchProperties,
                    icon: Icon(Icons.refresh, size: 14),
                    label: Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            )
                : RefreshIndicator(
              onRefresh: _fetchProperties,
              color: theme.colorScheme.primary,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];
                  return StreamBuilder<http.Response>(
                    stream: Stream.periodic(Duration(seconds: 5))
                        .asyncMap((_) => http.get(Uri.parse(
                      "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${property.pId ?? 0}",
                    ))),
                    builder: (context, snapshot) {
                      bool isRedDot = false;
                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          isRedDot = body is List && body.isNotEmpty && body[0]['logg'] == 0;
                        } catch (_) {}
                      }
                      return _buildPropertyCard(property, context, isRedDot);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}