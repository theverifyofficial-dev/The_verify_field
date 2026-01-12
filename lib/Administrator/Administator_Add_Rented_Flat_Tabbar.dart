// import 'package:flutter/material.dart';
// import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
//
// import '../Add_Rented_Flat/FieldWorker_Booking_Page.dart';
// import '../constant.dart';
// import 'AdministatorFieldWorkerBookingPage.dart';
//
// class AdministatorAddRentedFlatTabbar extends StatefulWidget {
//   final int tabIndex;
//   final String? propertyId;
//   const AdministatorAddRentedFlatTabbar({
//     super.key,
//     this.tabIndex = 0,
//     this.propertyId,  });
//
//   @override
//   State<AdministatorAddRentedFlatTabbar> createState() => _AdministatorAddRentedFlatTabbarState();
// }
//
// class _AdministatorAddRentedFlatTabbarState extends State<AdministatorAddRentedFlatTabbar>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedIndex = 0;
//
//   final List<String> _tabs = ["Booking", "Pending", "Complete"];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: _tabs.length, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _selectedIndex = _tabController.index;
//       });
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _tabController.animateTo(widget.tabIndex);
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // --- Booking Tab UI ---
//   Widget _buildBookingTab() {
//     return _buildAnimatedCard(
//       Colors.blueAccent,
//       "📑 Your Bookings",
//       "Here you can check all booked flats and assigned work.",
//     );
//   }
//
//   // --- Pending Tab UI ---
//   Widget _buildPendingTab() {
//     return _buildAnimatedCard(
//       Colors.orangeAccent,
//       "⏳ Pending Work",
//       "Tasks that are still in progress or waiting for approval.",
//     );
//   }
//
//   // --- Complete Tab UI ---
//   Widget _buildCompleteTab() {
//     return _buildAnimatedCard(
//       Colors.green,
//       "✅ Completed",
//       "All completed flats and successful deals are here.",
//     );
//   }
//
//   // --- Common Animated Card ---
//   Widget _buildAnimatedCard(Color color, String title, String subtitle) {
//     return Center(
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 600),
//         curve: Curves.easeInOut,
//         padding: const EdgeInsets.all(20),
//         child: Card(
//           elevation: 8,
//           shadowColor: color.withOpacity(0.5),
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(
//                 colors: [color.withOpacity(0.95), color.withOpacity(0.65)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   subtitle,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       fontSize: 15, color: Colors.white70, height: 1.4),
//                 ),
//                 const SizedBox(height: 25),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 28, vertical: 12),
//                   ),
//                   onPressed: () {
//                     // Later you can connect API/navigation here
//                   },
//                   child: Text(
//                     "View Details",
//                     style: TextStyle(
//                         color: color, fontWeight: FontWeight.bold, fontSize: 14),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- Main Build ---
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0, // Make sure there's no shadow
//         surfaceTintColor: Colors.black,
//         backgroundColor: Colors.black,
//         title: Image.asset(AppImages.verify, height: 75),
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Row(
//             children: [
//               SizedBox(
//                 width: 3,
//               ),
//               Icon(
//                 PhosphorIcons.caret_left_bold,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ],
//           ),
//         ),        // centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Container(
//             margin: const EdgeInsets.only(left: 16,right: 16,top: 8 ),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade900,
//               borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25)),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(
//                 // borderRadius: BorderRadius.circular(20),
//                 color: Colors.white,
//               ),
//               dividerColor: Colors.transparent,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.white,
//               labelStyle: const TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.bold),
//               tabs: _tabs.map((tab) => Padding(
//                 padding: const EdgeInsets.only(left: 8.0,right: 8),
//                 child: Tab(text: tab),
//               )).toList(),
//             ),
//           ),
//         ),
//       ),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 500),
//         child: TabBarView(
//           key: ValueKey<int>(_selectedIndex),
//           controller: _tabController,
//           children: [
//             AdministatiorFieldWorkerBookingPage(),
//             _buildPendingTab(),
//             _buildCompleteTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }
