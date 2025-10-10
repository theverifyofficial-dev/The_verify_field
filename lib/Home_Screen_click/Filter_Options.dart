import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../Future_Property_OwnerDetails_section/Future_Property.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Common_Filter_Residential.dart';
import 'Common_filter_WithFloor.dart';

class Filter_Options extends StatefulWidget {
  const Filter_Options({super.key});

  @override
  State<Filter_Options> createState() => _Filter_OptionsState();
}

class _Filter_OptionsState extends State<Filter_Options> {


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
            padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.all(3),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: Colors.grey),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      Tab(text: 'Common Filter'),
                      Tab(text: 'With Floor'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    //Residential_filter(),
                    //Residential_filter()
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String displayedText = "Data 1";

  void changeData(String newText) {
    setState(() {
      displayedText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            // padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[200],
              // borderRadius: BorderRadius.circular(10),
              boxShadow: Theme.of(context).brightness == Brightness.dark
                  ? []
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              indicatorColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: Colors.blue,
              unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600,fontFamily: "Poppins",),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600,fontFamily: "Poppins",),
              tabs: const [
                Tab(text: 'Common Filter'),
                Tab(text: 'Floor Option'),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Residential_filter(),
            Residential_filter_withfloor(),
          ],
        ),
      ),
    );
  }
}
