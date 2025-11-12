import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_app/models/driver_trip.model.dart';
import 'package:taxi_app/models/driver_trip_full_report.model.dart';
import 'package:taxi_app/models/driver_trip_report.model.dart';
import 'package:taxi_app/models/tracking_trip.model.dart';
import 'package:taxi_app/models/user_account.model.dart';
import 'package:taxi_app/models/user_data.model.dart';

/// [DBProvider] Es un Provider que simula las consultas a base de datos.
/// Cada método se debería reemplazar con peticiones a alguna aplicación backend conectada a base de datos.

class DBProvider with ChangeNotifier {
  List<TrackingTripModel> trackingTrips = [
    TrackingTripModel(
      driverTripId: 1,
      position: LatLng(-18.44166725099241, -70.29391753049082),
      dateTime: DateTime.now().add(Duration(minutes: -2)),
    ),
    TrackingTripModel(
      driverTripId: 1,
      position: LatLng(-18.465992754263894, -70.2939831083896),
      dateTime: DateTime.now().add(Duration(minutes: -1)),
    ),
  ];
  List<DriverTripModel> driverTrips = [
    DriverTripModel(
      id: 1,
      userId: 1,
      name: "Viaje 1",
      amount: 1000,
      driverTripStatus: DriverTripStatus.inprocess,
    ),
  ];
  List<UserAccountModel> userAccounts = [
    UserAccountModel(
      id: 1,
      email: 'driver',
      username: 'driver',
      accessToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1MTYyNDI2MjJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      password: 'driver',
      roles: [UserAccountRole.driver],
    ),
    UserAccountModel(
      id: 2,
      email: 'admin',
      username: 'admin',
      accessToken:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1MTYyNDI2MjJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      password: 'admin',
      roles: [UserAccountRole.driver, UserAccountRole.admin],
    ),
  ];

  Future<DriverTripModel> addDriverInProcessTrip(
    String name,
    int userId,
    int amount,
  ) async {
    DriverTripModel newDriverTrip = DriverTripModel(
      id: driverTrips.length + 1,
      userId: userId,
      name: name,
      amount: amount,
      driverTripStatus: DriverTripStatus.inprocess,
    );

    driverTrips.add(newDriverTrip);
    notifyListeners();
    return newDriverTrip;
  }

  Future<DriverTripModel> getATripById(int tripId) async {
    final DriverTripModel driverTripModel = driverTrips.firstWhere(
      (trip) => trip.id == tripId,
    );
    return driverTripModel;
  }

  Future<List<DriverTripModel>> getDriverInProcessTripsByUserId(
    int userId,
  ) async {
    return driverTrips
        .where(
          (trip) =>
              trip.userId == userId &&
              trip.driverTripStatus == DriverTripStatus.inprocess,
        )
        .toList();
  }

  Future<void> updateDriverPending2InProcessTripStatus(int tripId) async {
    final index = driverTrips.indexWhere((t) => t.id == tripId);
    if (index == -1) return;

    driverTrips[index].driverTripStatus = DriverTripStatus.inprocess;
    notifyListeners();
  }

  Future<List<UserDataModel>> verifyCredentials(
    String email,
    String password,
    bool isAdminLogin,
  ) async {
    return userAccounts
        .where(
          (userAccount) =>
              userAccount.email == email &&
              userAccount.password == password &&
              (!isAdminLogin ||
                  userAccount.roles.contains(UserAccountRole.admin)),
        )
        .map(
          (userAccount) => UserDataModel(
            id: userAccount.id,
            email: userAccount.email,
            username: userAccount.username,
            accessToken: userAccount.accessToken,
            roles: userAccount.roles,
          ),
        )
        .toList();
  }

  Future<void> updateStatusDriverInProcess2DoneTrip(int tripId) async {
    driverTrips = driverTrips.map((t) {
      if (t.id == tripId) {
        t.driverTripStatus = DriverTripStatus.done;
      }
      return t;
    }).toList();
    notifyListeners();
  }

  Future<void> addTrackingTrip(List<int> driverTripIds, LatLng position) async {
    final DateTime timestamp = DateTime.now();
    for (int driverTripId in driverTripIds) {
      trackingTrips.add(
        TrackingTripModel(
          driverTripId: driverTripId,
          position: position,
          dateTime: timestamp,
        ),
      );
    }
  }

  Future<List<TrackingTripModel>> getTrackingTripByTripId(int tripId) async {
    return trackingTrips
        .where((ttrip) => ttrip.driverTripId == tripId)
        .toList();
  }

