import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Administrator/Admin_future _property/BuildingHistoryPage.dart';
import '../Controller/Future_property_controller.dart';
import '../Custom_Widget/constant.dart';
import 'Add_commercial_property.dart';
import 'Add_futureProperty.dart';
import 'Add_plot_property.dart';
import 'Future_Property.dart';
import 'Future_property_details.dart';
import 'PlotShow.dart';
import 'commercialShow.dart';

class FuturePropertyTabPage extends StatefulWidget {
  const FuturePropertyTabPage({super.key});

  @override
  State<FuturePropertyTabPage> createState() =>
      _FuturePropertyTabPageState();
}

class _FuturePropertyTabPageState
    extends State<FuturePropertyTabPage>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;

  bool _isLoading = true;
  late FuturePropertyController controller;
  String _number = '';

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';

    controller = FuturePropertyController(_number);
    await controller.initialize();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // ← 4 tabs

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus();
        searchController.clear();
        isSearching = false;
        controller.refresh();
        setState(() {});
      }
    });
    _initialize();
  }

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(AppImages.verify, height: 65),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
        ),
      ),
      floatingActionButton: _tabController.index != 4
          ? FloatingActionButton.extended(
        onPressed: _showAddOptionsDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Forms",
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
      )
          : null, // ← no FAB on History tab

      body: Column(
        children: [
          const SizedBox(height: 10),

          // ── Tab Bar ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: isDark ? const Color(0xff2A2A2A) : Colors.black12,
              ),
            ),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              dividerColor: Colors.transparent,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isDark ? Colors.white : Colors.black,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              splashBorderRadius: BorderRadius.circular(30),
              labelColor: isDark ? Colors.black : Colors.white,
              unselectedLabelColor: isDark ? Colors.white70 : Colors.black87,
              labelStyle: const TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 13,
              ),
              tabs: const [
                Tab(text: "Buildings"),
                Tab(text: "Plots"),
                Tab(text: "Commercial"),
                Tab(text: "History"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Search bar — only on Buildings tab ──
          if (_tabController.index == 0) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  hintText: "Search building, owner, place...",
                  hintStyle: TextStyle(
                    fontFamily: "PoppinsMedium",
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.search,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600),
                    onPressed: () {
                      searchController.clear();
                      setState(() => isSearching = false);
                      controller.refresh();
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                    const BorderSide(color: Colors.blue, width: 1.2),
                  ),
                ),
                onChanged: (value) async {
                  setState(() {});
                  if (value.trim().isEmpty) {
                    setState(() => isSearching = false);
                    controller.refresh();
                    return;
                  }
                  setState(() => isSearching = true);
                  await controller.searchBuilding(value);
                },
              ),
            ),
            const SizedBox(height: 5),
          ],

          // ── Body ──
          Expanded(
            child: isSearching
                ? AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.properties.isEmpty) {
                  return const Center(child: Text("No results found"));
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.properties.length,
                    itemBuilder: (context, index) {
                      final property = controller.properties[index];
                      final isDark = Theme.of(context).brightness ==
                          Brightness.dark;
                      return GestureDetector(
                        onTap: () async {
                          final query = searchController.text;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Future_Property_details(
                                      idd: property.id.toString()),
                            ),
                          );
                          if (query.trim().isNotEmpty) {
                            await controller.searchBuilding(query);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: isDark
                                ? const Color(0xff1E1E1E)
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                property.images != null &&
                                    property.images!.isNotEmpty
                                    ? Image.network(
                                  "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images}",
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                  const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.image),
                                      )),
                                )
                                    : Container(
                                  height: 160,
                                  width: double.infinity,
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                                  child: const Icon(Icons.image,
                                      size: 40),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        property.propertyNameAddress ??
                                            "No Title",
                                        style: TextStyle(
                                          fontFamily: "PoppinsMedium",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16,
                                              color: Colors.red),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              "${property.place ?? "-"}",
                                              style: TextStyle(
                                                fontFamily:
                                                "PoppinsMedium",
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.grey.shade400
                                                    : Colors
                                                    .grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _modernTag(
                                              property.id.toString(),
                                              isDark),
                                          _modernTag(
                                              property.buyRent, isDark),
                                          _modernTag(
                                              property
                                                  .residenceCommercial,
                                              isDark),
                                          _modernTag(
                                              property.roadSize != null
                                                  ? "Road ${property.roadSize}"
                                                  : null,
                                              isDark),
                                          _modernTag(
                                              property.ageOfProperty,
                                              isDark),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
                : TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const FrontPage_FutureProperty(),
                PlotListPage(fieldworkerNumber: _number),
                CommercialListPage(fieldWorkerNumber: _number),
                // ── History Tab ──
                HistoryPage(
                  fwNumber: _number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernTag(String? text, bool isDark) {
    if (text == null || text.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.blue.withOpacity(0.2)
            : Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark
              ? Colors.blue.shade300
              : Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "PoppinsMedium",
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  void _showAddOptionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;
        return DraggableScrollableSheet(
          initialChildSize: isTablet ? 0.4 : 0.52,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.white,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: isTablet ? 50 : 42,
                      height: isTablet ? 6 : 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'Form options',
                    style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(height: isTablet ? 10 : 8),
                  Text(
                    'Choose one of the options below to add a new forms.',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.grey[800],
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        _buildOptionTile(
                          icon: Icons.apartment,
                          title: 'Add Building',
                          subtitle: 'Add a new residential building',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const Add_FutureProperty()));
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        _buildOptionTile(
                          icon: Icons.landscape,
                          title: 'Add Plot',
                          subtitle: 'Add a new plot record',
                          onTap: () async {
                            Navigator.of(context).pop();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PropertyListingPage()),
                            );
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Plot added',
                                        style: TextStyle(
                                            fontSize: isTablet ? 16 : 14)),
                                    backgroundColor: Colors.green),
                              );
                            }
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        _buildOptionTile(
                          icon: Icons.storefront,
                          title: 'Add Commercial',
                          subtitle: 'Add a commercial property',
                          onTap: () async {
                            Navigator.of(context).pop();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommercialPropertyForm()),
                            );
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Commercial added',
                                        style: TextStyle(
                                            fontSize: isTablet ? 16 : 14)),
                                    backgroundColor: Colors.green),
                              );
                            }
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel',
                              style:
                              TextStyle(fontSize: isTablet ? 16 : 14)),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 22 : 16,
              vertical: isTablet ? 20 : 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: isTablet ? 64 : 52,
                  width: isTablet ? 64 : 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                        Colors.blueGrey.shade700,
                        Colors.blueGrey.shade900
                      ]
                          : [Colors.blue.shade400, Colors.blue.shade700],
                    ),
                  ),
                  child: Icon(icon,
                      color: Colors.white, size: isTablet ? 30 : 24),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                            fontSize: isTablet ? 19 : 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          )),
                      if (subtitle != null) ...[
                        const SizedBox(height: 6),
                        Text(subtitle,
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 13,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            )),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: isTablet ? 18 : 14,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}