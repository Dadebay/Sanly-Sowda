// ignore_for_file: invalid_use_of_protected_member, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/controllers/products_filter.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/models/Location.dart';
import 'package:jummi/size_config.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer(this.drawerKey, {super.key});
  final GlobalKey<ScaffoldState> drawerKey;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  final MainController _mainController = Get.put(MainController());
  final ProductsFilterController _pfController = Get.put(ProductsFilterController());
  late int? uncollapsedCategory = 0;
  late int? uncollapsedLocation = 0;
  late List<Category?>? selectedCategories = [];
  late List<Location?>? selectedLocations = [];
  late bool? delivery = false;
  late bool? favorite = false;
  late bool? discount = false;
  late bool categoriesOpen = false;
  late bool locationsOpen = false;

  @override
  void initState() {
    selectedCategories!.addAll(_pfController.categories);
    selectedLocations!.addAll(_pfController.locations);
    delivery = _pfController.delivery.value;
    favorite = _pfController.favorite.value;
    discount = _pfController.discount.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Drawer(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter'.tr,
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 0.05,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.drawerKey.currentState!.closeEndDrawer();
                      },
                      child: Icon(
                        Icons.close_rounded,
                        size: SizeConfig.screenWidth * 0.06,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black.withOpacity(.3),
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.06,
              bottom: 58,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black12),
                    bottom: BorderSide(color: Colors.black12),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      !categoriesOpen
                          ? const SizedBox()
                          : AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: SizeConfig.screenWidth,
                              // height: categoriesOpen ? 300 : 0,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(10, 0, 0, 0),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
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
                                                                  category,
                                                                )) {
                                                                  setState(() {
                                                                    selectedCategories!.remove(category);
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    selectedCategories!.add(category);
                                                                  });
                                                                }
                                                                _pfController.setCategory(
                                                                  category,
                                                                );
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
                                                                          width: SizeConfig.screenWidth * 0.08,
                                                                          color: kPrimaryColor,
                                                                          placeholderBuilder: (BuildContext context) => Container(
                                                                            padding: const EdgeInsets.all(30.0),
                                                                            child: const CircularProgressIndicator(),
                                                                          ),
                                                                        )
                                                                      : Image.asset(
                                                                          'assets/images/no-image.png',
                                                                          width: SizeConfig.screenWidth * 0.09,
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      Get.locale == const Locale('tm', 'TM') ? category.name!.tm.toString() : category.name!.ru.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: SizeConfig.screenWidth * 0.045,
                                                                        color: selectedCategories!.contains(category) || (selectedCategories!.any((element) => category.children!.contains(element)))
                                                                            ? kPrimaryColor
                                                                            : Colors.black87,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  // category.children != null && category.children!.length != 0
                                                                  //     ? Icon(
                                                                  //         category.id == uncollapsedCategory ? Icons.remove : Icons.add,
                                                                  //         color: Colors.black54,
                                                                  //         size: SizeConfig.screenWidth * 0.06,
                                                                  //       )
                                                                  //     : selectedCategories!.contains(category)
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
                                                                          backgroundColor: const Color.fromARGB(20, 0, 0, 0),
                                                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(0),
                                                                          ),
                                                                        ),
                                                                        onPressed: () {
                                                                          if (selectedCategories!.contains(category)) {
                                                                            setState(() {
                                                                              selectedCategories!.remove(category);
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              selectedCategories!.add(category);
                                                                            });
                                                                          }
                                                                          _pfController.setCategory(category);
                                                                        },
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                Get.locale == const Locale('tm', 'TM') ? category.name!.tm.toString() : category.name!.ru.toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: SizeConfig.screenWidth * 0.045,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: selectedCategories!.contains(category) ? kPrimaryColor : Colors.black87,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            selectedCategories!.contains(category)
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
                                                                            backgroundColor: const Color.fromARGB(20, 0, 0, 0),
                                                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(0),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            if (selectedCategories!.contains(cat)) {
                                                                              setState(() {
                                                                                selectedCategories!.remove(cat);
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                selectedCategories!.add(cat);
                                                                              });
                                                                            }
                                                                            _pfController.setCategory(cat);
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  Get.locale == const Locale('tm', 'TM') ? cat.name!.tm.toString() : cat.name!.ru.toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: SizeConfig.screenWidth * 0.045,
                                                                                    color: selectedCategories!.contains(cat) ? kPrimaryColor : Colors.black87,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              selectedCategories!.contains(cat)
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
                              "${"Locations".tr} (${selectedLocations!.length} ${"selected".tr})",
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
                      !locationsOpen
                          ? const SizedBox()
                          : AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: SizeConfig.screenWidth,
                              // height: locationsOpen ? 300 : 0,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(10, 0, 0, 0),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
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
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Text('No data'.tr),
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
                                                                      Get.locale == const Locale('tm', 'TM') ? location.name!.tm.toString() : location.name!.ru.toString(),
                                                                      style: TextStyle(
                                                                        fontSize: SizeConfig.screenWidth * 0.045,
                                                                        color: selectedLocations!.contains(location) || selectedLocations!.any((element) => location.children!.contains(element))
                                                                            ? kPrimaryColor
                                                                            : Colors.black87,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  // location.children != null &&
                                                                  //         location.children!.length != 0
                                                                  //     ? Icon(
                                                                  //         location.id == uncollapsedLocation ? Icons.remove_rounded : Icons.add_rounded,
                                                                  //         color: Colors.black54,
                                                                  //         size: SizeConfig.screenWidth * 0.06,
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
                                                                          if (selectedLocations!.contains(location)) {
                                                                            setState(() {
                                                                              selectedLocations!.remove(location);
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              selectedLocations!.add(location);
                                                                            });
                                                                          }
                                                                          _pfController.setLocation(location);
                                                                        },
                                                                        style: TextButton.styleFrom(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            vertical: 10,
                                                                            horizontal: 17,
                                                                          ),
                                                                          backgroundColor: const Color.fromARGB(20, 0, 0, 0),
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
                                                                                      Get.locale == const Locale('tm', 'TM') ? location.name!.tm.toString() : location.name!.ru.toString(),
                                                                                      style: TextStyle(
                                                                                        fontSize: SizeConfig.screenWidth * 0.045,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: selectedLocations!.contains(location) ? kPrimaryColor : Colors.black87,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            selectedLocations!.contains(location)
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
                                                                            if (selectedLocations!.contains(loc)) {
                                                                              setState(() {
                                                                                selectedLocations!.remove(loc);
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                selectedLocations!.add(loc);
                                                                              });
                                                                            }
                                                                            _pfController.setLocation(loc);
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                            padding: const EdgeInsets.symmetric(
                                                                              vertical: 5,
                                                                              horizontal: 17,
                                                                            ),
                                                                            backgroundColor: const Color.fromARGB(20, 0, 0, 0),
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
                                                                                          color: selectedLocations!.contains(loc) ? kPrimaryColor : Colors.black87,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              selectedLocations!.contains(loc)
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
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            favorite = !favorite!;
                          });
                          _pfController.setFavorite();
                        },
                        child: Row(
                          children: [
                            favorite == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 5),
                            Text(
                              'Top Rated'.tr,
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth * 0.04,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            discount = !discount!;
                          });
                          _pfController.setDiscount();
                        },
                        child: Row(
                          children: [
                            discount == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 5),
                            Text(
                              'Discount'.tr,
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth * 0.04,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            delivery = !delivery!;
                          });
                          _pfController.setDelivery();
                        },
                        child: Row(
                          children: [
                            delivery == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 5),
                            Text(
                              'Delivery'.tr,
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth * 0.04,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            favorite = false;
                            discount = false;
                            delivery = false;
                            selectedCategories = [];
                            selectedLocations = [];
                          });
                          _pfController.clearFilter();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red,
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.red,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Clear Filter'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pfController.setSearch(true);
                          widget.drawerKey.currentState!.closeEndDrawer();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1.0,
                            color: kPrimaryColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Search'.tr,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
