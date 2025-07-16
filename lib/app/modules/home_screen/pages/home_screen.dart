import 'package:agrolab/app/routes/app_routes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import '../../leaf_scan/pages/leaf_scan.dart';
import '../../about_screen/pages/app_info_screen.dart';
import '../../encyclopedia_acreen/pages/encyclopedia_screen.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color backgroundColor = const Color(0xffe9edf1);
  Color secondaryColor = const Color(0xffe1e6ec);
  Color accentColor = const Color(0xff2d5765);
  late HomeController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = Get.isRegistered<HomeController>()
        ? Get.put(HomeController())
        : Get.find<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      systemNavigationBarColor: secondaryColor,
    ));
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/agrolabiconew.svg',
                          width: 64,
                          height: 64,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "AgroLab",
                            style: TextStyle(
                              fontFamily: 'intan',
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              LottieBuilder.asset(
                'assets/58375-plantas-y-hojas.json',
                width: 400,
                height: 100,
              ),
              GridView.count(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                physics: const ScrollPhysics(),
                children: List.generate(controller.crops.length, (index) {
                  final crop = controller.crops[index];
                  return _buildCrops(
                    cropName: crop.name,
                    cropImage: crop.imagePath,
                    modelName: crop.modelName,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrops(
      {required String cropName,
      required String cropImage,
      required String modelName}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.leafScanScreen,
            arguments: {'modelName': modelName});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            cropImage,
            width: 50,
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              textAlign: TextAlign.center,
              cropName,
              style: const TextStyle(
                fontFamily: 'intan',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
