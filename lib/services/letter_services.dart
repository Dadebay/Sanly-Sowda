import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LetterServices {
  static var client = http.Client();

  static Future<dynamic> createLetter(text) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.post(
        Uri.parse(create_letter_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
        body: {'text': text},
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getLetters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_letters_URL),
        headers: {
          'Accept': 'application/json',
          'Authorization': prefs.getString('access_token') != null && prefs.getString('access_token') != '' ? "Bearer ${prefs.getString("access_token")}" : '',
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
