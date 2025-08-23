import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home_Screen_click/View_All_Details.dart';
import 'PAYMENT_DETAILS.dart';

class Catid {
  final int id;
  final String document_type;
  final String looking_type;
  final String amount;
  final String Subid;

  Catid(
      {required this.id,required this.document_type,required this.looking_type,required this.amount,required this.Subid});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['id'],
        looking_type: json['looking_type'],
        document_type: json['document_type'],
        amount: json['amount'],
        Subid: json['building_subid']);
  }
}

class Processing_Document extends StatefulWidget {
  const Processing_Document({super.key});

  @override
  State<Processing_Document> createState() => _Processing_DocumentState();
}

class _Processing_DocumentState extends State<Processing_Document> {

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_data_by_looking_property_police_verifycation_document?building_subid=Processing');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //await Future.delayed(Duration(seconds: 1));
      final List result = json.decode(response.body);
      return result.map((data) => Catid.FromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              FutureBuilder<List<Catid>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.hasError){
                    return Text('${snapshot.error}');
                  }
                  else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    // If the list is empty, show an empty image
                    return Center(
                      child: Column(
                        children: [
                          //  Lottie.asset("assets/images/no data.json",width: 450),
                          Center(child: Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),)),
                        ],
                      ),
                    );
                  }
                  else{

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => View_Details_Payment(id: '${snapshot.data![index].Subid}',),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            child: Container(
                                padding: EdgeInsets.only(right: 10,left: 10,top: 10,bottom: 10),
                                child: Container(
                                  padding: EdgeInsets.only(right: 15,left: 10,top: 15,bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(width: 1, color: Colors.grey),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          //Image(image: AssetImage('assets/images/history_icon.png'),width: 60),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 300,
                                                  child: Text('${snapshot.data![index].document_type}',maxLines: 4, style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.black,fontFamily: 'Poppins',letterSpacing: 1.5,overflow: TextOverflow.ellipsis),)),
                                            ],
                                          ),
                                          // Image(image: AssetImage('assets/images/outgoing_arrow.png'),width: 20,color: Colors.greenAccent),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          //Image(image: AssetImage('assets/images/history_icon.png'),width: 60),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 300,
                                                  child: Text('${snapshot.data![index].looking_type}...',maxLines: 4, style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.red,fontFamily: 'Poppins',letterSpacing: 1.5,overflow: TextOverflow.ellipsis),)),
                                            ],
                                          ),
                                          // Image(image: AssetImage('assets/images/outgoing_arrow.png'),width: 20,color: Colors.greenAccent),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          //Image(image: AssetImage('assets/images/history_icon.png'),width: 60),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 300,
                                                  child: Text('${snapshot.data![index].amount} including GST',maxLines: 4, style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.green,fontFamily: 'Poppins',letterSpacing: 1.5,overflow: TextOverflow.ellipsis),)),
                                            ],
                                          ),
                                          // Image(image: AssetImage('assets/images/outgoing_arrow.png'),width: 20,color: Colors.greenAccent),
                                        ],
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ),
                        );

                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
