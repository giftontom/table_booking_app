class AuthData {
  String id;
  String key;

  AuthData(this.id, this.key);

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(json['id'], json['secretKey']);
  }
}
