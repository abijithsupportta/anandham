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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: BlocBuilder<BlogsListCubit, BlogsListState>(
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
                    const Text('Failed to load blogs'),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<BlogsListCubit>().loadInitial(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final query = state.query.trim().toLowerCase();
          final filteredItems = query.isEmpty
              ? state.items
              : state.items.where((item) {
                  final title = (item['title'] as String? ?? '').toLowerCase();
                  return title.contains(query);
                }).toList();
          final showLoadMore = query.isEmpty && state.hasMore;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
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
                              context.read<BlogsListCubit>().updateQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            filteredItems.length + (showLoadMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index >= filteredItems.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }
}
