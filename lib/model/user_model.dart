class UserModel {
  final String ID;
  final String F_Name;
  final String F_Number;
  final String FAadharCard;
  final String FLocation;

  UserModel(
      {required this.ID,required this.F_Name, required this.F_Number, required this.FAadharCard, required this.FLocation});

  factory UserModel.FromJson(Map<String, dynamic>json){
    return UserModel(
        ID: json['id'],
        F_Name: json['FName'],
        F_Number: json['FNumber'],
        FAadharCard: json['FAadharCard'],
        FLocation: json['F_Location']);
  }
}
