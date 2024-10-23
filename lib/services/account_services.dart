import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService {
  static var client = http.Client();

  static Future<dynamic> accountSignup(String phone, String password, String rePassword, String? refCode) async {
    try {
      final response = await client.post(
        Uri.parse(account_signup_URL),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'phone': "+993${phone.replaceAll(" ", "")}",
          'password': password,
          're_password': rePassword,
          'ref_code': refCode,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> accountSignin(String phone, String password) async {
    try {
      final response = await client.post(
        Uri.parse(account_signin_URL),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'phone': "+993${phone.replaceAll(" ", "")}",
          'password': password,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> checkOtp(String phone, String otp) async {
    try {
      final response = await client.post(
        Uri.parse(check_otp_URL),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'phone': "+993${phone.replaceAll(" ", "")}",
          'otp': otp,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> resetPasswordRequest(String phone) async {
    try {
      final response = await client.post(
        Uri.parse(reset_password_request_URL),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'phone': "+993${phone.replaceAll(" ", "")}",
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> resetPassword(String phone, String otp, String password, String repassword) async {
    try {
      final response = await client.post(
        Uri.parse(reset_password_URL),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'phone': "+993${phone.replaceAll(" ", "")}",
          'otp': otp,
          'password': password,
          're_password': repassword,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getMe(String token) async {
    try {
      // ignore: unnecessary_null_comparison
      final response = await client.get(Uri.parse(get_me_URL), headers: {'Accept': 'application/json', 'Authorization': token != null ? 'Bearer $token' : ''});
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> setReferral(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.post(
        Uri.parse(set_referral_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
        body: {
          'code': code,
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
