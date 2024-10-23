import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jummi/components/default_button.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/services/ecommerce_services.dart';
import 'package:jummi/size_config.dart';

class WallpaperForm extends StatefulWidget {
  const WallpaperForm({required this.ecommerce, super.key});

  final Ecommerce ecommerce;

  @override
  State<WallpaperForm> createState() => _WallpaperFormState();
}

class _WallpaperFormState extends State<WallpaperForm> {
  bool _loading = false;
  bool imageLoading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    setState(() {
      imageLoading = true;
    });
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
    setState(() {
      imageLoading = false;
    });
  }

  void _updateWallpaper(String? action) async {
    setState(() {
      _loading = true;
    });

    final response = await EcommerceService.updateWallpaper(
      widget.ecommerce.id,
      _imageFile,
      action,
    );

    if (response != null && response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      await Get.off(EcommerceScreen(ecommerce_id: widget.ecommerce.id!));
    } else if (response == null) {
      setState(() {
        _loading = false;
      });
      Get.snackbar(
        'Wallpaper update error',
        'Something went wrong!'.tr,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    } else {
      setState(() {
        _loading = false;
      });
      Get.snackbar(
        'Wallpaper update error',
        'Error on updating wallpaper',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  image: _imageFile == null
                      ? widget.ecommerce.wallpaperThumb == null
                          ? null
                          : DecorationImage(
                              image: NetworkImage(media_host + widget.ecommerce.wallpaperThumb),
                              fit: BoxFit.cover,
                            )
                      : DecorationImage(
                          image: FileImage(
                            _imageFile ?? File(''),
                          ),
                          fit: BoxFit.cover,
                        ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: imageLoading == true
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                getImage();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.upload_rounded,
                                    size: getProportionateScreenWidth(14),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Upload'.tr,
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(14),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _loading == true
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: DefaultButton(
                            text: 'Confirm'.tr,
                            press: () {
                              _updateWallpaper('update');
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text('Delete?'.tr),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'.tr),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _updateWallpaper('delete');
                                      },
                                      child: Text('Yes'.tr),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBarBuilder(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 28,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Wallpaper image'.tr,
      ),
    );
  }
}
