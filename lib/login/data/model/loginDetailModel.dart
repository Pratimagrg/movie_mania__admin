// To parse this JSON data, do
//
//     final loginDetailModel = loginDetailModelFromJson(jsonString);

class LoginDetailModel {
  LoginDetailModel({
    required this.refresh,
    required this.access,
    required this.user,
  });

  String refresh;
  String access;
  User user;

  factory LoginDetailModel.fromJson(Map<String, dynamic> json) =>
      LoginDetailModel(
        refresh: json["refresh"],
        access: json["access"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.avatar,
  });

  String id;
  dynamic fullname;
  String email;
  String avatar;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "avatar": avatar,
      };
}
