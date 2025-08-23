import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../ui_decoration_tools/constant.dart';
import 'Cancelled_Document_Request.dart';
import 'Pending_Payment_Document.dart';
import 'Prosessing_Document.dart';

class Pending_Document extends StatefulWidget {
  const Pending_Document({super.key});

  @override
  State<Pending_Document> createState() => _Pending_DocumentState();
}

class _Pending_DocumentState extends State<Pending_Document> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, true);

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
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Delete_Image()));
            },
            child: const Icon(
              PhosphorIcons.trash,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.all(3),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.red[500],
                  borderRadius: BorderRadius.circular(10),
                ),
                // ignore: prefer_const_literals_to_create_immutables
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Processing'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                Pending_Payment(),
                Processing_Document(),
                Cancelled_Document()
              ]),
            )
          ],
        ),
      ),

    );
  }
}
