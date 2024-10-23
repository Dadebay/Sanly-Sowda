// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/models/HomeStore.dart';
import 'package:jummi/models/MyBanner.dart';
import 'package:jummi/models/Product.dart';
import 'package:jummi/services/banner_services.dart';
import 'package:jummi/services/category_services.dart';
import 'package:jummi/services/ecommerce_services.dart';
import 'package:jummi/services/product_services.dart';

class HomeController extends GetxController {
  // Banner
  var bannersLoading = false.obs;
  var bannersError = ''.obs;
  var banners = <MyBanner>[].obs;

  void getBanners() async {
    try {
      bannersLoading(true);
      bannersError('');

      final List<MyBanner>? data = await BannerService.fetchBannerData();
      if (data != null) {
        banners.assignAll(data);
      } else {
        bannersError('Something went wrong');
      }
    } on Exception catch (_) {
      bannersError('Something went wrong');
    } finally {
      bannersLoading(false);
    }
  }

  // Top Discount
  var topDiscount = Product().obs;
  var topDiscountLoading = false.obs;
  var topDiscountError = ''.obs;

  void getTopDiscount() async {
    try {
      topDiscountLoading(true);
      topDiscountError('');

      final Product? data = await ProductService.getTopDiscount();
      if (data != null) {
        topDiscount(data);
      } else {
        topDiscountError('Something went wrong!'.tr);
      }
    } on Exception catch (_) {
      topDiscountError('Something went wrong!'.tr);
    } finally {
      topDiscountLoading(false);
    }
  }

  // Top Categories
  var topCategoriesLoading = false.obs;
  var topCategoriesError = ''.obs;
  var topCategories = <Category>[].obs;

  void getTopCategories() async {
    try {
      topCategoriesLoading(true);
      topCategoriesError('');

      final List<Category>? data = await CategoryService.fetchTopCategories();
      if (data != null) {
        topCategories.assignAll(data);
      } else {
        topCategoriesError('Something went wrong!'.tr);
      }
    } on Exception catch (_) {
      topCategoriesError('Something went wrong!'.tr);
    } finally {
      topCategoriesLoading(false);
    }
  }

  // Home Stores
  var homeStoresLoading = false.obs;
  var homeStores = <HomeStore>[].obs;
  var homeStoresError = ''.obs;

  void getHomeStores() async {
    try {
      homeStoresLoading(true);
      homeStoresError('');

      final List<HomeStore>? data = await EcommerceService.getHomeStores();
      if (data != null) {
        homeStores.assignAll(data);
      } else {
        homeStoresError('Something went wrong!'.tr);
      }
    } on Exception catch (_) {
      homeStoresError('Something went wrong!'.tr);
    } finally {
      homeStoresLoading(false);
    }
  }

  // New Products
  var newProductsLoading = false.obs;
  var newProducts = <Product>[].obs;
  var newProductsError = ''.obs;

  void getPopularProducts() async {
    try {
      newProductsLoading(true);
      newProductsError('');

      final List<Product>? data = await ProductService.getPopularProducts();
      if (data != null) {
        newProducts.assignAll(data);
      } else {
        newProductsError('Something went wrong!'.tr);
      }
    } on Exception catch (_) {
      newProductsError('Something went wrong!'.tr);
    } finally {
      newProductsLoading(false);
    }
  }

  // New Products
  var homeProductsLoading = false.obs;
  var homeProducts = <Product>[].obs;
  var homeProductsError = ''.obs;

  void getHomeProducts() async {
    try {
      homeProductsLoading(true);
      homeProductsError('');

      final List<Product>? data = await ProductService.getHomeProducts();
      if (data != null) {
        homeProducts.assignAll(data);
      } else {
        homeProductsError('Something went wrong!'.tr);
      }
    } on Exception catch (_) {
      homeProductsError('Something went wrong!'.tr);
    } finally {
      homeProductsLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Banners
    if (banners.value.isEmpty) {
      getBanners();
    }

    // Top Discount
    if (topDiscount.value.id == null) {
      getTopDiscount();
    }

    // Top Categories
    if (topCategories.value.isEmpty) {
      getTopCategories();
    }

    // Home Stores
    if (homeStores.value.isEmpty) {
      getHomeStores();
    }

    // New Products
    if (newProducts.value.isEmpty) {
      getPopularProducts();
    }

    // Home Products
    if (homeProducts.value.isEmpty) {
      getHomeProducts();
    }
  }
}
