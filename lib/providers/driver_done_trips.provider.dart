import 'package:flutter/material.dart';
import 'package:taxi_app/models/driver_trip_full_report.model.dart';
import 'package:taxi_app/models/driver_trip_report.model.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/providers/db.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';

class DriverDoneTripsProvider with ChangeNotifier {
  DBProvider dbProvider;
  UserAccountProvider userAccountProvider;
  List<DriverTripReportModel> driverTripReports = [];
  DriverTripFullReportModel? driverTripReport = null;

  DriverDoneTripsProvider({
    required this.dbProvider,
    required this.userAccountProvider,
  });

  Future<void> getDoneTripFullReportByTripId(int tripId) async {
    driverTripReport = await dbProvider.getDoneTripFullReportByTripId(tripId);
  }

  Future<void> getDriverTripReportByUserId() async {
    final UserDataModel? userData = userAccountProvider.userData;
    if (userData == null) return;
    driverTripReports = await dbProvider.getDriverDoneTripReportByUserId(
      userData.id,
    );
  }
}
