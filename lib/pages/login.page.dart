import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/pages/admin_dashboard.page.dart';
import 'package:taxi_app/pages/driver_in_process_trips.page.dart';
import 'package:taxi_app/providers/user_account.provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserAccountProvider>(
        builder: (_, auth, __) {
          final UserDataModel? userData = auth.userData;
          if (userData != null) {
            Future.microtask(() {
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => auth.isAdminLogin
                      ? AdminDashboardPage()
                      : DriverInProcessTripsPage(),
                ),
              );
            });
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Inicio de Sesión Taxi App'),

                  TextField(
                    controller: context
                        .read<UserAccountProvider>()
                        .emailTextController,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                    ),
                  ),

                  TextField(
                    controller: context
                        .read<UserAccountProvider>()
                        .passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: context
                            .watch<UserAccountProvider>()
                            .isAdminLogin,
                        onChanged: (value) {
                          context.read<UserAccountProvider>().setAdminLogin(
                            value ?? false,
                          );
                        },
                      ),
                      const Text("Iniciar como administrador"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      await context.read<UserAccountProvider>().signIn();
                    },
                    child: const Text("Iniciar sesión"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
