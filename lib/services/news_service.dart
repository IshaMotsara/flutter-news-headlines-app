import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_headlines_flutter/models/news_article.dart';

class NewsService {
  // Get your free API key from https://newsapi.org/register
  static const String _apiKey = 'a7521d976bef4429bada20fca98a733b';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> getTopHeadlines({String country = 'us'}) async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey&pageSize=20',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'ok' && data['articles'] != null) {
        final list = data['articles'] as List;
        return list.map((e) => NewsArticle.fromJson(e)).toList();
      }
    }
    return [];
  }
}
