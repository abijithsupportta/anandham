import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/core/utils/extensions.dart';
import 'package:anandham_user/core/utils/helpers.dart';
import 'package:anandham_user/presentation/blocs/blogs/blog_detail_cubit.dart';
import 'package:anandham_user/presentation/blocs/blogs/blog_detail_state.dart';

class BlogDetailPage extends StatelessWidget {
  final String blogId;

  const BlogDetailPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlogDetailCubit()..loadBlog(blogId),
      child: _BlogDetailView(blogId: blogId),
    );
  }
}

class _BlogDetailView extends StatelessWidget {
  final String blogId;

  const _BlogDetailView({required this.blogId});

  String _coverImageUrl(Map<String, dynamic> item) {
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

  String _copyPayload(
    String title,
    String authorName,
    String body,
    String excerpt,
  ) {
    final buffer = StringBuffer()..writeln(title);
    if (authorName.trim().isNotEmpty) {
      buffer.writeln(authorName);
    }
    final content = body.trim().isNotEmpty ? body : excerpt;
    if (content.trim().isNotEmpty) {
      buffer
        ..writeln('')
        ..writeln(content.trim());
    }
    return buffer.toString().trimRight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog')),
      body: BlocBuilder<BlogDetailCubit, BlogDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null || state.blog == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load blog'),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Please try again',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<BlogDetailCubit>().loadBlog(blogId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final blog = state.blog!;
          final title = (blog['title'] as String?) ?? '';
          final excerpt = (blog['excerpt'] as String?) ?? '';
          final body = (blog['body'] as String?) ?? '';
          final author = blog['author'] as Map<String, dynamic>?;
          final authorName = (author?['name'] as String?) ?? '';
          final coverUrl = _coverImageUrl(blog);
          final publishedAt = blog['published_at'] ?? blog['created_at'];
          final formattedDate = _formatDate(publishedAt);
          final postedAt = _parseDate(publishedAt);
          final timeAgo = postedAt?.timeAgo ?? '';
          final copyPayload = _copyPayload(title, authorName, body, excerpt);
          final content = body.trim().isNotEmpty ? body : excerpt;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Container(
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
                      child: AspectRatio(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy_rounded),
                                tooltip: 'Copy blog',
                                onPressed: copyPayload.trim().isEmpty
                                    ? null
                                    : () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: copyPayload),
                                        );
                                        if (!context.mounted) {
                                          return;
                                        }
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Blog copied'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                              ),
                            ],
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text(
                  content.trim().isEmpty ? 'No content available.' : content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
