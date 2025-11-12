import 'package:flutter/material.dart';
import 'package:taxi_app/models/driver_trip.model.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/providers/db.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';

class DriverInProcessTripsProvider with ChangeNotifier {
  List<DriverTripModel> driverInProcessTrips = [];
  DriverTripModel? driverTrip;

  DBProvider dbProvider;
  UserAccountProvider userAccountProvider;

  DriverInProcessTripsProvider({
    required this.dbProvider,
    required this.userAccountProvider,
  });

  Future<void> loadDriverTrips() async {
    final UserDataModel? userData = userAccountProvider.userData;
    if (userData == null) return;
    driverInProcessTrips = await dbProvider.getDriverInProcessTripsByUserId(
      userData.id,
    );
    notifyListeners();
  }

  Future<void> getDriverTripById(int tripId) async {
    driverTrip = await dbProvider.getATripById(tripId);
    notifyListeners();
  }

  Future<void> startDriverTrip(String name, int userId, int amount) async {
    DriverTripModel driverTripModel = await dbProvider.addDriverInProcessTrip(
      name,
      userId,
      amount,
    );
    driverInProcessTrips.add(driverTripModel);
  }

  Future<void> updateStatusDriverInProcess2DoneTrip(int tripId) async {
    await dbProvider.updateStatusDriverInProcess2DoneTrip(tripId);
  }
}
