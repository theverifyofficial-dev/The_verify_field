import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Upcoming/update_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Rent Agreement/update_images.dart';
import '../constant.dart';
import '../property_preview.dart';
import 'package:shimmer/shimmer.dart';



class UpcomingPropertyImage {
  final int id;
  final String imagePath;
  final int subId;

  UpcomingPropertyImage({
    required this.id,
    required this.imagePath,
    required this.subId,
  });

  factory UpcomingPropertyImage.fromJson(Map<String, dynamic> json) {
    return UpcomingPropertyImage(
      id: int.tryParse(json['M_id'].toString()) ?? 0,
      imagePath: json['M_images'] ?? "",
      subId: int.tryParse(json['subid'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'M_id': id,
      'M_images': imagePath,
      'subid': subId,
    };
  }
}



class UpcomingDetailsPage extends StatefulWidget {
  final int id;
  const UpcomingDetailsPage({super.key, required this.id});

  @override
  State<UpcomingDetailsPage> createState() => _UpcomingDetailsPageState();
}

class _UpcomingDetailsPageState extends State<UpcomingDetailsPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  Future<List<UpcomingPropertyImage>>? _galleryFuture;
  bool _isLoading = false; // Add this state variable
  String? _status; // value from liveUnlive key
  Map<int, String> _statusMap = {}; // holds status for all IDs

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
    _galleryFuture = fetchUpcomingPropertyImages(widget.id); // pass _id here
  }

