import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_headlines_flutter/models/news_article.dart';
import 'package:news_headlines_flutter/services/news_service.dart';
import 'package:news_headlines_flutter/View/news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _loading = true);
    final list = await _newsService.getTopHeadlines();
    setState(() {
      _articles = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headlines'),
      ),
      body: _loading
          ? const Center(
              child: SpinKitWave(
                color: Colors.deepPurple,
                size: 40,
              ),
            )
          : _articles.isEmpty
              ? const Center(
                  child: Text(
                    'No headlines found.\nCheck your API key or try again later.',
                    textAlign: TextAlign.center,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(article: article),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                                  CachedNetworkImage(
                                    imageUrl: article.urlToImage!,
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      height: 160,
                                      color: Colors.grey[200],
                                      child: const Center(child: CircularProgressIndicator()),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported, size: 48),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (article.description != null && article.description!.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          article.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
