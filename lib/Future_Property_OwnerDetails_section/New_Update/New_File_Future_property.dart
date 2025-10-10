import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../ui_decoration_tools/app_images.dart';

class Available_property extends StatefulWidget {
  const Available_property({super.key});

  @override
  State<Available_property> createState() => _Available_propertyState();
}

class _Available_propertyState extends State<Available_property> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.image,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      
      
    );
  }
}
