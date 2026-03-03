import 'package:flutter/material.dart';
import 'package:anandham_user/core/utils/extensions.dart';
import 'package:anandham_user/core/utils/helpers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BlogListItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const BlogListItem({super.key, required this.item, required this.onTap});

  @override
  State<BlogListItem> createState() => _BlogListItemState();
}

class _BlogListItemState extends State<BlogListItem> {
  final PageController _mediaPageController = PageController();
  int _currentMediaIndex = 0;

  @override
  void dispose() {
    _mediaPageController.dispose();
    super.dispose();
  }

  List<String> _coverImages() {
    final raw = widget.item['cover_images'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<String>()
        .map((image) => image.trim())
        .where((image) => image.isNotEmpty)
        .toList();
  }

  String? _youtubeThumbnailUrl() {
    final youtubeUrl = (widget.item['youtube_url'] as String? ?? '').trim();
    if (youtubeUrl.isEmpty) {
      return null;
    }

    final videoId =
        YoutubePlayer.convertUrlToId(youtubeUrl) ??
        (youtubeUrl.length <= 20 ? youtubeUrl : null);

    if (videoId == null || videoId.isEmpty) {
      return null;
    }

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  String _excerptText(String excerpt) {
    final trimmed = excerpt.trim();
    if (trimmed.isEmpty) {
      return 'No summary available.';
    }
    if (trimmed.length <= 140) {
      return trimmed;
    }
    return '${trimmed.substring(0, 140)}...';
  }

  DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  String _formatDate(dynamic value) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return Helpers.formatDate(parsed, pattern: 'dd MMM yyyy');
      }
    }
    if (value is DateTime) {
      return Helpers.formatDate(value, pattern: 'dd MMM yyyy');
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.item['title'] as String?) ?? '';
    final excerpt = (widget.item['excerpt'] as String?) ?? '';
    final author = widget.item['author'] as Map<String, dynamic>?;
    final category = widget.item['category'] as Map<String, dynamic>?;
    final categoryName = (category?['name'] as String? ?? '').trim();
    final authorName = (author?['name'] as String?) ?? '';
    final coverImages = _coverImages();
    final youtubeThumb = _youtubeThumbnailUrl();
    final mediaItems = [
      ...coverImages.map((url) => _MediaItem.image(url)),
      if (youtubeThumb != null) _MediaItem.youtube(youtubeThumb),
    ];
    final publishedAt =
        widget.item['published_at'] ?? widget.item['created_at'];
    final formattedDate = _formatDate(publishedAt);
    final postedAt = _parseDate(publishedAt);
    final timeAgo = postedAt?.timeAgo ?? '';

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: mediaItems.isEmpty
                        ? Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          )
                        : PageView.builder(
                            controller: _mediaPageController,
                            itemCount: mediaItems.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentMediaIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final media = mediaItems[index];
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    media.url,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHighest,
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                size: 40,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                  ),
                                  if (media.isYoutube)
                                    Center(
                                      child: Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.45,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 34,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (timeAgo.isNotEmpty)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  if (mediaItems.length > 1)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(mediaItems.length, (index) {
                          final selected = index == _currentMediaIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: selected ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (categoryName.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.30),
                        ),
                      ),
                      child: Text(
                        categoryName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (authorName.trim().isNotEmpty)
                        Expanded(
                          child: Text(
                            authorName,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (formattedDate.isNotEmpty) ...[
                        if (authorName.trim().isNotEmpty)
                          const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                      if (timeAgo.isNotEmpty) ...[
                        if (formattedDate.isNotEmpty ||
                            authorName.trim().isNotEmpty)
                          const SizedBox(width: 8),
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _excerptText(excerpt),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaItem {
  final String url;
  final bool isYoutube;

  const _MediaItem._({required this.url, required this.isYoutube});

  factory _MediaItem.image(String url) =>
      _MediaItem._(url: url, isYoutube: false);

  factory _MediaItem.youtube(String url) =>
      _MediaItem._(url: url, isYoutube: true);
}
