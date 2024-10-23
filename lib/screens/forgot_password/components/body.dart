import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/components/no_account.dart';
import 'package:jummi/screens/sign_in/sign_in_screen.dart';
import 'package:jummi/services/account_services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../components/custom_prefix_icon.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_errors.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController txtPhone = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
    mask: '&% ## ## ##',
    filter: {'#': RegExp(r'[0-9]'), '&': RegExp(r'[6,7]'), '%': RegExp(r'[0-5]')},
    type: MaskAutoCompletionType.lazy,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  late bool loading = false;
  late String page = 'first';
  TextEditingController otp = TextEditingController();

  late bool passLoading = false;
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtRePassword = TextEditingController();

  void signinUser() async {
    final response = await AccountService.resetPasswordRequest(
      txtPhone.text,
    );
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
        page = 'second';
      });
    } else if (response == null) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Error'.tr,
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
        'Error'.tr,
        jsonDecode(utf8.decode(response.bodyBytes))['detail'],
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  void _checkOtp() async {
    final response = await AccountService.checkOtp(
      txtPhone.text,
      otp.text,
    );

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
        page = 'third';
      });
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

  void _resetPassword() async {
    final response = await AccountService.resetPassword(
      txtPhone.text,
      otp.text,
      txtPassword.text,
      txtRePassword.text,
    );

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Success'.tr,
        'Password changed successfully!'.tr,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        margin: const EdgeInsets.all(10),
      );
      await Get.to(const SignInScreen());
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
        'Error'.tr,
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
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenWidth(100),
            ),
            Text(
              'Reset Password'.tr,
              style: headingStyle,
            ),
            SizedBox(
              height: getProportionateScreenWidth(10),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
              child: Text(
                'Reset your password using your phone number. Then write OTP code from message that we have sent. After that set new password.'.tr,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: page == 'first'
                  ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: txtPhone,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              if (value.length == 10 && errors.contains('Please enter valid phone number'.tr)) {
                                setState(() {
                                  errors.remove('Please enter valid phone number'.tr);
                                });
                              }
                            },
                            validator: (value) {
                              if ((value!.length != 11 && !errors.contains('Please enter valid phone number'.tr)) || (value[0] == '7' && value[1] != '1')) {
                                setState(() {
                                  errors.add('Please enter valid phone number'.tr);
                                });
                              }
                              return null;
                            },
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                              labelText: '__ __ __ __',
                              hintText: '__ __ __ __',
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              suffixIcon: const CustomSuffixIcon(
                                svgIcon: 'assets/icons/Phone.svg',
                              ),
                              prefixIcon: const CustomPrefixIcon(),
                              errorStyle: const TextStyle(height: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          FormErrors(errors: errors),
                          errors.isNotEmpty ? SizedBox(height: getProportionateScreenHeight(20)) : const SizedBox(),
                          loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : DefaultButton(
                                  text: 'Continue'.tr,
                                  press: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(
                                        () {
                                          loading = true;
                                          signinUser();
                                        },
                                      );
                                    }
                                  },
                                ),
                          const NoAccount(),
                        ],
                      ),
                    )
                  : page == 'second'
                      ? Form(
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
                        )
                      : Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: txtPassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password'.tr,
                                  hintText: 'Password'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  suffixIcon: const CustomSuffixIcon(
                                    svgIcon: 'assets/icons/Lock.svg',
                                  ),
                                  errorStyle: const TextStyle(height: 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  isDense: true,
                                ),
                              ),
                              SizedBox(height: getProportionateScreenHeight(20)),
                              TextFormField(
                                controller: txtRePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Re Password'.tr,
                                  hintText: 'Re Password'.tr,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  suffixIcon: const CustomSuffixIcon(
                                    svgIcon: 'assets/icons/Lock.svg',
                                  ),
                                  errorStyle: const TextStyle(height: 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  isDense: true,
                                ),
                              ),
                              SizedBox(height: getProportionateScreenHeight(20)),
                              FormErrors(errors: errors),
                              errors.isNotEmpty ? SizedBox(height: getProportionateScreenHeight(20)) : const SizedBox(),
                              passLoading == true
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
                                              _resetPassword();
                                            },
                                          ),
                                        ),
                                      ],
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
