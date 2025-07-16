import 'package:agrolab/app/routes/app_routes.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../home_screen/pages/home_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Color backgroundColor = const Color(0xffe9edf1);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.bottomNavBarScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      systemNavigationBarColor: backgroundColor,
    ));

    return EasySplashScreen(
      logo: Image.asset('assets/agrolablogo.png'),
      title: const Text(
        "AgroLab",
        style: TextStyle(
          fontSize: 45,
          fontFamily: 'intan',
        ),
      ),
      backgroundColor: backgroundColor,
      showLoader: true,
      loadingText: const Text("Initializing..."),
      durationInSeconds: 2,
    );
  }
}
