class UserProfile {
  final int id;
  final String name;
  final String email;
  final String number;
  final String password;
  final String aadhar;
  final String location;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.aadhar,
    required this.location,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['FName'],
      email: json['FEmail'],
      number: json['FNumber'],
      password: json['FPassword'],
      aadhar: json['FAadharCard'],
      location: json['F_Location'],
    );
  }
}
