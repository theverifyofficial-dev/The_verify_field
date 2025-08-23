class RealstateModel {
  int? id;
  String? rimage;

  RealstateModel({this.id, this.rimage});

  RealstateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rimage = json['Rimage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Rimage'] = this.rimage;
    return data;
  }
}