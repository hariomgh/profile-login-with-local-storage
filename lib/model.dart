class UserModel {
  final String email;
  final String password;
  final String imagePath;
  final String name;
  String? pincode;
  String? pincodeDescription;

  UserModel({
    required this.email,
    required this.password,
    required this.imagePath,
    required this.name,
    this.pincode,
    this.pincodeDescription,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      imagePath: json['imagePath'],
      name: json['name'],
      pincode: json['pincode'],
      pincodeDescription: json['pincodeDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'imagePath': imagePath,
      'name': name,
      'pincode': pincode,
      'pincodeDescription': pincodeDescription,
    };
  }
}
