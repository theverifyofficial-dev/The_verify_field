import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../ui_decoration_tools/constant.dart';

class Target_MainPage extends StatefulWidget {
  int Rented_target;
  int Rented_agrement_target;
  Target_MainPage({super.key, required this.Rented_target, required this.Rented_agrement_target});

  @override
  State<Target_MainPage> createState() => _Target_MainPageState();
}

class _Target_MainPageState extends State<Target_MainPage> {



  //int Rentproperty_Progress = rented; // Current progress
  final int Rentproperty_target = 5; // Target value

  int Sellprooperty_Progress = 3; // Current progress
  final int Sellprooperty_target = 4; // Target value

  int Insurance_Progress = 1; // Current progress
  final int Insurance_target = 5; // Target value

  int Vehicleadded_Progress = 70; // Current progress
  final int Vehicleadded_target = 100; // Target value

  //int lineProgress = 7; // Current progress value
  final int linetarget = 15; // Target value

  @override
  Widget build(BuildContext context) {
    double Rentproperty_percentage = widget.Rented_target / Rentproperty_target;
    double Sellprooperty_percentage = Sellprooperty_Progress / Sellprooperty_target;
    double Insurance_percentage = Insurance_Progress / Insurance_target;
    double Vehicleadded_percentage = Vehicleadded_Progress / Vehicleadded_target;
    double linepercentage = widget.Rented_agrement_target / linetarget;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
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
                PhosphorIcons.share,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              //_launchURL();
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.share,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                onTap: (){
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const motot_insurance_front()));*/
                },
                child: Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 60.0, // Circle size
                              lineWidth: 10.0, // Thickness
                              percent: Rentproperty_percentage.clamp(0.0, 1.0), // Clamp between 0 and 1
                              center: Text(
                                '${widget.Rented_target} / $Rentproperty_target',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              progressColor: Colors.redAccent, // Progress color
                              backgroundColor: Colors.grey.shade300, // Background color
                              circularStrokeCap: CircularStrokeCap.round, // Rounded edges
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          width: 135,
                          margin: EdgeInsets.only(right: 0, left: 0,bottom: 5),
                          child: Center(
                            child: Text("Rented Property",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              GestureDetector(
                onTap: (){
                  /*uploadImageWithTitle();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProgressScreen())
                  );*/
                },
                child: Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 60.0, // Circle size
                              lineWidth: 10.0, // Thickness
                              percent: Sellprooperty_percentage.clamp(0.0, 1.0), // Clamp between 0 and 1
                              center: Text(
                                '$Sellprooperty_Progress / $Sellprooperty_target',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              progressColor: Colors.purple, // Progress color
                              backgroundColor: Colors.grey.shade300, // Background color
                              circularStrokeCap: CircularStrokeCap.round, // Rounded edges
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          width: 135,
                          margin: EdgeInsets.only(right: 0, left: 0,bottom: 5),
                          child: Center(
                            child: Text("Sell Property",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              )

            ],
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              GestureDetector(
                onTap: (){
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const motot_insurance_front()));*/
                },
                child: Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 60.0, // Circle size
                              lineWidth: 10.0, // Thickness
                              percent: Insurance_percentage.clamp(0.0, 1.0), // Clamp between 0 and 1
                              center: Text(
                                '$Insurance_Progress / $Insurance_target',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              progressColor: Colors.orange, // Progress color
                              backgroundColor: Colors.grey.shade300, // Background color
                              circularStrokeCap: CircularStrokeCap.round, // Rounded edges
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          width: 135,
                          margin: EdgeInsets.only(right: 0, left: 0,bottom: 5),
                          child: Center(
                            child: Text("Insurance Target",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              GestureDetector(
                onTap: (){
                  /*uploadImageWithTitle();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProgressScreen())
                  );*/
                },
                child: Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Center(
                            child: CircularPercentIndicator(
                              radius: 60.0, // Circle size
                              lineWidth: 10.0, // Thickness
                              percent: Vehicleadded_percentage.clamp(0.0, 1.0), // Clamp between 0 and 1
                              center: Text(
                                '$Vehicleadded_Progress / $Vehicleadded_target',
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              progressColor: Colors.indigoAccent, // Progress color
                              backgroundColor: Colors.grey.shade300, // Background color
                              circularStrokeCap: CircularStrokeCap.round, // Rounded edges
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          width: 135,
                          margin: EdgeInsets.only(right: 0, left: 0,bottom: 5),
                          child: Center(
                            child: Text("Vehicle Added",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              )

            ],
          ),

          SizedBox(height: 20,),

      Card(
        color: Colors.white12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Progress Bar
              Text(
                '${(linepercentage * 100).toInt()}% Completed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Horizontal Progress Bar
              LinearProgressIndicator(
                value: linepercentage,
                minHeight: 10.0,
                color: Colors.blue,
                backgroundColor: Colors.grey.shade300,
              ),
              /*SizedBox(height: 10),
              Text(
                '${lineProgress.toInt()} / ${linetarget.toInt()}',
                style: TextStyle(fontSize: 18),
              ),*/

              const SizedBox(
                height: 20,
              ),

              Container(
                width: 350,
                margin: EdgeInsets.only(right: 0, left: 0,bottom: 5),
                child: Center(
                  child: Text("Police Verification / Rent Aggrement Target",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


        ],
      ),

    );
  }
}


