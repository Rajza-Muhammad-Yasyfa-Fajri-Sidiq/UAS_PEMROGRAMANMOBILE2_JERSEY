import 'package:dio/dio.dart';
import '../models/jersey.dart';

class ApiService {
  ApiService._();
  static final dio = Dio();

  // GANTI dengan base url MockAPI kamu:
  static const baseUrl = 'https://6970e6dd78fec16a63ff6981.mockapi.io';

  static Future<List<Jersey>> getJerseys({String? team}) async {
    final url = '$baseUrl/jerseys';
    final res = await dio.get(
      url,
      queryParameters: team == null ? null : {'team': team},
    );
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Jersey.fromJson).toList();
  }

  static Future<Jersey> getJerseyById(String id) async {
    final res = await dio.get('$baseUrl/jerseys/$id');
    return Jersey.fromJson((res.data as Map).cast<String, dynamic>());
  }
}
