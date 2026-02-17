import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanams_list_cubit.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanams_list_state.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_state.dart';

class KeerthanamsListPage extends StatelessWidget {
  const KeerthanamsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KeerthanamsListCubit()..loadKeerthanams(),
      child: const _KeerthanamsListView(),
    );
  }
}

class _KeerthanamsListView extends StatefulWidget {
  const _KeerthanamsListView();

  @override
  State<_KeerthanamsListView> createState() => _KeerthanamsListViewState();
}

class _KeerthanamsListViewState extends State<_KeerthanamsListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => context.read<KeerthanamsListCubit>().updateQuery(
        _searchController.text,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ഗുരുദേവകീർത്തനം')),
      body: BlocBuilder<KeerthanamsListCubit, KeerthanamsListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }

          final filtered = state.filteredItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search keerthanams...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<KeerthanamsListCubit>().updateQuery(
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
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          state.query.isEmpty
                              ? 'No keerthanams available'
                              : 'No keerthanams found',
                        ),
                      )
                    : BlocBuilder<KeerthanamSavedCubit, KeerthanamSavedState>(
                        builder: (context, savedState) {
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              final id = item['id'] as String;
                              final title = (item['title'] as String?) ?? '';
                              final authorName =
                                  (item['author_name'] as String?) ?? '';
                              final isSaved = savedState.savedIds.contains(id);

                              return InkWell(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    RouteNames.keerthanamDetail,
                                    arguments: item,
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.length > 50
                                                  ? '${title.substring(0, 50)}...'
                                                  : title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (authorName
                                                .trim()
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Text(
                                                authorName,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () async {
                                          await context
                                              .read<KeerthanamSavedCubit>()
                                              .toggleSaved(id);
                                        },
                                        borderRadius: BorderRadius.circular(24),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Icon(
                                            isSaved
                                                ? Icons.bookmark
                                                : Icons.bookmark_outline,
                                            color: isSaved
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.primary
                                                : null,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
