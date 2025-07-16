import 'package:agrolab/app/modules/ai_chat_screen/pages/ai_chat_screen.dart';
import 'package:agrolab/app/modules/about_screen/bindings/app_info_binding.dart';
import 'package:agrolab/app/modules/about_screen/pages/app_info_screen.dart';
import 'package:agrolab/app/modules/ai_chat_screen/bindings/ai_chat_bindings.dart';
import 'package:agrolab/app/modules/bottom_nav_bar/bindings/bottom_nav_bar_bindings.dart';
import 'package:agrolab/app/modules/bottom_nav_bar/pages/bottom_nav_bar_screen.dart';
import 'package:agrolab/app/modules/encyclopedia_acreen/bindings/encyclopedia_bindings.dart';
import 'package:agrolab/app/modules/encyclopedia_acreen/pages/encyclopedia_screen.dart';
import 'package:agrolab/app/modules/home_screen/bindings/home_bindings.dart';
import 'package:agrolab/app/modules/home_screen/pages/home_screen.dart';
import 'package:agrolab/app/modules/leaf_scan/bindings/leaf_scan_bindings.dart';
import 'package:agrolab/app/modules/leaf_scan/pages/leaf_scan.dart';
import 'package:agrolab/app/modules/splash_screen/bindings/splash_bindings.dart';
import 'package:agrolab/app/modules/splash_screen/pages/splash_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String aboutScreen = '/about_screen';
  static const String homeScreen = '/home_screen';
  static const String splashScreen = '/splash_screen';
  static const String encyclopediaScreen = '/encyclopedia_screen';
  static const String aiChatScreen = '/ai_chat_screen';
  static const String leafScanScreen = '/leaf_scan_screen';
  static const String bottomNavBarScreen = '/bottom_nav_bar_screen';

  static List<GetPage> pages = [
     GetPage(
        name: bottomNavBarScreen,
        binding: BottomNavBarBindings(),
        page: () {
          return  BottomNavBarScreen();
        }),
    GetPage(
        name: aboutScreen,
        binding: AppInfoBinding(),
        page: () {
          return const AppInfoScreen();
        }),
    GetPage(
        name: homeScreen,
        binding: HomeBinding(),
        page: () {
          return const HomeScreen();
        }),
        GetPage(
        name: encyclopediaScreen,
        binding: EncyclopediaBindings(),
        page: () {
          return const Encyclopedia();
        }),
        GetPage(
        name: splashScreen,
        binding: SplashBindings(),
        page: () {
          return const SplashPage();
        }),
        GetPage(
        name: leafScanScreen,
        binding: LeafScanBindings(),
        page: () {
          return const LeafScan();
        }),
        GetPage(
        name: aiChatScreen,
        binding: AiChatBindings(),
        page: () {
          return const AIChatScreen();
        }),
  ];
}
