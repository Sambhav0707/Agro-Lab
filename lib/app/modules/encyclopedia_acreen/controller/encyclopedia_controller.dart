import 'dart:convert';

import 'package:agrolab/app/modules/encyclopedia_acreen/models/news_model.dart';
import 'package:agrolab/app/utils/const/const.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EncyclopediaController extends GetxController {
  RxList<NewsResult> newsList = <NewsResult>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxString errorMessage = ''.obs;
  RxBool hasMorePages = true.obs;
  RxString nextPageUrl = ''.obs;

  @override
  void onInit() {
    getEncyclopedia();
    super.onInit();
  }

  Future<void> getEncyclopedia() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(Uri.parse(AppConstants.newsUri));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newsModel = NewsModel.fromJson(data);

        // Filter out empty results and add to the list
        newsList.value = newsModel.results
            .where((result) =>
                result.title.isNotEmpty && result.description.isNotEmpty)
            .toList();

        // Set pagination info
        hasMorePages.value = newsModel.hasNextPages;
        nextPageUrl.value = newsModel.nextPage;

        print('Fetched ${newsList.length} news articles');
      } else {
        errorMessage.value = 'Failed to load news: ${response.statusCode}';
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('Exception: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreNews() async {
    if (isLoadingMore.value ||
        !hasMorePages.value ||
        nextPageUrl.value.isEmpty) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final response = await http.get(Uri.parse(nextPageUrl.value));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newsModel = NewsModel.fromJson(data);

        // Filter and add new results to existing list
        final newResults = newsModel.results
            .where((result) =>
                result.title.isNotEmpty && result.description.isNotEmpty)
            .toList();

        newsList.addAll(newResults);

        // Update pagination info
        hasMorePages.value = newsModel.hasNextPages;
        nextPageUrl.value = newsModel.nextPage;

        print(
            'Loaded ${newResults.length} more news articles. Total: ${newsList.length}');
      } else {
        print('Error loading more news: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception loading more news: ${e.toString()}');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void refreshNews() {
    hasMorePages.value = true;
    nextPageUrl.value = '';
    getEncyclopedia();
  }

  bool shouldLoadMore(int index) {
    // Load more when user reaches the last 3 items
    return index >= newsList.length - 3 &&
        hasMorePages.value &&
        !isLoadingMore.value &&
        nextPageUrl.value.isNotEmpty;
  }
}
