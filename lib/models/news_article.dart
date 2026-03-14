class NewsArticle {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? author;
  final String? sourceName;
  final String? content;

  NewsArticle({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.author,
    this.sourceName,
    this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      author: json['author'],
      sourceName: json['source'] != null ? json['source']['name'] : null,
      content: json['content'],
    );
  }
}
