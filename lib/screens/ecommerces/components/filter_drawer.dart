// ignore_for_file: invalid_use_of_protected_member, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/ecommerces_filter.dart';
import 'package:jummi/controllers/main_controller.dart';
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
  final EcommercesFilterController _efController = Get.put(EcommercesFilterController());
  late int? uncollapsedCategory = 0;
  late int? uncollapsedLocation = 0;
  late List<Category?>? selectedCategories = [];
  late List<Location?>? selectedLocations = [];
  late bool? delivery = false;
  late bool? topRated = false;
  late bool categoriesOpen = true;
  late bool locationsOpen = false;

  @override
  void initState() {
    selectedCategories!.addAll(_efController.categories);
    selectedLocations!.addAll(_efController.locations);
    delivery = _efController.delivery.value;
    topRated = _efController.topRated.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
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
                        fontSize: width * 0.05,
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
                        size: width * 0.06,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.06,
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
                                fontSize: width * 0.045,
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
                              width: width,
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
                                                category.storesSum == null || category.storesSum == 0
                                                    ? const SizedBox()
                                                    : Container(
                                                        decoration: BoxDecoration(
                                                          color: uncollapsedCategory == category.id ? const Color.fromARGB(30, 231, 106, 60) : Colors.transparent,
                                                        ),
                                                        child: Column(
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
                                                                        borderRadius: BorderRadius.circular(0),
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      if (category.children!.isEmpty) {
                                                                        if (selectedCategories!.contains(category)) {
                                                                          setState(() {
                                                                            selectedCategories!.remove(category);
                                                                          });
                                                                        } else {
                                                                          setState(() {
                                                                            selectedCategories!.add(category);
                                                                          });
                                                                        }
                                                                        _efController.setCategory(category);
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
                                                                          const SizedBox(width: 10),
                                                                          Expanded(
                                                                            child: Text(
                                                                              Get.locale == const Locale('tm', 'TM') ? category.name!.tm.toString() : category.name!.ru.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: width * 0.045,
                                                                                color: selectedCategories!.contains(category) ||
                                                                                        (selectedCategories!.any((element) => category.children!.contains(element)))
                                                                                    ? kPrimaryColor
                                                                                    : Colors.black87,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 5),
                                                                          category.children != null && category.children!.isNotEmpty
                                                                              ? Text(category.storesSum.toString())
                                                                              : selectedCategories!.contains(category)
                                                                                  ? Icon(
                                                                                      Icons.check_rounded,
                                                                                      color: kPrimaryColor,
                                                                                      size: SizeConfig.screenWidth * 0.05,
                                                                                    )
                                                                                  : const SizedBox(),
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
                                                                                  backgroundColor: const Color.fromARGB(30, 231, 106, 60),
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
                                                                                  _efController.setCategory(category);
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        Get.locale == const Locale('tm', 'TM') ? category.name!.tm.toString() : category.name!.ru.toString(),
                                                                                        style: TextStyle(
                                                                                          fontSize: width * 0.045,
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
                                                                                        : Text(
                                                                                            category.stores_count.toString(),
                                                                                            style: const TextStyle(
                                                                                              color: Colors.black87,
                                                                                            ),
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              for (var cat in category.children!)
                                                                                cat.stores_count == null || cat.stores_count == 0
                                                                                    ? const SizedBox()
                                                                                    : TextButton(
                                                                                        style: TextButton.styleFrom(
                                                                                          padding: const EdgeInsets.symmetric(
                                                                                            vertical: 10,
                                                                                            horizontal: 17,
                                                                                          ),
                                                                                          backgroundColor: const Color.fromARGB(30, 231, 106, 60),
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
                                                                                          _efController.setCategory(cat);
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                Get.locale == const Locale('tm', 'TM') ? cat.name!.tm.toString() : cat.name!.ru.toString(),
                                                                                                style: TextStyle(
                                                                                                  fontSize: width * 0.045,
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
                                                                                                : Text(
                                                                                                    cat.stores_count.toString(),
                                                                                                    style: const TextStyle(
                                                                                                      color: Colors.black87,
                                                                                                    ),
                                                                                                  ),
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
                                fontSize: width * 0.045,
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
                              width: width,
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
                                                                borderRadius: BorderRadius.circular(0),
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
                                                                        fontSize: width * 0.045,
                                                                        color: selectedLocations!.contains(location) || (selectedLocations!.any((element) => location.children!.contains(element)))
                                                                            ? kPrimaryColor
                                                                            : Colors.black87,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 5),
                                                                  location.children != null && location.children!.isNotEmpty
                                                                      ? Icon(
                                                                          location.id == uncollapsedLocation ? Icons.remove_rounded : Icons.add_rounded,
                                                                          color: Colors.black54,
                                                                          size: SizeConfig.screenWidth * 0.06,
                                                                        )
                                                                      : const SizedBox(),
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
                                                                          _efController.setLocation(location);
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
                                                                                        fontSize: width * 0.045,
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
                                                                            _efController.setLocation(loc);
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
                                                                                          fontSize: width * 0.045,
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
                            topRated = !topRated!;
                          });
                          _efController.setTopRated();
                        },
                        child: Row(
                          children: [
                            topRated == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 5),
                            Text(
                              'Top Rated'.tr,
                              style: TextStyle(
                                fontSize: width * 0.045,
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
                          _efController.setDelivery();
                        },
                        child: Row(
                          children: [
                            delivery == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 5),
                            Text(
                              'Delivery'.tr,
                              style: TextStyle(
                                fontSize: width * 0.045,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
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
                            topRated = false;
                            delivery = false;
                            selectedCategories = [];
                            selectedLocations = [];
                          });
                          _efController.clearFilter();
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
                          _efController.setSearch(true);
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
