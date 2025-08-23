class model_flatfutureproperty {
  String? dimage;

  model_flatfutureproperty({this.dimage});

  model_flatfutureproperty.fromJson(Map<String, dynamic> json) {
    dimage = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.dimage;
    return data;
  }
}