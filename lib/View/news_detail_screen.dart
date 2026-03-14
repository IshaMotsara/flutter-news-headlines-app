import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:news_headlines_flutter/models/news_article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  String? _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMM d, y • h:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(article.publishedAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 160,
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
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (article.sourceName != null || article.author != null || formattedDate != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (article.sourceName != null)
                          _DetailChip(label: article.sourceName!),
                        if (article.author != null)
                          _DetailChip(label: article.author!),
                        if (formattedDate != null)
                          _DetailChip(label: formattedDate),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (article.description != null && article.description!.isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (article.content != null && article.content!.isNotEmpty) ...[
                    Text(
                      article.content!,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (article.url != null && article.url!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _openUrl(context, article.url!),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Read full article'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;

  const _DetailChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
