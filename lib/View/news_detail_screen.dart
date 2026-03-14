import 'package:flutter/material.dart';
import 'package:news_headlines_flutter/models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            if (article.sourceName != null) ...[
              Text('Source: ${article.sourceName}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 4),
            ],
            if (article.author != null) ...[
              Text('Author: ${article.author}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 4),
            ],
            if (article.publishedAt != null) ...[
              Text('Published: ${article.publishedAt}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 12),
            ],
            if (article.description != null && article.description!.isNotEmpty) ...[
              Text(article.description!, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
            ],
            if (article.content != null && article.content!.isNotEmpty) ...[
              Text(article.content!, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 12),
            ],
            if (article.url != null && article.url!.isNotEmpty)
              Text('Read more: ${article.url}', style: TextStyle(fontSize: 14, color: Colors.blue[700])),
          ],
        ),
      ),
    );
  }
}
