// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tree/flutter_tree.dart';
import 'package:get/get.dart';
import 'package:jummi/components/default_button.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/services/ecommerce_services.dart';
import 'package:jummi/size_config.dart';

class InfoForm extends StatefulWidget {
  const InfoForm({required this.ecommerce, super.key});

  final Ecommerce ecommerce;

  @override
  State<InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDelivery = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtLocation = TextEditingController();
  final _categoryScrollController = ScrollController();
  final _locationScrollController = ScrollController();
  final MainController _mainController = Get.put(MainController());
  late bool? delivery = false;
  late List<int?>? selectedCategories = [];
  late int selectedLocation = 0;
  late int? uncollapsedCategory = 0;
  late int? uncollapsedLocation = 0;
  late String? map_latitude = '';
  late String? map_longitude;
  bool _loading = false;
  late bool categoriesOpen = true;
  late bool locationsOpen = true;

  bool _checkIn(List<Category> categories, Category category) {
    var tick = false;
    for (var i = 0; i < categories.length; i++) {
      if (categories[i].id == category.id) {
        tick = true;
      }
    }
    return tick;
  }

  TreeNodeData mapServerDataToTreeData(Category category) {
    return TreeNodeData(
      title: category.name!.tm.toString(),
      expaned: false,
      extra: category.id,
      checked: _checkIn(widget.ecommerce.categories!, category),
      children: List.from(
        category.children!.map(
          (x) => mapServerDataToTreeData(x),
        ),
      ),
    );
  }

