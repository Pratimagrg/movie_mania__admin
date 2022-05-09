class MessageModel {
  MessageModel({
    required this.next,
    required this.previous,
    required this.results,
  });

  dynamic next;
  dynamic previous;
  List<dynamic> results;

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) => MessageModel(
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.senderType,
    required this.text,
    required this.created,
  });

  String senderType;
  String text;
  dynamic created;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        senderType: json["sender_type"],
        text: json["text"],
        created: null,
      );

  Map<String, dynamic> toJson() => {
        "sender_type": senderType,
        "text": text,
        "created": null,
      };
}
