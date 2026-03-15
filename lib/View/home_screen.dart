import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
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

  static const Color _bgColor = Color(0xFF464646);
  static const Color _appBarColor = Color(0xFF000000);
  static const Color _headlineWhite = Color(0xFFFFFFFF);
  static const Color _headlineGray = Color(0xFFF2F2F2);
  static const Color _sourceGray = Color(0xFFBABABA);

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

  String _formatSourceDate(NewsArticle article) {
    final source = article.sourceName ?? 'Unknown';
    if (article.publishedAt == null || article.publishedAt!.isEmpty) {
      return source;
    }
    try {
      final dt = DateTime.parse(article.publishedAt!);
      return '$source ${DateFormat('yyyy-MM-dd').format(dt)}';
    } catch (_) {
      return source;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black26,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _appBarColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'HEADLINES',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _headlineWhite,
            ),
          ),
        ),
        body: _loading
            ? const Center(child: SpinKitWave(color: _headlineWhite, size: 40))
            : _articles.isEmpty
            ? Center(
                child: Text(
                  'No headlines found.\nCheck your API key or try again later.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoSlab(
                    color: _sourceGray,
                    fontSize: 16,
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadNews,
                color: _headlineWhite,
                backgroundColor: _appBarColor,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 80,
                  ),
                  itemCount: _articles.length,
                  itemBuilder: (context, index) {
                    final article = _articles[index];
                    final isMainHeadline = index == 0;
                    const double cardHeight = 280;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailScreen(article: article),
                              ),
                            );
                          },
                          child: Container(
                            height: cardHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (article.urlToImage != null &&
                                    article.urlToImage!.isNotEmpty)
                                  CachedNetworkImage(
                                    imageUrl: article.urlToImage!,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      color: Colors.grey[800],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: _sourceGray,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      color: Colors.grey[800],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 48,
                                        color: _sourceGray,
                                      ),
                                    ),
                                  )
                                else
                                  Container(color: Colors.grey[800]),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.3),
                                        Colors.black.withValues(alpha: 0.85),
                                      ],
                                      stops: const [0.3, 0.6, 1.0],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        article.title,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 20,

                                          color: _headlineGray,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _formatSourceDate(article),
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: _sourceGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5)),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: _headlineGray,
                      size: 28,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(
                      Icons.circle_outlined,
                      color: _headlineGray,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(
                      Icons.square_outlined,
                      color: _headlineGray,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
