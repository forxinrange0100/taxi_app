enum DriverTripStatus { inprocess, done, cancelled }

class DriverTripModel {
  int id;
  int userId;
  String name;
  int amount;
  DriverTripStatus driverTripStatus;
  DriverTripModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.driverTripStatus,
  });
}
