import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/driver_trip.model.dart';
import 'package:taxi_app/models/tracking_trip.model.dart';
import 'package:taxi_app/pages/driver_in_process_trips.page.dart';
import 'package:taxi_app/providers/driver_in_process_trips.provider.dart';
import 'package:taxi_app/providers/tracking_trips.provider.dart';
import 'package:taxi_app/widgets/driver_trip_status.widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:taxi_app/widgets/price.widget.dart';

class DriverInProcessTripDetailsPage extends StatefulWidget {
  final int tripId;
  const DriverInProcessTripDetailsPage({super.key, required this.tripId});

  @override
  State<DriverInProcessTripDetailsPage> createState() =>
      _DriverInProcessTripDetailsPageState();
}

class _DriverInProcessTripDetailsPageState
    extends State<DriverInProcessTripDetailsPage> {
  Timer? _timer;
  bool _isLoading = false;
  bool _mapready = false;

  @override
  void initState() {
    super.initState();
    loadDriverTrip();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> loadDriverTrip() async {
    await context.read<DriverInProcessTripsProvider>().getDriverTripById(
      widget.tripId,
    );
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted || _isLoading) return;
      _isLoading = true;
      await context.read<TrackingTripsProvider>().loadTrackingTripByTripId(
        widget.tripId,
      );
      _isLoading = false;
      if (_mapready) {
        if (!mounted) return;
        context.read<TrackingTripsProvider>().moveCameraToLastPosition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.watch<DriverInProcessTripsProvider>().driverTrip?.name ?? '',
        ),
      ),
      body: Consumer<DriverInProcessTripsProvider>(
        builder: (_, trip, __) {
          final DriverTripModel? driverTrip = trip.driverTrip;
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
                  Consumer<TrackingTripsProvider>(
                    builder: (_, tracking, __) {
                      final List<TrackingTripModel> ttrip =
                          tracking.trackingTrips;
                      return Expanded(
                        child: (ttrip.isEmpty)
                            ? SizedBox()
                            : FlutterMap(
                                mapController: context
                                    .watch<TrackingTripsProvider>()
                                    .mapController,
                                options: MapOptions(
                                  initialCenter: ttrip.first.position,
                                  initialZoom: 17,
                                  minZoom: 5,
                                  maxZoom: 18,
                                  onMapReady: () {
                                    setState(() {
                                      _mapready = true;
                                    });
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        "https://api.maptiler.com/tiles/streets/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}",
                                  ),
                                  ttrip.isEmpty
                                      ? SizedBox()
                                      : PolylineLayer(
                                          key: ValueKey(ttrip.length),
                                          polylines: [
                                            Polyline(
                                              color: Colors.blueAccent,
                                              strokeWidth: 8,
                                              borderColor: Colors.white,
                                              borderStrokeWidth: 8,
                                              points: ttrip
                                                  .map((t) => t.position)
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: ttrip.first.position,
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
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await context
                          .read<DriverInProcessTripsProvider>()
                          .updateStatusDriverInProcess2DoneTrip(widget.tripId);
                      if (!context.mounted) return;
                      await context
                          .read<TrackingTripsProvider>()
                          .updateTrackingTrips();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DriverInProcessTripsPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.stop_circle),
                    label: const Text("Finalizar Viaje"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
