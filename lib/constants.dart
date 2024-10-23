// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jummi/models/Account.dart';
import 'package:jummi/screens/sign_in/sign_in_screen.dart';
import 'package:jummi/services/account_services.dart';
import 'package:jummi/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/main_controller.dart';

const api_host = 'http://216.250.11.212:8182/api/v1';
const media_host = 'http://216.250.11.212:8182';

const kPrimaryColor = Color.fromARGB(255, 255, 118, 67);
const kSecondColor = Color.fromARGB(255, 43, 114, 107);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  color: Colors.black,
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
);

///BorderRadius
const BorderRadius borderRadius5 = BorderRadius.all(Radius.circular(5));
const BorderRadius borderRadius10 = BorderRadius.all(Radius.circular(10));
const BorderRadius borderRadius15 = BorderRadius.all(Radius.circular(15));
const BorderRadius borderRadius20 = BorderRadius.all(Radius.circular(20));
const BorderRadius borderRadius25 = BorderRadius.all(Radius.circular(25));
const BorderRadius borderRadius30 = BorderRadius.all(Radius.circular(30));
const BorderRadius borderRadius40 = BorderRadius.all(Radius.circular(40));
const BorderRadius borderRadius50 = BorderRadius.all(Radius.circular(50));
/////////////////////////////////
const String gilroyBold = 'GilroyBold';
const String gilroySemiBold = 'GilroySemiBold';
const String gilroyMedium = 'GilroyMedium';
const String gilroyRegular = 'GilroyRegular';
//Language icons
const String tmIcon = 'assets/images/tm.png';
const String ruIcon = 'assets/images/ru.png';
const String engIcon = 'assets/images/uk.png';
///////////////////
// const String logo = 'assets/icons/logo.jpeg';
// const String noData = 'assets/lottie/noData.json';
// const String appName = 'Hajj';
const String loremImpsum =
    'Lorem ipsum, yaygın olarak kullanılan bir yer tutucu metne verilen isimdir. Dolgu veya sahte metin olarak da bilinen bu tip yer tutucu metinler, aslında anlamlı bir şey söylemeden bir alanı doldurmaya yarayan metinlerdir,Lorem ipsum, yaygın olarak kullanılan bir yer tutucu metne verilen isimdir. Dolgu veya sahte metin olarak da bilinen bu tip yer tutucu metinler, aslında anlamlı bir şey söylemeden bir alanı doldurmaya yarayan metinlerdir,Lorem ipsum, yaygın olarak kullanılan bir yer tutucu metne verilen isimdir. Dolgu veya sahte metin olarak da bilinen bu tip yer tutucu metinler, aslında anlamlı bir şey söylemeden bir alanı doldurmaya yarayan metinlerdir,Lorem ipsum, yaygın olarak kullanılan bir yer tutucu metne verilen isimdir. Dolgu veya sahte metin olarak da bilinen bu tip yer tutucu metinler, aslında anlamlı bir şey söylemeden bir alanı doldurmaya yarayan metinlerdir';
/////////////////////////////////////////////////
const String loadingLottie = 'assets/lottie/loading.json';
const String noDataLottie = 'assets/lottie/noData.json';
/////////////////////////////////////////////////

// Form Error
final RegExp emailValidatorRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
const String kPhoneNullError = 'Please Enter your phone number';
const String kInvalidPhoneError = 'Please Enter Valid Phone Number';
const String kInvalidPassError = 'Please enter valid password';
const String kShortPassError = 'Password is too short';
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = 'Please Enter your name';
const String kPhoneNumberNullError = 'Please Enter your phone number';
const String kAddressNullError = 'Please Enter your address';

// Error message
const String somethingWentWrong = 'Something went wrong!';
const String serverError = 'Server Error!';
const String unauthorized = 'Unauthorized';

Future<bool> checkConnection() async {
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse(api_host));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

bool checkUserAuth() {
  final MainController c = Get.put(MainController());
  if (c.user.value.id != null) {
    return true;
  } else {
    Get.defaultDialog(
      title: 'Login required!'.tr,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(
        color: Colors.black,
      ),
      content: Column(
        children: [
          Text(
            'You need to login to do this action!'.tr,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(const SignInScreen());
            },
            child: Text('Sign In'.tr),
          ),
        ],
      ),
      radius: 5,
    );
    return false;
  }
}

String makeFollowersCount(int? count) {
  if (count! > 1000000) {
    return '${count ~/ 1000000}.${(count % 1000000).toString()[0]}M';
  } else if (count > 1000) {
    return '${count ~/ 1000}.${(count % 1000).toString()[0]}K';
  } else {
    return count.toString();
  }
}

Future checkToken() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final MainController c = Get.put(MainController());
  final String? token = pref.getString('access_token');

  if (token == null) {
    c.setUser(null);
    return null;
  } else {
    final dynamic response = await AccountService.getMe(token);

    if (response != null && response.statusCode == 200) {
      final Account user = Account.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      c.setUser(user);
    } else if (response != null && response.statusCode == 404) {
      await pref.remove('access_token');
    } else {
      return '';
    }
    return pref.getString('access_token');
  }
}

String? getStringImage(File? file) {
  if (file == null) {
    return null;
  }
  return base64Encode(file.readAsBytesSync());
}

void removeToken() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.remove('access_token');
}