  Future<List<DriverTripReportModel>> getDriverTripReport() async {
    return driverTrips.map((trip) {
      final UserAccountModel userAccount = userAccounts.firstWhere(
        (user) => user.id == trip.userId,
      );
      final UserDataModel userData = UserDataModel(
        id: userAccount.id,
        email: userAccount.email,
        username: userAccount.username,
        accessToken: userAccount.accessToken,
        roles: userAccount.roles,
      );
      final List<TrackingTripModel> trackingTrip = trackingTrips.where((ttrip) {
        return ttrip.driverTripId == trip.id;
      }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

      if (trackingTrip.length < 2) {
        return DriverTripReportModel(
          id: trip.id,
          username: userData.username,
          tripname: trip.name,
          amount: trip.amount,
          driverTripStatus: trip.driverTripStatus,
          startPosition: null,
          endPosition: null,
          totalDistanceKm: 0,
          totalHours: 0,
        );
      }

      final Distance distance = Distance();
      double totalDistanceMeters = 0;
      for (int i = 0; i < trackingTrip.length - 1; i++) {
        totalDistanceMeters += distance(
          trackingTrip[i].position,
          trackingTrip[i + 1].position,
        );
      }
      final double totalDistanceKm = totalDistanceMeters / 1000.0;
      final Duration duration = trackingTrip.last.dateTime.difference(
        trackingTrip.first.dateTime,
      );
      final double totalHours = duration.inSeconds / 3600.0;

      return DriverTripReportModel(
        id: trip.id,
        username: userData.username,
        tripname: trip.name,
        amount: trip.amount,
        driverTripStatus: trip.driverTripStatus,
        startPosition: trackingTrip.first.position,
        endPosition: trackingTrip.last.position,
        totalDistanceKm: totalDistanceKm,
        totalHours: totalHours,
      );
    }).toList();
  }

  Future<List<DriverTripReportModel>> getDriverDoneTripReportByUserId(
    int userId,
  ) async {
    return driverTrips
        .where(
          (trip) =>
              trip.userId == userId &&
              trip.driverTripStatus == DriverTripStatus.done,
        )
        .map((trip) {
          final UserAccountModel userAccount = userAccounts.firstWhere(
            (user) => user.id == trip.userId,
          );
          final UserDataModel userData = UserDataModel(
            id: userAccount.id,
            email: userAccount.email,
            username: userAccount.username,
            accessToken: userAccount.accessToken,
            roles: userAccount.roles,
          );
          final List<TrackingTripModel> trackingTrip = trackingTrips.where((
            ttrip,
          ) {
            return ttrip.driverTripId == trip.id;
          }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

          if (trackingTrip.length < 2) {
            return DriverTripReportModel(
              id: trip.id,
              username: userData.username,
              tripname: trip.name,
              amount: trip.amount,
              driverTripStatus: trip.driverTripStatus,
              startPosition: null,
              endPosition: null,
              totalDistanceKm: 0,
              totalHours: 0,
            );
          }

          final Distance distance = Distance();
          double totalDistanceMeters = 0;
          for (int i = 0; i < trackingTrip.length - 1; i++) {
            totalDistanceMeters += distance(
              trackingTrip[i].position,
              trackingTrip[i + 1].position,
            );
          }
          final double totalDistanceKm = totalDistanceMeters / 1000.0;
          final Duration duration = trackingTrip.last.dateTime.difference(
            trackingTrip.first.dateTime,
          );
          final double totalHours = duration.inSeconds / 3600.0;

          return DriverTripReportModel(
            id: trip.id,
            username: userData.username,
            tripname: trip.name,
            amount: trip.amount,
            driverTripStatus: trip.driverTripStatus,
            startPosition: trackingTrip.first.position,
            endPosition: trackingTrip.last.position,
            totalDistanceKm: totalDistanceKm,
            totalHours: totalHours,
          );
        })
        .toList();
  }

  Future<DriverTripFullReportModel> getDoneTripFullReportByTripId(
    int tripId,
  ) async {
    DriverTripModel driverTrip = driverTrips.firstWhere(
      (trip) =>
          trip.id == tripId && trip.driverTripStatus == DriverTripStatus.done,
    );
    final UserAccountModel userAccount = userAccounts.firstWhere(
      (user) => user.id == driverTrip.userId,
    );
    final UserDataModel userData = UserDataModel(
      id: userAccount.id,
      email: userAccount.email,
      username: userAccount.username,
      accessToken: userAccount.accessToken,
      roles: userAccount.roles,
    );
    final List<TrackingTripModel> trackingTrip = trackingTrips.where((ttrip) {
      return ttrip.driverTripId == driverTrip.id;
    }).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (trackingTrip.length < 2) {
      return DriverTripFullReportModel(
        id: driverTrip.id,
        username: userData.username,
        tripname: driverTrip.name,
        amount: driverTrip.amount,
        driverTripStatus: driverTrip.driverTripStatus,
        coordinates: trackingTrip.map((ttrip) => ttrip.position).toList(),
        startPosition: null,
        endPosition: null,
        totalDistanceKm: 0,
        totalHours: 0,
      );
    }

    final Distance distance = Distance();
    double totalDistanceMeters = 0;
    for (int i = 0; i < trackingTrip.length - 1; i++) {
      totalDistanceMeters += distance(
        trackingTrip[i].position,
        trackingTrip[i + 1].position,
      );
    }
    final double totalDistanceKm = totalDistanceMeters / 1000.0;
    final Duration duration = trackingTrip.last.dateTime.difference(
      trackingTrip.first.dateTime,
    );
    final double totalHours = duration.inSeconds / 3600.0;

    return DriverTripFullReportModel(
      id: driverTrip.id,
      username: userData.username,
      tripname: driverTrip.name,
      amount: driverTrip.amount,
      driverTripStatus: driverTrip.driverTripStatus,
      coordinates: trackingTrip.map((ttrip) => ttrip.position).toList(),
      startPosition: trackingTrip.first.position,
      endPosition: trackingTrip.last.position,
      totalDistanceKm: totalDistanceKm,
      totalHours: totalHours,
    );
  }
}
