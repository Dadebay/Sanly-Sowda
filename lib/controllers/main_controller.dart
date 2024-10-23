// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'dart:convert';

import 'package:get/get.dart';
import 'package:jummi/models/Account.dart';
import 'package:jummi/models/Category.dart';
import 'package:jummi/models/Contact.dart';
import 'package:jummi/models/Help.dart';
import 'package:jummi/models/Hunting.dart';
import 'package:jummi/models/Location.dart';
import 'package:jummi/models/Noti.dart';
import 'package:jummi/models/Policy.dart';
import 'package:jummi/services/category_services.dart';
import 'package:jummi/services/help_services.dart';
import 'package:jummi/services/location_services.dart';
import 'package:jummi/services/noti_services.dart';
import 'package:jummi/services/policy_services.dart';

class MainController extends GetxController {
  // Set OTP phone
  var otp_phone = '*'.obs;

  void setOtpPhone(phone) {
    otp_phone.value = phone;
  }

  // Set OTP exp date
  var otp_exp_date = DateTime.now().obs;

  void setOtpExpDate(date) {
    otp_exp_date.value = DateTime.parse(date);
  }

  // Set User
  final user = Account().obs;

  void setUser(account) {
    if (account == null) {
      user.value = Account();
    } else {
      user.value = account;
    }
  }

  // Fetch all Categories
  var allCategoryDataLoading = false.obs;
  var allCategoryData = <Category>[].obs;

  void fetchAllCategories() async {
    try {
      allCategoryDataLoading = true.obs;

      final List<Category>? data = await CategoryService.fetchAllCategories();
      if (data != null) {
        allCategoryData.assignAll(data);
      }
    } finally {
      allCategoryDataLoading.value = false;
    }
  }

  // Fetch All Locations
  var allLocationDataLoading = false.obs;
  var allLocationData = <Location>[].obs;

  void fetchAllLocations() async {
    try {
      allLocationDataLoading = true.obs;

      final List<Location>? data = await LocationService.fetchLocations();
      if (data != null) {
        allLocationData.assignAll(data);
      }
    } finally {
      allLocationDataLoading.value = false;
    }
  }

  // Get Contacts
  var contactsLoading = false.obs;
  var contactsError = ''.obs;
  var contacts = <Contact>[].obs;

  void getContacts() async {
    try {
      contactsLoading = true.obs;
      contactsError.value = '';

      final List<Contact>? data = await HelpService.getContacts();
      if (data != null) {
        contacts.assignAll(data);
      } else {
        contactsError.value = 'Something went wrong!'.tr;
      }
    } on Exception catch (_) {
      contactsError.value = 'Something went wrong!'.tr;
    } finally {
      contactsLoading.value = false;
    }
  }

  // Get Helps
  var helpsLoading = false.obs;
  var helpsError = ''.obs;
  var helps = <Help>[].obs;

  void getHelps() async {
    try {
      helpsLoading = true.obs;
      helpsError.value = '';
      final List<Help>? data = await HelpService.getHelps();
      if (data != null) {
        helps.assignAll(data);
      } else {
        helpsError.value = 'Something went wrong!'.tr;
      }
    } on Exception catch (_) {
      helpsError.value = 'Something went wrong!'.tr;
    } finally {
      helpsLoading.value = false;
    }
  }

  // Get Policy
  var policiesLoading = false.obs;
  var policiesError = ''.obs;
  var policies = <Policy>[].obs;

  void getPolicies() async {
    try {
      policiesLoading = true.obs;
      policiesError.value = '';
      final List<Policy>? data = await PolicyService.getPolicies();
      if (data != null) {
        policies.assignAll(data);
      } else {
        policiesError.value = 'Something went wrong!'.tr;
      }
    } on Exception catch (_) {
      policiesError.value = 'Something went wrong!'.tr;
    } finally {
      policiesLoading.value = false;
    }
  }

  // Get Hunting
  var huntingLoading = false.obs;
  var huntingError = ''.obs;
  var hunting = Hunting().obs;

  Future<void> getHunting() async {
    try {
      huntingLoading = true.obs;
      huntingError = ''.obs;
      final dynamic data = await HuntingService.getHunting();
      if (data != null) {
        hunting.value = Hunting.fromJson(json.decode(utf8.decode(data.bodyBytes)));
      } else {
        huntingError.value = 'Something went wrong!'.tr;
      }
    } on Exception catch (_) {
      huntingError.value = 'Something went wrong!'.tr;
    } finally {
      huntingLoading.value = false;
    }
  }

  // Get Notifications
  var notisLoading = false.obs;
  var notisError = ''.obs;
  var notifications = <Noti>[].obs;

  void getNotifications() async {
    try {
      notisLoading = true.obs;
      notisError.value = '';
      final List<Noti>? data = await NotiService.fetchNotificationsTwo();
      if (data != null) {
        notifications.assignAll(data);
      } else {
        notisError.value = 'Something went wrong!'.tr;
      }
    } on Exception catch (_) {
      notisError.value = 'Something went wrong!'.tr;
    } finally {
      notisLoading.value = false;
    }
  }

  @override
  void onInit() {
    // Categories
    if (allCategoryData.isEmpty) {
      fetchAllCategories();
    }
    // Locations
    if (allLocationData.isEmpty) {
      fetchAllLocations();
    }
    // Contacts
    if (contacts.value.isEmpty) {
      getContacts();
    }
    // Helps
    if (helps.value.isEmpty) {
      getHelps();
    }
    // Policy
    if (policies.value.isEmpty) {
      getPolicies();
    }
    // Hunting
    // if (hunting.value.id == null) getHunting();
    // Notifications
    if (notifications.value.isEmpty) {
      getNotifications();
    }
    super.onInit();
  }
}
