import 'dart:convert';

import 'package:agrolab/app/utils/const/const.dart';
import 'package:get/get.dart';
import 'package:http/http.dart ' as http;

class EncyclopediaController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getEncyclopedia();
    super.onInit();
  }

  Future<void> getEncyclopedia() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.newsUri));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
