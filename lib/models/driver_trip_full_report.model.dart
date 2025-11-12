import 'package:latlong2/latlong.dart';
import 'package:taxi_app/models/driver_trip.model.dart';

class DriverTripFullReportModel {
  int id;
  String username;
  String tripname;

  LatLng? startPosition;
  LatLng? endPosition;

  List<LatLng> coordinates;

  double totalDistanceKm;
  double totalHours;
  int amount;
  DriverTripStatus driverTripStatus;

  DriverTripFullReportModel({
    required this.id,
    required this.username,
    required this.tripname,
    required this.coordinates,
    required this.startPosition,
    required this.endPosition,
    required this.totalDistanceKm,
    required this.totalHours,
    required this.amount,
    required this.driverTripStatus,
  });
}
