import 'package:flutter/material.dart';

class AdminDenied extends StatefulWidget {
  const AdminDenied({super.key});

  @override
  State<AdminDenied> createState() => _DenyAgreementState();
}

class _DenyAgreementState extends State<AdminDenied> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Denied Agreement Page'),
      ),
    );
  }
}
