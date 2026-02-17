import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/krithis/krithis_list_cubit.dart';
import 'package:anandham_user/presentation/blocs/krithis/krithis_list_state.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_state.dart';

class KrithisListPage extends StatelessWidget {
  const KrithisListPage({super.key});

  @override
  Widget build(BuildContext context) {
    SavedCubit? existingSavedCubit;
    try {
      existingSavedCubit = context.read<SavedCubit>();
    } catch (_) {
      existingSavedCubit = null;
    }

    return BlocProvider(
      create: (_) => KrithisListCubit()..loadKrithis(),
      child: MultiBlocProvider(
        providers: [
          if (existingSavedCubit != null)
            BlocProvider.value(value: existingSavedCubit)
          else
            BlocProvider(create: (_) => SavedCubit()..loadSaved()),
        ],
        child: const _KrithisListView(),
      ),
    );
  }
}

class _KrithisListView extends StatefulWidget {
  const _KrithisListView();

  @override
  State<_KrithisListView> createState() => _KrithisListViewState();
}

class _KrithisListViewState extends State<_KrithisListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () =>
          context.read<KrithisListCubit>().updateQuery(_searchController.text),
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
      appBar: AppBar(title: const Text('ഗുരുദേവകൃതികൾ')),
      body: BlocBuilder<KrithisListCubit, KrithisListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load krithis'),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }

          final filtered = state.filteredItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search krithis...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<KrithisListCubit>().updateQuery('');
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
                              ? 'No krithis available'
                              : 'No krithis found',
                        ),
                      )
                    : BlocBuilder<SavedCubit, SavedState>(
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
                              final isSaved = savedState.savedIds.contains(id);

                              return InkWell(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    RouteNames.krithiDetail,
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
                                        child: Text(
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
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () async {
                                          await context
                                              .read<SavedCubit>()
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
