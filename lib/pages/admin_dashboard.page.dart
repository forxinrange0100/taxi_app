import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/driver_trip_report.model.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/pages/login.page.dart';
import 'package:taxi_app/providers/driver_trip_report.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';
import 'package:taxi_app/widgets/driver_trip_status.widget.dart';
import 'package:taxi_app/widgets/user_roles.widget.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    loadDriverTripReport();
  }

  Future<void> loadDriverTripReport() async {
    context.read<DriverTripReportProvider>().getDriverTripReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Administración")),
      body: Consumer<UserAccountProvider>(
        builder: (_, auth, __) {
          final UserDataModel? userData = auth.userData;
          if (userData == null) return SizedBox();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Bienvenido ${userData.username}"),
                      UserRolesWidget(roles: userData.roles),
                    ],
                  ),
                ),
                Consumer<DriverTripReportProvider>(
                  builder: (_, tripReport, __) {
                    final List<DriverTripReportModel> reports =
                        tripReport.driverTripReports;
                    if (reports.isEmpty) {
                      return const Center(
                        child: Text("Sin viajes registrados."),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (_, index) {
                          final trip = reports[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              title: Text(trip.tripname),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Conductor: ${trip.username}"),
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
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false,
                    );
                  },
                  child: const Text("Cerrar sesión"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
