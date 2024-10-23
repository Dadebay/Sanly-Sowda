import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/screens/otp/otp_screen.dart';
import 'package:jummi/services/account_services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../components/custom_prefix_icon.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_errors.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  var maskFormatter = MaskTextInputFormatter(
    mask: '&% ## ## ##',
    filter: {'#': RegExp(r'[0-9]'), '&': RegExp(r'[6,7]'), '%': RegExp(r'[0-5]')},
    type: MaskAutoCompletionType.lazy,
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final List<String> errors = [];
  late bool loading = false;
  final String _kInvalidPhoneError = 'Please enter valid phone number'.tr;
  final String _kInvalidPassError = 'Please enter valid password'.tr;
  final MainController _c = Get.put(MainController());

  void signinUser() async {
    final response = await AccountService.accountSignin(
      txtPhone.text,
      txtPassword.text,
    );

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      _c.setOtpPhone(txtPhone.text);
      _c.setOtpExpDate(json.decode(response.body)['otp_exp_date']);
      await Get.off(
        OtpScreen(
          phone: txtPhone.text,
        ),
      );
    } else if (response == null) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Sign in error'.tr,
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
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: txtPhone,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              if (value.length == 10 && errors.contains(_kInvalidPhoneError)) {
                setState(() {
                  errors.remove(_kInvalidPhoneError);
                });
              }
            },
            validator: (value) {
              if ((value!.length != 11 && !errors.contains(_kInvalidPhoneError)) || (value[0] == '7' && value[1] != '1')) {
                setState(() {
                  errors.add(_kInvalidPhoneError);
                });
                return '';
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
          TextFormField(
            controller: txtPassword,
            obscureText: true,
            onChanged: (value) {
              if (value.length >= 6 && errors.contains(_kInvalidPassError)) {
                setState(() {
                  errors.remove(_kInvalidPassError);
                });
              }
            },
            validator: (value) {
              if (value!.length < 6 && !errors.contains(_kInvalidPassError)) {
                setState(() {
                  errors.add(_kInvalidPassError);
                });
                return '';
              }
              return null;
            },
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
          SizedBox(height: getProportionateScreenHeight(10)),
          SizedBox(height: getProportionateScreenHeight(10)),
          FormErrors(errors: errors),
          errors.isNotEmpty ? SizedBox(height: getProportionateScreenHeight(20)) : const SizedBox(),
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
                          if (formKey.currentState!.validate()) {
                            setState(
                              () {
                                loading = true;
                                signinUser();
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
