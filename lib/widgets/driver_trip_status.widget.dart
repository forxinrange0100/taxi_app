import 'package:flutter/material.dart';
import 'package:taxi_app/models/driver_trip.model.dart';

class DriverTripStatusWidget extends StatelessWidget {
  final DriverTripStatus driverTripStatus;
  const DriverTripStatusWidget({super.key, required this.driverTripStatus});

  Color _getBackgroundColor() {
    switch (driverTripStatus) {
      case DriverTripStatus.inprocess:
        return Colors.blue.shade100;
      case DriverTripStatus.cancelled:
        return Colors.red.shade100;
      case DriverTripStatus.done:
        return Colors.green.shade100;
    }
  }

  Color _getTextColor() {
    switch (driverTripStatus) {
      case DriverTripStatus.inprocess:
        return Colors.blue.shade800;
      case DriverTripStatus.cancelled:
        return Colors.red.shade800;
      case DriverTripStatus.done:
        return Colors.green.shade800;
    }
  }

  String _getLabel() {
    switch (driverTripStatus) {
      case DriverTripStatus.inprocess:
        return "En curso";
      case DriverTripStatus.cancelled:
        return "Cancelado";
      case DriverTripStatus.done:
        return "Completado";
    }
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
