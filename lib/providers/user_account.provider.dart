import 'package:flutter/widgets.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/providers/db.provider.dart';

class UserAccountProvider with ChangeNotifier {
  DBProvider dbProvider;

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  UserDataModel? _userData;

  TextEditingController get emailTextController => _emailTextController;
  TextEditingController get passwordTextController => _passwordTextController;
  bool isAdminLogin = false;
  UserDataModel? get userData => _userData;

  UserAccountProvider({required this.dbProvider});

  void setAdminLogin(bool value) {
    isAdminLogin = value;
    notifyListeners();
  }

  Future<void> signIn() async {
    await verifyCredentials(
      _emailTextController.text,
      _passwordTextController.text,
    );
    _emailTextController.clear();
    _passwordTextController.clear();
    notifyListeners();
  }

  /// [verifyCredentials] Verificar credenciales.
  /// [email] y [password] son como credenciales que ingresa el usuario para verificar de que el usuario sea válido o no.
  /// de tal forma de que si el usuario se encuentra, se pueden extraer datos básicos como [_username] o [_accessToken] por ejemplo.
  /// Lo ideal es cambiar lógica conectando un servicio de autenticación de tercero o alguna aplicación por motivos de seguridad.

  Future<bool> verifyCredentials(String email, String password) async {
    List<UserDataModel> findUserData = await dbProvider.verifyCredentials(
      email,
      password,
      isAdminLogin,
    );
    if (findUserData.isNotEmpty) {
      _userData = findUserData[0];
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    _userData = null;
    isAdminLogin = false;
    _emailTextController.clear();
    _passwordTextController.clear();
    notifyListeners();
  }
}
