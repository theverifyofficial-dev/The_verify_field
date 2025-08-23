class ShowVehicleModel {
  int? iid;
  String? image_ji;
  int? imagename;

  ShowVehicleModel({this.iid, this.image_ji, this.imagename});

  ShowVehicleModel.fromJson(Map<String, dynamic> json) {
    iid = json['id'];
    image_ji = json['imagepath'];
    imagename = json['imagename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.iid;
    data['imagepath'] = this.image_ji;
    data['imagename'] = this.imagename;
    return data;
  }
}