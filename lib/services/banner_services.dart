import 'package:http/http.dart' as http;
import 'package:jummi/endpoints.dart';
import 'package:jummi/models/MyBanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerService {
  static var client = http.Client();

  static Future<dynamic> fetchBannerData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_banners_URL),
        headers: {
          'Authorization': prefs.getString('access_token').toString(),
        },
      );
      if (response.statusCode == 200) {
        return bannerFromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchMainStores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await client.get(
        Uri.parse(get_main_stores_URL),
        headers: {
          'Authorization': prefs.getString('access_token').toString(),
        },
      );
      return response;
    } catch (e) {
      return null;
    }
  }
}
