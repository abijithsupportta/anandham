import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/blogs/blogs_list_cubit.dart';
import 'package:anandham_user/presentation/blocs/blogs/blogs_list_state.dart';
import 'package:anandham_user/presentation/pages/blogs/widgets/blog_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsPage extends StatelessWidget {
  const BlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlogsListCubit()..loadInitial(),
      child: const _BlogsListView(),
    );
  }
}

class _BlogsListView extends StatefulWidget {
  const _BlogsListView();

  @override
  State<_BlogsListView> createState() => _BlogsListViewState();
}

class _BlogsListViewState extends State<_BlogsListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _searchController.addListener(_handleSearch);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (context.read<BlogsListCubit>().state.query.trim().isNotEmpty) {
      return;
    }

    final threshold = _scrollController.position.maxScrollExtent - 240;
    if (_scrollController.position.pixels >= threshold) {
      context.read<BlogsListCubit>().loadMore();
    }
  }

  void _handleSearch() {
    context.read<BlogsListCubit>().updateQuery(_searchController.text);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<BlogsListCubit>().loadInitial(),
          child: BlocBuilder<BlogsListCubit, BlogsListState>(
            builder: (context, state) {
              if (state.isLoading && state.items.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: const [
                    SizedBox(height: 280),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }

              if (state.errorMessage != null && state.items.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: [
                    SizedBox(
                      height: 320,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Failed to load blogs'),
                              const SizedBox(height: 8),
                              Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () => context
                                    .read<BlogsListCubit>()
                                    .loadInitial(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              final categoryMap = <String, String>{};
              for (final item in state.items) {
                final category = item['category'] as Map<String, dynamic>?;
                final categoryId = (category?['id'] as String? ?? '').trim();
                final categoryName = (category?['name'] as String? ?? '')
                    .trim();
                if (categoryId.isNotEmpty && categoryName.isNotEmpty) {
                  categoryMap[categoryId] = categoryName;
                }
              }
              final categoryEntries = categoryMap.entries.toList()
                ..sort((a, b) => a.value.compareTo(b.value));

              if (_selectedCategoryId != 'all' &&
                  !categoryMap.containsKey(_selectedCategoryId)) {
                _selectedCategoryId = 'all';
              }

              final query = state.query.trim().toLowerCase();
              final filteredItems = state.items.where((item) {
                final title = (item['title'] as String? ?? '').toLowerCase();
                final excerpt = (item['excerpt'] as String? ?? '')
                    .toLowerCase();
                final category = item['category'] as Map<String, dynamic>?;
                final categoryId = (category?['id'] as String? ?? '').trim();
                final categoryName = (category?['name'] as String? ?? '')
                    .toLowerCase();

                final queryMatch =
                    query.isEmpty ||
                    title.contains(query) ||
                    excerpt.contains(query) ||
                    categoryName.contains(query);
                final categoryMatch =
                    _selectedCategoryId == 'all' ||
                    categoryId == _selectedCategoryId;

                return queryMatch && categoryMatch;
              }).toList();

              final showLoadMore = query.isEmpty && state.hasMore;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search blogs...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<BlogsListCubit>().updateQuery(
                                    '',
                                  );
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (categoryEntries.isNotEmpty)
                    SizedBox(
                      height: 44,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text('All'),
                              selected: _selectedCategoryId == 'all',
                              onSelected: (_) {
                                setState(() {
                                  _selectedCategoryId = 'all';
                                });
                              },
                            ),
                          ),
                          ...categoryEntries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(entry.value),
                                selected: _selectedCategoryId == entry.key,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedCategoryId = entry.key;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              query.isEmpty
                                  ? 'No blogs available'
                                  : 'No blogs found',
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount:
                                filteredItems.length + (showLoadMore ? 1 : 0),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              if (index >= filteredItems.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: state.isLoadingMore
                                        ? const CircularProgressIndicator()
                                        : const SizedBox.shrink(),
                                  ),
                                );
                              }

                              final item = filteredItems[index];
                              final blogId = (item['id'] as String?) ?? '';

                              return BlogListItem(
                                item: item,
                                onTap: blogId.trim().isEmpty
                                    ? () {}
                                    : () async {
                                        await Navigator.pushNamed(
                                          context,
                                          RouteNames.blogDetail,
                                          arguments: blogId,
                                        );
                                      },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
