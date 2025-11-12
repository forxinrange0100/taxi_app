import 'package:flutter/material.dart';
import 'package:taxi_app/pages/login.page.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/db.provider.dart';
import 'package:taxi_app/providers/driver_done_trips.provider.dart';
import 'package:taxi_app/providers/driver_trip_report.provider.dart';
import 'package:taxi_app/providers/driver_in_process_trips.provider.dart';
import 'package:taxi_app/providers/tracking_trips.provider.dart';
import 'package:taxi_app/providers/user_account.provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DBProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              UserAccountProvider(dbProvider: context.read<DBProvider>()),
        ),
        ChangeNotifierProvider(
          create: (context) => TrackingTripsProvider(
            dbProvider: context.read<DBProvider>(),
            userAccountProvider: context.read<UserAccountProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DriverInProcessTripsProvider(
            dbProvider: context.read<DBProvider>(),
            userAccountProvider: context.read<UserAccountProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DriverDoneTripsProvider(
            dbProvider: context.read<DBProvider>(),
            userAccountProvider: context.read<UserAccountProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DriverTripReportProvider(dbProvider: context.read<DBProvider>()),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LoginPage(),
    );
  }
}
