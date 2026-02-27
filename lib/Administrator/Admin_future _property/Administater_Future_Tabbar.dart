import 'package:flutter/material.dart';
import 'package:verify_feild_worker/Administrator/Admin_future%20_property/Administater_Plot.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Administater_Commercial.dart';
import 'Administater_Future_Property.dart';

class AdministaterPropertyTabPage extends StatefulWidget {

  static const String FieldCommercial = "/FieldCommercial";

  final bool fromNotification;
  final int tabIndex;
  final String? commercialId;
  final String? plotId;
  final String? buildingId;

  const AdministaterPropertyTabPage({
    Key? key,
    this.tabIndex = 0,
    this.commercialId,
    this.plotId,
    this.buildingId,
    this.fromNotification = false,
  }) : super(key: key);



  @override
  State<AdministaterPropertyTabPage> createState() => _AdministaterPropertyTabPageState();
}

class _AdministaterPropertyTabPageState extends State<AdministaterPropertyTabPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.tabIndex,   // ✅ IMPORTANT
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.asset(AppImages.transparent,height: 40,),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.white,            // Selected text color
            unselectedLabelColor: Colors.grey,   // Unselected text color
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              Tab(
                //icon: Icon(Icons.apartment),
                text: "Building",
              ),
              Tab(
                //icon: Icon(Icons.landscape),
                text: "Plot",
              ),
              Tab(
                //icon: Icon(Icons.business),
                text: "Commercial",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ADministaterShow_FutureProperty(
              buildingId: widget.buildingId,
              fromNotification: widget.fromNotification,
            ),

            Show_Administater_Plot(
              plotId: widget.plotId,
              fromNotification: widget.fromNotification,
            ),

            Show_Aministater_Commercial(
              commercialId: widget.commercialId,
              fromNotification: widget.fromNotification,
            ),
          ],
        ),
      ),
    );
  }
}
