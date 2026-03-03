import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/guru_stories/guru_stories_list_cubit.dart';
import 'package:anandham_user/presentation/blocs/guru_stories/guru_stories_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuruStoriesListPage extends StatelessWidget {
  const GuruStoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuruStoriesListCubit()..loadStories(),
      child: const _GuruStoriesListView(),
    );
  }
}

class _GuruStoriesListView extends StatefulWidget {
  const _GuruStoriesListView();

  @override
  State<_GuruStoriesListView> createState() => _GuruStoriesListViewState();
}

class _GuruStoriesListViewState extends State<_GuruStoriesListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearch);
  }

  void _handleSearch() {
    context.read<GuruStoriesListCubit>().updateQuery(_searchController.text);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearch)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Guru Stories')),
      body: SafeArea(
        child: BlocBuilder<GuruStoriesListCubit, GuruStoriesListState>(
          builder: (context, state) {
            if (state.isLoading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load guru stories'),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () =>
                            context.read<GuruStoriesListCubit>().loadStories(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final query = state.query.trim().toLowerCase();
            final filtered = query.isEmpty
                ? state.items
                : state.items.where((story) {
                    final title =
                        (story['title'] as String? ?? '').toLowerCase();
                    final author =
                        (story['author_name'] as String? ?? '').toLowerCase();
                    return title.contains(query) || author.contains(query);
                  }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search stories...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _searchController.clear,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            query.isEmpty
                                ? 'No guru stories available'
                                : 'No stories found',
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final story = filtered[index];
                            final storyId =
                                (story['id'] as String? ?? '').trim();
                            final title =
                                (story['title'] as String? ?? '').trim();
                            final author =
                                (story['author_name'] as String? ?? '').trim();

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: storyId.isEmpty
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.guruStoryDetail,
                                          arguments: storyId,
                                        );
                                      },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: isLight
                                        ? colorScheme.surfaceContainerLow
                                        : colorScheme.surfaceContainer,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isLight
                                          ? colorScheme.primary.withValues(
                                              alpha: 0.28,
                                            )
                                          : Theme.of(context).dividerColor,
                                    ),
                                    boxShadow: isLight
                                        ? [
                                            BoxShadow(
                                              color: colorScheme.primary
                                                  .withValues(alpha: 0.08),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : const [],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 34,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary
                                                .withValues(alpha: 0.14),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: colorScheme.primary
                                                  .withValues(alpha: 0.45),
                                            ),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  color: colorScheme.primary,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                author.isEmpty
                                                    ? 'Author: Unknown'
                                                    : 'Author: $author',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: colorScheme.primary,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
