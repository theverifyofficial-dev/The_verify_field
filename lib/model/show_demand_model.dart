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

  /// null, missing keys and the literal string "null" all become ''.
  static String _s(dynamic v) {
    final t = v?.toString().trim() ?? '';
    return t.toLowerCase() == 'null' ? '' : t;
  }

  factory Cat_id.fromJson(Map<String, dynamic> json) {
    return Cat_id(
      id: int.tryParse(_s(json['VTD_id'])) ?? 0,
      V_name: _s(json['V_name']),
      V_number: _s(json['V_number']),
      bhk: _s(json['bhk']),
      budget: _s(json['budget']),
      place: _s(json['place']),
      floor_option: _s(json['floor_option']),
      Additional_Info: _s(json['Additional_Info']),
      Shifting_date: _s(json['Shifting_date']),
      Current_date: _s(json['Current__Date']),
      Parking: _s(json['Parking']),
      Gadi_Number: _s(json['Gadi_Number']),
      FeildWorker_Name: _s(json['FeildWorker_Name']),
      FeildWorker_Number: _s(json['FeildWorker_Number']),
      Current__Date: _s(json['Current__Date']),
      Family_Members: _s(json['Family_Members']),
      buyrent: _s(json['Buy_rent']),
    );
  }
}