import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../Home_Screen_click/Real-Estate.dart';
import 'ALl_Demands.dart';
import 'Assigned_Tenant_Demand.dart';
import '../Police_Verification/Tenant_Details.dart';
import '../constant.dart';
import 'Calendar.dart';
import 'Feild_Accpte_TenantDemand.dart';
import 'Parent_class_TenantDemand.dart';
import 'Pending_Bottom_tenantdemand/Parent_Pending_bottomfile.dart';
import 'Perant_Class_Accpte_Demand.dart';
import 'Show_TenantDemands.dart';
import 'Visit_By_date/Visit_by_date.dart';

class MainPage_TenandDemand extends StatefulWidget {
  const MainPage_TenandDemand({super.key});

  @override
  State<MainPage_TenandDemand> createState() => _MainPage_TenandDemandState();
}

class _MainPage_TenandDemandState extends State<MainPage_TenandDemand> {

  List<Widget> pages = [
    const parent_TenandDemand(),
    const Calender(),
    const parent_bottom_Pending(),
  ];
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  void _showBottomSheet(BuildContext context) {

    List<String> timing = [
      "Residential",
      "Plots",
      "Commercial",
    ];
    ValueNotifier<int> timingIndex = ValueNotifier(0);

    String displayedData = "Press a button to display data";

    void updateData(String newData) {
      setState(() {
        displayedData = newData;
      });
    }

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 5,right: 5,top: 0, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(3),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.grey),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      Tab(text: 'Residential'),
                      Tab(text: 'Commercial'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    Filter_Options(),
                    Commercial_Filter()
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          if (currentIndex != currentIndex) {
            // If not on the home screen, go back to home screen
            setState(() {
              currentIndex == 0;
            });
            return false; // Do not exit the app
          }else {
            // If on the home screen, prompt to exit the app
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exit App'),
                content: Text('Do you want to exit the app?'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            ) ?? false;
          }
        },
        child: Scaffold(
          body: ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, int index, _) {
                return pages[index];
              }
          ),
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, int index, _) {
                return Container(
                  //padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, -2
                        ),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    child: BottomNavigationBar(
                      currentIndex: index,
                      elevation: 8.0, // Add elevation for a shadow-like effect
                      showUnselectedLabels: true,
                      showSelectedLabels: true,
                      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Colors.red,
                      unselectedItemColor: Colors.white,
                      backgroundColor: Colors.black,
                      onTap: (v) {
                        setState(() {
                          currentIndex.value = v;
                        });
                      },
                      items: const [
                        BottomNavigationBarItem(icon: Icon(Iconsax.home_copy), label: "Home",backgroundColor: Colors.black),
                        //BottomNavigationBarItem(icon: Icon(PhosphorIcons.newspaper), label: "News",backgroundColor: Colors.black),
                        BottomNavigationBarItem(icon: Icon(Iconsax.calendar), label: "Calendar",backgroundColor: Colors.black),
                        BottomNavigationBarItem(icon: Icon(Iconsax.arrange_circle), label: "Pending",backgroundColor: Colors.black),
                      ],
                    ),
                  ),
                );
              }
          ),
        )
    );
  }
}
