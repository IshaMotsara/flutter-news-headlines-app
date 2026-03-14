import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_headlines_flutter/models/news_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsService {
  // Get your free API key from https://newsapi.org/register
  static const String _apiKey = 'a7521d976bef4429bada20fca98a733b';
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _cacheKey = 'cached_headlines';

  Future<List<NewsArticle>> getTopHeadlines({String country = 'us'}) async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey&pageSize=20',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok' && data['articles'] != null) {
          final list = data['articles'] as List;
          final articles = list.map((e) => NewsArticle.fromJson(e)).toList();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_cacheKey, response.body);
          return articles;
        }
      }
    } catch (_) {
      // Offline or network error - load from cache
    }

    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
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
