import 'dart:convert';
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_headlines_flutter/models/news_article.dart';

class NewsService {
  // Get your free API key from https://newsapi.org/register
  static const String _apiKey = 'a7521d976bef4429bada20fca98a733b';
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _boxName = 'news';
  static const String _cacheKey = 'headlines';

  Box get _box => Hive.box(_boxName);

  Future<List<NewsArticle>> getTopHeadlines({String country = 'us'}) async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey&pageSize=20',
    );

    try {
      final response = await http.get(url).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
         log("News are loaded from local database");
        // This block runs if the request times out
        throw Error();
      },
    );;

      if (response.statusCode == 200) {
        log("News are loaded from Internet");
        final data = json.decode(response.body);
        if (data['status'] == 'ok' && data['articles'] != null) {
          final list = data['articles'] as List;
          final articles = list.map((e) => NewsArticle.fromJson(e)).toList();
          await _box.put(_cacheKey, response.body);
          return articles;
        }
      }
    } catch (_) {
      // Offline or API error - load from Hive
      log("News are loaded from local database");
    }

    final cached = _box.get(_cacheKey) as String?;
    if (cached != null) {
      final data = json.decode(cached);
      if (data['articles'] != null) {
        final list = data['articles'] as List;
        return list.map((e) => NewsArticle.fromJson(e)).toList();
      }
    }
    return [];
  }
}
