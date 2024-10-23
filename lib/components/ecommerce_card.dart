import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class EcommerceCard extends StatelessWidget {
  const EcommerceCard({
    required this.detail,
    super.key,
  });

  final Ecommerce detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => Get.to(
          EcommerceScreen(ecommerce_id: detail.id!),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: SizeConfig.screenHeight * 0.08,
              decoration: detail.wallpaperThumb == null
                  ? BoxDecoration(
                      color: Colors.grey.shade300,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/noimage-bg.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    )
                  : BoxDecoration(
                      color: Colors.grey.shade300,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(media_host + detail.wallpaperThumb),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
            ),
            detail.delivery == true
                ? Positioned(
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        radius: SizeConfig.screenWidth * 0.04,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.local_shipping,
                          size: SizeConfig.screenWidth * 0.04,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Positioned(
              top: SizeConfig.screenHeight * 0.01,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: SizeConfig.screenWidth * 0.18,
                  height: SizeConfig.screenWidth * 0.18,
                  decoration: detail.avatarThumb == null
                      ? BoxDecoration(
                          color: Colors.grey,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/noimage-profile.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        )
                      : BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(media_host + detail.avatarThumb),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.09),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: SizeConfig.screenWidth * 0.04,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            makeFollowersCount(detail.followers_count),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7),
                              fontSize: SizeConfig.screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: SizeConfig.screenWidth * 0.04,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${detail.review_value}'.substring(0, 3),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7),
                              fontSize: SizeConfig.screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.002),
                  Center(
                    child: Text(
                      detail.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.004),
                  detail.categories!.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                '${detail.categories![0].name!.tm}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.035,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${detail.location!.name!.tm}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 0.035,
                            color: Colors.black54,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
