class UserModel {
  String uid;
  String email;
  String fname;
  String lname;
  String image;
  String token;
  String type;
  String pid;

  UserModel({
    this.uid,
    this.email,
    this.fname,
    this.lname,
    this.image,
    this.token,
    this.type,
    this.pid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map['uid'],
        email: map['email'],
        fname: map['fname'],
        lname: map['lname'],
        image: map['image'],
        token: map['token'],
        type: map['type'],
        pid: map['pid'],
      );

  Map<String, dynamic> userMap() {
    return {
      'uid': uid,
      'email': email,
      'fname': fname,
      'lname': lname,
      'image': image,
      'token': token,
      'type': type,
      'pid': pid,
    };
  }
}
