class Cat_id {
  final int id;
  final String V_name;
  final String V_number;
  final String bhk;
  final String budget;
  final String place;
  final String floor_option;
  final String Additional_Info;
  final String Shifting_date;
  final String Current_date;
  final String Parking;
  final String Gadi_Number;
  final String FeildWorker_Name;
  final String FeildWorker_Number;
  final String Current__Date;
  final String Family_Members;
  final String buyrent;

  Cat_id({
    required this.id,
    required this.V_name,
    required this.V_number,
    required this.bhk,
    required this.budget,
    required this.place,
    required this.floor_option,
    required this.Additional_Info,
    required this.Shifting_date,
    required this.Current_date,
    required this.Parking,
    required this.Gadi_Number,
    required this.FeildWorker_Name,
    required this.FeildWorker_Number,
    required this.Current__Date,
    required this.Family_Members,
    required this.buyrent,
  });

  factory Cat_id.fromJson(Map<String, dynamic> json) {
    return Cat_id(
      id: json['VTD_id'] ?? 0,

      V_name: json['V_name']?.toString() ?? '',
      V_number: json['V_number']?.toString() ?? '',
      bhk: json['bhk']?.toString() ?? '',
      budget: json['budget']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      floor_option: json['floor_option']?.toString() ?? '',
      Additional_Info: json['Additional_Info']?.toString() ?? '',
      Shifting_date: json['Shifting_date']?.toString() ?? '',

      Current_date: json['Current__Date']?.toString() ?? '',

      Parking: json['Parking']?.toString() ?? '',
      Gadi_Number: json['Gadi_Number']?.toString() ?? '',

      FeildWorker_Name: json['FeildWorker_Name']?.toString() ?? '',
      FeildWorker_Number: json['FeildWorker_Number']?.toString() ?? '',

      Current__Date: json['Current__Date']?.toString() ?? '',

      Family_Members: json['Family_Members']?.toString() ?? '',

      buyrent: json['Buy_rent']?.toString() ?? '',
    );
  }
}