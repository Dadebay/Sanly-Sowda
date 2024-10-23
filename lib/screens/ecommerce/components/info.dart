// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/components/info_form.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/screens/map/map_screen.dart';
import 'package:jummi/services/ecommerce_services.dart';
import 'package:jummi/size_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  const Info({required this.ecommerce, super.key});

  final Ecommerce ecommerce;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final MainController _mainC = Get.put(MainController());
  late bool? _followed = false;
  bool _followLoading = false;

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _followEcommerce() async {
    setState(() {
      _followLoading = true;
    });
    final dynamic response = await EcommerceService.followEcommerce(widget.ecommerce.id);
    if (response != null && response.statusCode == 200) {
      setState(() {
        _followed = !_followed!;
        _followLoading = false;
      });
    } else {
      setState(() {
        _followLoading = false;
      });
    }
  }

  Future<void> _rateStore(id, star) async {
    final dynamic response = await EcommerceService.rateEcommerce(id, star);
    if (response != null && response.statusCode == 200) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EcommerceScreen(ecommerce_id: widget.ecommerce.id!),
        ),
      );
    } else {
      await Get.to(EcommerceScreen(ecommerce_id: id));
      Get.snackbar('Error', 'Something went wrong!'.tr);
    }
  }

  @override
  void initState() {
    _followed = widget.ecommerce.followed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Column(
        children: [
          // Name and Followers count
          const SizedBox(height: 10),
          widget.ecommerce.verified == false
              ? ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Store is not checked yet! Wait until Adminstrator checks.'.tr,
                          style: TextStyle(
                            height: 1,
                            fontSize: SizeConfig.screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Name
              SizedBox(
                width: getProportionateScreenWidth(250),
                child: Text(
                  widget.ecommerce.name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              // Followers count
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    makeFollowersCount(widget.ecommerce.followers_count),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  Text(
                    'followers'.tr,
                    style: const TextStyle(height: 1),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Follow button
                  Obx(
                    () => _mainC.user.value.userEcommerce != null && _mainC.user.value.userEcommerce!.id == widget.ecommerce.id
                        ? const SizedBox()
                        : Row(
                            children: [
                              _followLoading == true
                                  ? const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        if (checkUserAuth()) {
                                          _followEcommerce();
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: _followed == true ? Colors.black87 : Colors.transparent,
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: Colors.black87,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        _followed == true ? 'Unfollow'.tr : 'Follow'.tr,
                                        style: TextStyle(
                                          color: _followed == true ? Colors.white : Colors.black87,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 10),
                            ],
                          ),
                  ),
                  // Review button
                  OutlinedButton(
                    onPressed: () {
                      if (checkUserAuth()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            int starCount = 0;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return widget.ecommerce.rated == true
                                    ? AlertDialog(
                                        content: Text('You have already rated!'.tr),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      )
                                    : AlertDialog(
                                        title: Text('Rate store!'.tr),
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  starCount = 1;
                                                });
                                              },
                                              child: Icon(
                                                starCount >= 1 ? Icons.star_rate_rounded : Icons.star_border_rounded,
                                                size: 38,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  starCount = 2;
                                                });
                                              },
                                              child: Icon(
                                                starCount >= 2 ? Icons.star_rate_rounded : Icons.star_border_rounded,
                                                size: 38,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  starCount = 3;
                                                });
                                              },
                                              child: Icon(
                                                starCount >= 3 ? Icons.star_rate_rounded : Icons.star_border_rounded,
                                                size: 38,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  starCount = 4;
                                                });
                                              },
                                              child: Icon(
                                                starCount >= 4 ? Icons.star_rate_rounded : Icons.star_border_rounded,
                                                size: 38,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  starCount = 5;
                                                });
                                              },
                                              child: Icon(
                                                starCount >= 5 ? Icons.star_rate_rounded : Icons.star_border_rounded,
                                                size: 38,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Cancel'.tr),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              starCount == 0
                                                  ? Get.snackbar(
                                                      "${"Rate".tr}!",
                                                      'Please select stars!'.tr,
                                                    )
                                                  : _rateStore(
                                                      widget.ecommerce.id,
                                                      starCount,
                                                    );
                                            },
                                            child: Text('Rate'.tr),
                                          ),
                                        ],
                                      );
                              },
                            );
                          },
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: widget.ecommerce.rated == true ? kPrimaryColor : Colors.transparent,
                      side: const BorderSide(width: 1.0, color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.ecommerce.review_value.toString(),
                          style: TextStyle(
                            color: widget.ecommerce.rated == true ? Colors.white : kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.star,
                          color: widget.ecommerce.rated == true ? Colors.white : kPrimaryColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  widget.ecommerce.map_latitude == null || widget.ecommerce.map_longitude == null
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () => Get.to(
                            MapScreen(
                              many: false,
                              markers: [
                                {
                                  'latitude': widget.ecommerce.map_latitude.toString(),
                                  'longitude': widget.ecommerce.map_longitude.toString(),
                                },
                              ],
                              title: widget.ecommerce.name.toString(),
                            ),
                          ),
                          icon: Icon(
                            Icons.person_pin_circle_rounded,
                            color: kPrimaryColor,
                            size: SizeConfig.screenWidth * 0.08,
                          ),
                        ),
                  // QR code
                  IconButton(
                    icon: Icon(
                      Icons.qr_code_rounded,
                      color: kPrimaryColor,
                      size: SizeConfig.screenWidth * 0.08,
                    ),
                    onPressed: () {
                      Get.defaultDialog(
                        title: '',
                        titlePadding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        content: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            children: [
                              Screenshot(
                                controller: screenshotController,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: SizeConfig.screenHeight * 0.12,
                                        decoration: widget.ecommerce.wallpaperThumb == null
                                            ? BoxDecoration(
                                                color: Colors.grey.shade300,
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    'assets/images/noimage-bg.png',
                                                  ),
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
                                                  image: CachedNetworkImageProvider(
                                                    media_host + widget.ecommerce.wallpaperThumb,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                              ),
                                      ),
                                      Positioned(
                                        top: SizeConfig.screenHeight * 0.03,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Container(
                                            width: SizeConfig.screenWidth * 0.27,
                                            height: SizeConfig.screenWidth * 0.27,
                                            decoration: widget.ecommerce.avatarThumb == null
                                                ? BoxDecoration(
                                                    color: Colors.grey,
                                                    image: const DecorationImage(
                                                      image: AssetImage(
                                                        'assets/images/noimage-profile.png',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(
                                                      100,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 3,
                                                    ),
                                                  )
                                                : BoxDecoration(
                                                    color: Colors.grey,
                                                    image: DecorationImage(
                                                      image: CachedNetworkImageProvider(
                                                        media_host + widget.ecommerce.avatarThumb,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.circular(
                                                      100,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 3,
                                                    ),
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
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.16,
                                            ),
                                            Column(
                                              children: [
                                                Center(
                                                  child: SizedBox(
                                                    width: SizeConfig.screenWidth * 0.55,
                                                    child: Text(
                                                      widget.ecommerce.name!,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: SizeConfig.screenWidth * 0.06,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  widget.ecommerce.phone,
                                                  style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: SizeConfig.screenWidth * 0.038,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: SizeConfig.screenHeight * 0.006,
                                            ),
                                            Center(
                                              child: SizedBox(
                                                width: SizeConfig.screenWidth * 0.55,
                                                height: SizeConfig.screenWidth * 0.55,
                                                child: QrImage(
                                                  data: widget.ecommerce.id.toString(),
                                                  size: SizeConfig.screenWidth * 0.5,
                                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                                    size: const Size(100, 100),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/logo.svg',
                                                  width: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  'Sanly',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      233,
                                                      120,
                                                      45,
                                                    ),
                                                    fontSize: SizeConfig.screenWidth * 0.055,
                                                  ),
                                                ),
                                                Text(
                                                  'Söwda',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      45,
                                                      114,
                                                      107,
                                                    ),
                                                    fontSize: SizeConfig.screenWidth * 0.055,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Image(
                                                  image: const AssetImage(
                                                    'assets/images/mobile_apps.png',
                                                  ),
                                                  width: SizeConfig.screenWidth * 0.16,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: SizeConfig.screenWidth * 0.58,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await screenshotController.capture().then((Uint8List? image) async {
                                      final dir = await getTemporaryDirectory();
                                      final filename = '${dir.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';

                                      final file = File(filename);
                                      await file.writeAsBytes(image!).then((value) {
                                        // GallerySaver.saveImage(value.path)
                                        //     .then((value) {
                                        //   Get.snackbar(
                                        //     "Success".tr,
                                        //     "Image saved successfully!".tr,
                                        //     colorText: Colors.white,
                                        //     backgroundColor:
                                        //         Colors.green.withOpacity(.8),
                                        //     margin: EdgeInsets.all(10),
                                        //   );
                                        //   Navigator.pop(context);
                                        // }).onError((error, stackTrace) {
                                        //   Get.snackbar(
                                        //     "Error".tr,
                                        //     "Error on saving image to gallery!"
                                        //         .tr,
                                        //     colorText: Colors.white,
                                        //     backgroundColor:
                                        //         Colors.red.withOpacity(.8),
                                        //     margin: EdgeInsets.all(10),
                                        //   );
                                        // });
                                      }).onError((error, stackTrace) {});
                                    }).catchError((onError) {});
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download_rounded,
                                        size: SizeConfig.screenWidth * 0.04,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'Download as image'.tr,
                                        style: TextStyle(
                                          fontSize: SizeConfig.screenWidth * 0.04,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        radius: 5,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Column(
            children: [
              // Bio
              Row(
                children: [
                  widget.ecommerce.description != null && widget.ecommerce.description.length > 0
                      ? Expanded(
                          child: Text(
                            widget.ecommerce.description.toString(),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              widget.ecommerce.delivery == true ? const SizedBox(height: 5) : const SizedBox(),
              widget.ecommerce.delivery == true
                  ? Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text('${widget.ecommerce.delivery_price} TMT'),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 5),
              // Category
              widget.ecommerce.categories != null && widget.ecommerce.categories!.isNotEmpty
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          RichText(
                            text: TextSpan(
                              children: [
                                for (int i = 0; i < widget.ecommerce.categories!.length; i++) ...[
                                  TextSpan(
                                    text: (Get.locale == const Locale('tm', 'TM') ? widget.ecommerce.categories![i].name!.tm : widget.ecommerce.categories![i].name!.ru).toString() +
                                        (i + 1 != widget.ecommerce.categories!.length ? ', ' : ''),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: SizeConfig.screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 3),
              // Locations
              widget.ecommerce.location != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (Get.locale == const Locale('tm', 'TM') ? widget.ecommerce.location!.name!.tm : widget.ecommerce.location!.name!.ru).toString(),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.ecommerce.locationStr != null && widget.ecommerce.locationStr != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.ecommerce.locationStr.toString(),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 3),
              // Urls
              widget.ecommerce.urlA != null
                  ? Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.link,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              child: Text(
                                widget.ecommerce.urlA.toString(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse(
                                    widget.ecommerce.urlA.toString(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                      ],
                    )
                  : const SizedBox(),
              // Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final url = 'tel:${widget.ecommerce.phone}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // throw 'Could not launch $url';
                        Get.snackbar('Error', 'Could not launch $url!');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1.0, color: kPrimaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.ecommerce.phone.toString(),
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => _mainC.user.value.userEcommerce != null && _mainC.user.value.userEcommerce!.id == widget.ecommerce.id
                        ? OutlinedButton(
                            onPressed: () => Get.to(InfoForm(ecommerce: widget.ecommerce)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1.0, color: Colors.black87),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Edit'.tr,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
