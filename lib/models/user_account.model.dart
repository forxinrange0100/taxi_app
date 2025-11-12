enum UserAccountRole { admin, driver }

class UserAccountModel {
  int id;
  String username;
  String email;
  String accessToken;
  String password;
  List<UserAccountRole> roles;
  UserAccountModel({
    required this.id,
    required this.email,
    required this.username,
    required this.accessToken,
    required this.password,
    required this.roles,
  });
}
