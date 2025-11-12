import 'package:latlong2/latlong.dart';

class TrackingTripModel {
  int driverTripId;
  LatLng position;
  DateTime dateTime;

  TrackingTripModel({
    required this.driverTripId,
    required this.position,
    required this.dateTime,
  });
}
