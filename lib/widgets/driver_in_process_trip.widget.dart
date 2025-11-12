import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/pages/driver_in_process_trip_details.page.dart';
import 'package:taxi_app/providers/driver_in_process_trips.provider.dart';
import 'package:taxi_app/widgets/driver_trip_status.widget.dart';
import 'package:taxi_app/widgets/price.widget.dart';

class DriverInProcessTripWidget extends StatelessWidget {
  const DriverInProcessTripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context
          .watch<DriverInProcessTripsProvider>()
          .driverInProcessTrips
          .length,
      itemBuilder: (context, index) {
        final driverTrip = context
            .watch<DriverInProcessTripsProvider>()
            .driverInProcessTrips[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.blueAccent),
            title: Text(
              driverTrip.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID del viaje: ${driverTrip.id}"),
                PriceWidget(price: driverTrip.amount),
              ],
            ),
            trailing: DriverTripStatusWidget(
              driverTripStatus: driverTrip.driverTripStatus,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DriverInProcessTripDetailsPage(
                    tripId: context
                        .read<DriverInProcessTripsProvider>()
                        .driverInProcessTrips[index]
                        .id,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
