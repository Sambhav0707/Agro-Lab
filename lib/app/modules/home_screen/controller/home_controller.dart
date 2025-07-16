import 'package:get/get.dart';

class Crop {
  final String name;
  final String imagePath;
  final String modelName;
  Crop({required this.name, required this.imagePath, required this.modelName});
}

class HomeController extends GetxController {
  final crops = <Crop>[
    Crop(
        name: 'Apple',
        imagePath: 'assets/new-apple-icon.svg',
        modelName: 'Apple'),
    Crop(
        name: 'Bell Pepper',
        imagePath: 'assets/bell-pepper-svgrepo-com.svg',
        modelName: 'BellPepper'),
    Crop(
        name: 'Cherry',
        imagePath: 'assets/cherry-svgrepo-com.svg',
        modelName: 'Cherry'),
    Crop(
        name: 'Corn',
        imagePath: 'assets/corn-svgrepo-com.svg',
        modelName: 'Corn'),
    Crop(
        name: 'Grape',
        imagePath: 'assets/grapes-grape-svgrepo-com.svg',
        modelName: 'Grape'),
    Crop(
        name: 'Peach',
        imagePath: 'assets/peach-svg-new.svg',
        modelName: 'Peach'),
    Crop(
        name: 'Potato',
        imagePath: 'assets/potato-new.svg',
        modelName: 'Potato'),
    Crop(
        name: 'Rice',
        imagePath: 'assets/grain-new-icon.svg',
        modelName: 'Rice'),
    Crop(
        name: 'Tomato',
        imagePath: 'assets/tomato-new-icon.svg',
        modelName: 'Tomato'),
    Crop(
        name: 'Wheat',
        imagePath: 'assets/wheat-barley-svgrepo-com.svg',
        modelName: 'Wheat'),
    Crop(
        name: 'SugarCane',
        imagePath: 'assets/sugarcane.svg',
        modelName: 'SugarCane'),
    Crop(
        name: 'Nuts',
        imagePath: 'assets/nut-svgrepo-com.svg',
        modelName: 'Groundnut'),
    Crop(
        name: 'Cotton',
        imagePath: 'assets/cotton-svgrepo-com.svg',
        modelName: 'Cotton'),
    Crop(
        name: 'Coffee',
        imagePath: 'assets/coffee-svgrepo-com.svg',
        modelName: 'Coffee'),
    Crop(
        name: 'Soya Bean',
        imagePath: 'assets/beans-svgrepo-com.svg',
        modelName: 'SoyaBean'),
  ].obs;
}
