import 'package:taxi_app/models/user_account.model.dart';

class UserDataModel {
  int id;
  String username;
  String email;
  String accessToken;
  List<UserAccountRole> roles;
  UserDataModel({
    required this.id,
    required this.email,
    required this.username,
    required this.accessToken,
    required this.roles,
  });
}
