class DocumentMainModel_F {
  int? id;
  String? dimage;

  DocumentMainModel_F({this.id, this.dimage});

  DocumentMainModel_F.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dimage = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img'] = this.dimage;
    return data;
  }
}