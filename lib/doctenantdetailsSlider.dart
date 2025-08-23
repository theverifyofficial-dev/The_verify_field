class DocumentTenantDetailsModel {
  String? timage;

  DocumentTenantDetailsModel({this.timage});

  DocumentTenantDetailsModel.fromJson(Map<String, dynamic> json) {
    timage = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagepath'] = this.timage;
    return data;
  }
}