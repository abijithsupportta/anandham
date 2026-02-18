import 'package:anandham_user/core/utils/extensions.dart';
import 'package:anandham_user/core/utils/helpers.dart';
import 'package:anandham_user/presentation/blocs/blogs/blog_detail_cubit.dart';
import 'package:anandham_user/presentation/blocs/blogs/blog_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

class _BlogDetailView extends StatefulWidget {
  final String blogId;

  const _BlogDetailView({required this.blogId});

  @override
  State<_BlogDetailView> createState() => _BlogDetailViewState();
}

class _BlogDetailViewState extends State<_BlogDetailView> {
  final PageController _mediaPageController = PageController();

  YoutubePlayerController? _youtubeController;
  String? _youtubeVideoId;
  int _currentMediaIndex = 0;

  @override
  void dispose() {
    _mediaPageController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  void _configureYoutube(String rawUrl) {
    final trimmed = rawUrl.trim();
    final resolvedVideoId =
        YoutubePlayer.convertUrlToId(trimmed) ??
        (trimmed.isNotEmpty ? trimmed : null);

    if (_youtubeVideoId == resolvedVideoId) {
      return;
    }

    _youtubeController?.dispose();
    _youtubeController = null;
    _youtubeVideoId = null;

    if (resolvedVideoId != null && resolvedVideoId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: resolvedVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
        ),
      );
      _youtubeVideoId = resolvedVideoId;
    }
  }

  List<String> _coverImages(Map<String, dynamic> blog) {
    final raw = blog['cover_images'];
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
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

  Widget _imageSlide(BuildContext context, String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }

  Widget _youtubeSlide(BuildContext context) {
    if (_youtubeController == null) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.play_circle_outline,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        bottomActions: const [
          CurrentPosition(),
          SizedBox(width: 8),
          ProgressBar(isExpanded: true),
          SizedBox(width: 8),
          RemainingDuration(),
          PlaybackSpeedButton(),
        ],
      ),
    );
  }

  Widget _mediaCarousel(BuildContext context, Map<String, dynamic> blog) {
    final images = _coverImages(blog);
    final hasYoutube = _youtubeController != null;
    final totalItems = images.length + (hasYoutube ? 1 : 0);

    if (totalItems == 0) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    final youtubeIndex = images.length;

    if (_currentMediaIndex >= totalItems) {
      _currentMediaIndex = totalItems - 1;
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _mediaPageController,
            itemCount: totalItems,
            onPageChanged: (index) {
              setState(() {
                _currentMediaIndex = index;
              });
            },
            itemBuilder: (context, index) {
              if (hasYoutube && index == youtubeIndex) {
                return _youtubeSlide(context);
              }
              return _imageSlide(context, images[index]);
            },
          ),
        ),
        if (totalItems > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              children: List.generate(totalItems, (index) {
                final selected = index == _currentMediaIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog')),
      body: BlocConsumer<BlogDetailCubit, BlogDetailState>(
        listener: (context, state) {
          final blog = state.blog;
          if (blog == null) {
            return;
          }
          final youtubeUrl = (blog['youtube_url'] as String? ?? '').trim();
          _configureYoutube(youtubeUrl);
        },
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
                      onPressed: () => context.read<BlogDetailCubit>().loadBlog(
                        widget.blogId,
                      ),
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
          final publishedAt = blog['published_at'] ?? blog['created_at'];
          final formattedDate = _formatDate(publishedAt);
          final postedAt = _parseDate(publishedAt);
          final timeAgo = postedAt?.timeAgo ?? '';
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
                      child: SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: _mediaCarousel(context, blog),
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
