import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class LeafScanController extends GetxController {
  late String modelName;

  Interpreter? _interpreter;
  List<String>? _labels;

  var pickedImage = Rx<File?>(null);
  var isButtonPressedCamera = false.obs;
  var isButtonPressedGallery = false.obs;
  var resultVisibility = false.obs;
  var confidence = ''.obs;
  var name = ''.obs;
  var cropName = ''.obs;
  var diseaseName = ''.obs;
  var diseaseUrl = ''.obs;
  var diseaseSeverity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    modelName = Get.arguments != null && Get.arguments['modelName'] != null
        ? Get.arguments['modelName']
        : '';
    initTflite();
  }

  String modelPathSelector() {
    final Map<String, String> modelPaths = {
      'apple': 'assets/Apple',
      'bellpepper': 'assets/BellPepper',
      'cherry': 'assets/Cherry',
      'cotton': 'assets/Cotton',
      'coffee': 'assets/Coffee',
      'corn': 'assets/Corn',
      'grape': 'assets/Grape',
      'groundnut': 'assets/Groundnut',
      'peach': 'assets/Peach',
      'potato': 'assets/Potato',
      'rice': 'assets/Rice',
      'tomato': 'assets/Tomato',
      'soyabean': 'assets/SoyaBean',
      'sugarcane': 'assets/SugarCane',
      'wheat': 'assets/Wheat',
    };
    return modelPaths[modelName.toLowerCase()] ?? '';
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      } else {
        final imageTemporary = File(image.path);
        pickedImage.value = imageTemporary;
        applyModelOnImage(imageTemporary);
        resultVisibility.value = true;
        isButtonPressedCamera.value = false;
        isButtonPressedGallery.value = false;
      }
    } on PlatformException {
      // Handle error
    }
  }

  void buttonPressedCamera() {
    isButtonPressedCamera.value = !isButtonPressedCamera.value;
    getImage(ImageSource.camera);
  }

  void buttonPressedGallery() {
    isButtonPressedGallery.value = !isButtonPressedGallery.value;
    getImage(ImageSource.gallery);
  }

  Future<void> initTflite() async {
    try {
      await loadModel();
      await loadLabels();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> loadModel() async {
    String modelPath = modelPathSelector();
    try {
      final interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset(
        '$modelPath/model_unquant.tflite',
        options: interpreterOptions,
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> loadLabels() async {
    String modelPath = modelPathSelector();
    try {
      final labelData = await rootBundle.loadString('$modelPath/labels.txt');
      _labels = labelData.split('\n');
    } catch (e) {
      // Handle error
    }
  }

  Future<void> applyModelOnImage(File file) async {
    if (_interpreter == null) return;
    try {
      final imageData = file.readAsBytesSync();
      final image = img.decodeImage(imageData);
      if (image == null) return;
      final resizedImage = img.copyResize(image, width: 224, height: 224);
      var buffer = Float32List(1 * 224 * 224 * 3);
      var index = 0;
      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          buffer[index++] = (pixel.r.toDouble() - 127.5) / 127.5;
          buffer[index++] = (pixel.g.toDouble() - 127.5) / 127.5;
          buffer[index++] = (pixel.b.toDouble() - 127.5) / 127.5;
        }
      }
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      var input = buffer.reshape(inputShape);
      var output = List.filled(outputShape.reduce((a, b) => a * b), 0.0)
          .reshape(outputShape);
      _interpreter!.run(input, output);
      var results = output[0] as List<double>;
      var maxScore = 0.0;
      var maxIndex = 0;
      for (var i = 0; i < results.length; i++) {
        if (results[i] > maxScore) {
          maxScore = results[i];
          maxIndex = i;
        }
      }
      if (_labels != null && maxIndex < _labels!.length) {
        name.value = _labels![maxIndex];
        confidence.value = maxScore.toStringAsFixed(2);
        splitModelResult();
        calculateDiseaseSeverity(double.parse(confidence.value));
      }
    } catch (e) {
      // Handle error
    }
  }

  void splitModelResult() {
    List temp = name.value.split(' ');
    cropName.value = temp[0];
    temp.removeAt(0);
    if (temp.isNotEmpty && temp[0].toLowerCase() == modelName.toLowerCase()) {
      temp.removeAt(0);
    }
    diseaseName.value = temp.join(' ');
    if (diseaseName.value.isEmpty) {
      diseaseName.value = "healthy";
    }
  }

  void calculateDiseaseSeverity(double confidenceScore) {
    if (diseaseName.value.toLowerCase() == "healthy") {
      diseaseSeverity.value = "0%";
      return;
    }
    double severityPercentage = confidenceScore * 100;
    if (confidenceScore > 0.8) {
      severityPercentage = 75 + (confidenceScore - 0.8) * 125;
    } else if (confidenceScore > 0.6) {
      severityPercentage = 50 + (confidenceScore - 0.6) * 125;
    } else if (confidenceScore > 0.4) {
      severityPercentage = 25 + (confidenceScore - 0.4) * 125;
    } else {
      severityPercentage = confidenceScore * 62.5;
    }
    if (severityPercentage > 100) severityPercentage = 100;
    diseaseSeverity.value = "${severityPercentage.toStringAsFixed(0)}%";
  }

  void closeModel() async {
    _interpreter?.close();
  }
}
