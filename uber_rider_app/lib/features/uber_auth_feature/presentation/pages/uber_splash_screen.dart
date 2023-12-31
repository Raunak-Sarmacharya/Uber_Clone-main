import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:uber_rider_app/core/network_checker/uber_network_checker_controller.dart';
import 'package:uber_rider_app/features/uber_auth_feature/presentation/getx/auth_controller.dart';
import 'package:uber_rider_app/features/uber_auth_feature/presentation/pages/uber_auth_register_page.dart';
import 'package:uber_rider_app/features/uber_auth_feature/presentation/pages/uber_auth_welcome_page.dart';
import 'package:uber_rider_app/features/uber_home_page_feature/presentation/pages/uber_home_page.dart';
import 'package:uber_rider_app/injection_container.dart' as di;

class UberSplashScreen extends StatefulWidget {
  const UberSplashScreen({Key? key}) : super(key: key);

  @override
  _UberSplashScreenState createState() => _UberSplashScreenState();
}

class _UberSplashScreenState extends State<UberSplashScreen>  with SingleTickerProviderStateMixin {

  final UberAuthController _uberAuthController =
      Get.put(di.sl<UberAuthController>());
  final UberNetWorkStatusChecker _netWorkStatusChecker =
      Get.put(di.sl<UberNetWorkStatusChecker>());

  @override
  void initState() {
    _netWorkStatusChecker.updateConnectionStatus();
    _uberAuthController.checkIsSignIn();
    Timer(const Duration(seconds: 7), () async {
      if (_uberAuthController.isSignIn.value) {
        if (await _uberAuthController.checkUserStatus()) {
          Get.off(() => const UberHomePage());
        } else {
          Get.off(() => const UberAuthRegistrationPage());
        }
      } else {
        Get.off(() => const UberAuthWelcomeScreen());
      }
    });

    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays:
    SystemUiOverlay.values);

    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container( color: Colors.black,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/Animation - 1704051232367.json',filterQuality: FilterQuality.high,),
            // const Text("PuffGo",
            // style: TextStyle(
            //   color: Colors.green,fontSize: 45,fontWeight: FontWeight.w800,
            //   fontStyle: FontStyle.italic,
            //   fontFamily: "Brand Bold",
            // ),),
          ],

        )
        //   width: double.infinity,
  //       decoration:BoxDecoration(gradient: LinearGradient(
  //           colors:
  //           [Colors.green,Colors.blue],
  //         begin: Alignment.topCenter,end: Alignment.bottomCenter,),),
  //       child: Column(mainAxisAlignment:MainAxisAlignment.center,
  //         children: const [
  //         Icon(Icons.car_rental,size: 80,
  // color: Colors.black26 ,),
  // SizedBox(height: 20,),Text("PuffGo",
  // style: TextStyle(
  // color: Colors.white,fontSize: 32,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic,
  // fontFamily: "Brand Bold",
  // ),)
  //   ],
  //     ),
    ));
  }
}




