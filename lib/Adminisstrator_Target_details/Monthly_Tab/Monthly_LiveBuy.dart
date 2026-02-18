import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_LiveBuy.dart'
    show LiveMonthlyBuyModel;
import 'Monthly_under_detail/Monthlu_Livebuy_details.dart';

/// =======================
/// API FETCH (BUY ONLY)
/// =======================
Future<List<LiveMonthlyBuyModel>> fetchLiveMonthlyBuy(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_monthly_show.php?field_workar_number=$number",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Live Monthly API Error");
  }

  final decoded = json.decode(res.body);
  final List list = decoded['data'] ?? [];

  final buyOnly = list.where((e) => e['Buy_Rent'] == 'Buy').toList();

  return buyOnly.map((e) => LiveMonthlyBuyModel.fromJson(e)).toList();
}

/// =======================
/// UI SCREEN
/// =======================
class MonthlyLiveBuy extends StatefulWidget {
  final String number;

  const MonthlyLiveBuy({super.key, required this.number});

  @override
  State<MonthlyLiveBuy> createState() => _MonthlyLiveBuyState();
}

class _MonthlyLiveBuyState extends State<MonthlyLiveBuy> {
  late Future<List<LiveMonthlyBuyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchLiveMonthlyBuy(widget.number);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: FutureBuilder<List<LiveMonthlyBuyModel>>(
        future: futureData,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final list = snap.data ?? [];

          if (list.isEmpty) {
            return const Center(child: Text("No Live Buy Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final b = list[i];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LiveMonthlyBuyDetailScreen(p: b),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(

                        color: theme.cardColor,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ================= IMAGE =================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [

                            Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.image}",
                              height: 210,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            /// Gradient
                            Container(
                              height: 210,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(.65),
                                  ],
                                ),
                              ),
                            ),

                            /// Property Type Badge (Same as Rent)
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFA855F7),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "Buy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PoppinsBold",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            /// Verified Icon
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  color: Color(0xFFA855F7),
                                  size: 18,
                                ),
                              ),
                            ),

                            /// Title + Location
                            Positioned(
                              bottom: 18,
                              left: 18,
                              right: 18,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    b.furnishedUnfurnished,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.white70,
                                          size: 15),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          b.locations,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: Colors.white70,
                                            fontFamily:
                                            "PoppinsMedium",
                                          ),
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

                      const SizedBox(height: 14),

                      /// ================= DETAILS =================
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            /// Field Worker + Price (Same Layout)
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.fieldWorkerName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                        fontWeight:
                                        FontWeight.w600,
                                        fontFamily:
                                        "PoppinsMedium",
                                      ),
                                    ),
                                    Text(
                                      "(${b.fieldWorkerNumber})",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                        fontWeight:
                                        FontWeight.w500,
                                        fontFamily:
                                        "PoppinsMedium",
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "₹${b.askingPrice}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "PoppinsMedium",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// Chips Row
                            Row(
                              children: [
                                _LuxuryChip(
                                    Icons.square_foot,
                                    b.squareFit),
                                const SizedBox(width: 8),
                                _LuxuryChip(
                                    Icons.layers,
                                    b.floor),
                                const SizedBox(width: 8),
                                _LuxuryChip(
                                    Icons.local_parking,
                                    b.parking),
                              ],
                            ),

                            const SizedBox(height: 10),

                            if (b.facility.isNotEmpty)
                              Text(
                                b.facility,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                  color: Colors.grey,
                                  fontFamily: "PoppinsMedium",
                                ),
                              ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// =======================
/// CHIP (IDENTICAL)
/// =======================
class _LuxuryChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LuxuryChip(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFFA855F7)),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
              fontFamily: "PoppinsMedium",
            ),
          ),
        ],
      ),
    );
  }
}
