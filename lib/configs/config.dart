import 'dart:convert';
import 'package:http/http.dart' as http;

class configApi {
  static const String APIImageFilm = 'https://img.phimapi.com/';
  static const String APINewFilm =
      'https://phimapi.com/danh-sach/phim-moi-cap-nhat';
  static const String APIfeatureFilm =
      'https://phimapi.com/v1/api/danh-sach/phim-le';
  static const String APItelevisionSeries =
      'https://phimapi.com/v1/api/danh-sach/phim-bo';
  static const String APIcartoon =
      'https://phimapi.com/v1/api/danh-sach/hoat-hinh';
  static const String APItvShows =
      'https://phimapi.com/v1/api/danh-sach/tv-shows';
  static const String APIcategory = 'https://phimapi.com/the-loai';
  static const String APIcountry = 'https://phimapi.com/quoc-gia';
  static const String APISearch = 'https://phimapi.com/v1/api/tim-kiem';
}

Future<Map<String, dynamic>> fetchAPI(String apiUrl, {int page = 1}) async {
  try {
    final response = await http.get(Uri.parse('$apiUrl?page=$page'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error: $error');
    return {};
  }
}