  Future<void> fetchPropertyDetails() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_details_page.php?P_id=${widget.id}");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded["status"] == "success" && decoded["data"].isNotEmpty) {
        setState(() {
          propertyData = decoded["data"][0];
          isLoading = false;
          final data = propertyData!;
          _status = data['live_unlive'];
        });
      }
    } else {
      throw Exception("Failed to load data");
    }
  }


  Future<List<UpcomingPropertyImage>> fetchUpcomingPropertyImages(int id) async {
    final url =
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_show_mumlitiple_image_api.php?subid=$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['status'] == 'success' && decoded['data'] != null) {
        final List<dynamic> imagesList = decoded['data'];
        return imagesList
            .map((item) => UpcomingPropertyImage.fromJson(item))
            .toList();
      } else {
        throw Exception("Invalid response structure: missing 'data' key");
      }
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }


  Widget infoRow(BuildContext context, String label, String? value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value?.isNotEmpty == true ? value! : "N/A",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionCard(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              )),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget buildGradientButton(BuildContext context,property_id) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.brightness == Brightness.dark
                    ? [Colors.blueGrey.shade700, Colors.indigo.shade400]
                    : [Colors.indigo.shade500, Colors.deepPurple.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateForm(propertyId: property_id ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Update",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 55,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.brightness == Brightness.dark
                    ? [Colors.blueGrey.shade700, Colors.indigo.shade400]
                    : [Colors.indigo.shade500, Colors.deepPurple.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Multi Image",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _toggleStatus() async {
    setState(() => _isLoading = true);
    final currentStatus = _status;
    try {
      if (currentStatus == "Book") {
        await _performAction("update");
        await _performAction("copy");
        _status = "Live";
      } else if (currentStatus == "Live") {
        await _performAction("reupdate");
        await _performAction("delete");
        _status = "Book";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Status changed to $_status"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 6, // number of shimmer placeholders
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }


  Future<void> _performAction(String action) async {
    final response = await http.post(
      Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/move_to_main_realestae.php"),
      body: {"action": action, "P_id": widget.id.toString()},
    );
    if (response.statusCode != 200) throw Exception("Failed $action");
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = propertyData!;
    final imageUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo']}";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
        surfaceTintColor: Colors.black,
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
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                FutureBuilder<List<UpcomingPropertyImage>>(
                  future: _galleryFuture,
                  builder: (context, gallerySnapshot) {
                    if (gallerySnapshot.connectionState == ConnectionState.waiting) {
                      return _buildImageShimmer();
                    } else if (gallerySnapshot.hasError) {
                      return Center(child: Text("Error loading gallery"));
                    } else if (!gallerySnapshot.hasData || gallerySnapshot.data!.isEmpty) {
                      return Center(child: Text("No images available"));
                    } else {
                      final images = gallerySnapshot.data!;
                      return SizedBox(
                        height: 100, // height of horizontal gallery
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final image = images[index];
                            final isDarkMode = Theme.of(context).brightness == Brightness.dark;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PropertyPreview(
                                      ImageUrl:
                                      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.imagePath}",
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.imagePath}",
                                  width: 120, // width of each thumbnail
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 120,
                                    height: 100,
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 120,
                                    height: 100,
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      color: isDarkMode ? Colors.white : Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),

                SizedBox(height: 12),


                Text(
                  "${data['Bhk']} • ${data['Typeofproperty'] ?? 'Property'}",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  data['locations'] ?? "",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                sectionCard(context, "Pricing", [
                  infoRow(context, "Show Price", data['show_Price']),
                  infoRow(context, "Asking Price", data['asking_price']),
                  infoRow(context, "Last Price", data['Last_Price']),
                ]),

                sectionCard(context, "Property Information", [
                  infoRow(context, "Flat Number", data['Flat_number']),
                  infoRow(context, "Total Floor", data['Total_floor']),
                  infoRow(context, "Balcony", data['Balcony']),
                  infoRow(context, "Square Feet", data['squarefit']),
                  infoRow(context, "Maintenance", data['maintance']),
                  infoRow(context, "Parking", data['parking']),
                  infoRow(context, "Age of Property", data['age_of_property']),
                  infoRow(context, "Metro Distance", data['metro_distance']),
                  infoRow(context, "Highway Distance", data['highway_distance']),
                  infoRow(context, "Main Market Distance", data['main_market_distance']),
                  infoRow(context, "Facility", data['Facility']),
                ]),

                sectionCard(context, "Owner Details", [
                  infoRow(context, "Owner Name", data['owner_name']),
                  infoRow(context, "Owner Number", data['owner_number']),
                  infoRow(context, "Care Taker Name", data['care_taker_name']),
                  infoRow(context, "Care Taker Number", data['care_taker_number']),
                ]),

                sectionCard(context, "Field Worker", [
                  infoRow(context, "Name", data['field_warkar_name']),
                  infoRow(context, "Number", data['field_workar_number']),
                  infoRow(context, "Address", data['fieldworkar_address']),
                  infoRow(context, "Current Location", data['field_worker_current_location']),
                ]),

                Container(
                  padding: const EdgeInsets.only(left: 12,right: 12,top: 10,bottom: 25),
                  height: 100,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? Colors.grey
                            : (_status == "Live"
                            ? Colors.grey // Live → Grey
                            : _status == "Book"
                            ? Colors.red // Book → Red
                            : Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: _isLoading || _status == null
                          ? null
                          : () async {
                        setState(() => _isLoading = true);

                        try {
                          if (_status == "Book") {
                            // Update + Copy
                            final updateResponse = await http.post(
                              Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php"),
                              body: {"action": "update", "P_id": widget.id.toString()},
                            );

                            final moveResponse = await http.post(
                              Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php"),
                              body: {"action": "copy", "P_id": widget.id.toString()},
                            );

                            if (updateResponse.statusCode == 200 &&
                                moveResponse.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Property updated & moved successfully!",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() => _status = "Live"); // flip after success
                            }
                          } else if (_status == "Live") {
                            // Reupdate + Delete
                            final updateResponse = await http.post(
                              Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php"),
                              body: {"action": "reupdate", "P_id": widget.id.toString()},
                            );

                            final deleteResponse = await http.post(
                              Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php"),
                              body: {"action": "delete", "source_id": widget.id.toString()},

                            );

                            if (deleteResponse.statusCode == 200) {
                              print('source_id ${widget.id}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Property UnLived successfully!",
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                              setState(() => _status = "Book"); // flip after success
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e"),
                                backgroundColor: Colors.red),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                      child: _isLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 18,
                            height: 30,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text("Processing...",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      )
                          : Text(
                        _status == "Live"
                            ? "Rent out / Book" // Live → text
                            : _status == "Book"
                            ? "Move to live" // Book → text
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomActionBar(

        onAddImages: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdateImages(propertyId: widget.id,)));

        }, onEdit: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>  UpdateForm(propertyId: widget.id)));

      },
      ),
    );
  }


}

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAddImages;
  final bool isDarkMode;

  const _BottomActionBar({
    required this.onEdit,
    required this.onAddImages,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0,top: 5,left: 8,right: 8),
        child: Row(
          children: [


            // 🌈 Add Images Button with Gradient
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.blue.shade400, Colors.blueAccent]
                        : [Colors.blueAccent, Colors.blue.shade700],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.folder_copy_sharp,size: 25,),
                  label: const Text('Update data ',style: TextStyle(fontFamily: "PoppinsBold",fontSize: 15),),
                  onPressed:  onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 6,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.deepPurple.shade700, Colors.purpleAccent]
                        : [Colors.purple, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate,size: 25,),
                  label: const Text('Add Images',style: TextStyle(fontFamily: "PoppinsBold",fontSize: 15),),
                  onPressed:
                  onAddImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

