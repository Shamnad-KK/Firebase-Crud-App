class UserModel {
  final String userName;
  final String email;
  final String uid;

  UserModel({
    required this.userName,
    required this.email,
    required this.uid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map["userName"],
      email: map["email"],
      uid: map["uid"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "email": email,
      "uid": uid,
    };
  }
}
