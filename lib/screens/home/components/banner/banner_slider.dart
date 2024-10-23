// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/models/MyBanner.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/product_details/product_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerSlider extends StatefulWidget {
  final List<MyBanner> bannerList;
  const BannerSlider({required this.bannerList, super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;
  late List<Widget> imageSlider;

  @override
  void initState() {
    imageSlider = widget.bannerList
        .map(
          (e) => GestureDetector(
            onTap: () async {
              if (e.url != null && e.url.startsWith('http')) {
                // Web url
                await launchUrl(Uri.parse(e.url));
              } else if (e.url != null && e.url.startsWith('product:')) {
                // Product
                await Get.to(
                  () => DetailsScreen(
                    product_id: int.parse(e.url.substring(8)),
                    editable: false,
                  ),
                );
              } else if (e.url != null && e.url.startsWith('ecommerce:')) {
                // Ecommerce
                await Get.to(
                  EcommerceScreen(
                    ecommerce_id: int.parse(e.url.substring(10)),
                  ),
                );
              } else {
                // Nothing
              }
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: media_host + e.imageThumb!,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      progressIndicatorBuilder: (context, url, DownloadProgress) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: imageSlider,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(
                () {
                  _current = index;
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageSlider.map((e) {
            final int index = imageSlider.indexOf(e);
            return AnimatedContainer(
              duration: kAnimationDuration,
              width: _current == index ? 16 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _current == index ? kPrimaryColor : Colors.black12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
