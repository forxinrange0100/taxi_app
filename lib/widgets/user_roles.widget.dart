import 'package:flutter/material.dart';
import 'package:taxi_app/models/user_account.model.dart';

class UserRolesWidget extends StatelessWidget {
  final List<UserAccountRole> roles;
  const UserRolesWidget({super.key, required this.roles});

  Color _getBackgroundColor() {
    if (roles.contains(UserAccountRole.admin) &&
        roles.contains(UserAccountRole.driver)) {
      return Colors.purple.shade100;
    } else if (roles.contains(UserAccountRole.admin)) {
      return Colors.blue.shade100;
    } else if (roles.contains(UserAccountRole.driver)) {
      return Colors.green.shade100;
    }
    return Colors.grey.shade100;
  }

  Color _getTextColor() {
    if (roles.contains(UserAccountRole.admin) &&
        roles.contains(UserAccountRole.driver)) {
      return Colors.purple.shade800;
    } else if (roles.contains(UserAccountRole.admin)) {
      return Colors.blue.shade800;
    } else if (roles.contains(UserAccountRole.driver)) {
      return Colors.green.shade800;
    }
    return Colors.grey.shade800;
  }

  String _getLabel() {
    if (roles.contains(UserAccountRole.admin) &&
        roles.contains(UserAccountRole.driver)) {
      return "Administrador & Conductor";
    } else if (roles.contains(UserAccountRole.admin)) {
      return "Administrador";
    } else if (roles.contains(UserAccountRole.driver)) {
      return "Conductor";
    }
    return "Sin Rol";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(color: _getTextColor(), fontWeight: FontWeight.bold),
      ),
    );
  }
}
