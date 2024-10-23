// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/ecommerce_filter.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/size_config.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer(this.drawerKey, {super.key});
  final GlobalKey<ScaffoldState> drawerKey;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  final _categoryScrollController = ScrollController();
  final MainController _mainController = Get.put(MainController());
  final EcommerceFilterController _efController = Get.put(EcommerceFilterController());
  late int? uncollapsedCategory = 0;
  late List<int?>? selectedCategories = [];
  late bool? favorite = false;
  late bool? discount = false;

  @override
  void initState() {
    selectedCategories!.addAll(_efController.categories);
    favorite = _efController.favorite.value;
    discount = _efController.discount.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.drawerKey.currentState!.closeEndDrawer();
                      },
                      child: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black.withOpacity(.3),
                ),
                const SizedBox(height: 10),
                Text(
                  'Categories (${selectedCategories!.length} selected)',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 250,
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
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text('No data'),
                                  )
                                : Column(
                                    children: [
                                      // ignore: invalid_use_of_protected_member
                                      for (var category in _mainController.allCategoryData.value)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 3,
                                            horizontal: 5,
                                          ),
                                          decoration: const BoxDecoration(
                                              // color: selectedCategories!
                                              //         .contains(
                                              //             category.id)
                                              //     ? Color.fromARGB(
                                              //         30, 0, 0, 0)
                                              //     : Color.fromARGB(
                                              //         0, 0, 0, 0),
                                              ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (uncollapsedCategory != category.id) {
                                                          setState(() {
                                                            uncollapsedCategory = category.id;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            uncollapsedCategory = 0;
                                                          });
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          category.children != null && category.children!.isNotEmpty
                                                              ? Icon(
                                                                  category.id == uncollapsedCategory ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
                                                                )
                                                              : const SizedBox(),
                                                          const SizedBox(width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              category.name!.tm.toString(),
                                                              style: TextStyle(
                                                                fontSize: SizeConfig.screenWidth * 0.05,
                                                                color: selectedCategories!.contains(
                                                                  category.id,
                                                                )
                                                                    ? kPrimaryColor
                                                                    : Colors.black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  category.children!.isEmpty
                                                      ? GestureDetector(
                                                          onTap: () {
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
                                                            _efController.setCategory(
                                                              category.id,
                                                            );
                                                          },
                                                          child: selectedCategories!.contains(
                                                            category.id,
                                                          )
                                                              ? Icon(
                                                                  Icons.check_box_outlined,
                                                                  color: selectedCategories!.contains(
                                                                    category.id,
                                                                  )
                                                                      ? kPrimaryColor
                                                                      : Colors.black54,
                                                                )
                                                              : Icon(
                                                                  Icons.check_box_outline_blank,
                                                                  color: selectedCategories!.contains(
                                                                    category.id,
                                                                  )
                                                                      ? kPrimaryColor
                                                                      : Colors.black54,
                                                                ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              uncollapsedCategory == category.id
                                                  ? Container(
                                                      child: category.children!.isNotEmpty
                                                          ? Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    vertical: 1,
                                                                    horizontal: 10,
                                                                  ),
                                                                  margin: const EdgeInsets.only(
                                                                    left: 10,
                                                                  ),
                                                                  decoration: const BoxDecoration(
                                                                    color: Color.fromARGB(
                                                                      20,
                                                                      0,
                                                                      0,
                                                                      0,
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
                                                                                'Hemmesi',
                                                                                style: TextStyle(
                                                                                  fontSize: SizeConfig.screenWidth * 0.05,
                                                                                  fontWeight: FontWeight.w700,
                                                                                  color: selectedCategories!.contains(category.id) ? kPrimaryColor : Colors.black87,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          if (selectedCategories!.contains(category.id)) {
                                                                            setState(() {
                                                                              selectedCategories!.remove(category.id);
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              selectedCategories!.add(category.id);
                                                                            });
                                                                          }
                                                                          _efController.setCategory(category.id);
                                                                        },
                                                                        child: selectedCategories!.contains(category.id)
                                                                            ? Icon(
                                                                                Icons.check_box_outlined,
                                                                                color: selectedCategories!.contains(category.id) ? kPrimaryColor : Colors.black54,
                                                                              )
                                                                            : Icon(
                                                                                Icons.check_box_outline_blank,
                                                                                color: selectedCategories!.contains(category.id) ? kPrimaryColor : Colors.black54,
                                                                              ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                for (var cat in category.children!)
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical: 1,
                                                                      horizontal: 10,
                                                                    ),
                                                                    margin: const EdgeInsets.only(
                                                                      left: 10,
                                                                    ),
                                                                    decoration: const BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                        20,
                                                                        0,
                                                                        0,
                                                                        0,
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
                                                                                  cat.name!.tm.toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: SizeConfig.screenWidth * 0.05,
                                                                                    color: selectedCategories!.contains(cat.id) ? kPrimaryColor : Colors.black87,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            if (selectedCategories!.contains(cat.id)) {
                                                                              setState(() {
                                                                                selectedCategories!.remove(cat.id);
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                selectedCategories!.add(cat.id);
                                                                              });
                                                                            }
                                                                            _efController.setCategory(cat.id);
                                                                          },
                                                                          child: selectedCategories!.contains(cat.id)
                                                                              ? Icon(
                                                                                  Icons.check_box_outlined,
                                                                                  color: selectedCategories!.contains(cat.id) ? kPrimaryColor : Colors.black54,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.check_box_outline_blank,
                                                                                  color: selectedCategories!.contains(cat.id) ? kPrimaryColor : Colors.black54,
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
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          favorite = !favorite!;
                        });
                        _efController.setFavorite();
                      },
                      child: favorite == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                    ),
                    const SizedBox(width: 5),
                    const Text('Favorite'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          discount = !discount!;
                        });
                        _efController.setDiscount();
                      },
                      child: discount == true ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank),
                    ),
                    const SizedBox(width: 5),
                    const Text('Discount'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            favorite = false;
                            discount = false;
                            selectedCategories = [];
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
                        child: const Text(
                          'Clear Filter',
                          style: TextStyle(
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
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
