class UserModel {
  final String name;
  final String email;
  final String imageUrl;
  final String createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class UserModelMin {
  final String name;
  final String imageUrl;

  UserModelMin({required this.name, required this.imageUrl});

  factory UserModelMin.fromJson(Map<String, dynamic> json) {
    return UserModelMin(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
