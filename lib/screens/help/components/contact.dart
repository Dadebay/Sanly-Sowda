import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jummi/controllers/main_controller.dart';
import 'package:jummi/models/Letter.dart';
import 'package:jummi/screens/policy/policy_screen.dart';
import 'package:jummi/screens/sign_in/sign_in_screen.dart';
import 'package:jummi/services/letter_services.dart';
import 'package:jummi/size_config.dart';

class HelpContact extends StatefulWidget {
  const HelpContact({super.key});

  @override
  State<HelpContact> createState() => _HelpContactState();
}

class _HelpContactState extends State<HelpContact> {
  final TextEditingController _letterController = TextEditingController();
  late bool agree = false;
  final MainController _mainC = Get.put(MainController());

  late bool lettersLoading = true;
  late String? lettersError;
  late List<Letter> letters = [];

  Future<void> _getLetters() async {
    setState(() {
      lettersLoading = true;
      letters.clear();
    });
    final dynamic response = await LetterServices.getLetters();
    if (response != null && response.statusCode == 200) {
      setState(() {
        lettersError = null;
        letters.addAll(letterFromJson(jsonEncode(jsonDecode(utf8.decode(response.bodyBytes)))));
        lettersLoading = false;
      });
    } else if (response.statusCode == 400) {
      setState(() {
        lettersError = json.decode(response.body)['detail'].toString();
        lettersLoading = false;
      });
    } else {
      setState(() {
        lettersError = 'Something went wrong!'.tr;
        lettersLoading = false;
      });
    }
  }

  Future<void> _createLetter() async {
    if (_letterController.text.length < 5) {
      Get.snackbar(
        'Error'.tr,
        'Letter must be at least 5 characters!'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
    } else {
      final dynamic response = await LetterServices.createLetter(_letterController.text);
      if (response != null && response.statusCode == 200) {
        Get.snackbar(
          'Success'.tr,
          'Your letter sent successfully!'.tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
        );
        setState(() {
          _letterController.text = '';
          agree = false;
        });
        await _getLetters();
      } else if (response != null && response.statusCode == 400) {
        Get.snackbar(
          'Error'.tr,
          json.decode(utf8.decode(response.bodyBytes))['detail'].toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
        );
      } else {
        Get.snackbar(
          'Error'.tr,
          'Something went wrong!'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLetters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: _mainC.user.value.id == null
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${'Contact with Adminstrator'.tr}:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'First sign in to contact with adminstrator!'.tr,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Get.to(const SignInScreen()),
                  child: Text('Sign In'.tr),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'Contact with Adminstrator'.tr}:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _letterController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: '${'Letter'.tr}...',
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      agree = !agree;
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = !agree;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.to(const PolicyScreen()),
                          child: Text(
                            'I have read and agree to the privacy policy, terms of services, and community guidlines.'.tr,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(12),
                              color: Colors.black,
                              height: 1.2,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(width: 10),
                      // IconButton(
                      //   onPressed: () => Get.to(PrivacyScreen()),
                      //   icon: Icon(
                      //     Icons.read_more_rounded,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (agree) {
                          _createLetter();
                        } else {}
                      },
                      style: !agree
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.black12,
                            )
                          : ElevatedButton.styleFrom(),
                      child: Text(
                        'Send'.tr,
                        style: !agree ? const TextStyle(color: Colors.black38) : const TextStyle(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${'Written letters'.tr}:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                lettersLoading == true
                    ? const Text('...')
                    : lettersError != null
                        ? Text('$lettersError')
                        : letters.isEmpty
                            ? Text('No data'.tr)
                            : Column(
                                children: [
                                  for (var i = 0; i < letters.length; i++)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(15, 0, 0, 0),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('dd.MM.yyyy').format(letters[i].createdAt!),
                                            style: TextStyle(
                                              fontSize: getProportionateScreenWidth(16),
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${letters[i].text}',
                                            style: TextStyle(
                                              height: 1.2,
                                              color: Colors.black87,
                                              fontSize: getProportionateScreenWidth(14),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: Color.fromARGB(25, 0, 0, 0),
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.black54,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            child: letters[i].answer == null || letters[i].answer == ''
                                                ? Text('Pending for answer of Adminstrator...'.tr)
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Adminstrator'.tr,
                                                        style: TextStyle(
                                                          fontSize: getProportionateScreenWidth(16),
                                                          fontWeight: FontWeight.w800,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${letters[i].answer}',
                                                        style: TextStyle(
                                                          height: 1.2,
                                                          color: Colors.black87,
                                                          fontSize: getProportionateScreenWidth(14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
              ],
            ),
    );
  }
}
