import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Custom_Widget/property_preview.dart';
import 'InsuranceShowListPage.dart';
import 'UpdateInsuranceForm Screen.dart';

class InsuranceDetailScreen extends StatefulWidget {
  final int insuranceId;

  const InsuranceDetailScreen({
    super.key,
    required this.insuranceId,
  });

  @override
  State<InsuranceDetailScreen> createState() =>
      _InsuranceDetailScreenState();
}

class _InsuranceDetailScreenState extends State<InsuranceDetailScreen> {

  final PageController _pageController = PageController();
  int currentPage = 0;

  bool isLoading = true;
  InsuranceModel? insurance;

  String? userName;
  String? userNumber;
  String? userStoredFAadharCard;
  String? userStoredLocation;

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedLocation = prefs.getString('location') ?? '';
    final storedFAadharCard = prefs.getString('post');

    // 🔥 PRINT DATA
    debugPrint("------ SHARED PREF DATA ------");
    debugPrint("Name: $storedName");
    debugPrint("Number: $storedNumber");
    debugPrint("Location: $storedLocation");
    debugPrint("Post: $storedFAadharCard");
    debugPrint("------------------------------");

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
        userStoredFAadharCard = storedFAadharCard;
        userStoredLocation = storedLocation;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fetchDetails();
    loadUserName();
    fetchMultipleImages();
  }
  String insuranceBaseUrl =
      "https://verifyserve.social/PHP_Files/"
      "insurance_insert_api/insurance_details/";

  List<String> multipleImages = [];

  Future<void> fetchMultipleImages() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/PHP_Files/"
              "insurance_insert_api/insurance_details/"
              "show_insurance_multiple_image.php?subid=${widget.insuranceId}"));

      final decoded = jsonDecode(response.body);
      print("show_insurance_multiple_image ${response.body}");
      print("show_insurance_multiple_image ${widget.insuranceId}");
      if (decoded['success'] == true) {
        final List data = decoded['data'];

        multipleImages =
            data.map((e) => insuranceBaseUrl + e['car_images']).toList();
      }
    } catch (e) {
      debugPrint("Multiple Image Error: $e");
    }

    if (mounted) setState(() {});
  }

  Future<void> fetchDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/PHP_Files/"
              "insurance_insert_api/insurance_details/"
              "show_api_for_details_page.php?id=${widget.insuranceId}"));

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == "success") {
        insurance = InsuranceModel.fromJson(decoded['data'][0]);
      }
    } catch (e) {
      debugPrint("Detail Error: $e");
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _refreshPage() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      fetchDetails(),
      fetchMultipleImages(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  // String _formatCreatedDate(String? date) {
  //   if (date == null || date.isEmpty) return "-";
  //
  //   try {
  //     final parsed =
  //     DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
  //     return DateFormat("dd MMM yyyy, hh:mm a").format(parsed);
  //   } catch (e) {
  //     return date;
  //   }
  // }

  Widget policyHolderCard(InsuranceModel item) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2433)   // Dark mode card
            : const Color(0xffF5F6F8),  // Light mode card
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.8)
                : Colors.black.withOpacity(.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE + BADGE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                "Policy Holder",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xffD4AF37)
                      : Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified,
                  color: isDark ? Colors.black : Colors.orange,
                  size: 16,
                ),
              )
            ],
          ),

          const SizedBox(height: 18),

          /// USER INFO
          Row(
            children: [

              /// AVATAR
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? const Color(0xffD4AF37)
                        : Colors.amber,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: isDark
                      ? const Color(0xff121212)
                      : Colors.grey.shade200,
                  child: Icon(
                    Icons.person,
                    color: isDark
                        ? const Color(0xffA0A0A0)
                        : Colors.grey,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    item.name ?? "-",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    "Privilege Member since 2021",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xffB8860B)
                          : Colors.grey,
                    ),
                  )
                ],
              )
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            color: isDark
                ? const Color(0xff2E3A4E)
                : Colors.grey.shade300,
          ),

          const SizedBox(height: 14),

          /// EMAIL
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 18,
                color: isDark
                    ? const Color(0xffA0A0A0)
                    : Colors.grey.shade700,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "EMAIL ADDRESS",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: isDark
                            ? const Color(0xffA0A0A0)
                            : Colors.grey,
                      ),
                    ),

                    Text(
                      item.emailId ?? "-",
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 14),

          /// PHONE
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                size: 18,
                color: isDark
                    ? const Color(0xffA0A0A0)
                    : Colors.grey.shade700,
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "PRIMARY CONTACT",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: isDark
                          ? const Color(0xffA0A0A0)
                          : Colors.grey,
                    ),
                  ),

                  Text(
                    item.number ?? "-",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget vehicleSpecCard(InsuranceModel item) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2433)   // Dark mode card
            : const Color(0xffF5F6F8),  // Light mode card
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.8)
                : Colors.black.withOpacity(.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            "Vehicle Specifications",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 18),

          /// ROW 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              specItem("DRIVE TYPE", item.vehicleType, isDark),

              specItem("FUEL SOURCE", item.fuelType, isDark),
            ],
          ),

          const SizedBox(height: 18),

          /// ROW 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              specItem("REGISTRATION", item.vehicleNumber, isDark),

              specItem("ENGINE REF.", item.vehicle_category, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget specItem(String title, String? value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            color: isDark
                ? const Color(0xffA0A0A0)
                : Colors.grey,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value ?? "-",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xff111827),
          ),
        ),
      ],
    );
  }

  Widget currentPolicyCard(InsuranceModel item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff0F172A),
            Color(0xff1E293B),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "CURRENT POLICY",
                style: TextStyle(
                  color: Color(0xffFACC15),
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// EXPIRING BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: const Text(
                  "EXPIRING\nSOON",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: Color(0xffFACC15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// POLICY NAME
          const Text(
            "Comprehensive Plus",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          /// SMALL INFO CARDS
          Row(
            children: [

              /// RENEWAL DATE CARD
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "RENEWAL DUE",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.nextRenewDate ?? "-",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// CLAIM BONUS CARD
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "CLAIM BONUS",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item.claim ?? "No Claims",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget documentsGrid(InsuranceModel item) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final docs = [

      {"title": "Car Photo", "url": item.carPhotoUrl, "tag": "VEHICLE"},
      {"title": "RC Front", "url": item.rcFrontUrl, "tag": "REGISTRATION"},
      {"title": "RC Back", "url": item.rcBackUrl, "tag": "REGISTRATION"},
      {"title": "Aadhar Front", "url": item.aadharFrontUrl, "tag": "IDENTITY"},
      {"title": "Aadhar Back", "url": item.aadharBackUrl, "tag": "IDENTITY"},
      {"title": "Old Policy", "url": item.oldPolicyUrl, "tag": "INSURANCE"}, // ✅ ADD THIS
      {"title": "Pollution", "url": item.pollutionPhotoUrl, "tag": "COMPLIANCE"},

    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),

      itemCount: docs.length,

      itemBuilder: (_, i) {

        final doc = docs[i];
        final imageUrl = doc["url"];

        return GestureDetector(
          onTap: () {

            if (imageUrl != null && imageUrl.toString().isNotEmpty) {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PropertyPreview(ImageUrl: imageUrl),
                ),
              );

            }

          },

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(.6)
                      : Colors.black.withOpacity(.08),
                  blurRadius: 10,
                )
              ],
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),

              child: Stack(
                children: [

                  /// IMAGE OR PLACEHOLDER
                  Positioned.fill(
                    child: imageUrl != null && imageUrl.toString().isNotEmpty

                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,

                      loadingBuilder: (context, child, progress) {

                        if (progress == null) return child;

                        return Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      },

                      errorBuilder: (_, __, ___) {

                        return Container(
                          color: isDark
                              ? const Color(0xff1A2433)
                              : Colors.grey.shade200,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(
                                Icons.insert_drive_file_rounded,
                                size: 40,
                                color: isDark
                                    ? Colors.white54
                                    : Colors.grey,
                              ),

                              const SizedBox(height: 6),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  doc["title"]!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )

                    /// IF IMAGE URL EMPTY
                        : Container(
                      color: isDark
                          ? const Color(0xff1A2433)
                          : Colors.grey.shade200,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.insert_drive_file,
                            size: 40,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey,
                          ),

                          const SizedBox(height: 6),

                          Text(
                            doc["title"]!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white60
                                  : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  /// OVERLAY ONLY IF IMAGE EXISTS
                  if (imageUrl != null && imageUrl.toString().isNotEmpty)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                  /// TAG
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        doc["tag"]!,
                        style: const TextStyle(
                          color: Color(0xffFACC15),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  /// TITLE
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      doc["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget multipleImagesGallery() {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (multipleImages.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 16),

        Text(
          "Car Gallery",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 110,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: multipleImages.length,

            itemBuilder: (context, index) {

              final imageUrl = multipleImages[index];

              return GestureDetector(

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullImageViewer(
                        images: multipleImages,
                        initialIndex: index,
                      ),
                    ),
                  );

                },

                child: Container(
                  margin: const EdgeInsets.only(right: 12),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),

                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      gaplessPlayback: true,

                      /// LOADING
                      loadingBuilder: (context, child, progress) {

                        if (progress == null) return child;

                        return SizedBox(
                          height: 110,
                          width: 110,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      },

                      /// ERROR IMAGE
                      errorBuilder: (_, __, ___) {

                        return Container(
                          height: 110,
                          width: 110,
                          color: isDark
                              ? const Color(0xff1A2433)
                              : Colors.grey.shade200,
                          child: Icon(
                            Icons.broken_image,
                            color: isDark
                                ? Colors.white54
                                : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget nomineeCard(InsuranceModel item) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2433)   // dark card
            : const Color(0xffF5F6F8),  // light card
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.8)
                : Colors.black.withOpacity(.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            "Nomine",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              /// ICON BOX
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.orange.withOpacity(.15)
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 14),

              /// NOMINEE INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      item.nomineeName ?? "-",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "${item.nomineeRelation ?? "-"} • ${item.nomineeAge ?? "-"} Years",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xffA0A0A0)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              /// SHARE SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Text(
                    "SHARE",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: isDark
                          ? const Color(0xffA0A0A0)
                          : Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.orange.withOpacity(.15)
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "100%",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget agentCallCard() {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2433)
            : const Color(0xffF5F6F8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.8)
                : Colors.black.withOpacity(.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [

          /// AGENT AVATAR
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor:
              isDark ? const Color(0xff121212) : Colors.grey.shade200,
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),

          const SizedBox(width: 14),

          /// AGENT INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "DEDICATED AGENT",
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: isDark
                        ? const Color(0xffA0A0A0)
                        : Colors.grey,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  insurance?.fieldWorkerName ?? "Agent",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                Text(
                  insurance?.fieldWorkerNumber ?? "-",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xffA0A0A0)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// CALL BUTTON
          // GestureDetector(
          //   onTap: () async {
          //
          //     final phone = insurance?.fieldWorkerNumber ?? "";
          //
          //     final Uri url = Uri.parse("tel:$phone");
          //
          //     if (await canLaunchUrl(url)) {
          //       await launchUrl(url);
          //     }
          //
          //   },
          //   child: Container(
          //     height: 46,
          //     width: 46,
          //     decoration: BoxDecoration(
          //       color: isDark
          //           ? const Color(0xffD4AF37)   // gold button dark mode
          //           : const Color(0xff0F172A),  // dark button light mode
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(.25),
          //           blurRadius: 8,
          //         )
          //       ],
          //     ),
          //     child: Icon(
          //       Icons.call,
          //       color: isDark ? Colors.black : Colors.white,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget currentDateCard(String? date) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2433)
            : const Color(0xffF5F6F8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(.8)
                : Colors.black.withOpacity(.3 ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [

          /// DATE ICON BOX
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.blue.withOpacity(.15)
                  : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 14),

          /// DATE INFO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "CREATED DATE",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  color: isDark
                      ? const Color(0xffA0A0A0)
                      : Colors.grey,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                date ?? "-",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white
                      : const Color(0xff111827),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (insurance == null) {
      return const Scaffold(
        body: Center(child: Text("No Data Found")),
      );
    }

    final item = insurance!;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A192F) : Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: CustomScrollView(
          slivers: [
            /// ✅ HERO HEADER
        //     PageController _pageController = PageController();
        // int currentPage = 0;

        SliverAppBar(
        expandedHeight: 250,
        pinned: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,

        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [

              /// PAGE VIEW (BETTER THAN CAROUSEL FOR DELETE)
              multipleImages.isEmpty
                  ? Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              )
                  : PageView.builder(
                controller: _pageController,
                itemCount: multipleImages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {

                  final imageUrl = multipleImages[index];

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    gaplessPlayback: true,

                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),

              /// PAGINATION DOTS
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    multipleImages.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentPage == index ? 10 : 6,
                      height: currentPage == index ? 10 : 6,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Colors.white
                            : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              /// TOP BUTTONS
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    _circleButton(Icons.arrow_back_ios_new, () {
                      Navigator.pop(context);
                    }),

                    if (userStoredFAadharCard == "FieldWorkar")
                      _circleButton(Icons.edit, () async {

                        final refreshed = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UpdateInsuranceFormScreen(item: item),
                          ),
                        );

                        if (refreshed == true) {
                          _refreshPage();
                        }

                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

            /// ✅ CONTENT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ✅ FLOATING RENEWAL CARD
                    // Transform.translate(
                    //   offset: const Offset(0, -40),
                    //   child: _renewalGlassCard(item),
                    // ),
                    const SizedBox(height: 8),

                    /// ✅ CUSTOMER CARD
                    /// ✅ CUSTOMER CARD
                    // _premiumCard(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       _sectionTitle("Customer Profile"),
                    //       const SizedBox(height: 12),
                    //
                    //       _infoRow("Name", item.name),
                    //       _infoRow("Phone", item.number),
                    //       _infoRow("Email", item.emailId),
                    //
                    //       const SizedBox(height: 10),
                    //
                    //       _infoRow("Claim Status", item.claim),
                    //     ],
                    //   ),
                    // ),

                    policyHolderCard(item),

                    SizedBox(height: 16),

                    vehicleSpecCard(item),

                    SizedBox(height: 16),

                    currentPolicyCard(item),

                    SizedBox(height: 16),

                    nomineeCard(item),

                    SizedBox(height: 16),

                    currentDateCard(item.current_dates),

                    SizedBox(height: 14),

                    documentsGrid(item),

                    // SizedBox(height: 16),
                    //
                    // multipleImagesGallery(),

                    SizedBox(height: 16),

                    agentCallCard(),

                     SizedBox(height: 14),




                    /// ✅ VEHICLE CARD
                    // _premiumCard(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       _sectionTitle("Vehicle Details"),
                    //       const SizedBox(height: 12),
                    //
                    //       _infoRow("Vehicle No", item.vehicleNumber),
                    //
                    //       const SizedBox(height: 10),
                    //
                    //       _infoRow("Pollution", item.pollutionYesNo),
                    //
                    //       const SizedBox(height: 10),
                    //
                    //       Positioned(
                    //         bottom: 30,
                    //         left: 20,
                    //         right: 20,
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //
                    //             Container(
                    //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    //               decoration: BoxDecoration(
                    //                 color: Colors.green,
                    //                 borderRadius: BorderRadius.circular(20),
                    //               ),
                    //               child: Text(
                    //                 "POLICY ACTIVE",
                    //                 style: TextStyle(
                    //                   fontSize: 10,
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //
                    //             SizedBox(height: 8),
                    //
                    //             Text(
                    //               item.vehicle_category ?? "Vehicle",
                    //               style: TextStyle(
                    //                 fontSize: 26,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //
                    //             Text(
                    //               "${item.vehicleNumber}",
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //                 color: Colors.white70,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       _infoRow("Type", item.vehicleType),
                    //       _infoRow("Fuel", item.fuelType),
                    //       _infoRow("Created Date", _formatCreatedDate(item.current_dates)),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 14),
                    //
                    // _premiumCard(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       _sectionTitle("Nominee Details"),
                    //       const SizedBox(height: 12),
                    //
                    //       _infoRow("Nominee Name", item.nomineeName),
                    //       _infoRow("Relation", item.nomineeRelation),
                    //       _infoRow("Age", item.nomineeAge),
                    //     ],
                    //   ),
                    // ),


                    /// ✅ DOCUMENTS
                    // _sectionTitle("Documents"),
                    // const SizedBox(height: 10),
                    //
                    // _documentsGrid(item),
                    // if (multipleImages.isNotEmpty) ...[
                    //   const SizedBox(height: 16),
                    //
                    //   _sectionTitle("Car Gallery"),
                    //
                    //   const SizedBox(height: 10),
                    //
                    //   SizedBox(
                    //     height: 100,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: multipleImages.length,
                    //       itemBuilder: (context, index) {
                    //
                    //         final imageUrl = multipleImages[index];
                    //
                    //         return GestureDetector(
                    //
                    //           onTap: () {
                    //             Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                 builder: (context) => PropertyPreview(
                    //                   ImageUrl: imageUrl,
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //           child: Container(
                    //             margin: const EdgeInsets.only(right: 12),
                    //             child: ClipRRect(
                    //               borderRadius: BorderRadius.circular(16),
                    //               child: Image.network(
                    //                 imageUrl,
                    //                 height: 100,
                    //                 width: 100,
                    //                 fit: BoxFit.cover,
                    //
                    //                 loadingBuilder: (_, child, progress) {
                    //                   if (progress == null) return child;
                    //
                    //                   return const SizedBox(
                    //                     height: 100,
                    //                     width: 100,
                    //                     child: Center(
                    //                       child: SizedBox(
                    //                         height: 18,
                    //                         width: 18,
                    //                         child: CircularProgressIndicator(
                    //                           strokeWidth: 2,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //
                    //                 errorBuilder: (_, __, ___) =>
                    //                 const Icon(Icons.broken_image, color: Colors.red),
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ],
                    // const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // String _formatDate(String? date) {
  //   if (date == null || date.isEmpty) return "-";
  //
  //   try {
  //     final parsed = DateFormat("dd-MM-yyyy").parse(date);
  //     return DateFormat("dd MMM yyyy").format(parsed);
  //   } catch (e) {
  //     return date; // fallback
  //   }
  // }
  // /// ✅ RENEWAL CARD
  // Widget _renewalGlassCard(InsuranceModel item) {
  //   return Container(
  //     padding: const EdgeInsets.all(18),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(26),
  //       gradient: const LinearGradient(
  //         colors: [
  //           Color(0xFF4F46E5),
  //           Color(0xFF3B82F6),
  //         ],
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.blue.withOpacity(0.35),
  //           blurRadius: 18,
  //           offset: const Offset(0, 8),
  //         )
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //
  //         const Icon(Icons.event_available, color: Colors.white),
  //
  //         const SizedBox(width: 12),
  //
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //
  //               const Text(
  //                 "Upcoming Renewal",
  //                 style: TextStyle(
  //                   fontSize: 11,
  //                   color: Colors.white70,
  //                 ),
  //               ),
  //
  //               Text(
  //                 item.nextRenewDate ?? "No Renewal Date",
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontFamily: "PoppinsBold",
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         Container(
  //           padding: const EdgeInsets.symmetric(
  //               horizontal: 14, vertical: 8),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: Colors.white.withOpacity(0.2),
  //           ),
  //           child: const Text(
  //             "ACTIVE",
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontFamily: "PoppinsBold",
  //               color: Colors.white,
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _premiumCard({required Widget child}) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(22),
  //       color: isDark ? Colors.white10 : Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
  //           blurRadius: 12,
  //           offset: const Offset(0, 6),
  //         )
  //       ],
  //     ),
  //     child: child,
  //   );
  // }

  // Widget _infoRow(String label, String? value) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8),
  //     child: Row(
  //       children: [
  //
  //         Text(
  //           "$label : ",
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontFamily: "PoppinsMedium",
  //             color: isDark ? Colors.white54 : Colors.grey,
  //           ),
  //         ),
  //
  //         Expanded(
  //           child: Text(
  //             value == null || value.isEmpty ? "-" : value,
  //             style: TextStyle(
  //               fontSize: 13,
  //               fontFamily: "PoppinsMedium",
  //               color: isDark ? Colors.white : Colors.black87,
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.35),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
  // /// ✅ SECTION TITLE
  // Widget _sectionTitle(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 6),
  //     child: Text(
  //       title,
  //       style: const TextStyle(
  //         fontSize: 16,
  //         fontFamily: "PoppinsBold",
  //       ),
  //     ),
  //   );
  // }

  // /// ✅ DOCUMENT GRID
  // Widget _documentsGrid(InsuranceModel item) {
  //   return Wrap(
  //     spacing: 10,
  //     runSpacing: 10,
  //     children: [
  //       _docCard("Aadhaar Front", item.aadharFrontUrl),
  //       _docCard("Aadhaar Back", item.aadharBackUrl),
  //       _docCard("PAN Card", item.panCardPhotoUrl),
  //       _docCard("RC Front", item.rcFrontUrl),
  //       _docCard("RC Back", item.rcBackUrl),
  //       _docCard("Old Policy", item.oldPolicyUrl),
  //       _docCard("Pollution Certificate", item.pollutionPhotoUrl),
  //     ],
  //  );
  // }

  // Widget _docCard(String title, String? imageUrl) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => PropertyPreview(
  //             ImageUrl: "${imageUrl}",
  //           ),
  //         ),
  //       );
  //     },
  //
  //     child: Container(
  //       width: 110,
  //       height: 110,
  //       padding: const EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(16),
  //         color: Colors.white10,
  //       ),
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: imageUrl != null
  //                 ? ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: Image.network(
  //                 imageUrl,
  //                 fit: BoxFit.cover,
  //
  //                 /// ✅ SMALL LOADER
  //                 loadingBuilder: (context, child, progress) {
  //                   if (progress == null) return child;
  //
  //                   return const Center(
  //                     child: SizedBox(
  //                       height: 16,
  //                       width: 16,
  //                       child: CircularProgressIndicator(
  //                         strokeWidth: 4,
  //                         color: Colors.blue,
  //                       ),
  //                     ),
  //                   );
  //                 },
  //
  //                 /// ✅ ERROR STATE
  //                 errorBuilder: (_, __, ___) =>
  //                     Icon(Icons.image_rounded, color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey,size: 20,
  //                     ),
  //               ),
  //
  //             )
  //                 : const Icon(Icons.insert_drive_file, color: Colors.grey),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               fontSize: 10,
  //               fontFamily: "PoppinsMedium",
  //             ),
  //             textAlign: TextAlign.center,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class FullImageViewer extends StatelessWidget {

  final List images;
  final int initialIndex;

  const FullImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {

    PageController controller =
    PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          PageView.builder(
            controller: controller,
            itemCount: images.length,

            itemBuilder: (context, index) {

              return InteractiveViewer(
                minScale: 1,
                maxScale: 4,

                child: Center(
                  child: Image.network(
                    images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
