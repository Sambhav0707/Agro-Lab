// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:io';
import 'package:agrolab/app/modules/home_screen/pages/home_screen.dart';
import 'package:agrolab/app/routes/app_routes.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../encyclopedia_acreen/pages/encyclopedia_screen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as img;

import '../../about_screen/pages/app_info_screen.dart';
import '../../ai_chat_screen/pages/ai_chat_screen.dart';
import 'package:get/get.dart';
import '../controller/leaf_scan_controller.dart';

class LeafScan extends StatelessWidget {
  final String? modelName;
  const LeafScan({super.key, this.modelName});

  @override
  Widget build(BuildContext context) {
    final LeafScanController controller = Get.put(LeafScanController());
    Color backgroundColor = const Color(0xffe9edf1);
    Color secondaryColor = const Color(0xffe1e6ec);
    Color accentColor = const Color(0xff2d5765);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      systemNavigationBarColor: secondaryColor,
    ));

    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        onTap: (index) {
          //todo implement transition to other screens
          // debugPrint(index);
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Encyclopedia(),
              ),
            );
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppInfoScreen(),
              ),
            );
          }
        },
        index: 1,
        backgroundColor: backgroundColor,
        color: secondaryColor,
        buttonBackgroundColor: backgroundColor,
        animationDuration: Duration(
          milliseconds: 300,
        ),
        items: [
          NeumorphicIcon(
            Icons.menu_book_rounded,
            style: NeumorphicStyle(
              color: accentColor,
              intensity: 20,
            ),
          ),
          NeumorphicIcon(
            Icons.home_rounded,
            style: NeumorphicStyle(
              color: accentColor,
              intensity: 20,
            ),
          ),
          NeumorphicIcon(
            Icons.info_rounded,
            style: NeumorphicStyle(
              color: accentColor,
              intensity: 20,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/agrolabicon.svg',
                          width: 45,
                          height: 45,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
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
                  Container(
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/tensorflow-icontext.svg',
                      width: 40,
                      height: 40,
                    ),
                  )
                ],
              ),
              Center(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    border: NeumorphicBorder(
                      color: accentColor,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Obx(() => controller.pickedImage.value != null
                        ? Image.file(
                            controller.pickedImage.value!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : LottieBuilder.asset(
                            'assets/plant.json',
                            width: 300,
                            height: 300,
                          )),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(() => NeumorphicButton(
                          tooltip: 'Camera',
                          style: NeumorphicStyle(
                            color: Color(0xffe9edf1),
                          ),
                          pressed: controller.isButtonPressedCamera.value,
                          onPressed: controller.buttonPressedCamera,
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_rounded,
                                size: 64,
                                color: accentColor,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                  fontFamily: 'intan',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        )),
                    Obx(() => NeumorphicButton(
                          tooltip: 'Gallery',
                          style: NeumorphicStyle(
                            color: Color(0xffe9edf1),
                          ),
                          pressed: controller.isButtonPressedGallery.value,
                          onPressed: controller.buttonPressedGallery,
                          child: Column(
                            children: [
                              Icon(
                                Icons.image_rounded,
                                size: 64,
                                color: accentColor,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  fontFamily: 'intan',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Obx(() => Visibility(
                    visible: !controller.resultVisibility.value,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: Row(
                              children: [
                                NeumorphicIcon(
                                  Icons.camera_alt_rounded,
                                  style: NeumorphicStyle(
                                    color: accentColor,
                                  ),
                                  size: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 5,
                                  ),
                                  child: Text(
                                    "Select a plant leaf image to view the results",
                                    style: TextStyle(
                                      fontFamily: 'inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              children: [
                                NeumorphicIcon(
                                  Icons.light_mode_rounded,
                                  style: NeumorphicStyle(
                                    color: accentColor,
                                  ),
                                  size: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 5,
                                  ),
                                  child: Text(
                                    'The image should be well lit and clear',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NeumorphicIcon(
                                  Icons.hide_image_rounded,
                                  style: NeumorphicStyle(
                                    color: accentColor,
                                  ),
                                  size: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                    child: Text(
                                      "Images other than specific plant leaves may give incorrect results",
                                      softWrap: true,
                                      maxLines: 10,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              Obx(() => Visibility(
                    visible: controller.resultVisibility.value,
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.diseaseName.value.toLowerCase() !=
                            "healthy") {
                          controller.diseaseUrl.value =
                              "https://www.google.com/search?q=${controller.modelName}+${controller.diseaseName.value.replaceAll(' ', '+')}";
                          Uri url = Uri.parse(controller.diseaseUrl.value);
                          await launchUrl(url,
                              mode: LaunchMode.externalNonBrowserApplication);
                        } else {
                          controller.diseaseUrl.value =
                              "https://www.google.com/search?q=${controller.modelName}+plant+care+tips";
                          Uri url = Uri.parse(controller.diseaseUrl.value);
                          await launchUrl(url,
                              mode: LaunchMode.externalNonBrowserApplication);
                        }
                      },
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          lightSource: LightSource.topLeft,
                          intensity: 20,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                        ),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(50, 10, 50, 20),
                                  child: Obx(() => NeumorphicText(
                                        controller.diseaseName.value,
                                        style: NeumorphicStyle(
                                          color: Colors.black,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                        'Confidence : ${controller.confidence.value}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.justify,
                                      )),
                                  Obx(() => controller.diseaseName.value
                                              .toLowerCase() !=
                                          "healthy"
                                      ? Text(
                                          'Severity : ${controller.diseaseSeverity.value}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: controller
                                                        .diseaseSeverity.value
                                                        .startsWith("7") ||
                                                    controller
                                                        .diseaseSeverity.value
                                                        .startsWith("8") ||
                                                    controller
                                                        .diseaseSeverity.value
                                                        .startsWith("9")
                                                ? Colors.red.shade800
                                                : controller.diseaseSeverity
                                                            .value
                                                            .startsWith("5") ||
                                                        controller
                                                            .diseaseSeverity
                                                            .value
                                                            .startsWith("6")
                                                    ? Colors.orange.shade800
                                                    : Colors.green.shade800,
                                          ),
                                          textAlign: TextAlign.justify,
                                        )
                                      : Container()),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      NeumorphicIcon(
                                        Icons.info_rounded,
                                        style: NeumorphicStyle(
                                          color: accentColor,
                                        ),
                                        size: 15,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Obx(() => Text(
                                                controller.diseaseName.value
                                                            .toLowerCase() !=
                                                        "healthy"
                                                    ? 'Tap on this card to read more about this disease'
                                                    : 'Tap on this card for ${controller.modelName} plant care tips',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.justify,
                                                softWrap: true,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Obx(() => controller.diseaseName.value
                                              .toLowerCase() !=
                                          "healthy"
                                      ? Column(
                                          children: [
                                            SizedBox(height: 15),
                                            NeumorphicButton(
                                              style: NeumorphicStyle(
                                                color: accentColor,
                                                depth: 2,
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                              onPressed: () {
                                                Get.toNamed(
                                                    AppRoutes.aiChatScreen,
                                                    arguments: {
                                                      "cropName":
                                                          controller.modelName,
                                                      "diseaseName": controller
                                                          .diseaseName.value,
                                                      "severity": controller
                                                          .diseaseSeverity
                                                          .value,
                                                    });
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         AIChatScreen(

                                                //     ),
                                                //   ),
                                                // );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.smart_toy_rounded,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Ask AI for treatment",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