  void _updateInfo() async {
    setState(() {
      _loading = true;
    });

    final response = await EcommerceService.updateInfo(
      widget.ecommerce.id,
      txtName.text,
      txtDescription.text,
      delivery,
      double.parse(txtDelivery.text),
      selectedCategories,
      txtLocation.text,
      selectedLocation,
      map_latitude,
      map_longitude,
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
        'Info update error',
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
        'Info update error',
        json.decode(response.body)['detail'],
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  @override
  void initState() {
    txtName.text = widget.ecommerce.name.toString();
    txtDescription.text = widget.ecommerce.description.toString();
    txtDelivery.text = widget.ecommerce.delivery_price.toString();
    delivery = widget.ecommerce.delivery;
    txtLocation.text = widget.ecommerce.locationStr != null ? widget.ecommerce.locationStr.toString() : '';
    selectedLocation = widget.ecommerce.location != null ? widget.ecommerce.location!.id! : 0;
    if (widget.ecommerce.map_latitude == null || widget.ecommerce.map_longitude == null) {
      map_latitude = null;
      map_longitude = null;
    } else {
      map_latitude = widget.ecommerce.map_latitude;
      map_longitude = widget.ecommerce.map_longitude;
    }
    for (var i = 0; i < widget.ecommerce.categories!.length; i++) {
      selectedCategories!.add(widget.ecommerce.categories![i].id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 5,
                    ),
                    child: Text(
                      "${"Name".tr}:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: txtName,
                    decoration: InputDecoration(
                      hintText: 'Name of store'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 5,
                    ),
                    child: Text(
                      "${"Description".tr}:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: txtDescription,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Description about store'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        categoriesOpen = !categoriesOpen;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${"Categories".tr} (${selectedCategories!.length} ${"selected".tr})",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        categoriesOpen ? const Icon(Icons.expand_less_outlined) : const Icon(Icons.expand_more_rounded),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: categoriesOpen ? 10 : 0,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: SizeConfig.screenWidth,
                    height: categoriesOpen ? 300 : 0,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _categoryScrollController,
                      child: SingleChildScrollView(
                        controller: _categoryScrollController,
                        child: Obx(
                          () => _mainController.allCategoryDataLoading == true
                              ? Container(
                                  padding: const EdgeInsets.all(20),
                                  child: const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : _mainController.allCategoryData.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Text('No data'.tr),
                                    )
                                  : Column(
                                      children: [
                                        for (var category in _mainController.allCategoryData.value)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                      style: TextButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(
                                                          vertical: 7,
                                                          horizontal: 5,
                                                        ),
                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        if (category.children!.isEmpty) {
                                                          if (selectedCategories!.contains(
                                                            category.id,
                                                          )) {
                                                            setState(() {
                                                              selectedCategories!.remove(
                                                                category.id,
                                                              );
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedCategories!.add(
                                                                category.id,
                                                              );
                                                            });
                                                          }
                                                        } else {
                                                          if (uncollapsedCategory != category.id) {
                                                            setState(() {
                                                              uncollapsedCategory = category.id;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              uncollapsedCategory = 0;
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            category.image != null
                                                                ? SvgPicture.network(
                                                                    media_host + category.image,
                                                                    width: SizeConfig.screenWidth * 0.06,
                                                                    color: kPrimaryColor,
                                                                    placeholderBuilder: (BuildContext context) => Container(
                                                                      padding: const EdgeInsets.all(30.0),
                                                                      child: const SizedBox(
                                                                        width: 20,
                                                                        height: 20,
                                                                        child: CircularProgressIndicator(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Image.asset(
                                                                    'assets/images/no-image.png',
                                                                    width: SizeConfig.screenWidth * 0.09,
                                                                  ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                Get.locale ==
                                                                        const Locale(
                                                                          'tm',
                                                                          'TM',
                                                                        )
                                                                    ? category.name!.tm.toString()
                                                                    : category.name!.ru.toString(),
                                                                style: TextStyle(
                                                                  fontSize: SizeConfig.screenWidth * 0.045,
                                                                  color: selectedCategories!.contains(
                                                                    category.id,
                                                                  )
                                                                      ? kPrimaryColor
                                                                      : Colors.black87,
                                                                ),
                                                              ),
                                                            ),
                                                            // SizedBox(width: 5),
                                                            // category.children != null && category.children!.length != 0
                                                            //     ? Icon(
                                                            //         category.id == uncollapsedCategory ? Icons.remove : Icons.add,
                                                            //         color: Colors.black54,
                                                            //         size: SizeConfig.screenWidth * 0.06,
                                                            //       )
                                                            //     : selectedCategories!.contains(category.id)
                                                            //         ? Icon(
                                                            //             Icons.check_rounded,
                                                            //             color: kPrimaryColor,
                                                            //             size: SizeConfig.screenWidth * 0.05,
                                                            //           )
                                                            //         : SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              uncollapsedCategory == category.id
                                                  ? Container(
                                                      child: category.children!.isNotEmpty
                                                          ? Column(
                                                              children: [
                                                                TextButton(
                                                                  style: TextButton.styleFrom(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical: 10,
                                                                      horizontal: 17,
                                                                    ),
                                                                    backgroundColor: const Color.fromARGB(
                                                                      20,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                    ),
                                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(0),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    if (selectedCategories!.contains(
                                                                      category.id,
                                                                    )) {
                                                                      setState(() {
                                                                        selectedCategories!.remove(category.id);
                                                                      });
                                                                    } else {
                                                                      setState(() {
                                                                        selectedCategories!.add(category.id);
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          'All'.tr,
                                                                          style: TextStyle(
                                                                            fontSize: SizeConfig.screenWidth * 0.045,
                                                                            fontWeight: FontWeight.w700,
                                                                            color: selectedCategories!.contains(category.id) ? kPrimaryColor : Colors.black87,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      selectedCategories!.contains(category.id)
                                                                          ? Icon(
                                                                              Icons.check_rounded,
                                                                              color: kPrimaryColor,
                                                                              size: SizeConfig.screenWidth * 0.05,
                                                                            )
                                                                          : const SizedBox(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                for (var cat in category.children!)
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        vertical: 10,
                                                                        horizontal: 17,
                                                                      ),
                                                                      backgroundColor: const Color.fromARGB(
                                                                        20,
                                                                        0,
                                                                        0,
                                                                        0,
                                                                      ),
                                                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(0),
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      if (selectedCategories!.contains(cat.id)) {
                                                                        setState(() {
                                                                          selectedCategories!.remove(cat.id);
                                                                        });
                                                                      } else {
                                                                        setState(() {
                                                                          selectedCategories!.add(cat.id);
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(
                                                                            Get.locale == const Locale('tm', 'TM') ? cat.name!.tm.toString() : cat.name!.ru.toString(),
                                                                            style: TextStyle(
                                                                              fontSize: SizeConfig.screenWidth * 0.045,
                                                                              color: selectedCategories!.contains(cat.id) ? kPrimaryColor : Colors.black87,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectedCategories!.contains(cat.id)
                                                                            ? Icon(
                                                                                Icons.check_rounded,
                                                                                color: kPrimaryColor,
                                                                                size: SizeConfig.screenWidth * 0.05,
                                                                              )
                                                                            : const SizedBox(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],
                                                            )
                                                          : const SizedBox(),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        locationsOpen = !locationsOpen;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Locations'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        locationsOpen ? const Icon(Icons.expand_less_outlined) : const Icon(Icons.expand_more_rounded),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: locationsOpen ? 10 : 0,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: SizeConfig.screenWidth,
                    height: locationsOpen ? 300 : 0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _locationScrollController,
                      child: SingleChildScrollView(
                        controller: _locationScrollController,
                        child: Obx(
                          () => _mainController.allLocationDataLoading == true
                              ? Container(
                                  padding: const EdgeInsets.all(20),
                                  child: const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : _mainController.allLocationData.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Text('No data'),
                                    )
                                  : Column(
                                      children: [
                                        for (var location in _mainController.allLocationData.value)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (uncollapsedLocation != location.id) {
                                                          setState(() {
                                                            uncollapsedLocation = location.id;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            uncollapsedLocation = 0;
                                                          });
                                                        }
                                                      },
                                                      style: TextButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 5,
                                                        ),
                                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                Get.locale ==
                                                                        const Locale(
                                                                          'tm',
                                                                          'TM',
                                                                        )
                                                                    ? location.name!.tm.toString()
                                                                    : location.name!.ru.toString(),
                                                                style: TextStyle(
                                                                  fontSize: SizeConfig.screenWidth * 0.045,
                                                                  color: selectedLocation == location.id ? kPrimaryColor : Colors.black87,
                                                                ),
                                                              ),
                                                            ),
                                                            // SizedBox(
                                                            //     width: 5),
                                                            // location.children !=
                                                            //             null &&
                                                            //         location.children!
                                                            //                 .length !=
                                                            //             0
                                                            //     ? Icon(
                                                            //         location.id ==
                                                            //                 uncollapsedLocation
                                                            //             ? Icons
                                                            //                 .remove_rounded
                                                            //             : Icons
                                                            //                 .add_rounded,
                                                            //         color: Colors
                                                            //             .black54,
                                                            //         size: SizeConfig
                                                            //                 .screenWidth *
                                                            //             0.06,
                                                            //       )
                                                            //     : SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              uncollapsedLocation == location.id
                                                  ? Container(
                                                      child: location.children!.isNotEmpty
                                                          ? Column(
                                                              children: [
                                                                TextButton(
                                                                  onPressed: () {
                                                                    if (selectedLocation == location.id) {
                                                                      setState(() {
                                                                        selectedLocation = 0;
                                                                      });
                                                                    } else {
                                                                      setState(() {
                                                                        selectedLocation = location.id!;
                                                                      });
                                                                    }
                                                                  },
                                                                  style: TextButton.styleFrom(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical: 10,
                                                                      horizontal: 17,
                                                                    ),
                                                                    backgroundColor: const Color.fromARGB(
                                                                      20,
                                                                      0,
                                                                      0,
                                                                      0,
                                                                    ),
                                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(0),
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                'All'.tr,
                                                                                style: TextStyle(
                                                                                  fontSize: SizeConfig.screenWidth * 0.045,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: selectedLocation == location.id ? kPrimaryColor : Colors.black87,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      selectedLocation == location.id
                                                                          ? Icon(
                                                                              Icons.check_rounded,
                                                                              color: kPrimaryColor,
                                                                              size: SizeConfig.screenWidth * 0.05,
                                                                            )
                                                                          : const SizedBox(),
                                                                    ],
                                                                  ),
                                                                ),
                                                                for (var loc in location.children!)
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      if (selectedLocation == loc.id) {
                                                                        setState(() {
                                                                          selectedLocation = 0;
                                                                        });
                                                                      } else {
                                                                        setState(() {
                                                                          selectedLocation = loc.id!;
                                                                        });
                                                                      }
                                                                    },
                                                                    style: TextButton.styleFrom(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        vertical: 5,
                                                                        horizontal: 17,
                                                                      ),
                                                                      backgroundColor: const Color.fromARGB(
                                                                        20,
                                                                        0,
                                                                        0,
                                                                        0,
                                                                      ),
                                                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(0),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  Get.locale == const Locale('tm', 'TM') ? loc.name!.tm.toString() : loc.name!.ru.toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: SizeConfig.screenWidth * 0.045,
                                                                                    color: selectedLocation == loc.id ? kPrimaryColor : Colors.black87,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        selectedLocation == loc.id
                                                                            ? Icon(
                                                                                Icons.check_rounded,
                                                                                color: kPrimaryColor,
                                                                                size: SizeConfig.screenWidth * 0.05,
                                                                              )
                                                                            : const SizedBox(),
                                                                      ],
                                                                    ),
                                                                  ),
                                                              ],
                                                            )
                                                          : const SizedBox(),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 5,
                    ),
                    child: Text(
                      "${"A written location".tr}:",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: txtLocation,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Location',
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final geoPoint = await showSimplePickerLocation(
                              context: context,
                              isDismissible: true,
                              textCancelPicker: 'Cancel'.tr,
                              textConfirmPicker: 'Select'.tr,
                              initCurrentUserPosition: true,
                              initZoom: 12,
                            );
                            if (geoPoint != null) {
                              setState(() {
                                map_latitude = geoPoint.latitude.toString();
                                map_longitude = geoPoint.longitude.toString();
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              map_latitude == null || map_longitude == null
                                  ? Icon(
                                      Icons.add_location_outlined,
                                      size: SizeConfig.screenWidth * 0.05,
                                    )
                                  : Icon(
                                      Icons.edit_location_outlined,
                                      size: SizeConfig.screenWidth * 0.05,
                                    ),
                              const SizedBox(width: 5),
                              Text(
                                map_latitude == null || map_longitude == null ? 'Select location from map'.tr : 'Change selected location from map'.tr,
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.04,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            map_latitude = null;
                            map_longitude = null;
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                          size: SizeConfig.screenWidth * 0.08,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: delivery,
                          onChanged: (value) {
                            setState(() {
                              delivery = !delivery!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Have a delivery service?'.tr,
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.05,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  delivery == true
                      ? Text(
                          "${"Delivery price".tr}:",
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 0.05,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox(),
                  delivery == true ? const SizedBox(height: 5) : const SizedBox(),
                  delivery == true
                      ? TextFormField(
                          controller: txtDelivery,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Delivery price'.tr,
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            isDense: true,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  _loading == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : DefaultButton(
                          text: 'Confirm'.tr,
                          press: () => _updateInfo(),
                        ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
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
        'Change info'.tr,
      ),
    );
  }
}
