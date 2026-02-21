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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<KeerthanamSavedCubit>().loadSaved();

    _searchController.addListener(
      () => context.read<KeerthanamsListCubit>().updateQuery(
        _searchController.text,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('ഗുരുദേവകീർത്തനം')),
      body: SafeArea(
        bottom: true,
        child: BlocBuilder<KeerthanamsListCubit, KeerthanamsListState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            final visible = state.filteredItems;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                                context
                                    .read<KeerthanamsListCubit>()
                                    .updateQuery('');
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
                  child: visible.isEmpty
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
                              controller: _scrollController,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              padding: EdgeInsets.fromLTRB(
                                16,
                                4,
                                16,
                                16 + bottomInset + 24,
                              ),
                              itemCount: visible.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = visible[index];
                                final id = item['id'] as String;
                                final title = (item['title'] as String?) ?? '';
                                final authorName =
                                    (item['author_name'] as String?) ?? '';
                                final isSaved = savedState.savedIds.contains(
                                  id,
                                );

                                return InkWell(
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RouteNames.keerthanamDetail,
                                      arguments: item,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSaved
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.3)
                                            : Theme.of(context).dividerColor,
                                        width: isSaved ? 2 : 1,
                                      ),
                                      boxShadow: isSaved
                                          ? [
                                              BoxShadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withValues(alpha: 0.1),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : null,
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
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: isSaved
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.15)
                                                : null,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () async {
                                              await context
                                                  .read<KeerthanamSavedCubit>()
                                                  .toggleSaved(id);
                                              if (context.mounted) {
                                                final error = context
                                                    .read<
                                                      KeerthanamSavedCubit
                                                    >()
                                                    .state
                                                    .errorMessage;
                                                if (error != null) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(error),
                                                      backgroundColor: Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                      duration: const Duration(
                                                        seconds: 4,
                                                      ),
                                                      action: SnackBarAction(
                                                        label: 'Dismiss',
                                                        onPressed: () {
                                                          if (context.mounted) {
                                                            context
                                                                .read<
                                                                  KeerthanamSavedCubit
                                                                >()
                                                                .clearError();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
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
      ),
    );
  }
}
