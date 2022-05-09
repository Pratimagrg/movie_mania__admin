// To parse this JSON data, do
//
//     final messageListModel = messageListModelFromJson(jsonString);

import 'dart:convert';

class MessageListModel {
  MessageListModel(
      {required this.senderType,
      required this.text,
      this.created,
      required this.messageType,
      this.next});

  String senderType;
  String text;
  dynamic created;
  String messageType;
  dynamic next;

  factory MessageListModel.fromJson(Map<String, dynamic> json) =>
      MessageListModel(
        senderType: json["sender_type"],
        text: json["text"],
        created: null,
        messageType: json["message_type"],
        next: null,
      );

  Map<String, dynamic> toJson() => {
        "sender_type": senderType,
        "text": text,
        "created": null,
        "message_type": messageType,
        "next": null,
      };
}
