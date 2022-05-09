import 'dart:convert';

class RoomListModel {
  RoomListModel(
      {required this.id,
      required this.name,
      required this.normal_user,
      this.unread_messages});

  int id;
  String name;
  String normal_user;
  dynamic unread_messages;

  factory RoomListModel.fromJson(Map<String, dynamic> json) => RoomListModel(
        id: json["id"],
        name: json["name"],
        normal_user: json["normal_user"],
        unread_messages: json["unread_messages"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "normal_user": normal_user,
        "unread_mesages": unread_messages,
      };
}
