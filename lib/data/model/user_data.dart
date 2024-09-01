import 'dart:convert';

class UserData {
  final int id;
  final String token;
  UserData({
    required this.id,
    required this.token,
  });

  UserData copyWith({
    int? id,
    String? token,
  }) {
    return UserData(
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id']?.toInt() ?? 0,
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() => 'UserData(id: $id, token: $token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData && other.id == id && other.token == token;
  }

  @override
  int get hashCode => id.hashCode ^ token.hashCode;
}
