// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'dart:convert';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    this.message,
    this.receiver,
    this.sender,
    this.time,
    this.token,
    this.messageType,
  });

  String message;
  String receiver;
  String sender;
  String time;
  String token;
  String messageType;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        message: json["message"],
        receiver: json["receiver"],
        sender: json["sender"],
        time: json["time"],
        token: json["token"],
        messageType: json["messageType"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "receiver": receiver,
        "sender": sender,
        "time": time,
        "token": token,
        "messageType": messageType,
      };
}
