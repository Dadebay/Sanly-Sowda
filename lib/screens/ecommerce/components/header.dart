import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/components/avatar_form.dart';
import 'package:jummi/screens/ecommerce/components/wallpaper_form.dart';
import 'package:jummi/screens/home/home_screen.dart';

class Header extends StatelessWidget {
  const Header({
    required this.ecommerce,
    super.key,
  });

  final Ecommerce ecommerce;

  @override
  Widget build(BuildContext context) {
    final MainController mainC = Get.put(MainController());
    return Container(
      decoration: ecommerce.wallpaperThumb == null
          ? BoxDecoration(
              color: Colors.grey.shade300,
              image: const DecorationImage(
                image: AssetImage('assets/images/noimage-bg.png'),
                fit: BoxFit.cover,
              ),
            )
          : BoxDecoration(
              color: Colors.grey.shade300,
              image: DecorationImage(
                image: CachedNetworkImageProvider(media_host + ecommerce.wallpaperThumb),
                fit: BoxFit.cover,
              ),
            ),
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(.4),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.previousRoute == '' || Get.previousRoute == '/' ? Get.off(const HomeScreen()) : Get.back();
                      },
                      icon: Icon(
                        Get.previousRoute == '' ? Icons.home_rounded : Icons.chevron_left,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 49,
                    height: 49,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(.4),
                    ),
                    child: PopupMenuButton(
                      child: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'report',
                          height: 35,
                          child: Text(
                            'Report',
                          ),
                        ),
                        // PopupMenuItem(
                        //   child: Text(
                        //     'See on map',
                        //   ),
                        //   value: "report",
                        //   height: 35,
                        // ),
                        // PopupMenuItem(
                        //   child: Container(
                        //     height: 0.5,
                        //     width: double.infinity,
                        //     color: Colors.grey,
                        //   ),
                        //   height: 10,
                        // ),
                        // PopupMenuItem(
                        //   child: Text(
                        //     'Open your own store',
                        //   ),
                        //   value: "open",
                        //   height: 35,
                        // ),
                      ],
                      onSelected: (value) => {
                        if (value == 'edit')
                          {
                            // Edit
                          }
                        else
                          {
                            // Delete
                          },
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 200),
          Positioned(
            top: 100,
            left: 10,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.only(top: 5, right: 5),
              width: 80,
              height: 80,
              decoration: ecommerce.avatarThumb == null
                  ? BoxDecoration(
                      color: Colors.grey,
                      image: const DecorationImage(image: AssetImage('assets/images/noimage-profile.png'), fit: BoxFit.cover),
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    )
                  : BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(image: CachedNetworkImageProvider(media_host + ecommerce.avatarThumb), fit: BoxFit.cover),
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
              child: Obx(
                () => mainC.user.value.userEcommerce != null && mainC.user.value.userEcommerce!.id == ecommerce.id
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: GestureDetector(
                              onTap: () => Get.to(
                                AvatarForm(
                                  ecommerce: ecommerce,
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(180, 197, 197, 197),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          ),
          Obx(
            () => mainC.user.value.userEcommerce != null && mainC.user.value.userEcommerce!.id == ecommerce.id
                ? Positioned(
                    bottom: 20,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => Get.to(
                        WallpaperForm(
                          ecommerce: ecommerce,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(180, 197, 197, 197),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
