import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/pages/driver_done_trips.page.dart';
import 'package:taxi_app/pages/start_trip.page.dart';
import 'package:taxi_app/pages/login.page.dart';
import 'package:taxi_app/providers/driver_in_process_trips.provider.dart';
import 'package:taxi_app/providers/tracking_trips.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';
import 'package:taxi_app/widgets/driver_in_process_trip.widget.dart';
import 'package:taxi_app/widgets/user_roles.widget.dart';

class DriverInProcessTripsPage extends StatefulWidget {
  const DriverInProcessTripsPage({super.key});

  @override
  State<DriverInProcessTripsPage> createState() =>
      _DriverInProcessTripsPageState();
}

class _DriverInProcessTripsPageState extends State<DriverInProcessTripsPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await context.read<DriverInProcessTripsProvider>().loadDriverTrips();
    await setupGPS();
  }

  Future<void> setupGPS() async {
    await requestLocationPermission();
    if (!mounted) return;
    context.read<TrackingTripsProvider>().updateTrackingTrips();
  }

  Future<void> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 10),
            const SizedBox(width: 6),
            const Text("Viajes en proceso"),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DriverDoneTripsPage()),
              );
            },
            icon: const Icon(Icons.history, color: Colors.black),
            label: const Text(
              "Historial",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<UserAccountProvider>(
        builder: (_, auth, __) {
          final UserDataModel? userData = auth.userData;
          if (userData == null) return SizedBox();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StartTripPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text("Agregar Viaje"),
              ),
              Expanded(child: DriverInProcessTripWidget()),
              ElevatedButton(
                onPressed: () async {
                  auth.signOut();
                  context.read<TrackingTripsProvider>().pauseTrackingTrips();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text("Cerrar sesión"),
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
