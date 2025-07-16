import 'package:agrolab/app/modules/encyclopedia_acreen/controller/encyclopedia_controller.dart';
import 'package:agrolab/app/modules/encyclopedia_acreen/pages/encyclopedia_screen.dart';
import 'package:agrolab/app/modules/home_screen/pages/home_screen.dart';
import 'package:agrolab/app/modules/about_screen/pages/app_info_screen.dart';
import 'package:agrolab/app/utils/helpers/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../controller/bottom_nav_bar_controller.dart';

class BottomNavBarScreen extends StatefulWidget {
  BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  late BottomNavBarController controller;
  late EncyclopediaController encyclopediaController;
  @override
  void initState() {
    encyclopediaController = Get.isRegistered<EncyclopediaController>()
        ? Get.find<EncyclopediaController>()
        : Get.put(EncyclopediaController());
    controller = Get.isRegistered<BottomNavBarController>()
        ? Get.put(BottomNavBarController())
        : Get.put(BottomNavBarController());
    encyclopediaController.getEncyclopedia();

    super.initState();
  }

  final List<Widget> screens = [
    Encyclopedia(),
    HomeScreen(),
    AppInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.indexes[1].value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => CurvedNavigationBar(
            onTap: (index) {
              controller.indexes[1].value = index;
            },
            index: controller.indexes[1].value,
            backgroundColor: AppColors.backgroundColor,
            color: AppColors.secondaryColor,
            buttonBackgroundColor: AppColors.backgroundColor,
            animationDuration: const Duration(
              milliseconds: 300,
            ),
            items: [
              NeumorphicIcon(
                Icons.menu_book_rounded,
                style: const NeumorphicStyle(
                  color: AppColors.accentColor,
                  intensity: 20,
                ),
              ),
              NeumorphicIcon(
                Icons.home_rounded,
                style: const NeumorphicStyle(
                  color: AppColors.accentColor,
                  intensity: 20,
                ),
              ),
              NeumorphicIcon(
                Icons.info_rounded,
                style: const NeumorphicStyle(
                  color: AppColors.accentColor,
                  intensity: 20,
                ),
              ),
            ],
          )),
    );
  }
}
