class RealEstateSlider {
  final int mId;
  final String mImages;
  final int subid;

  RealEstateSlider({
    required this.mId,
    required this.mImages,
    required this.subid,
  });

  factory RealEstateSlider.fromJson(Map<String, dynamic> json) {
    return RealEstateSlider(
      mId: int.tryParse(json['M_id'].toString()) ?? 0,
      mImages: json['M_images'] ?? "",
      subid: int.tryParse(json['subid'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'M_id': mId,
      'M_images': mImages,
      'subid': subid,
    };
  }
}
class RealEstateSlider1 {
  int? id;
  String? rimg;
  int? pid;

  RealEstateSlider1({this.id, this.rimg, this.pid});

  RealEstateSlider1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rimg = json['imagepath'];
    pid = json['imagename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagepath'] = this.rimg;
    data['imagename'] = this.pid;
    return data;
  }
}