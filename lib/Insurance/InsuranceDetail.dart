import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'InsuranceShowListPage.dart';
import 'UpdateInsuranceForm Screen.dart';
import 'insurance_ui_kit.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';

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
  }
  // **2026-10-22 migration**: both the detail endpoint AND the base it
  // builds document/image URLs from now point at the NEW table's backend
  // (same migration as `InsuranceShowListPage.dart`'s top-level
  // `insuranceBaseUrl` -- kept as a separate field here since this class
  // already had its own copy of the constant rather than importing the
  // shared one). See "Vehicle_Info_API_Insurance_Redesign_Spec.md" §15.
  String insuranceBaseUrl =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/";

  List<String> multipleImages = [];

  /// **2026-10-22**: the new table's own detail endpoint already returns
  /// `car_images` (a list of relative paths) directly on the record
  /// itself -- there is no separate "multiple images" endpoint on this
  /// new backend the way the old table had one, so this just reads off
  /// whatever `fetchDetails()` already fetched instead of making a
  /// second network call to an endpoint that doesn't exist here.
  void _loadMultipleImagesFromRecord() {
    final images = insurance?.carImageUrls ?? const <String>[];
    multipleImages = images;
    if (mounted) setState(() {});
  }

  Future<void> fetchDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/"
              "show_api_details_page.php?id=${widget.insuranceId}"));

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true) {
        final data = decoded['data'];
        if (data is List && data.isNotEmpty) {
          insurance = InsuranceModel.fromJson(data.first as Map<String, dynamic>);
        } else if (data is Map<String, dynamic>) {
          insurance = InsuranceModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint("Detail Error: $e");
    }

    _loadMultipleImagesFromRecord();
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _refreshPage() async {
    setState(() {
      isLoading = true;
    });

    await fetchDetails();

    setState(() {
      isLoading = false;
    });
  }



  Widget _buildHeaderCarousel() {
    return Stack(
      fit: StackFit.expand,
      children: [
        multipleImages.isEmpty
            ? Container(
                color: InsColors.bg,
                child: const Center(
                  child: Icon(Icons.directions_car_filled_rounded,
                      color: InsColors.textMuted, size: 56),
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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: InsColors.bg,
                        child: const Icon(Icons.broken_image_rounded,
                            color: InsColors.textMuted, size: 40),
                      ),
                    ),
                  );
                },
              ),

        /// bottom gradient so the top buttons/dots stay legible over bright photos
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(.25),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(.35),
                  ],
                  stops: const [0, 0.25, 0.7, 1],
                ),
              ),
            ),
          ),
        ),

        if (multipleImages.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                multipleImages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentPage == index ? 9 : 6,
                  height: currentPage == index ? 9 : 6,
                  decoration: BoxDecoration(
                    color: currentPage == index ? Colors.white : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          top: 48,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleButton(Icons.arrow_back_ios_new_rounded, () {
                Navigator.pop(context);
              }),
              if (userStoredFAadharCard == "FieldWorkar")
                _circleButton(Icons.edit_rounded, () async {
                  final refreshed = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateInsuranceFormScreen(item: insurance!),
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
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.38),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget policyHolderCard(InsuranceModel item) {
    final ownerNumber = item.number;
    final hasOwnerNumber = ownerNumber != null && ownerNumber.trim().isNotEmpty;

    return InsSectionCard(
      title: "Policy Holder",
      icon: Icons.verified_user_rounded,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: InsColors.bg,
              child: const Icon(Icons.person_rounded, color: InsColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "-",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: InsColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.number ?? "-",
                    style: const TextStyle(fontSize: 13, color: InsColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (hasOwnerNumber) ...[
              GestureDetector(
                onTap: () => _callNumber(ownerNumber),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: InsColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.call_rounded, color: InsColors.success, size: 18),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _openWhatsApp(ownerNumber),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: InsColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.chat_rounded, color: InsColors.success, size: 18),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: InsColors.border),
        const SizedBox(height: 4),
        InsInfoRow(
          label: "Email Address",
          value: item.emailId ?? "",
          icon: Icons.email_outlined,
        ),
        InsInfoRow(label: "Extra Number", value: item.extraNumber ?? "", icon: Icons.contact_phone_outlined, copyable: true),
        InsInfoRow(label: "Calling Number", value: item.callingNumber ?? "", icon: Icons.call_outlined, copyable: true),
      ],
    );
  }

  // **2026-10-22 dedup**: "Insurance Valid Upto" used to duplicate the
  // exact same INSURANCE_UPTO value the "Insurance Policy Details"
  // dynamic section below already shows -- removed from here, leaving
  // only the manually-entered Claim status (not an RTO field, so it has
  // nowhere else to live). Hidden entirely when there's no claim on
  // file, same "no empty card" rule `nomineeCard` already follows.
  // `vehicleSpecCard` (Body Type / Fuel / Registration No. / Engine
  // Number) was removed outright in the same pass -- every one of its
  // rows duplicated a field the "Engine & Vehicle Specs" / "Registration
  // & Authority" dynamic sections already render.
  Widget currentPolicyCard(InsuranceModel item) {
    final hasClaim = item.claim != null && item.claim!.trim().isNotEmpty;
    if (!hasClaim) return const SizedBox.shrink();
    return InsSectionCard(
      title: "Claim Status",
      icon: Icons.workspace_premium_outlined,
      children: [
        InsInfoRow(label: "Insurance Claim", value: item.claim ?? "", icon: Icons.workspace_premium_outlined),
      ],
    );
  }

  Widget documentsGrid(InsuranceModel item) {
    final docs = [
      {"title": "Vehicle Photo", "url": item.carPhotoUrl},
      {"title": "RC Front", "url": item.rcFrontUrl},
      {"title": "RC Back", "url": item.rcBackUrl},
      {"title": "Aadhar Front", "url": item.aadharFrontUrl},
      {"title": "Aadhar Back", "url": item.aadharBackUrl},
      {"title": "PAN Card", "url": item.panCardPhotoUrl},
      {"title": "Old Policy", "url": item.oldPolicyUrl},
      {"title": "Driving License", "url": item.dlImgUrl},
      {"title": "New Policy", "url": item.newPolicyDocumentUrl},
      {"title": "Pollution", "url": item.pollutionPhotoUrl},
    ];

    // Only the documents that actually have an uploaded image are
    // swipeable in the full-screen viewer -- tapping any one of them
    // opens the viewer positioned on that document, and from there the
    // person can swipe through every other uploaded document too,
    // instead of being dropped into an isolated single-image view.
    final availableDocs = docs
        .where((d) => (d["url"] as String?)?.isNotEmpty == true)
        .map((d) => InsDocItem(title: d["title"] as String, url: d["url"] as String))
        .toList();

    return InsSectionCard(
      title: "Documents",
      icon: Icons.folder_copy_outlined,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final doc = docs[i];
            final imageUrl = doc["url"];
            final hasImage = imageUrl != null && imageUrl.toString().isNotEmpty;

            return GestureDetector(
              onTap: hasImage
                  ? () {
                      final startIndex = availableDocs.indexWhere((d) => d.title == doc["title"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InsDocumentViewer(
                            items: availableDocs,
                            initialIndex: startIndex < 0 ? 0 : startIndex,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: InsColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: InsColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasImage)
                      Image.network(
                        imageUrl.toString(),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => _docPlaceholder(doc["title"]!),
                      )
                    else
                      _docPlaceholder(doc["title"]!),
                    if (hasImage)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            doc["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _docPlaceholder(String title) {
    return Container(
      color: InsColors.bg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file_outlined, size: 30, color: InsColors.textMuted),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: InsColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget multipleImagesGallery() {
    if (multipleImages.isEmpty) {
      return const SizedBox();
    }

    return InsSectionCard(
      title: "Car Gallery",
      icon: Icons.photo_library_outlined,
      children: [
        SizedBox(
          height: 96,
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
                  margin: const EdgeInsets.only(right: 10),
                  width: 96,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 96,
                      height: 96,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: InsColors.bg,
                          width: 96,
                          height: 96,
                          child: const Center(
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: InsColors.bg,
                        width: 96,
                        height: 96,
                        child: const Icon(Icons.broken_image_rounded, color: InsColors.textMuted),
                      ),
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
    // Hide the whole card rather than showing a "Not provided"
    // placeholder when there's no nominee on file.
    final hasNominee = item.nomineeName != null && item.nomineeName!.isNotEmpty;
    if (!hasNominee) return const SizedBox.shrink();

    return InsSectionCard(
      title: "Nominee",
      icon: Icons.groups_rounded,
      children: [
        Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: InsColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.groups_rounded, color: InsColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nomineeName ?? "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: InsColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${item.nomineeRelation ?? "-"} • ${item.nomineeAge ?? "-"} Years",
                    style: const TextStyle(fontSize: 12, color: InsColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        InsInfoRow(label: "Marital Status", value: item.maritalStatus ?? "", icon: Icons.family_restroom_outlined),
      ],
    );
  }

  Future<void> _callNumber(String? number) async {
    if (number == null || number.trim().isEmpty) return;
    final uri = Uri(scheme: 'tel', path: number.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String? number) async {
    if (number == null || number.trim().isEmpty) return;
    final digits = number.trim().replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget agentCallCard() {
    final number = insurance?.fieldWorkerNumber;
    final hasNumber = number != null && number.trim().isNotEmpty;

    return InsSectionCard(
      title: "Dedicated Agent",
      icon: Icons.support_agent_rounded,
      children: [
        Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: InsColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person_rounded, color: InsColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insurance?.fieldWorkerName ?? "Agent",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: InsColors.textPrimary,
                    ),
                  ),
                  Text(
                    number ?? "-",
                    style: const TextStyle(fontSize: 12, color: InsColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (hasNumber)
              GestureDetector(
                onTap: () => _callNumber(number),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: InsColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.call_rounded, color: InsColors.success, size: 18),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget currentDateCard(String? date) {
    // Only a single row -- hide the whole card rather than leaving an
    // empty header showing when there's no date.
    if (date == null || date.trim().isEmpty) return const SizedBox.shrink();

    return InsSectionCard(
      title: "Created Date",
      icon: Icons.calendar_month_rounded,
      children: [
        InsInfoRow(label: "Created On", value: formatInsuranceDate(date), icon: Icons.schedule_rounded),
      ],
    );
  }

  @override
  // 2026-10-29, Building/Flat insurance-linking feature: "Go to
  // Building"/"Go to Flat" buttons on the Detail page itself -- previously
  // this navigation only existed on the field-worker List card (§34.3),
  // not here, even though InsuranceModel has carried buildingId/flatId
  // since §34. Only rendered when the record actually has a linked id.
  Widget _buildLinkageRow(InsuranceModel item) {
    if (!item.hasBuildingLink && !item.hasFlatLink) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (item.hasBuildingLink)
            OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Future_Property_details(idd: item.buildingId!)),
              ),
              icon: const Icon(Icons.apartment, size: 16),
              label: Text('Go to Building #${item.buildingId}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: InsColors.primary,
                side: const BorderSide(color: InsColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          if (item.hasFlatLink)
            OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => underflat_futureproperty(
                    id: item.flatId!,
                    Subid: '',
                    buildingId: item.buildingId,
                  ),
                ),
              ),
              icon: const Icon(Icons.door_front_door_outlined, size: 16),
              label: Text('Go to Flat #${item.flatId}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: InsColors.primary,
                side: const BorderSide(color: InsColors.primary),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: InsColors.bg,
        body: Center(child: CircularProgressIndicator(color: InsColors.primary)),
      );
    }

    if (insurance == null) {
      return const Scaffold(
        backgroundColor: InsColors.bg,
        body: Center(
          child: Text(
            "No Data Found",
            style: TextStyle(color: InsColors.textSecondary),
          ),
        ),
      );
    }

    final item = insurance!;

    return Scaffold(
      backgroundColor: InsColors.bg,
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        color: InsColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 240,
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: InsColors.bg,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderCarousel(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name ?? "Insurance Record",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: InsColors.textPrimary,
                            ),
                          ),
                        ),
                        if (item.vehicleNumber?.trim().isNotEmpty == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 2),
                            child: InsBadge(
                              label: item.vehicleNumber!,
                              tone: InsBadgeTone.primary,
                              icon: Icons.directions_car_filled_rounded,
                            ),
                          ),
                      ],
                    ),
                    if (item.blacklistStatus != null &&
                        item.blacklistStatus!.trim().isNotEmpty &&
                        !['NA', 'N/A', '-'].contains(item.blacklistStatus!.trim().toUpperCase()))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: InsBadge(
                          label: 'Blacklisted: ${item.blacklistStatus}',
                          tone: InsBadgeTone.error,
                        ),
                      ),
                    const SizedBox(height: 16),
                    // 2026-10-22 restyle: the dark gradient summary card
                    // the user asked to match from the reference RTO-
                    // lookup app, reading off the same RTO-keyed map the
                    // section cards below it use -- see
                    // `InsVehicleHeaderCard` in `insurance_ui_kit.dart`.
                    _buildLinkageRow(item),
                    InsVehicleHeaderCard(record: item.toVehicleInfoMap()),
                    policyHolderCard(item),
                    // Owner Name / Mobile Number / Owner Email are already
                    // shown above (header card + Policy Holder card) --
                    // excluded here so they don't repeat a 3rd/4th time in
                    // the "Owner & Contact Info" section below. Owner
                    // Serial No. is excluded too -- it's already in the
                    // header card's "Owner #<serial>" pill.
                    ...buildDynamicVehicleInfoSections(
                      item.toVehicleInfoMap(),
                      isFromApiPayload: false,
                      excludeApiKeys: const {
                        'OWNER_NAME',
                        'MOBILE_NO',
                        'owner_email',
                        'OWNER_SERIAL_NO',
                      },
                    ),
                    currentPolicyCard(item),
                    nomineeCard(item),
                    currentDateCard(item.current_dates),
                    documentsGrid(item),
                    multipleImagesGallery(),
                    agentCallCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
    PageController controller = PageController(initialPage: initialIndex);

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
