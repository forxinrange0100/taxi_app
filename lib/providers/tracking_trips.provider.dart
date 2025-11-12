import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_app/models/driver_trip.model.dart';
import 'package:taxi_app/models/tracking_trip.model.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/providers/db.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';

class TrackingTripsProvider with ChangeNotifier {
  DBProvider dbProvider;
  UserAccountProvider userAccountProvider;
  final MapController _mapController = MapController();

  List<TrackingTripModel> trackingTrips = [];

  TrackingTripsProvider({
    required this.dbProvider,
    required this.userAccountProvider,
  });

  StreamSubscription<Position> positionSubscription =
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((position) {});

  MapController get mapController => _mapController;

  Future<void> updateTrackingTrips() async {
    trackingTrips.clear();
    final UserDataModel? userData = userAccountProvider.userData;
    if (userData == null) return;

    await positionSubscription.cancel();

    List<DriverTripModel> driverInProcessTrips = await dbProvider
        .getDriverInProcessTripsByUserId(userData.id);

    positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((position) async {
          await dbProvider.addTrackingTrip(
            driverInProcessTrips.map((trip) => trip.id).toList(),
            LatLng(position.latitude, position.longitude),
          );

          notifyListeners();
        });
  }

  Future<void> pauseTrackingTrips() async {
    positionSubscription.pause();
  }

  Future<void> loadTrackingTripByTripId(int tripId) async {
    trackingTrips = await dbProvider.getTrackingTripByTripId(tripId)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }

  void moveCameraToLastPosition() {
    if (trackingTrips.isNotEmpty) {
      mapController.move(
        trackingTrips.first.position,
        mapController.camera.zoom,
      );
    }
    notifyListeners();
  }
}
