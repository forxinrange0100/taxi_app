import 'package:flutter/material.dart';
import 'package:taxi_app/models/driver_trip_report.model.dart';
import 'package:taxi_app/providers/db.provider.dart';

class DriverTripReportProvider with ChangeNotifier {
  DBProvider dbProvider;
  List<DriverTripReportModel> driverTripReports = [];

  DriverTripReportProvider({required this.dbProvider});

  Future<void> getDriverTripReport() async {
    driverTripReports = await dbProvider.getDriverTripReport();
    notifyListeners();
  }
}
