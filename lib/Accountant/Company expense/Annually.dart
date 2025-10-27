import 'package:flutter/material.dart';

class Annually extends StatefulWidget {
  const Annually({super.key});

  @override
  State<Annually> createState() => _AnnuallyState();
}

class _AnnuallyState extends State<Annually> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Annually Expenses"),),);
  }
}
