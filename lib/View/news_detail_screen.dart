import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:news_headlines_flutter/models/news_article.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

  static const Color _bgDark = Color(0xFF464646);
  static const Color _headlineColor = Color(0xFFF2F2F2);
  static const Color _bodyColor = Color(0xFFBABABA);
  static const double _topPaddingBackArrow = 42;
  static const double _headlineToSourceSpacing = 24;
  static const double _sourceToBodySpacing = 64;
  static const double _bodyHorizontalPadding = 16;
  static const double _bodyBottomPadding = 16;

  String _formatDateYmd(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(dt);
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
    final topPadding = MediaQuery.paddingOf(context).top;
    final dateStr = _formatDateYmd(article.publishedAt);
    const double imageHeight = 320;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black26,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _bgDark,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: imageHeight,
                        width: double.infinity,
                        child: article.urlToImage != null &&
                                article.urlToImage!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: article.urlToImage!,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: Colors.grey[800],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: _bodyColor,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: _bodyColor,
                                  ),
                                ),
                              )
                            : Container(color: Colors.grey[800]),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                              Colors.black.withValues(alpha: 0.9),
                            ],
                            stops: const [0.35, 0.7, 1.0],
                          ),
                        ),
                        child: SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: _bodyHorizontalPadding,
                              right: _bodyHorizontalPadding,
                              bottom: 24,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article.title,
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 29,
                                    fontWeight: FontWeight.w700,
                                    color: _headlineColor,
                                  ),
                                ),
                                const SizedBox(height: _headlineToSourceSpacing),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      article.sourceName ?? 'Unknown',
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: _headlineColor,
                                      ),
                                    ),
                                    if (dateStr.isNotEmpty)
                                      Text(
                                        dateStr,
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: _headlineColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: _sourceToBodySpacing,
                      left: _bodyHorizontalPadding,
                      right: _bodyHorizontalPadding,
                      bottom: _bodyBottomPadding + 80,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.description != null &&
                            article.description!.isNotEmpty)
                          Text(
                            article.description!,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _bodyColor,
                              height: 1.5,
                            ),
                          ),
                        if (article.content != null &&
                            article.content!.isNotEmpty) ...[
                          if (article.description != null &&
                              article.description!.isNotEmpty)
                            const SizedBox(height: 16),
                          Text(
                            article.content!,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _bodyColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                        if (article.url != null &&
                            article.url!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          TextButton.icon(
                            onPressed: () =>
                                _openUrl(context, article.url!),
                            icon: const Icon(
                              Icons.open_in_new,
                              size: 18,
                              color: _headlineColor,
                            ),
                            label: Text(
                              'Read full article',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 14,
                                color: _headlineColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: topPadding + _topPaddingBackArrow,
              left: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.maybePop(context),
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back,
                      color: _headlineColor,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: _headlineColor, size: 28),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(Icons.circle_outlined,
                        color: _headlineColor, size: 28),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(Icons.square_outlined,
                        color: _headlineColor, size: 28),
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
