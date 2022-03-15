class UserModel {
  String uid;
  String email;
  String firstName;
  String lastName;
  String image;
  String token;
  String type;
  String pid;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.image,
    this.token,
    this.type,
    this.pid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        image: map['image'],
        token: map['token'],
        type: map['type'],
        pid: map['pid'],
      );

  Map<String, dynamic> userMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'token': token,
      'type': type,
      'pid': pid,
    };
  }
}
