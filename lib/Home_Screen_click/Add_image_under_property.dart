import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui_decoration_tools/constant.dart';
import '../doctenantdetailsSlider.dart';
import 'Add_images_in_Realestate.dart';
import 'Delete_Image.dart';
import 'Edit_Page_Realestate.dart';
import 'Edit_Property_SecondPage.dart';
import 'Real-Estate.dart';
import 'View_All_Details.dart';
import 'package:geolocator/geolocator.dart';

class Catid {
  final String property_num;

  Catid(
      {required this.property_num});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(
        property_num: json['imagepath']);
  }
}

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> with WidgetsBindingObserver{

  bool _isLoading = false;

  Future<void> Book_property() async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=$_id&looking=Book'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_Real_Estate(),), (route) => route.isFirst);
      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();

  int _id = 0;
  String _Longitude = '';
  String _Latitude = '';
  double? _latitude;
  double? _longitude;
  bool _shouldCheckLocationAgain = false;

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getCurrentLocation(); // this will update _latitude and _longitude
    _loaduserdata();
  }

  _centerContent() {
    if (_latitude == null || _longitude == null) {
      return Row(
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 10),
          Text(
            'Fetching location...',
            style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
          ),
        ],
      );
    }

    return Text(
      'Latitude: $_latitude\nLongitude: $_longitude',
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isLocationLoading) {
      // Delay helps system apply location changes
      Future.delayed(Duration(seconds: 2), () {
        _getCurrentLocation();
      });
    }
  }


  bool _isLocationDialogShown = false;
  bool _isLocationLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocationLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!_isLocationDialogShown) {
        _isLocationDialogShown = true;

        bool opened = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Location Required'),
            content: Text('Please enable location services.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context, true);
                  await Geolocator.openLocationSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
        );

        // Give system time before retry
        if (opened == true) {
          await Future.delayed(Duration(seconds: 2));
        }
      }

      setState(() => _isLocationLoading = false);
      return;
    }

    // Reset so popup can show again later if needed
    _isLocationDialogShown = false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLocationLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLocationLoading = false);
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _isLocationLoading = false;
        });
      }
    } catch (e) {
      print("Location error: $e");
      if (mounted) {
        setState(() => _isLocationLoading = false);
      }
    }

  }

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_Image_under_Realestatet?id_num=$_id");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );

    return result;
  }

  Future<void> uploadImageWithTitle(File imageFile, String title) async {

    String uploadUrl = 'https://verifyserve.social/upload.php';

    FormData formData = FormData.fromMap({
      "name": title,
      "image": await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        setState(() {
          _imageFile = null;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful: ${response.data}')),
        );
        print('Upload successful: ${response.data}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      print('Error occurred: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (_imageFile == null) {
      Fluttertoast.showToast(
          msg: "Image are required",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a title')),
      );
      return;
    }

    await uploadImageWithTitle(_imageFile!, _id.toString());
  }

  String data = 'Initial Data';

  void _refreshData() {
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }

  late String googleMapsUrl;

  bool _shouldRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(
          AppImages.verify,
          height: MediaQuery.of(context).size.height * 0.075, // Responsive height
          filterQuality: FilterQuality.high,
        ),
        leading: IconButton(
          icon: Icon(
            PhosphorIcons.caret_left_bold,
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.075,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIcons.trash,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Delete_Image()),
              );
              if (result == true) _refreshData();
            },
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.04,
              vertical: constraints.maxHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Picker Section
                Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.04,
                                    vertical: constraints.maxHeight * 0.015,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  XFile? pickedImage = await pickAndCompressImage();
                                  if (pickedImage != null) {
                                    setState(() => _imageFile = File(pickedImage.path));
                                  }
                                },
                                child: Text(
                                  'Pick Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: constraints.maxWidth * 0.04,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: constraints.maxWidth * 0.3,
                              height: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(_imageFile!, fit: BoxFit.cover),
                              )
                                  : Center(
                                child: Text(
                                  'No image',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        // Upload Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.errorContainer,
                              padding: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              _handleUpload();
                              setState(() => _isLoading = true
                              );
                            },
                            child: _isLoading
                                ? SizedBox(
                              height: constraints.maxHeight * 0.03,
                              width: constraints.maxHeight * 0.03,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            )
                                : Text(
                              "Upload Image",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: constraints.maxWidth * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: constraints.maxHeight * 0.03),

                // Location Info
                Card(
                  color: Theme.of(context).cardColor,
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location Coordinates",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.titleLarge?.color,
                            fontSize: constraints.maxWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.01),
                        _isLocationLoading
                        ? Center(child: CircularProgressIndicator())
                            : Text(
                        (_latitude != null && _longitude != null)
                        ? 'Latitude: $_latitude\nLongitude: $_longitude'
                            : 'Location not available',
                        style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                        ),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: constraints.maxHeight * 0.03),

                // Images List
                FutureBuilder<List<Catid>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.03),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.03),
                        child: Center(
                          child: Text(
                            'Error loading images',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(constraints.maxHeight * 0.03),
                        child: Center(
                          child: Text(
                            'No images available',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                          crossAxisSpacing: constraints.maxWidth * 0.03,
                          mainAxisSpacing: constraints.maxWidth * 0.03,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: "https://www.verifyserve.social/${snapshot.data![index].property_num}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: Center(
                                  child: Image.asset(
                                    AppImages.loading,
                                    width: constraints.maxWidth * 0.1,
                                    height: constraints.maxWidth * 0.1,
                                  ),
                                ),
                              ),
                              errorWidget: (context, error, stack) => Container(
                                color: Theme.of(context).colorScheme.surfaceVariant,
                                child: Center(
                                  child: Image.asset(
                                    AppImages.imageNotFound,
                                    width: constraints.maxWidth * 0.1,
                                    height: constraints.maxWidth * 0.1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width * 0.04,
      //     vertical: MediaQuery.of(context).size.height * 0.01,
      //   ),
      //   child: Row(
      //     children: [
      //       // ✅ Edit Property Button with Gradient
      //       Expanded(
      //         child: Container(
      //           decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //               colors: [Colors.blue, Colors.lightBlueAccent],
      //             ),
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           child: ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.transparent,
      //               shadowColor: Colors.transparent,
      //               padding: EdgeInsets.symmetric(
      //                 vertical: MediaQuery.of(context).size.height * 0.02,
      //               ),
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //             ),
      //             onPressed: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => Edit_Realestate_Secondpage()),
      //               );
      //             },
      //             child: Text(
      //               'Edit Property',
      //               style: TextStyle(
      //                 fontSize: MediaQuery.of(context).size.width * 0.04,
      //                 color: Colors.white,
      //                 fontFamily: "PoppinsBold",
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //
      //       SizedBox(width: MediaQuery.of(context).size.width * 0.03),
      //
      //       // ✅ Book Property Button with Gradient
      //       Expanded(
      //         child: Container(
      //           decoration: BoxDecoration(
      //             gradient: LinearGradient(
      //               colors: [Colors.green, Colors.lightGreenAccent],
      //             ),
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           child: ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.transparent,
      //               shadowColor: Colors.transparent,
      //               padding: EdgeInsets.symmetric(
      //                 vertical: MediaQuery.of(context).size.height * 0.02,
      //               ),
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //             ),
      //             onPressed: () {
      //               showDialog<bool>(
      //                 context: context,
      //                 builder: (context) => AlertDialog(
      //                   title: Text('Book Property'),
      //                   content: Text('Do you really want to book this property?'),
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(12),
      //                   ),
      //                   backgroundColor: Theme.of(context).dialogBackgroundColor,
      //                   titleTextStyle: TextStyle(
      //                     color: Theme.of(context).textTheme.titleLarge?.color,
      //                     fontSize: MediaQuery.of(context).size.width * 0.05,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                   contentTextStyle: TextStyle(
      //                     color: Theme.of(context).textTheme.bodyMedium?.color,
      //                   ),
      //                   actions: [
      //                     TextButton(
      //                       onPressed: () => Navigator.pop(context, false),
      //                       child: Text(
      //                         'CANCEL',
      //                         style: TextStyle(
      //                           color: Theme.of(context).colorScheme.error,
      //                         ),
      //                       ),
      //                     ),
      //                     ElevatedButton(
      //                       style: ElevatedButton.styleFrom(
      //                         backgroundColor: Theme.of(context).colorScheme.tertiary,
      //                       ),
      //                       onPressed: () async {
      //                         await Book_property();
      //                         Navigator.pop(context, true);
      //                       },
      //                       child: Text(
      //                         'CONFIRM',
      //                         style: TextStyle(
      //                           color: Theme.of(context).colorScheme.onTertiary,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             },
      //             child: Text(
      //               'Book Property',
      //               style: TextStyle(
      //                 fontSize: MediaQuery.of(context).size.width * 0.04,
      //                 color: Colors.white,
      //                 fontFamily: "PoppinsBold",
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getInt('id_Building') ?? 0;
      _Longitude = prefs.getString('id_Longitude') ?? '';
      _Latitude = prefs.getString('id_Latitude') ?? '';
    });


  }

  void _launchMaps() async {
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

}
