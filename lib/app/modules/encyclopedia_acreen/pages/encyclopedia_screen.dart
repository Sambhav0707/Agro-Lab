import 'package:agrolab/app/modules/encyclopedia_acreen/controller/encyclopedia_controller.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
// ignore: unnecessary_import
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../about_screen/pages/app_info_screen.dart';
import '../../home_screen/pages/home_screen.dart';

class Encyclopedia extends StatefulWidget {
  const Encyclopedia({super.key});

  @override
  State<Encyclopedia> createState() => _EncyclopediaState();
}

class _EncyclopediaState extends State<Encyclopedia> {
  Color backgroundColor = const Color(0xffe9edf1);
  Color secondaryColor = const Color(0xffe1e6ec);
  Color accentColor = const Color(0xff2d5765);
  late EncyclopediaController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    controller = Get.isRegistered<EncyclopediaController>()
        ? Get.put(EncyclopediaController())
        : Get.find<EncyclopediaController>();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMoreNews();
    }
  }

  Future<void> _onRefresh() async {
    // Reset to top of list
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Refresh the news list
    controller.refreshNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset(
                        'assets/agrolabicon.svg',
                        width: 45,
                        height: 45,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
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
                // Refresh button
                Obx(() => controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        onPressed: controller.refreshNews,
                        icon: const Icon(Icons.refresh),
                      )),
              ],
            ),

            // Animation
            RepaintBoundary(
              child: LottieBuilder.asset(
                'assets/58375-plantas-y-hojas.json',
                width: 400,
                height: 100,
              ),
            ),

            // News Articles with RefreshIndicator
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading news',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: controller.refreshNews,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.newsList.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'No news articles available\nPull down to refresh',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: controller.newsList.length +
                        (controller.hasMorePages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the bottom
                      if (index == controller.newsList.length) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Loading more articles...',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final news = controller.newsList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () async {
                              // if (news.href.isNotEmpty) {
                              //   try {
                              //     // Clean and validate the URL
                              //     String cleanUrl = news.href.trim();

                              //     // Check if URL contains truncated content or invalid patterns
                              //     if (cleanUrl.contains('[+') ||
                              //         cleanUrl.contains('[upgrade') ||
                              //         cleanUrl.contains('...') ||
                              //         cleanUrl.length < 10) {
                              //       // Show message for truncated/invalid URLs
                              //       if (mounted) {
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(
                              //           SnackBar(
                              //             content: Text(
                              //                 'Article link not available (truncated)'),
                              //             duration: const Duration(seconds: 2),
                              //             backgroundColor: Colors.orange,
                              //           ),
                              //         );
                              //       }
                              //       return;
                              //     }

                              //     // Add protocol if missing
                              //     if (!cleanUrl.startsWith('http://') &&
                              //         !cleanUrl.startsWith('https://')) {
                              //       cleanUrl = 'https://$cleanUrl';
                              //     }

                              //     // Encode special characters
                              //     cleanUrl = Uri.encodeFull(cleanUrl);

                              //     Uri url = Uri.parse(cleanUrl);
                              //     final canLaunch = await canLaunchUrl(url);
                              //     if (canLaunch) {
                              //       await launchUrl(url,
                              //           mode: LaunchMode.externalApplication);
                              //     } else {
                              //       // Show snackbar if URL cannot be launched
                              //       if (mounted) {
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(
                              //           SnackBar(
                              //             content: Text(
                              //                 'Cannot open: ${news.title}'),
                              //             duration: const Duration(seconds: 2),
                              //             backgroundColor: Colors.orange,
                              //           ),
                              //         );
                              //       }
                              //     }
                              //   } catch (e) {
                              //     // Show error snackbar with more details
                              //     if (mounted) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text(
                              //               'Invalid URL format: ${news.href}'),
                              //           duration: const Duration(seconds: 3),
                              //           backgroundColor: Colors.red,
                              //         ),
                              //       );
                              //     }
                              //     print('URL parsing error: ${e.toString()}');
                              //     print('Original URL: ${news.href}');
                              //   }
                              // } else {
                              //   // Show message if no URL available
                              //   if (mounted) {
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text(
                              //             'No link available for this article'),
                              //         duration: Duration(seconds: 2),
                              //         backgroundColor: Colors.grey,
                              //       ),
                              //     );
                              //   }
                              // }
                            },
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  // Image
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        bottomLeft: Radius.circular(13),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        bottomLeft: Radius.circular(13),
                                      ),
                                      child: news.image.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: news.image,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                color: Colors.grey.shade300,
                                                child: const Icon(Icons.image,
                                                    size: 40),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.grey.shade300,
                                                child: const Icon(Icons.error,
                                                    size: 40),
                                              ),
                                            )
                                          : Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.article,
                                                  size: 40),
                                            ),
                                    ),
                                  ),

                                  // Content
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news.title,
                                            style: const TextStyle(
                                              fontFamily: 'intan',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Expanded(
                                            child: Text(
                                              news.description,
                                              style: const TextStyle(
                                                fontFamily: 'intan',
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
