// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:http/http.dart' as http;
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Controller/Show_demand_control.dart';
// import '../constant.dart';
// import 'Feedback_Details_Page.dart';
// import 'Parent_class_TenantDemand.dart';
// import 'package:get/get.dart';
//
//
// class Catid {
//   final int id;
//   final String fieldworkar_name;
//   final String fieldworkar_number;
//   final String demand_name;
//   final String demand_number;
//   final String buy_rent;
//   final String place;
//   final String BHK;
//   final String dates;
//   final String times;
//
//   Catid(
//       {required this.id, required this.fieldworkar_name, required this.fieldworkar_number, required this.demand_name, required this.demand_number,
//         required this.buy_rent, required this.place, required this.BHK, required this.dates, required this.times});
//
//   factory Catid.FromJson(Map<String, dynamic>json){
//     return Catid(id: json['id'],
//         fieldworkar_name: json['fieldworkar_name'],
//         fieldworkar_number: json['fieldworkar_number'],
//         demand_name: json['demand_name'],
//         demand_number: json['demand_number'],
//         buy_rent: json['buy_rent'],
//         place: json['add_info'],
//         BHK: json['bhk'],
//         dates: json['dates'],
//         times: json['times']);
//   }
// }
//
// class Persnol_Assignd_Tenant_details extends StatefulWidget {
//   const Persnol_Assignd_Tenant_details({super.key});
//
//   @override
//   State<Persnol_Assignd_Tenant_details> createState() => _Persnol_Assignd_Tenant_detailsState();
// }
//
// class _Persnol_Assignd_Tenant_detailsState extends State<Persnol_Assignd_Tenant_details> {
//
//   TextEditingController _searchController = TextEditingController();
//   Timer? _debounce;
//   List<Catid> _allProperties = [];
//   String selectedLabel = '';
//   List<Catid> _filteredProperties = [];
//   int propertyCount = 0;
//
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//
//     _debounce = Timer(const Duration(milliseconds: 400), () {
//       String query = _searchController.text.toLowerCase().trim();
//
//       List<Catid> filtered;
//
//       if (query.isEmpty) {
//         filtered = List.from(_allProperties);
//         selectedLabel = '';
//       } else {
//         filtered = _allProperties.where((item) {
//           bool matches(String? value) =>
//               (value ?? '').toLowerCase().contains(query);
//
//           return matches(item.BHK) ||
//               matches(item.place) ||
//               matches(item.buy_rent) ||
//               matches(item.dates) ||
//               matches(item.demand_name) ||
//               matches(item.demand_number) ||
//               matches(item.fieldworkar_name) ||
//               matches(item.fieldworkar_number);
//         }).toList();
//       }
//
//       setState(() {
//         _filteredProperties = filtered;
//         propertyCount = filtered.length;
//       });
//     });
//   }
//
//
//   Future<List<Catid>> fetchData(id) async {
//     var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_assign_tenant_demand_by_feild_num_looking_location_?fieldworkar_number=$_num&looking_type=Re_Demand&location_=$_location');
//     final responce = await http.get(url);
//     if (responce.statusCode == 200) {
//       List listresponce = json.decode(responce.body);
//       listresponce.sort((a, b) => b['id'].compareTo(a['id']));
//       return listresponce.map((data) => Catid.FromJson(data)).toList();
//     }
//     else {
//       throw Exception('Unexpected error occured!');
//     }
//   }
//
//   Future<List<Catid>> fetchData_pendinhg(id) async {
//     var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_assign_tenant_demand_by_feild_num_looking_location_?fieldworkar_number=$_num&looking_type=Pending&location_=$_location');
//     final responce = await http.get(url);
//     if (responce.statusCode == 200) {
//       List listresponce = json.decode(responce.body);
//       listresponce.sort((a, b) => b['id'].compareTo(a['id']));
//       return listresponce.map((data) => Catid.FromJson(data)).toList();
//     }
//     else {
//       throw Exception('Unexpected error occured!');
//     }
//   }
//
//   Future<void> fetchdata_insurt(id,type,feedback) async{
//     final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/update_assign_tenant_demand_by_id_looking_feedback_?id=$id&looking_type=$type&feedback=$feedback'));
//     //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));
//
//     if(responce.statusCode == 200){
//       print(responce.body);
//       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => parent_TenandDemand(),), (route) => route.isFirst);
//
//       /*final delete_respponce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Delete_assign_tenant_demand_?id=$id'));
//
//       if(delete_respponce.statusCode == 200){
//         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Accept_Feedback_Parent_Page(),), (route) => route.isFirst);
//       }*/
//
//       //SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     } else {
//       print('Failed Registration');
//     }
//
//   }
//
//   final TextEditingController _feedback = TextEditingController();
//
//   void _showBottomSheet(BuildContext context, String id) {
//     showModalBottomSheet(
//       backgroundColor: Colors.black,
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           margin: EdgeInsets.only(left: 20,right: 20,top: 20,),
//           // Add your content for the bottom sheet here
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                   padding: EdgeInsets.only(left: 5,top: 20),
//                   child: Text('Enter Your FeedBack',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),
//
//               SizedBox(height: 5,),
//
//               Container(
//                 padding: const EdgeInsets.all(1),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   // boxShadow: K.boxShadow,
//                 ),
//                 child: TextField(style: TextStyle(color: Colors.black),
//                   keyboardType: TextInputType.text,
//                   controller: _feedback,
//                   decoration: InputDecoration(
//                       hintText: "Enter Your FeedBack",
//                       prefixIcon: Icon(
//                         PhosphorIcons.phone_call,
//                         color: Colors.black,
//                       ),
//                       hintStyle: TextStyle(color: Colors.black,fontFamily: 'Poppins',),
//                       border: InputBorder.none),
//                 ),
//               ),
//
//               SizedBox(height: 40,),
//
//               Center(
//                 child: Container(
//                   height: 50,
//                   width: 200,
//                   margin: const EdgeInsets.symmetric(horizontal: 50),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                       color: Colors.red.withOpacity(0.8)
//                   ),
//
//
//
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red
//                     ),
//                     onPressed: (){
//                       //data = _email.toString();
//                       //fetchdata(iidd,num, bloc.buyRentDetailsData.first.tPid, bloc.buyRentDetailsData.first.tital, bloc.buyRentDetailsData.first.priceh, _Bidprice.text);
//                       //Navigator.pop(context);
//
//                       fetchdata_insurt(id, "Pending", _feedback.text);
//
//                       print(id);
//                       Fluttertoast.showToast(
//                           msg: "Your Feedback Successfully Added",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 1,
//                           backgroundColor: Colors.grey,
//                           textColor: Colors.white,
//                           fontSize: 16.0
//                       );
//
//                     }, child: Text("Submit", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, ),
//                   ),
//                   ),
//
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   String _num = '';
//   String _na = '';
//   String _location = '';
//   bool _isLoading = true;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loaduserdata();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//
//
//         body: Container(
//             child: SingleChildScrollView(
//                 child: Column(
//                     children: [
//                       _isLoading
//                           ? Center(
//                         child: Lottie.asset(AppImages.loading, height: 400),)
//                           : Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Search Box
//                                   Material(
//                                     elevation: 4,
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: AnimatedContainer(
//                                       duration: const Duration(
//                                           milliseconds: 300),
//                                       curve: Curves.easeInOut,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.grey[100]!,
//                                             Colors.grey[50]!
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.2),
//                                             blurRadius: 10,
//                                             spreadRadius: 2,
//                                             offset: const Offset(0, 4),
//                                           ),
//                                         ],
//                                       ),
//                                       child: TextField(
//                                         controller: _searchController,
//                                         style: const TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         decoration: InputDecoration(
//                                           hintText: 'Search properties...',
//                                           hintStyle: TextStyle(
//                                               color: Colors.grey.shade600,
//                                               fontSize: 16),
//                                           prefixIcon: Padding(
//                                             padding: const EdgeInsets.all(12),
//                                             child: Icon(Icons.search_rounded,
//                                                 color: Colors.grey.shade700,
//                                                 size: 24),
//                                           ),
//                                           suffixIcon: AnimatedSwitcher(
//                                             duration: const Duration(
//                                                 milliseconds: 200),
//                                             child: _searchController.text
//                                                 .isNotEmpty
//                                                 ? IconButton(
//                                               key: const ValueKey('clear'),
//                                               icon: Icon(Icons.close_rounded,
//                                                   color: Colors.grey.shade700,
//                                                   size: 22),
//                                               onPressed: () {
//                                                 _searchController.clear();
//                                                 selectedLabel = '';
//                                                 _filteredProperties =
//                                                     _allProperties;
//                                                 propertyCount = 0;
//                                                 FocusScope
//                                                     .of(context)
//                                                     .unfocus();
//                                                 setState(() {});
//                                               },
//                                             )
//                                                 : const SizedBox(
//                                                 key: ValueKey('empty')),
//                                           ),
//                                           filled: true,
//                                           fillColor: Colors.transparent,
//                                           contentPadding: const EdgeInsets
//                                               .symmetric(vertical: 16),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 12),
//                                             borderSide: BorderSide.none,
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 12),
//                                             borderSide: BorderSide(
//                                                 color: Colors.blueGrey
//                                                     .withOpacity(0.3),
//                                                 width: 1),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 12),
//                                             borderSide: BorderSide(
//                                                 color: Colors.blueAccent
//                                                     .withOpacity(0.8),
//                                                 width: 1.5),
//                                           ),
//                                         ),
//                                         onChanged: (value) {
//                                           _onSearchChanged();
//                                           setState(() {});
//                                         },
//                                       ),
//                                     ),
//                                   ),
//
//
//                                   FutureBuilder<List<Catid>>(
//                                       future: fetchData("" + 1.toString()),
//                                       builder: (context, abc) {
//                                         if (abc.connectionState ==
//                                             ConnectionState.waiting) {
//                                           return Center(
//                                               child: CircularProgressIndicator());
//                                         }
//                                         else if (abc.hasError) {
//                                           return Text('${abc.error}');
//                                         }
//                                         else if (abc.data == null ||
//                                             abc.data!.isEmpty) {
//                                           // If the list is empty, show an empty image
//                                           return Center(
//                                             child: Column(
//                                               children: [
//                                                 // Lottie.asset("assets/images/no data.json",width: 450),
//                                                 Text("",
//                                                   style: TextStyle(fontSize: 20,
//                                                       fontWeight: FontWeight
//                                                           .w500,
//                                                       color: Colors.white,
//                                                       fontFamily: 'Poppins',
//                                                       letterSpacing: 0),),
//                                               ],
//                                             ),
//                                           );
//                                         }
//                                         else {
//                                           return ListView.builder(
//                                               itemCount: abc.data!.length,
//                                               shrinkWrap: true,
//                                               physics: NeverScrollableScrollPhysics(),
//                                               itemBuilder: (
//                                                   BuildContext context,
//                                                   int len) {
//                                                 int displayIndex = abc.data!
//                                                     .length - len;
//                                                 return
//                                                   GestureDetector(
//                                                     onTap: () async {
//                                                       //  int itemId = abc.data![len].id;
//                                                       //int iiid = abc.data![len].PropertyAddress
//                                                       /*SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   prefs.setString('id_Document', abc.data![len].id.toString());*/
//                                                       /*SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   prefs.setInt('id_Building', abc.data![len].id);
//                                   prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
//                                   prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute
//                                         (builder: (context) => Tenant_Demands_details())
//                                   );*/
//
//                                                     },
//                                                     child: Column(
//                                                       children: [
//                                                         Padding(
//                                                           padding: const EdgeInsets
//                                                               .only(top: 20,
//                                                               left: 10,
//                                                               right: 10,
//                                                               bottom: 10),
//                                                           child: Container(
//                                                             padding: const EdgeInsets
//                                                                 .all(10),
//                                                             decoration: BoxDecoration(
//                                                               color: Colors
//                                                                   .white,
//                                                               borderRadius: BorderRadius
//                                                                   .circular(
//                                                                   10),
//                                                             ),
//                                                             child: Column(
//                                                               crossAxisAlignment: CrossAxisAlignment
//                                                                   .start,
//                                                               mainAxisAlignment: MainAxisAlignment
//                                                                   .center,
//                                                               children: [
//
//                                                                 SizedBox(
//                                                                   height: 10,
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//
//                                                                     Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .indigoAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .indigoAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           // Icon(Iconsax.sort_copy,size: 15,),
//                                                                           //SizedBox(width: 10,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .buy_rent /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                             style: TextStyle(
//                                                                                 fontSize: 15,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//
//
//                                                                     SizedBox(
//                                                                       width: 10,
//                                                                     ),
//
//                                                                     Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .greenAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .greenAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           // Icon(Iconsax.sort_copy,size: 15,),
//                                                                           //SizedBox(width: 10,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .BHK /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                             style: TextStyle(
//                                                                                 fontSize: 15,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//
//
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 10,
//                                                                 ),
//
//                                                                 Row(
//                                                                   children: [
//                                                                     Icon(Iconsax
//                                                                         .location_copy,
//                                                                       size: 12,
//                                                                       color: Colors
//                                                                           .red,),
//                                                                     SizedBox(
//                                                                       width: 2,),
//                                                                     Text(
//                                                                       " Name | Number",
//                                                                       overflow: TextOverflow
//                                                                           .ellipsis,
//                                                                       maxLines: 2,
//                                                                       style: TextStyle(
//                                                                           fontSize: 11,
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontWeight: FontWeight
//                                                                               .w600),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 5,
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     SizedBox(
//                                                                       width: 10,),
//                                                                     Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .blueAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .blueAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           // Icon(Iconsax.sort_copy,size: 15,),
//                                                                           //w SizedBox(width: 10,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .demand_name /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                             style: TextStyle(
//                                                                                 fontSize: 14,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//
//                                                                     SizedBox(
//                                                                       width: 10,
//                                                                     ),
//
//                                                                     GestureDetector(
//                                                                       onTap: () {
//                                                                         showDialog<
//                                                                             bool>(
//                                                                           context: context,
//                                                                           builder: (
//                                                                               context) =>
//                                                                               AlertDialog(
//                                                                                 title: Text(
//                                                                                     "Call " +
//                                                                                         abc
//                                                                                             .data![len]
//                                                                                             .demand_name),
//                                                                                 content: Text(
//                                                                                     'Do you really want to Call? ' +
//                                                                                         abc
//                                                                                             .data![len]
//                                                                                             .demand_name),
//                                                                                 shape: RoundedRectangleBorder(
//                                                                                     borderRadius: BorderRadius
//                                                                                         .circular(
//                                                                                         20)),
//                                                                                 actions: <
//                                                                                     Widget>[
//                                                                                   ElevatedButton(
//                                                                                     onPressed: () =>
//                                                                                         Navigator
//                                                                                             .of(
//                                                                                             context)
//                                                                                             .pop(
//                                                                                             false),
//                                                                                     child: Text(
//                                                                                         'No'),
//                                                                                   ),
//                                                                                   ElevatedButton(
//                                                                                     onPressed: () async {
//                                                                                       FlutterPhoneDirectCaller
//                                                                                           .callNumber(
//                                                                                           '${abc
//                                                                                               .data![len]
//                                                                                               .demand_number}');
//                                                                                     },
//                                                                                     child: Text(
//                                                                                         'Yes'),
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                         ) ??
//                                                                             false;
//                                                                       },
//                                                                       child: Container(
//                                                                         padding: EdgeInsets
//                                                                             .only(
//                                                                             left: 10,
//                                                                             right: 10,
//                                                                             top: 0,
//                                                                             bottom: 0),
//                                                                         decoration: BoxDecoration(
//                                                                           borderRadius: BorderRadius
//                                                                               .circular(
//                                                                               5),
//                                                                           border: Border
//                                                                               .all(
//                                                                               width: 1,
//                                                                               color: Colors
//                                                                                   .pinkAccent),
//                                                                           boxShadow: [
//                                                                             BoxShadow(
//                                                                                 color: Colors
//                                                                                     .pinkAccent
//                                                                                     .withOpacity(
//                                                                                     0.5),
//                                                                                 blurRadius: 10,
//                                                                                 offset: Offset(
//                                                                                     0,
//                                                                                     0),
//                                                                                 blurStyle: BlurStyle
//                                                                                     .outer
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                         child: Row(
//                                                                           children: [
//                                                                             Icon(
//                                                                               Iconsax
//                                                                                   .call,
//                                                                               size: 15,
//                                                                               color: Colors
//                                                                                   .red,),
//                                                                             SizedBox(
//                                                                               width: 4,),
//                                                                             Text(
//                                                                               "" +
//                                                                                   abc
//                                                                                       .data![len]
//                                                                                       .demand_number /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                               style: TextStyle(
//                                                                                   fontSize: 14,
//                                                                                   color: Colors
//                                                                                       .black,
//                                                                                   fontWeight: FontWeight
//                                                                                       .w500,
//                                                                                   letterSpacing: 0.5
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//
//                                                                 SizedBox(
//                                                                   height: 10,
//                                                                 ),
//
//                                                                 Row(
//                                                                   children: [
//                                                                     Icon(Iconsax
//                                                                         .location_copy,
//                                                                       size: 12,
//                                                                       color: Colors
//                                                                           .red,),
//                                                                     SizedBox(
//                                                                       width: 2,),
//                                                                     Text(
//                                                                       "Feild Worker Name | Number",
//                                                                       overflow: TextOverflow
//                                                                           .ellipsis,
//                                                                       maxLines: 2,
//                                                                       style: TextStyle(
//                                                                           fontSize: 11,
//                                                                           color: Colors
//                                                                               .black,
//                                                                           fontWeight: FontWeight
//                                                                               .w600),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 SizedBox(
//                                                                   height: 5,
//                                                                 ),
//                                                                 Row(
//                                                                   children: [
//                                                                     SizedBox(
//                                                                       width: 10,),
//                                                                     Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .blueAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .blueAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           // Icon(Iconsax.sort_copy,size: 15,),
//                                                                           //w SizedBox(width: 10,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .fieldworkar_name /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                             style: TextStyle(
//                                                                                 fontSize: 14,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//
//                                                                     SizedBox(
//                                                                       width: 10,
//                                                                     ),
//
//                                                                     GestureDetector(
//                                                                       onTap: () {
//                                                                         showDialog<
//                                                                             bool>(
//                                                                           context: context,
//                                                                           builder: (
//                                                                               context) =>
//                                                                               AlertDialog(
//                                                                                 title: Text(
//                                                                                     "Call " +
//                                                                                         abc
//                                                                                             .data![len]
//                                                                                             .fieldworkar_number),
//                                                                                 content: Text(
//                                                                                     'Do you really want to Call? ' +
//                                                                                         abc
//                                                                                             .data![len]
//                                                                                             .fieldworkar_name),
//                                                                                 shape: RoundedRectangleBorder(
//                                                                                     borderRadius: BorderRadius
//                                                                                         .circular(
//                                                                                         20)),
//                                                                                 actions: <
//                                                                                     Widget>[
//                                                                                   ElevatedButton(
//                                                                                     onPressed: () =>
//                                                                                         Navigator
//                                                                                             .of(
//                                                                                             context)
//                                                                                             .pop(
//                                                                                             false),
//                                                                                     child: Text(
//                                                                                         'No'),
//                                                                                   ),
//                                                                                   ElevatedButton(
//                                                                                     onPressed: () async {
//                                                                                       FlutterPhoneDirectCaller
//                                                                                           .callNumber(
//                                                                                           '${abc
//                                                                                               .data![len]
//                                                                                               .fieldworkar_number}');
//                                                                                     },
//                                                                                     child: Text(
//                                                                                         'Yes'),
//                                                                                   ),
//                                                                                 ],
//                                                                               ),
//                                                                         ) ??
//                                                                             false;
//                                                                       },
//                                                                       child: Container(
//                                                                         padding: EdgeInsets
//                                                                             .only(
//                                                                             left: 10,
//                                                                             right: 10,
//                                                                             top: 0,
//                                                                             bottom: 0),
//                                                                         decoration: BoxDecoration(
//                                                                           borderRadius: BorderRadius
//                                                                               .circular(
//                                                                               5),
//                                                                           border: Border
//                                                                               .all(
//                                                                               width: 1,
//                                                                               color: Colors
//                                                                                   .pinkAccent),
//                                                                           boxShadow: [
//                                                                             BoxShadow(
//                                                                                 color: Colors
//                                                                                     .pinkAccent
//                                                                                     .withOpacity(
//                                                                                     0.5),
//                                                                                 blurRadius: 10,
//                                                                                 offset: Offset(
//                                                                                     0,
//                                                                                     0),
//                                                                                 blurStyle: BlurStyle
//                                                                                     .outer
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                         child: Row(
//                                                                           children: [
//                                                                             Icon(
//                                                                               Iconsax
//                                                                                   .call,
//                                                                               size: 15,
//                                                                               color: Colors
//                                                                                   .red,),
//                                                                             SizedBox(
//                                                                               width: 4,),
//                                                                             Text(
//                                                                               "" +
//                                                                                   abc
//                                                                                       .data![len]
//                                                                                       .fieldworkar_number /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                               style: TextStyle(
//                                                                                   fontSize: 14,
//                                                                                   color: Colors
//                                                                                       .black,
//                                                                                   fontWeight: FontWeight
//                                                                                       .w500,
//                                                                                   letterSpacing: 0.5
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//
//                                                                 SizedBox(
//                                                                   height: 10,
//                                                                 ),
//
//                                                                 Row(
//                                                                   children: [
//                                                                     SizedBox(
//                                                                       width: 10,),
//                                                                     Container(
//                                                                       width: 300,
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .orangeAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .orangeAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Column(
//                                                                         children: [
//                                                                           // Icon(Iconsax.sort_copy,size: 15,),
//                                                                           //w SizedBox(width: 10,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .place,
//                                                                             maxLines: 3, /*+abc.data![len].Building_Name.toUpperCase()*/
//                                                                             style: TextStyle(
//                                                                                 fontSize: 13,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//
//                                                                 SizedBox(
//                                                                   height: 10,
//                                                                 ),
//
//                                                                 Row(
//                                                                   mainAxisAlignment: MainAxisAlignment
//                                                                       .spaceBetween,
//                                                                   children: [
//                                                                     GestureDetector(
//                                                                       onTap: () {
//                                                                         Navigator
//                                                                             .push(
//                                                                             context,
//                                                                             MaterialPageRoute
//                                                                               (builder: (
//                                                                                 context) =>
//                                                                                 Feedback_Details(
//                                                                                   id: '${abc
//                                                                                       .data![len]
//                                                                                       .id
//                                                                                       .toString()}',))
//                                                                         );
//                                                                       },
//                                                                       child: Container(
//                                                                         height: 40,
//                                                                         padding: const EdgeInsets
//                                                                             .symmetric(
//                                                                             horizontal: 25),
//                                                                         decoration: BoxDecoration(
//                                                                             borderRadius: const BorderRadius
//                                                                                 .only(
//                                                                                 topLeft: Radius
//                                                                                     .circular(
//                                                                                     10),
//                                                                                 topRight: Radius
//                                                                                     .circular(
//                                                                                     10),
//                                                                                 bottomRight: Radius
//                                                                                     .circular(
//                                                                                     10),
//                                                                                 bottomLeft: Radius
//                                                                                     .circular(
//                                                                                     10)),
//                                                                             color: Colors
//                                                                                 .deepPurpleAccent
//                                                                                 .withOpacity(
//                                                                                 0.8)),
//                                                                         child: Center(
//                                                                           child: Text(
//                                                                             "Open Page",
//                                                                             style: TextStyle(
//                                                                                 color: Colors
//                                                                                     .white,
//                                                                                 fontWeight: FontWeight
//                                                                                     .bold,
//                                                                                 letterSpacing: 0.8,
//                                                                                 fontSize: 14),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//
//                                                                   ],
//                                                                 ),
//
//                                                                 SizedBox(
//                                                                   height: 10,),
//
//                                                                 Row(
//                                                                   children: [
//                                                                     Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 0,
//                                                                           right: 0,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .white),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .white
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Column(
//                                                                         children: [
//                                                                           // Icon(Iconsax.sort_copy,size: 15,),
//                                                                           //w SizedBox(width: 10,),
//                                                                           Text(
//                                                                             "[ Re Demand No = $displayIndex ]", /*+abc.data![len].Building_Name.toUpperCase()*/
//                                                                             style: TextStyle(
//                                                                                 backgroundColor: Colors
//                                                                                     .red,
//                                                                                 fontSize: 13,
//                                                                                 color: Colors
//                                                                                     .white,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   );
//                                               });
//                                         }
//                                       }
//
//                                   ),
//
//                                   FutureBuilder<List<Catid>>(
//                                       future: fetchData_pendinhg("" +
//                                           1.toString()),
//                                       builder: (context, abc) {
//                                         if (abc.connectionState ==
//                                             ConnectionState.waiting) {
//                                           return Center(
//                                               child: CircularProgressIndicator());
//                                         }
//                                         else if (abc.hasError) {
//                                           return Text('${abc.error}');
//                                         }
//                                         else if (abc.data == null ||
//                                             abc.data!.isEmpty) {
//                                           // If the list is empty, show an empty image
//                                           return Center(
//                                             child: Column(
//                                               children: [
//                                                 // Lottie.asset("assets/images/no data.json",width: 450),
//                                                 Text("No Data Found!",
//                                                   style: TextStyle(
//                                                       fontSize: 20,
//                                                       fontWeight: FontWeight
//                                                           .w500,
//                                                       color: Colors.white,
//                                                       fontFamily: 'Poppins',
//                                                       letterSpacing: 0),),
//                                               ],
//                                             ),
//                                           );
//                                         }
//                                         else {
//                                           return ListView.builder(
//                                               itemCount: abc.data!.length,
//                                               shrinkWrap: true,
//                                               physics: NeverScrollableScrollPhysics(),
//                                               itemBuilder: (
//                                                   BuildContext context,
//                                                   int len) {
//                                                 int displayIndex = abc.data!
//                                                     .length - len;
//                                                 return GestureDetector(
//                                                   onTap: () async {
//                                                     //  int itemId = abc.data![len].id;
//                                                     //int iiid = abc.data![len].PropertyAddress
//                                                     /*SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   prefs.setString('id_Document', abc.data![len].id.toString());*/
//                                                     /*SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   prefs.setInt('id_Building', abc.data![len].id);
//                                   prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
//                                   prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute
//                                         (builder: (context) => Tenant_Demands_details())
//                                   );*/
//
//                                                   },
//                                                   child: Column(
//                                                     children: [
//                                                       Padding(
//                                                         padding: const EdgeInsets
//                                                             .only(top: 20,
//                                                             left: 10,
//                                                             right: 10,
//                                                             bottom: 10),
//                                                         child: Container(
//                                                           padding: const EdgeInsets
//                                                               .all(10),
//                                                           decoration: BoxDecoration(
//                                                             color: Colors.white,
//                                                             borderRadius: BorderRadius
//                                                                 .circular(10),
//                                                           ),
//                                                           child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment
//                                                                 .start,
//                                                             mainAxisAlignment: MainAxisAlignment
//                                                                 .center,
//                                                             children: [
//
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               Row(
//                                                                 children: [
//
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                         left: 10,
//                                                                         right: 10,
//                                                                         top: 0,
//                                                                         bottom: 0),
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius
//                                                                           .circular(
//                                                                           5),
//                                                                       border: Border
//                                                                           .all(
//                                                                           width: 1,
//                                                                           color: Colors
//                                                                               .indigoAccent),
//                                                                       boxShadow: [
//                                                                         BoxShadow(
//                                                                             color: Colors
//                                                                                 .indigoAccent
//                                                                                 .withOpacity(
//                                                                                 0.5),
//                                                                             blurRadius: 10,
//                                                                             offset: Offset(
//                                                                                 0,
//                                                                                 0),
//                                                                             blurStyle: BlurStyle
//                                                                                 .outer
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     child: Row(
//                                                                       children: [
//                                                                         // Icon(Iconsax.sort_copy,size: 15,),
//                                                                         //SizedBox(width: 10,),
//                                                                         Text(
//                                                                           "" +
//                                                                               abc
//                                                                                   .data![len]
//                                                                                   .buy_rent /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                           style: TextStyle(
//                                                                               fontSize: 15,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontWeight: FontWeight
//                                                                                   .w500,
//                                                                               letterSpacing: 0.5
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//
//
//                                                                   SizedBox(
//                                                                     width: 10,
//                                                                   ),
//
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                         left: 10,
//                                                                         right: 10,
//                                                                         top: 0,
//                                                                         bottom: 0),
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius
//                                                                           .circular(
//                                                                           5),
//                                                                       border: Border
//                                                                           .all(
//                                                                           width: 1,
//                                                                           color: Colors
//                                                                               .greenAccent),
//                                                                       boxShadow: [
//                                                                         BoxShadow(
//                                                                             color: Colors
//                                                                                 .greenAccent
//                                                                                 .withOpacity(
//                                                                                 0.5),
//                                                                             blurRadius: 10,
//                                                                             offset: Offset(
//                                                                                 0,
//                                                                                 0),
//                                                                             blurStyle: BlurStyle
//                                                                                 .outer
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     child: Row(
//                                                                       children: [
//                                                                         // Icon(Iconsax.sort_copy,size: 15,),
//                                                                         //SizedBox(width: 10,),
//                                                                         Text(
//                                                                           "" +
//                                                                               abc
//                                                                                   .data![len]
//                                                                                   .BHK /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                           style: TextStyle(
//                                                                               fontSize: 15,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontWeight: FontWeight
//                                                                                   .w500,
//                                                                               letterSpacing: 0.5
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//
//
//                                                                 ],
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//
//                                                               Row(
//                                                                 children: [
//                                                                   Icon(
//                                                                     Iconsax
//                                                                         .location_copy,
//                                                                     size: 12,
//                                                                     color: Colors
//                                                                         .red,),
//                                                                   SizedBox(
//                                                                     width: 2,),
//                                                                   Text(
//                                                                     " Name | Number",
//                                                                     overflow: TextOverflow
//                                                                         .ellipsis,
//                                                                     maxLines: 2,
//                                                                     style: TextStyle(
//                                                                         fontSize: 11,
//                                                                         color: Colors
//                                                                             .black,
//                                                                         fontWeight: FontWeight
//                                                                             .w600),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 5,
//                                                               ),
//                                                               Row(
//                                                                 children: [
//                                                                   SizedBox(
//                                                                     width: 10,),
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                         left: 10,
//                                                                         right: 10,
//                                                                         top: 0,
//                                                                         bottom: 0),
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius
//                                                                           .circular(
//                                                                           5),
//                                                                       border: Border
//                                                                           .all(
//                                                                           width: 1,
//                                                                           color: Colors
//                                                                               .blueAccent),
//                                                                       boxShadow: [
//                                                                         BoxShadow(
//                                                                             color: Colors
//                                                                                 .blueAccent
//                                                                                 .withOpacity(
//                                                                                 0.5),
//                                                                             blurRadius: 10,
//                                                                             offset: Offset(
//                                                                                 0,
//                                                                                 0),
//                                                                             blurStyle: BlurStyle
//                                                                                 .outer
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     child: Row(
//                                                                       children: [
//                                                                         // Icon(Iconsax.sort_copy,size: 15,),
//                                                                         //w SizedBox(width: 10,),
//                                                                         Text(
//                                                                           "" +
//                                                                               abc
//                                                                                   .data![len]
//                                                                                   .demand_name /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                           style: TextStyle(
//                                                                               fontSize: 14,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontWeight: FontWeight
//                                                                                   .w500,
//                                                                               letterSpacing: 0.5
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: 10,
//                                                                   ),
//
//                                                                   GestureDetector(
//                                                                     onTap: () {
//                                                                       showDialog<
//                                                                           bool>(
//                                                                         context: context,
//                                                                         builder: (
//                                                                             context) =>
//                                                                             AlertDialog(
//                                                                               title: Text(
//                                                                                   "Call " +
//                                                                                       abc
//                                                                                           .data![len]
//                                                                                           .demand_name),
//                                                                               content: Text(
//                                                                                   'Do you really want to Call? ' +
//                                                                                       abc
//                                                                                           .data![len]
//                                                                                           .demand_name),
//                                                                               shape: RoundedRectangleBorder(
//                                                                                   borderRadius: BorderRadius
//                                                                                       .circular(
//                                                                                       20)),
//                                                                               actions: <
//                                                                                   Widget>[
//                                                                                 ElevatedButton(
//                                                                                   onPressed: () =>
//                                                                                       Navigator
//                                                                                           .of(
//                                                                                           context)
//                                                                                           .pop(
//                                                                                           false),
//                                                                                   child: Text(
//                                                                                       'No'),
//                                                                                 ),
//                                                                                 ElevatedButton(
//                                                                                   onPressed: () async {
//                                                                                     FlutterPhoneDirectCaller
//                                                                                         .callNumber(
//                                                                                         '${abc
//                                                                                             .data![len]
//                                                                                             .demand_number}');
//                                                                                   },
//                                                                                   child: Text(
//                                                                                       'Yes'),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                       ) ??
//                                                                           false;
//                                                                     },
//                                                                     child: Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .pinkAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .pinkAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           Icon(
//                                                                             Iconsax
//                                                                                 .call,
//                                                                             size: 15,
//                                                                             color: Colors
//                                                                                 .red,),
//                                                                           SizedBox(
//                                                                             width: 4,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .demand_number /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                             style: TextStyle(
//                                                                                 fontSize: 14,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//
//                                                               Row(
//                                                                 children: [
//                                                                   Icon(
//                                                                     Iconsax
//                                                                         .location_copy,
//                                                                     size: 12,
//                                                                     color: Colors
//                                                                         .red,),
//                                                                   SizedBox(
//                                                                     width: 2,),
//                                                                   Text(
//                                                                     "Feild Worker Name | Number",
//                                                                     overflow: TextOverflow
//                                                                         .ellipsis,
//                                                                     maxLines: 2,
//                                                                     style: TextStyle(
//                                                                         fontSize: 11,
//                                                                         color: Colors
//                                                                             .black,
//                                                                         fontWeight: FontWeight
//                                                                             .w600),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 5,
//                                                               ),
//                                                               Row(
//                                                                 children: [
//                                                                   SizedBox(
//                                                                     width: 10,),
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                         left: 10,
//                                                                         right: 10,
//                                                                         top: 0,
//                                                                         bottom: 0),
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius
//                                                                           .circular(
//                                                                           5),
//                                                                       border: Border
//                                                                           .all(
//                                                                           width: 1,
//                                                                           color: Colors
//                                                                               .blueAccent),
//                                                                       boxShadow: [
//                                                                         BoxShadow(
//                                                                             color: Colors
//                                                                                 .blueAccent
//                                                                                 .withOpacity(
//                                                                                 0.5),
//                                                                             blurRadius: 10,
//                                                                             offset: Offset(
//                                                                                 0,
//                                                                                 0),
//                                                                             blurStyle: BlurStyle
//                                                                                 .outer
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     child: Row(
//                                                                       children: [
//                                                                         // Icon(Iconsax.sort_copy,size: 15,),
//                                                                         //w SizedBox(width: 10,),
//                                                                         Text(
//                                                                           "" +
//                                                                               abc
//                                                                                   .data![len]
//                                                                                   .fieldworkar_name /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                           style: TextStyle(
//                                                                               fontSize: 14,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontWeight: FontWeight
//                                                                                   .w500,
//                                                                               letterSpacing: 0.5
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//
//                                                                   SizedBox(
//                                                                     width: 10,
//                                                                   ),
//
//                                                                   GestureDetector(
//                                                                     onTap: () {
//                                                                       showDialog<
//                                                                           bool>(
//                                                                         context: context,
//                                                                         builder: (
//                                                                             context) =>
//                                                                             AlertDialog(
//                                                                               title: Text(
//                                                                                   "Call " +
//                                                                                       abc
//                                                                                           .data![len]
//                                                                                           .fieldworkar_number),
//                                                                               content: Text(
//                                                                                   'Do you really want to Call? ' +
//                                                                                       abc
//                                                                                           .data![len]
//                                                                                           .fieldworkar_name),
//                                                                               shape: RoundedRectangleBorder(
//                                                                                   borderRadius: BorderRadius
//                                                                                       .circular(
//                                                                                       20)),
//                                                                               actions: <
//                                                                                   Widget>[
//                                                                                 ElevatedButton(
//                                                                                   onPressed: () =>
//                                                                                       Navigator
//                                                                                           .of(
//                                                                                           context)
//                                                                                           .pop(
//                                                                                           false),
//                                                                                   child: Text(
//                                                                                       'No'),
//                                                                                 ),
//                                                                                 ElevatedButton(
//                                                                                   onPressed: () async {
//                                                                                     FlutterPhoneDirectCaller
//                                                                                         .callNumber(
//                                                                                         '${abc
//                                                                                             .data![len]
//                                                                                             .fieldworkar_number}');
//                                                                                   },
//                                                                                   child: Text(
//                                                                                       'Yes'),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                       ) ??
//                                                                           false;
//                                                                     },
//                                                                     child: Container(
//                                                                       padding: EdgeInsets
//                                                                           .only(
//                                                                           left: 10,
//                                                                           right: 10,
//                                                                           top: 0,
//                                                                           bottom: 0),
//                                                                       decoration: BoxDecoration(
//                                                                         borderRadius: BorderRadius
//                                                                             .circular(
//                                                                             5),
//                                                                         border: Border
//                                                                             .all(
//                                                                             width: 1,
//                                                                             color: Colors
//                                                                                 .pinkAccent),
//                                                                         boxShadow: [
//                                                                           BoxShadow(
//                                                                               color: Colors
//                                                                                   .pinkAccent
//                                                                                   .withOpacity(
//                                                                                   0.5),
//                                                                               blurRadius: 10,
//                                                                               offset: Offset(
//                                                                                   0,
//                                                                                   0),
//                                                                               blurStyle: BlurStyle
//                                                                                   .outer
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       child: Row(
//                                                                         children: [
//                                                                           Icon(
//                                                                             Iconsax
//                                                                                 .call,
//                                                                             size: 15,
//                                                                             color: Colors
//                                                                                 .red,),
//                                                                           SizedBox(
//                                                                             width: 4,),
//                                                                           Text(
//                                                                             "" +
//                                                                                 abc
//                                                                                     .data![len]
//                                                                                     .fieldworkar_number /*+abc.data![len].Building_Name.toUpperCase()*/,
//                                                                             style: TextStyle(
//                                                                                 fontSize: 14,
//                                                                                 color: Colors
//                                                                                     .black,
//                                                                                 fontWeight: FontWeight
//                                                                                     .w500,
//                                                                                 letterSpacing: 0.5
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//
//                                                               Row(
//                                                                 children: [
//                                                                   SizedBox(
//                                                                     width: 10,),
//                                                                   Container(
//                                                                     width: 300,
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                         left: 10,
//                                                                         right: 10,
//                                                                         top: 0,
//                                                                         bottom: 0),
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius
//                                                                           .circular(
//                                                                           5),
//                                                                       border: Border
//                                                                           .all(
//                                                                           width: 1,
//                                                                           color: Colors
//                                                                               .orangeAccent),
//                                                                       boxShadow: [
//                                                                         BoxShadow(
//                                                                             color: Colors
//                                                                                 .orangeAccent
//                                                                                 .withOpacity(
//                                                                                 0.5),
//                                                                             blurRadius: 10,
//                                                                             offset: Offset(
//                                                                                 0,
//                                                                                 0),
//                                                                             blurStyle: BlurStyle
//                                                                                 .outer
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     child: Column(
//                                                                       children: [
//                                                                         // Icon(Iconsax.sort_copy,size: 15,),
//                                                                         //w SizedBox(width: 10,),
//                                                                         Text(
//                                                                           "" +
//                                                                               abc
//                                                                                   .data![len]
//                                                                                   .place,
//                                                                           maxLines: 3, /*+abc.data![len].Building_Name.toUpperCase()*/
//                                                                           style: TextStyle(
//                                                                               fontSize: 13,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontWeight: FontWeight
//                                                                                   .w500,
//                                                                               letterSpacing: 0.5
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//
//                                                               Row(
//                                                                 mainAxisAlignment: MainAxisAlignment
//                                                                     .spaceBetween,
//                                                                 children: [
//                                                                   GestureDetector(
//                                                                     onTap: () {
//                                                                       Navigator
//                                                                           .push(
//                                                                           context,
//                                                                           MaterialPageRoute
//                                                                             (builder: (
//                                                                               context) =>
//                                                                               Feedback_Details(
//                                                                                 id: '${abc
//                                                                                     .data![len]
//                                                                                     .id
//                                                                                     .toString()}',))
//                                                                       );
//                                                                     },
//                                                                     child: Container(
//                                                                       height: 40,
//                                                                       padding: const EdgeInsets
//                                                                           .symmetric(
//                                                                           horizontal: 25),
//                                                                       decoration: BoxDecoration(
//                                                                           borderRadius: const BorderRadius
//                                                                               .only(
//                                                                               topLeft: Radius
//                                                                                   .circular(
//                                                                                   10),
//                                                                               topRight: Radius
//                                                                                   .circular(
//                                                                                   10),
//                                                                               bottomRight: Radius
//                                                                                   .circular(
//                                                                                   10),
//                                                                               bottomLeft: Radius
//                                                                                   .circular(
//                                                                                   10)),
//                                                                           color: Colors
//                                                                               .deepPurpleAccent
//                                                                               .withOpacity(
//                                                                               0.8)),
//                                                                       child: Center(
//                                                                         child: Text(
//                                                                           "Open Page",
//                                                                           style: TextStyle(
//                                                                               color: Colors
//                                                                                   .white,
//                                                                               fontWeight: FontWeight
//                                                                                   .bold,
//                                                                               letterSpacing: 0.8,
//                                                                               fontSize: 14),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//
//                                                                 ],
//                                                               ),
//
//                                                               SizedBox(
//                                                                 height: 10,),
//
//                                                               Row(
//                                                                 children: [
//                                                                   Container(
//                                                                     padding: EdgeInsets
//                                                                         .only(
//                                                                         left: 10,
//                                                                         right: 10,
//                                                                         top: 0,
//                                                                         bottom: 0),
//                                                                     decoration: BoxDecoration(
//                                                                       borderRadius: BorderRadius
//                                                                           .circular(
//                                                                           5),
//                                                                       border: Border
//                                                                           .all(
//                                                                           width: 1,
//                                                                           color: Colors
//                                                                               .orangeAccent),
//                                                                       boxShadow: [
//                                                                         BoxShadow(
//                                                                             color: Colors
//                                                                                 .orangeAccent
//                                                                                 .withOpacity(
//                                                                                 0.5),
//                                                                             blurRadius: 10,
//                                                                             offset: Offset(
//                                                                                 0,
//                                                                                 0),
//                                                                             blurStyle: BlurStyle
//                                                                                 .outer
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     child: Column(
//                                                                       children: [
//                                                                         // Icon(Iconsax.sort_copy,size: 15,),
//                                                                         //w SizedBox(width: 10,),
//                                                                         Text(
//                                                                           "Demand No = $displayIndex", /*+abc.data![len].Building_Name.toUpperCase()*/
//                                                                           style: TextStyle(
//                                                                               fontSize: 13,
//                                                                               color: Colors
//                                                                                   .black,
//                                                                               fontWeight: FontWeight
//                                                                                   .w500,
//                                                                               letterSpacing: 0.5
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 );
//                                               });
//                                         }
//                                       }
//
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ]
//                       )
//                     ]
//                 )
//             )
//         ));
//   }
//
//   Widget _buildDarkChip(String text, Color borderColor) { //for Re Demand.
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2C2C2C),
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(width: 1, color: borderColor),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontSize: 13.5,
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDarkBox(String text, Color borderColor, {double fontSize = 15}) { //for Demand.
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2B2B2B),
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(width: 1, color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color: borderColor.withOpacity(0.4),
//             blurRadius: 8,
//             offset: const Offset(0, 0),
//             blurStyle: BlurStyle.outer,
//           ),
//         ],
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: fontSize,
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }
//
//
//   void _loaduserdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _na = prefs.getString('name') ?? '';
//       _num = prefs.getString('number') ?? '';
//       _location = prefs.getString('location') ?? '';
//     });
//   }
//
// }
