class ChatRoomModel {
  String roomId;
  String message;
  String image;
  String type;
  String time;

  ChatRoomModel({
    this.roomId,
    this.message,
    this.image,
    this.type,
    this.time,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) => ChatRoomModel(
        roomId: map['roomId'],
        message: map['fname'],
        image: map['image'],
        type: map['type'],
        time: map['time'],
      );

  Map<String, dynamic> chatMap() {
    return {
      'message': message,
      'image': image,
      'type': type,
      'time': time,
    };
  }
}
