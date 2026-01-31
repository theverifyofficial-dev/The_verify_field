import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../../Custom_Widget/constant.dart';
import '../../utilities/bug_founder_fuction.dart';

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
  final String addharNumber;

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
    required this.addharNumber,
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
      addharNumber: json['addhar_number'] ?? '',
    );
  }
}

class AgreementCustomer extends StatefulWidget {
  const AgreementCustomer({Key? key}) : super(key: key);

  @override
  State<AgreementCustomer> createState() => _AgreementCustomerState();
}

class _AgreementCustomerState extends State<AgreementCustomer> {

  final String baseImageUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/";
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
    const apiUrl =
        'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/show_api_for_fetch_api.php';

    try {
      final res = await http.get(Uri.parse(apiUrl));

      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: apiUrl,
          error: "HTTP ${res.statusCode}",
          statusCode: res.statusCode,
        );
        return;
      }

      final decoded = json.decode(res.body);
      final List listData =
      decoded is List ? decoded : (decoded['data'] ?? []);

      allData = listData
          .map((e) => AgreementUser.fromJson(e))
          .toList()
          .reversed
          .toList(); // 🔥 latest first

      filteredData = allData;

      setState(() => loading = false);
    } catch (e) {
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: loading
          ? ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 6,
        itemBuilder: (_, __) => _skeletonCard(),
      )
          : RefreshIndicator(
        onRefresh: fetchAllData,
        child: CustomScrollView(
          slivers: [

            /// 🔢 TOTAL COUNT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                child: Row(
                  children: [
                    const Icon(Icons.people, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Total Customers: ${filteredData.length}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔍 SEARCH
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: applyFilter,
                  decoration: InputDecoration(
                    hintText: "Search name, phone, ID…",
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
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            /// 📋 LIST / EMPTY
            filteredData.isEmpty
                ? SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  "No data found",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => buildUserCard(
                  context,
                  filteredData[index],
                  index,
                ),
                childCount: filteredData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildUserCard(
      BuildContext context, AgreementUser user, int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [

            /// ID
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "ID: ${user.id}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          openFullImage(context, baseImageUrl + user.selfie),
                      child:CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade300,
                        child: ClipOval(
                          child: Image.network(
                            baseImageUrl + user.selfie,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;

                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "(${user.relation.toUpperCase()} ${user.relationPerson})",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// DETAILS
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _infoRow(Icons.phone, "Phone", user.mobile),
                      _infoRow(Icons.fingerprint, "Aadhar", user.addharNumber),

                      const SizedBox(height: 6),

                      const Text(
                        "ADDRESS",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.address,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// AADHAR IMAGES
                Row(
                  children: [
                    Expanded(
                      child: buildImageCard(
                        context,
                        "Aadhar Front",
                        baseImageUrl + user.aadhaarFront,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildImageCard(
                        context,
                        "Aadhar Back",
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageCard(
      BuildContext context, String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => openFullImage(context, imageUrl),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: RepaintBoundary(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> downloadAndSaveImage(String imageUrl) async {
  try {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: "Permission denied");
      return;
    }

    final response = await Dio().get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final result = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: "agreement_${DateTime.now().millisecondsSinceEpoch}",
    );

    Fluttertoast.showToast(
      msg: result['isSuccess'] == true
          ? "Image saved to gallery ✅"
          : "Save failed ❌",
    );
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}

void openFullImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierColor: Colors.black,
    builder: (_) => Material(
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
          Positioned(
            top: 12,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () => downloadAndSaveImage(imageUrl),
            ),
          ),
        ],
      ),
    ),
  );
}

class ImageGallerySaverPlus {
  static const MethodChannel _channel =
  MethodChannel('image_gallery_saver_plus');

  static Future<dynamic> saveImage(
      Uint8List imageBytes, {
        int quality = 80,
        String? name,
      }) async {
    return _channel.invokeMethod('saveImageToGallery', {
      'imageBytes': imageBytes,
      'quality': quality,
      'name': name,
    });
  }
}

Widget _skeletonCard() {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(height: 14, width: 140),
                    const SizedBox(height: 8),
                    _shimmerBox(height: 12, width: 180),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _shimmerBox(height: 60, width: double.infinity),
        ],
      ),
    ),
  );
}

Widget _shimmerBox({required double height, required double width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
