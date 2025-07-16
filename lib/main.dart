import 'package:agrolab/app/routes/app_routes.dart';
import 'package:agrolab/app/utils/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/splash_screen/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppRoutes.pages,
      title: 'AgroLab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'intant',
      ),
      initialRoute: AppRoutes.splashScreen,
      initialBinding: InitialBinding(),
      // home: const HomeScreen(),
    );
  }
}
