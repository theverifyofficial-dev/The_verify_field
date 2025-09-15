import 'package:flutter/material.dart';

class DenyAgreement extends StatefulWidget {
  const DenyAgreement({super.key});

  @override
  State<DenyAgreement> createState() => _DenyAgreementState();
}

class _DenyAgreementState extends State<DenyAgreement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Center(
            child: Text('Denied Agreement Page'),
          )
        ],
      ),
    );
  }
}
