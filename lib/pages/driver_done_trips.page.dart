import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/driver_trip_report.model.dart';
import 'package:taxi_app/pages/driver_done_trip_details.page.dart';
import 'package:taxi_app/providers/driver_done_trips.provider.dart';
import 'package:taxi_app/widgets/driver_trip_status.widget.dart';

class DriverDoneTripsPage extends StatefulWidget {
  const DriverDoneTripsPage({super.key});

  @override
  State<DriverDoneTripsPage> createState() => _DriverDoneTripsPageState();
}

class _DriverDoneTripsPageState extends State<DriverDoneTripsPage> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadDriverTripReports();
  }

  Future<void> loadDriverTripReports() async {
    await context.read<DriverDoneTripsProvider>().getDriverTripReportByUserId();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Viajes Completados")),
      body: loading
          ? SizedBox()
          : Consumer<DriverDoneTripsProvider>(
              builder: (_, tripReport, __) {
                final List<DriverTripReportModel> reports =
                    tripReport.driverTripReports;
                if (reports.isEmpty) {
                  return const Center(child: Text("Sin viajes completados."));
                }
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (_, index) {
                    final trip = reports[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        title: Text(trip.tripname),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DriverTripStatusWidget(
                              driverTripStatus: trip.driverTripStatus,
                            ),
                            if (trip.startPosition != null &&
                                trip.endPosition != null)
                              Text(
                                "De (${trip.startPosition!.latitude.toStringAsFixed(4)}, ${trip.startPosition!.longitude.toStringAsFixed(4)}) "
                                "a (${trip.endPosition!.latitude.toStringAsFixed(4)}, ${trip.endPosition!.longitude.toStringAsFixed(4)})",
                              ),
                            Text(
                              "Distancia: ${trip.totalDistanceKm.toStringAsFixed(2)} km",
                            ),
                            Text(
                              "Duración: ${trip.totalHours.toStringAsFixed(2)} hrs",
                            ),
                          ],
                        ),
                        trailing: Text("\$${trip.amount}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DriverDoneTripDetailsPage(tripId: trip.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
