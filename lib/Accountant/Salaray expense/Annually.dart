import 'package:flutter/material.dart';

class Salary_Annually extends StatefulWidget {
  const Salary_Annually({super.key});

  @override
  State<Salary_Annually> createState() => _AnnuallyState();
}

class _AnnuallyState extends State<Salary_Annually> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Annually Salary"),),);
  }
}
