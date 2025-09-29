import 'package:flutter/material.dart';

class AddRentedMain extends StatefulWidget {
  const AddRentedMain({super.key});

  @override
  State<AddRentedMain> createState() => _AddRentedMainState();
}

class _AddRentedMainState extends State<AddRentedMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Add Rented Main"))
        ],
      ),
    );
  }
}
