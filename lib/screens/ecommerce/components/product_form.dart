// ignore_for_file: unnecessary_null_comparison, invalid_use_of_protected_member, deprecated_member_use, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jummi/components/default_button.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/models/Ecommerce.dart';
import 'package:jummi/models/Product.dart';
import 'package:jummi/screens/ecommerce/ecommerce_screen.dart';
import 'package:jummi/services/product_services.dart';
import 'package:jummi/size_config.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({
    required this.product,
    required this.ecommerce,
    super.key,
  });

  final Product? product;
  final Ecommerce? ecommerce;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final MainController _mainController = Get.put(MainController());
  final _picker = ImagePicker();
  bool imageLoading = false;
  final List<File> _imageFiles = [];
  late int? uncollapsedCategory = 0;
  late int? selectedCategory = 0;
  late bool _loading = false;
  TextEditingController txtName = TextEditingController();
  TextEditingController txtContent = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtDiscountPrice = TextEditingController();

  Future getImage() async {
    setState(() {
      imageLoading = true;
    });
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
      });
    }
    setState(() {
      imageLoading = false;
    });
  }

  void _handleDelete() async {
    final response = await ProductService.deleteProduct(widget.product!.id);
    if (response != null && response.statusCode == 200) {
      await Get.off(EcommerceScreen(ecommerce_id: widget.ecommerce!.id!));
    } else if (response == null) {
      Get.snackbar(
        'Product delete error',
        'Something went wrong!'.tr,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    } else {
      Get.snackbar(
        'Product delete error',
        json.decode(utf8.decode(response.bodyBytes))['detail'],
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  void _submitForm() async {
    setState(() {
      _loading = true;
    });
    final response = widget.product == null
        ? await ProductService.createProduct(
            widget.ecommerce!.id,
            _imageFiles,
            txtName.text,
            txtContent.text,
            txtPrice.text,
            txtDiscountPrice.text,
            selectedCategory,
          )
        : await ProductService.updateProduct(
            widget.product!.id,
            txtName.text,
            txtContent.text,
            txtPrice.text,
            txtDiscountPrice.text,
            selectedCategory,
          );
    if (response != null && response.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      await Get.to(EcommerceScreen(ecommerce_id: widget.ecommerce!.id!));
    } else if (response == null) {
      setState(() {
        _loading = false;
      });
      Get.snackbar(
        widget.product == null ? 'Product create error' : 'Product update error',
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
        widget.product == null ? 'Product create error' : 'Product update error',
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
    if (widget.product != null) {
      txtName.text = widget.product!.name != null ? widget.product!.name.toString() : '';
      txtContent.text = widget.product!.content != null ? widget.product!.content.toString() : '';
      txtPrice.text = widget.product!.price != null ? widget.product!.price.toString() : '';
      txtDiscountPrice.text = widget.product!.discountPrice != null ? widget.product!.discountPrice.toString() : '';
      selectedCategory = widget.product!.category!.id;
    }
    if (_mainController.allCategoryData.isEmpty) {
      _mainController.fetchAllCategories();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarBuilder(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.product == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${"Images".tr}:",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Text('First image is main image'.tr),
                        ],
                      ),
                    )
                  : const SizedBox(),
              widget.product == null
                  ? GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      childAspectRatio: 1,
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      padding: const EdgeInsets.all(10.0),
                      children: List.generate(
                        _imageFiles == null ? 1 : _imageFiles.length + 1,
                        (index) {
                          return index < _imageFiles.length
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _imageFiles.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(
                                          _imageFiles[index],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () => getImage(),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                    ),
                                  ),
                                );
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${"Name".tr}:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.05,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: txtName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Name'.tr,
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
                      Text(
                        "${"Content".tr}:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.05,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: txtContent,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Content'.tr,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${"Price".tr}:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.screenWidth * 0.05,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: txtPrice,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Price'.tr,
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
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${"Discount price".tr}:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: SizeConfig.screenWidth * 0.05,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: txtDiscountPrice,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Discount price'.tr,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${"Category".tr}:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.screenWidth * 0.05,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: SizeConfig.screenWidth,
                        // height: 300,
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
                                                          if (selectedCategory == category.id) {
                                                            setState(() {
                                                              selectedCategory = 0;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              selectedCategory = category.id;
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
                                                                  color: selectedCategory == category.id ? kPrimaryColor : Colors.black87,
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
                                                            //     : selectedCategory == category.id
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
                                                                    if (selectedCategory == category.id) {
                                                                      setState(() {
                                                                        selectedCategory = 0;
                                                                      });
                                                                    } else {
                                                                      setState(() {
                                                                        selectedCategory = category.id;
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
                                                                            color: selectedCategory == category.id ? kPrimaryColor : Colors.black87,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      selectedCategory == category.id
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
                                                                      if (selectedCategory == cat.id) {
                                                                        setState(() {
                                                                          selectedCategory = 0;
                                                                        });
                                                                      } else {
                                                                        setState(() {
                                                                          selectedCategory = cat.id;
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
                                                                              color: selectedCategory == cat.id ? kPrimaryColor : Colors.black87,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectedCategory == cat.id
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _loading == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : DefaultButton(
                                    text: 'Confirm'.tr,
                                    press: () => _submitForm(),
                                  ),
                          ),
                          widget.product != null ? const SizedBox(width: 10) : const SizedBox(),
                          widget.product != null
                              ? IconButton(
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
                                                _handleDelete();
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
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
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
        widget.product == null ? 'Add product'.tr : 'Change product'.tr,
      ),
    );
  }
}
