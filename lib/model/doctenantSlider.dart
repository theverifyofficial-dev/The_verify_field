class DocumentTenantModel {
  int? id;
  String? pimage;
  int? pid;

  DocumentTenantModel({this.id, this.pimage, this.pid});

  DocumentTenantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pimage = json['Pimage'];
    pid = json['Pid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Pimage'] = this.pimage;
    data['Pid'] = this.pid;
    return data;
  }
}