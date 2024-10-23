import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/home/home_screen.dart';
import 'package:jummi/services/account_services.dart';
import 'package:jummi/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({required this.phone, super.key});

  final String phone;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late int lastSecs;
  late int minutes;
  late int seconds;
  late bool loading = false;

  TextEditingController otp = TextEditingController();

  late MainController _c;

  @override
  void initState() {
    _c = Get.put(MainController());
    setState(() {
      lastSecs = DateTime.now().difference(_c.otp_exp_date.value).inSeconds.abs();
      minutes = lastSecs ~/ 60;
      seconds = lastSecs - (lastSecs ~/ 60) * 60;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (lastSecs <= 0) {
            lastSecs = 0;
            minutes = 0;
            seconds = 0;
          } else {
            lastSecs = lastSecs - 1;
            minutes = lastSecs ~/ 60;
            seconds = lastSecs - (lastSecs ~/ 60) * 60;
          }
        });
      }
    });
    super.initState();
  }

  void _checkOtp() async {
    final SharedPreferences prefs = await _prefs;
    final response = await AccountService.checkOtp(
      _c.otp_phone.value,
      otp.text,
    );

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      await prefs.setString('access_token', json.decode(response.body)['access_token']);
      await checkToken();
      Get.snackbar(
        'Login'.tr,
        'You have logged in successfully!'.tr,
        colorText: Colors.white,
        backgroundColor: Colors.green,
        icon: const Icon(
          Icons.login,
          color: Colors.white,
        ),
        margin: const EdgeInsets.all(10),
      );
      await Get.off(const HomeScreen());
    } else if (response == null) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'OTP check error'.tr,
        'Something went wrong!'.tr,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    } else {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Sign in error'.tr,
        // json.decode(response.body)["detail"],
        jsonDecode(utf8.decode(response.bodyBytes))['detail'],
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(150)),
              Text(
                'OTP Verification'.tr,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Obx(() => Text("${"We sent your OTP code to".tr} ****${_c.otp_phone.value.replaceAll(" ", "").substring(_c.otp_phone.value.replaceAll(" ", "").length - 4)}")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This code will expired in'.tr,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "0$minutes:${seconds >= 10 ? seconds : '0$seconds'}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(150),
                      child: TextFormField(
                        controller: otp,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kTextColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: kTextColor),
                          ),
                        ),
                        onChanged: (value) {
                          // nextField(value: value, focusNode: pin2FocusNode);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    loading == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    'Continue'.tr,
                                    style: TextStyle(
                                      fontSize: getProportionateScreenWidth(16),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    _checkOtp();
                                  },
                                ),
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
    );
  }
}
