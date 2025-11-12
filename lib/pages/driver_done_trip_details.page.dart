import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/driver_trip_full_report.model.dart';
import 'package:taxi_app/providers/driver_done_trips.provider.dart';
import 'package:taxi_app/widgets/driver_trip_status.widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:taxi_app/widgets/price.widget.dart';

class DriverDoneTripDetailsPage extends StatefulWidget {
  final int tripId;
  const DriverDoneTripDetailsPage({super.key, required this.tripId});

  @override
  State<DriverDoneTripDetailsPage> createState() =>
      _DriverDoneTripDetailsPageState();
}

class _DriverDoneTripDetailsPageState extends State<DriverDoneTripDetailsPage> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadDriverTrip();
  }

  Future<void> loadDriverTrip() async {
    await context.read<DriverDoneTripsProvider>().getDoneTripFullReportByTripId(
      widget.tripId,
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.watch<DriverDoneTripsProvider>().driverTripReport?.tripname ??
              '',
        ),
      ),
      body: loading
          ? SizedBox()
          : Consumer<DriverDoneTripsProvider>(
              builder: (_, trip, __) {
                final DriverTripFullReportModel? driverTrip =
                    trip.driverTripReport;
                if (driverTrip == null) {
                  return SizedBox();
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ID: ${driverTrip.id}"),
                              Row(
                                children: [
                                  Text("Monto: "),
                                  PriceWidget(price: driverTrip.amount),
                                ],
                              ),
                              DriverTripStatusWidget(
                                driverTripStatus: driverTrip.driverTripStatus,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter:
                                  driverTrip.startPosition ?? LatLng(0, 0),
                              initialZoom: 17,
                              minZoom: 5,
                              maxZoom: 18,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              ),
                              driverTrip.coordinates.isEmpty
                                  ? SizedBox()
                                  : PolylineLayer(
                                      key: ValueKey(
                                        driverTrip.coordinates.length,
                                      ),
                                      polylines: [
                                        Polyline(
                                          color: Colors.blueAccent,
                                          strokeWidth: 8,
                                          borderColor: Colors.white,
                                          borderStrokeWidth: 8,
                                          points: driverTrip.coordinates
                                              .toList(),
                                        ),
                                      ],
                                    ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point:
                                        driverTrip.startPosition ??
                                        LatLng(0, 0),
                                    width: 40,
                                    height: 40,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.directions_car,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
