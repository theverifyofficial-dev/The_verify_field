class DocumentMainModel {
  int? id;
  String? dimage;

  DocumentMainModel({this.id, this.dimage});

  DocumentMainModel.fromJson(Map<String, dynamic> json) {
    id = json['imagename'];
    dimage = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagename'] = this.id;
    data['imagepath'] = this.dimage;
    return data;
  }
}