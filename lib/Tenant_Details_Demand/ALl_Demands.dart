import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../Administrator/Administrator_main_tenantdemand.dart';
import '../Custom_Widget/constant.dart';


class Tenant_ALl_demands extends StatefulWidget {
  const Tenant_ALl_demands({super.key});

  @override
  State<Tenant_ALl_demands> createState() => _Tenant_ALl_demandsState();
}

class _Tenant_ALl_demandsState extends State<Tenant_ALl_demands>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

// TABLE 1
  int currentPage = 1;
  int totalPages = 1;
  int totalRecords = 0;
  bool hasNextPage = false;
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<TenantModel> _allData = [];
  List<TenantModel> _filteredData = [];

  String searchText = "";
  String _lastSearch = "";
  Timer? _debounce;

// TABLE 2
  int currentPage2 = 1;
  int totalPages2 = 1;
  int totalRecords2 = 0;
  bool hasNextPage2 = false;
  bool isLoading2 = false;

  final ScrollController _scrollController2 = ScrollController();
  final TextEditingController _searchController2 = TextEditingController();

  List<TenantDemand2Model> _allData2 = [];
  List<TenantDemand2Model> _filteredData2 = [];

  String searchText2 = "";
  String _lastSearch2 = "";
  Timer? _debounce2;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    fetchData();
    fetchData2();

    // TABLE 1 pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          hasNextPage &&
          !isLoading) {
        currentPage++;
        fetchData(isLoadMore: true);
      }
    });

    // TABLE 2 pagination
    _scrollController2.addListener(() {
      if (_scrollController2.position.pixels >=
          _scrollController2.position.maxScrollExtent - 200 &&
          hasNextPage2 &&
          !isLoading2) {
        currentPage2++;
        fetchData2(isLoadMore: true);
      }
    });

    // TABLE 1 search
    _searchController.addListener(() {
      _debounce?.cancel();

      _debounce = Timer(
        const Duration(milliseconds: 500),
        _onSearchChanged,
      );
    });

    // TABLE 2 search
    _searchController2.addListener(() {
      _debounce2?.cancel();

      _debounce2 = Timer(
        const Duration(milliseconds: 500),
        _onSearchChanged2,
      );
    });
  }

  Future<void> fetchData({bool isLoadMore = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/All_Tenant_Demand.php?page=$currentPage&search=${Uri.encodeComponent(searchText)}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final page = jsonData["pagination"];

      totalPages = page["total_pages"];
      totalRecords = page["total_records"];
      hasNextPage = page["has_next_page"];

      List<TenantModel> newList =
      (jsonData["data"] as List)
          .map((e) => TenantModel.FromJson(e))
          .toList();

      setState(() {
        if (isLoadMore) {
          _allData.addAll(newList);
        } else {
          _allData = newList;
        }

        _filteredData = List.from(_allData);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchData2({bool isLoadMore = false}) async {
    if (isLoading2) return;

    setState(() {
      isLoading2 = true;
    });

    try {
      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/"
            "Tenant_demand/All_Tenant_Demand_2nd_table.php"
            "?page=$currentPage2"
            "&search=${Uri.encodeComponent(searchText2)}",
      );

      debugPrint("SECOND TABLE API: $url");

      final response = await http.get(url);

      debugPrint("SECOND TABLE STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final page = jsonData["pagination"];

        if (page != null) {
          totalPages2 = page["total_pages"] ?? 1;
          totalRecords2 = page["total_records"] ?? 0;
          hasNextPage2 = page["has_next_page"] ?? false;
        }

        final List<TenantDemand2Model> newList =
        (jsonData["data"] as List)
            .map(
              (e) => TenantDemand2Model.fromJson(
            e as Map<String, dynamic>,
          ),
        )
            .toList();

        if (!mounted) return;

        setState(() {
          if (isLoadMore) {
            _allData2.addAll(newList);
          } else {
            _allData2 = newList;
          }

          _filteredData2 = List.from(_allData2);
        });
      } else {
        debugPrint(
          "SECOND TABLE API ERROR: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint(
        "Second Tenant Demand API Error: $e",
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading2 = false;
        });
      }
    }
  }

  void _onSearchChanged() async {
    final text = _searchController.text.trim();

    if (text == _lastSearch) return;

    _lastSearch = text;
    searchText = text;

    setState(() {
      currentPage = 1;
      hasNextPage = false;
      totalPages = 1;
      totalRecords = 0;

      _allData.clear();
      _filteredData.clear();
    });

    await fetchData();
  }

  void _onSearchChanged2() async {
    final text = _searchController2.text.trim();

    if (text == _lastSearch2) return;

    _lastSearch2 = text;
    searchText2 = text;

    setState(() {
      currentPage2 = 1;
      hasNextPage2 = false;
      totalPages2 = 1;
      totalRecords2 = 0;

      _allData2.clear();
      _filteredData2.clear();
    });

    await fetchData2();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _debounce2?.cancel();

    _scrollController.dispose();
    _scrollController2.dispose();

    _searchController.dispose();
    _searchController2.dispose();

    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Column(
          children: [
            AppBar(
              surfaceTintColor: Colors.black,
              centerTitle: true,
              backgroundColor: Colors.black,
              title: Image.asset(AppImages.verify, height: 75),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          PhosphorIconsRegular.caretLeft,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              actions:  [
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
                  },
                  child: Icon(
                    PhosphorIcons.image(),
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  Lottie.asset("assets/images/no data.json",width: 450),
                Text("Tenant Demands",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
              ],
            ),
          ],
        ),),
      body: Column(
        children: [

          // TOTAL COUNTS
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Tenant Demand",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          totalRecords.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Tenant Demand 2",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          totalRecords2.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),


          TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: "Tenant Demand",
              ),
              Tab(
                text: "Tenant Demand 2",
              ),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [

                // TAB 1
                _buildFirstTable(),

                // TAB 2
                _buildSecondTable(),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstTable() {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search Tenant Demand",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: Text(
            searchText.isEmpty
                ? "Total Tenant Demands : $totalRecords"
                : "Search Results : $totalRecords",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Expanded(
          child: _filteredData.isEmpty
              ? const Center(
            child: Text(
              "No Data Found!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          )
              : ListView.builder(
            controller: _scrollController,
            itemCount:
            _filteredData.length + (hasNextPage ? 1 : 0),
            itemBuilder: (context, index) {

              if (index == _filteredData.length) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final item = _filteredData[index];

              // ⬇️ KEEP YOUR CURRENT TENANT CARD HERE
              return _buildTenantCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecondTable() {
    return Column(
      children: [

        // SEARCH
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController2,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Search Field Worker / Tenant",
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        // COUNT
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: Text(
            searchText2.isEmpty
                ? "Total Tenant Demands : $totalRecords2"
                : "Search Results : $totalRecords2",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // LIST
        Expanded(
          child: _filteredData2.isEmpty
              ? const Center(
            child: Text(
              "No Data Found!",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          )
              : ListView.builder(
            controller: _scrollController2,
            itemCount:
            _filteredData2.length +
                (hasNextPage2 ? 1 : 0),
            itemBuilder: (context, index) {

              // PAGINATION LOADER
              if (index == _filteredData2.length) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final item = _filteredData2[index];

              return _buildSecondTenantCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTenantCard(TenantModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 5, right: 5, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color:
                                    Colors.greenAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .greenAccent
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //SizedBox(width: 10,),
                                  Icon(
                                    PhosphorIcons.house(),
                                    size: 12,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "" +
                                        item.bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color:
                                    Colors.greenAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .greenAccent
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item.buyrent /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color:
                                    Colors.greenAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .greenAccent
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .place /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location_copy,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              " Name | Number",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.red),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.red
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .V_name /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(
                                        title: Text("Call " +
                                            item
                                                .V_name),
                                        content: Text(
                                            'Do you really want to Call? ' +
                                                item
                                                    .V_name),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20)),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(
                                                    context)
                                                    .pop(
                                                    false),
                                            child: Text('No'),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                () async {
                                              FlutterPhoneDirectCaller
                                                  .callNumber(
                                                  '${item.V_number}');
                                            },
                                            child:
                                            Text('Yes'),
                                          ),
                                        ],
                                      ),
                                ) ??
                                    false;
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 0,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      5),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.red),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.red
                                            .withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: Offset(0, 0),
                                        blurStyle:
                                        BlurStyle.outer),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.call,
                                      size: 15,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "" +
                                          item
                                              .V_number /*+abc.data![len].Building_Name.toUpperCase()*/,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.w500,
                                          letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location_copy,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Type Of Requirement / Floor Options",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.purple),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.purple),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .floor_option /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.car(),
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Need Parking / Vehicle Number",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.cyanAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.cyanAccent
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .Parking /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.cyanAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.cyanAccent
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .Gadi_Number
                                            .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.users(),
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Family Members = ",
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),

                            SizedBox(
                              width: 100,
                              child: Text(
                                "" +
                                    item
                                        .Family_Members +
                                    " Members",
                                overflow:
                                TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight:
                                    FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.addressBook(),
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Additional Information",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    "" +
                                        item
                                            .Additional_Info,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.addressBook(),
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Budget / Shifting Date",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.blue),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blue
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //SizedBox(width: 10,),
                                  Icon(
                                    PhosphorIcons
                                        .currencyInr(),
                                    size: 12,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "" +
                                        item
                                            .budget /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.blue),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.blue
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .Shifting_date /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            "Field Worker",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.purple),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.purple
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        item
                                            .FeildWorker_Name /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(
                                        title: Text(
                                            'Call Feild Worker'),
                                        content: Text(
                                            'Do you really want to Call Feild Worker?'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                20)),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(
                                                    context)
                                                    .pop(
                                                    false),
                                            child: Text('No'),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                () async {
                                              FlutterPhoneDirectCaller
                                                  .callNumber(
                                                  '${item.FeildWorker_Number}');
                                            },
                                            child:
                                            Text('Yes'),
                                          ),
                                        ],
                                      ),
                                ) ??
                                    false;
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 0,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      5),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.purple),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.purple
                                            .withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: Offset(0, 0),
                                        blurStyle:
                                        BlurStyle.outer),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    // Icon(Iconsax.sort_copy,size: 15,),
                                    //SizedBox(width: 10,),
                                    Text(
                                      "" +
                                          item
                                              .FeildWorker_Number /*+abc.data![len].Building_Name.toUpperCase()*/,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.w500,
                                          letterSpacing: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors
                                        .lightGreenAccent),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .lightGreenAccent
                                          .withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle:
                                      BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "Tenant id =  " +
                                        item.id
                                            .toString() /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight:
                                        FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 0,
                              bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .lightGreenAccent),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors
                                      .lightGreenAccent
                                      .withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                  blurStyle:
                                  BlurStyle.outer),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon(Iconsax.sort_copy,size: 15,),
                              //w SizedBox(width: 10,),
                              Text(
                                "" +
                                    item
                                        .Current_date
                                        .toString() /*+abc.data![len].Building_Name.toUpperCase()*/,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight:
                                    FontWeight.w500,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSecondTenantCard(
      TenantDemand2Model item) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --------------------------------
            // TOP ROW
            // --------------------------------

            Row(
              children: [

                _secondTag(
                  Icons.home_outlined,
                  item.bhk,
                  Colors.green,
                ),

                const SizedBox(width: 8),

                _secondTag(
                  Icons.swap_horiz,
                  item.buyRent,
                  Colors.green,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _secondTag(
                    Icons.location_on_outlined,
                    item.location,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --------------------------------
            // DEMAND NAME
            // --------------------------------

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Colors.red,
                ),
                const SizedBox(width: 4),
                const Text(
                  "Demand | ",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.demandName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // --------------------------------
            // DEMAND NUMBER
            // --------------------------------

            Row(
              children: [
                const SizedBox(width: 18),

                GestureDetector(
                  onTap: () {
                    _callNumber(
                      item.demandNumber,
                      "Call ${item.demandName}",
                    );
                  },
                  child: _secondTag(
                    Icons.phone,
                    item.demandNumber,
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --------------------------------
            // REQUIREMENT
            // --------------------------------

            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.red,
                ),
                SizedBox(width: 4),
                Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,

                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Text(
                item.addInfo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,

                ),
              ),
            ),

            const SizedBox(height: 10),

            // --------------------------------
            // REFERENCE
            // --------------------------------

            Row(
              children: [
                const Icon(
                  Icons.link,
                  size: 14,
                  color: Colors.red,
                ),
                const SizedBox(width: 4),
                const Text(
                  "Reference : ",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.reference,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --------------------------------
            // FEEDBACK / STATUS
            // --------------------------------

            Row(
              children: [

                _secondTag(
                  Icons.feedback_outlined,
                  item.feedback,
                  Colors.orange,
                ),

                const SizedBox(width: 8),

                _secondTag(
                  Icons.pending_outlined,
                  item.lookingType,
                  Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --------------------------------
            // FIELD WORKER
            // --------------------------------

            const Center(
              child: Text(
                "Field Worker",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Row(
              children: [

                Expanded(
                  child: _secondTag(
                    Icons.person_outline,
                    item.fieldworkarName,
                    Colors.purple,
                  ),
                ),

                const SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    _callNumber(
                      item.fieldworkarNumber,
                      "Call ${item.fieldworkarName}",
                    );
                  },
                  child: _secondTag(
                    Icons.phone,
                    item.fieldworkarNumber,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --------------------------------
            // ID
            // --------------------------------

            _secondTag(
              Icons.tag,
              "Tenant id = ${item.id}",
              Colors.lightGreen,
            ),

            const SizedBox(height: 10),

            // --------------------------------
            // DATE + TIME
            // --------------------------------

            Row(
              children: [

                _secondTag(
                  Icons.access_time,
                  item.dates,
                  Colors.blue,
                ),

                const SizedBox(width: 8),

                _secondTag(
                  Icons.calendar_today,
                  item.times,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondTag(
      IconData icon,
      String text,
      Color borderColor,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: borderColor,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callNumber(
      String number,
      String title,
      ) async {
    final shouldCall = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            "Do you really want to Call?",
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (shouldCall == true) {
      await FlutterPhoneDirectCaller.callNumber(number);
    }
  }

}