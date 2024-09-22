class Model {
  Model({
    required this.regNo,
    required this.email,
    required this.name,
    required this.mobile,
    required this.password,
  });
  String regNo;
  String email;
  String name;
  String mobile;
  String password;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        regNo: json["regNo"],
        email: json["email"],
        name: json["name"],
        mobile: json["mobile"],
        password: json["password"],
      );
}
