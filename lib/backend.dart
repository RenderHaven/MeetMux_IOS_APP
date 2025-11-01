import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'https://api.jikan.moe/v4';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<List<Map<String, dynamic>>> animeSearch({
    String? query,
    bool? unapproved,
    int? page,
    int? limit,
    String? type,
    String? status,
    double? score,
    double? minScore,
    double? maxScore,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {};

      if (query != null && query.isNotEmpty) {
        queryParams['q'] = query;
      }
      if (unapproved == true) {
        queryParams['unapproved'] = '';
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }
      if (status != null) {
        queryParams['status'] = status.toString();
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (type != null) {
        queryParams['type'] = type;
      }
      if (score != null) {
        queryParams['score'] = score.toString();
      }
      if (minScore != null) {
        queryParams['min_score'] = minScore.toString();
      }
      if (maxScore != null) {
        queryParams['max_score'] = maxScore.toString();
      }

      final Uri uri = Uri.parse(
        '$baseUrl/anime',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dynamic rawData = jsonDecode(response.body);

        if (rawData is List) {
          return rawData.cast<Map<String, dynamic>>();
        } else if (rawData is Map<String, dynamic>) {
          if (rawData.containsKey('data') && rawData['data'] is List) {
            return (rawData['data'] as List).cast<Map<String, dynamic>>();
          } else if (rawData.containsKey('results') &&
              rawData['results'] is List) {
            return (rawData['results'] as List).cast<Map<String, dynamic>>();
          } else if (rawData.containsKey('anime') && rawData['anime'] is List) {
            return (rawData['anime'] as List).cast<Map<String, dynamic>>();
          } else {
            return [rawData];
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load anime: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load anime: $e');
    }
  }
}
