class DocumentMainModel_F {
  String? subid;
  String? dimage;

  DocumentMainModel_F({this.subid, this.dimage});

  DocumentMainModel_F.fromJson(Map<String, dynamic> json) {
    subid = json['subid'];
    dimage = json['img'];
  }

  Map<String, dynamic> toJson() {
    return {
      "subid": subid,
      "img": dimage,
    };
  }
}