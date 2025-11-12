import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/models/user_data.model.dart';
import 'package:taxi_app/pages/driver_in_process_trips.page.dart';
import 'package:taxi_app/providers/driver_in_process_trips.provider.dart';
import 'package:taxi_app/providers/tracking_trips.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';

class StartTripPage extends StatelessWidget {
  const StartTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameEditingController = TextEditingController();
    final TextEditingController amountEditingController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Viaje")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                TextField(
                  controller: nameEditingController,
                  decoration: InputDecoration(labelText: "Nombre del Viaje"),
                ),
                TextField(
                  controller: amountEditingController,
                  decoration: const InputDecoration(labelText: "Monto"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final UserDataModel? userData = context
                    .read<UserAccountProvider>()
                    .userData;
                if (userData == null) return;
                context.read<DriverInProcessTripsProvider>().startDriverTrip(
                  nameEditingController.text,
                  userData.id,
                  int.tryParse(amountEditingController.text) ?? 0,
                );
                context.read<TrackingTripsProvider>().updateTrackingTrips();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => DriverInProcessTripsPage()),
                  (route) => false,
                );
              },
              child: const Text("Iniciar Viaje"),
            ),
          ],
        ),
      ),
    );
  }
}
