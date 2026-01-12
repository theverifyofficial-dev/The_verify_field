import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:verify_feild_worker/constant.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';



/// =======================
/// MODEL
/// =======================

class AgreementUser {
  final String id;
  final String name;
  final String relation;
  final String relationPerson;
  final String address;
  final String mobile;
  final String selfie;
  final String aadhaarFront;
  final String aadhaarBack;
  final String addhar_number;

  AgreementUser({
    required this.id,
    required this.name,
    required this.relation,
    required this.relationPerson,
    required this.address,
    required this.mobile,
    required this.selfie,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.addhar_number
  });

  factory AgreementUser.fromJson(Map<String, dynamic> json) {
    return AgreementUser(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
      relationPerson: json['relation_person_name'] ?? '',
      address: json['addresss'] ?? '',
      mobile: json['mobile_number'] ?? '',
      selfie: json['selfie'] ?? '',
      aadhaarFront: json['addhar_front'] ?? '',
      aadhaarBack: json['addhar_back'] ?? '',
      addhar_number: json['addhar_number'] ?? '',
    );
  }
}


class AgreementYearlyDetail extends StatefulWidget {
  const AgreementYearlyDetail({Key? key}) : super(key: key);

  @override
  State<AgreementYearlyDetail> createState() => AgreementYearlyDetailState();
}

class AgreementYearlyDetailState extends State<AgreementYearlyDetail> {
  final String baseImageUrl =
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/";

  List<AgreementUser> allData = [];
  List<AgreementUser> filteredData = [];

  bool loading = true;
  String search = "";

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    const String apiUrl =
        'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/show_api_for_fetch_api.php';

    try {
      final url = Uri.parse(apiUrl);
      final res = await http.get(url);

      // ❌ HTTP ERROR
      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: apiUrl,
          error: "HTTP Error: ${res.statusCode}",
          statusCode: res.statusCode,
        );
        return;
      }

      final decoded = json.decode(res.body);

      List listData =
      decoded is List ? decoded : (decoded['data'] ?? []);

      allData =
          listData.map((e) => AgreementUser.fromJson(e)).toList();
      filteredData = allData;

      setState(() => loading = false);
    }

    // ❌ JSON / FORMAT ERROR
    catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode: 500,
      );

      setState(() => loading = false);
    }
  }


  void applyFilter(String value) {
    search = value.toLowerCase();
    setState(() {
      filteredData = search.isEmpty
          ? allData
          : allData.where((u) {
        return u.name.toLowerCase().contains(search) ||
            u.mobile.contains(search) ||
            u.id.contains(search) ||
            u.relation.toLowerCase().contains(search);
      }).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color:  Colors.white),

        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText:
                "Search",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      search = "";
                      filteredData = allData;
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: applyFilter,
            ),
          ),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return buildUserCard(
                  context,
                  filteredData[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// =======================
  /// CARD UI (UNCHANGED)
  /// =======================
  Widget buildUserCard(BuildContext context, AgreementUser user) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [

            /// ID BADGE
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "ID: ${user.id}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// SELFIE + DETAILS
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            openFullImage(
                              context,
                              baseImageUrl + user.selfie,
                            ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                          NetworkImage(baseImageUrl + user.selfie),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// ✅ NAME (FIRST LINE)
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6,),
                            /// ✅ RELATION (SECOND LINE - SLIGHTLY INDENTED)
                            Padding(
                              padding: const EdgeInsets.only(left: 2,),
                              child: Text(
                                "(${user.relation.toUpperCase()} ${user.relationPerson})",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 1),

                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1E),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// 📞 PHONE
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.phone, color: Colors.white70, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Phone: ${user.mobile}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  /// 🆔 AADHAR
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Icon(Icons.fingerprint, color: Colors.white70, size: 18),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Aadhar Number: ${user.addhar_number}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  /// 📍 ADDRESS
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.red, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ADDRESS:",
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                             Text(
                                              user.address,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),

                const SizedBox(height:1),

                /// AADHAAR IMAGES
                Row(
                  children: [
                    Expanded(
                      child: buildImageCard(
                        context,
                        "Aadhar card Front",
                        baseImageUrl + user.aadhaarFront,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildImageCard(
                        context,
                        "Aadhar card Back",
                        baseImageUrl + user.aadhaarBack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageCard(BuildContext context, String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => openFullImage(context, imageUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 4 / 3, // 👈 keeps image balanced
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Center(
                  child: Icon(Icons.broken_image, size: 24),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
/// =======================
/// FULL IMAGE VIEWER (ZOOM ONLY)
/// =======================
Future<void> downloadAndSaveImage(String imageUrl) async {
  try {
    // 🔐 Permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: "Permission denied");
      return;
    }

    // ⬇ Download image
    var response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    // 💾 Save to gallery
    final result = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: "agreement_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true) {
      Fluttertoast.showToast(msg: "Image saved to gallery ✅");
    } else {
      Fluttertoast.showToast(msg: "Failed to save image ❌");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: $e");
  }
}

void openFullImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black,
    builder: (_) => SafeArea(
      child: Material(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.network(imageUrl),
              ),
            ),

            /// ❌ CLOSE
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.close,
                    color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            /// ⬇ DOWNLOAD
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.download,
                    color: Colors.white, size: 28),
                onPressed: () {
                  downloadAndSaveImage(imageUrl);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
