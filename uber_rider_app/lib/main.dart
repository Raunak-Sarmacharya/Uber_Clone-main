// Importing necessary packages and modules
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'features/uber_auth_feature/presentation/pages/uber_splash_screen.dart';
import 'injection_container.dart' as di;

// The main function of the application.
// It initializes the Firebase app, sets up the dependency injection,
// sets the preferred device orientation, and runs the app.

Future main() async {
  // Ensuring that widget binding is initialized.

  WidgetsFlutterBinding.ensureInitialized();
  // Initializing the Firebase app.
  await Firebase.initializeApp();
  // Setting up the dependency injection.
  await di.init();
  // Setting the preferred device orientation.
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // lock orientation
  // Running the app.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UberSplashScreen(),
    );
  }
}
