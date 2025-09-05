import 'package:get/get.dart';
import '../Controller/Show_demand_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'Add_tenantdemand_num.dart';
import 'Tenant_demands_details.dart';

class Catid {
  final int id;
  final String V_name;
  final String V_number;
  final String bhk;
  final String budget;
  final String place;
  final String floor_option;
  final String Additional_Info;
  final String Shifting_date;
  final String Current_date;
  final String Parking;
  final String Gadi_Number;
  final String FeildWorker_Name;
  final String FeildWorker_Number;
  final String Current__Date;
  final String Family_Members;
  final String buyrent;

  Catid(
      {required this.id, required this.V_name, required this.V_number, required this.bhk, required this.budget,
        required this.place, required this.floor_option, required this.Additional_Info, required this.Shifting_date,required this.Current_date,
        required this.Parking, required this.Gadi_Number, required this.FeildWorker_Name, required this.FeildWorker_Number,
        required this.Current__Date,required this.Family_Members,required this.buyrent});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['VTD_id'],
        V_name: json['V_name'],
        V_number: json['V_number'],
        bhk: json['bhk'],
        budget: json['budget'],
        place: json['place'],
        floor_option: json['floor_option'],
        Additional_Info: json['Additional_Info'],
        Shifting_date: json['Shifting_date'],
        Current_date: json['Current__Date'],
        Parking: json['Parking'],
        Gadi_Number: json['Gadi_Number'],
        FeildWorker_Name: json['FeildWorker_Name'],
        FeildWorker_Number: json['FeildWorker_Number'],
        Current__Date: json['Current__Date'],
        Family_Members: json['Family_Members'],
        buyrent: json['Buy_rent']);
  }
}

class Tenant_demands extends StatefulWidget {
  const Tenant_demands({super.key});

  @override
  State<Tenant_demands> createState() => _Tenant_demandsState();
}

class _Tenant_demandsState extends State<Tenant_demands> {

  final TenantController tenantController = Get.put(TenantController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Obx(() {
        if (tenantController.tenantList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final reversedList = tenantController.filteredList;


        return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) => tenantController.searchText.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search tenant name, place, BHK...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: tenantController.searchText.value.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        tenantController.searchText.value = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              if (reversedList.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "No matching result found.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Total Result: ${reversedList.length}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

        Expanded(
        child: RefreshIndicator(
          onRefresh: () => tenantController.fetchTenants(
            tenantController.number, // call API again
          ),
          child: ListView.builder(
            itemCount: reversedList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, index) {
              final item = reversedList[index];
              int displayIndex = reversedList.length - index;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Tenant_Demands_details(
                        idd: '${item.id}',
                        pending_id: '0',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// First Row: BHK - Buy/Rent - Place
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTag(
                              icon: PhosphorIcons.house,
                              text: item.bhk,
                              borderColor: Colors.red,
                              iconColor: Colors.red,
                            ),
                            _buildTag(
                              text: item.buyrent,
                              borderColor: Colors.blue,
                            ),
                            _buildTag(
                              text: item.place,
                              borderColor: Colors.green,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Name Row
                        Center(
                          child: _buildTag(
                            text: item.V_name,
                            borderColor: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            horizontalPadding: 40,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// Budget + Shifting Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTag(
                                icon: PhosphorIcons.currency_inr,
                                text: "Budget : ${item.budget}",
                                borderColor: Colors.blue,
                                iconColor: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTag(
                                text: "Shifting: ${item.Shifting_date}",
                                borderColor: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Tenant ID + Demand No
                        Row(
                          children: [
                            Expanded(
                              child: _buildTag(
                                text: "Tenant id = ${item.id}",
                                borderColor: Colors.lightGreenAccent,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTag(
                                text: "Demand No = $displayIndex",
                                borderColor: Colors.brown,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
        ]
    );
      }
      ),
        floatingActionButton:
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),

                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_Tenant_num()));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 5,),
                      Text("Add Demand", style: const TextStyle(fontSize: 15),),
                    ],
                  ),),
              ],
            ),
            const SizedBox(height: 30,)
          ],
        )
        );
  }

  Widget _buildTag({
    String text = "",
    IconData? icon,
    Color borderColor = Colors.grey,
    Color? iconColor,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    double horizontalPadding = 10,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: iconColor ?? borderColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                fontWeight: fontWeight,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

