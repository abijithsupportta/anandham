import 'package:flutter/material.dart';
import 'package:anandham_user/core/utils/extensions.dart';
import 'package:anandham_user/core/utils/helpers.dart';

class BlogListItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const BlogListItem({super.key, required this.item, required this.onTap});

  String _coverImageUrl() {
    final raw = item['cover_images'];
    if (raw is List) {
      for (final image in raw) {
        if (image is String && image.trim().isNotEmpty) {
          return image;
        }
      }
    }
    return '';
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
    final title = (item['title'] as String?) ?? '';
    final excerpt = (item['excerpt'] as String?) ?? '';
    final author = item['author'] as Map<String, dynamic>?;
    final authorName = (author?['name'] as String?) ?? '';
    final coverUrl = _coverImageUrl();
    final publishedAt = item['published_at'] ?? item['created_at'];
    final formattedDate = _formatDate(publishedAt);
    final postedAt = _parseDate(publishedAt);
    final timeAgo = postedAt?.timeAgo ?? '';

    return InkWell(
      onTap: onTap,
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
                    child: coverUrl.isEmpty
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
                        : Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 40,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
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
