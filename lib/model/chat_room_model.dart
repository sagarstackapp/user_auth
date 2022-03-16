// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'dart:convert';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    this.image,
    this.message,
    this.receiver,
    this.sender,
    this.time,
    this.token,
  });

  String image;
  String message;
  String receiver;
  String sender;
  String time;
  String token;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        image: json["image"],
        message: json["message"],
        receiver: json["receiver"],
        sender: json["sender"],
        time: json["time"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "message": message,
        "receiver": receiver,
        "sender": sender,
        "time": time,
        "token": token,
      };
}
