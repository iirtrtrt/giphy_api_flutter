import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';

class GifRepositoryProvider {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://api.giphy.com/v1/gifs/'),
  );

  Future<List<GifModel>> gifSearch(String query, int offset) async {
    try {
      final response = await _dio.get(
        'search',
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'q': query,
          'limit': 20,
          'offset': offset,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      final gifs = data.map((json) => GifModel.fromJson(json)).toList();

      return gifs;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
