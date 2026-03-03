import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharmas_cubit.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharmas_state.dart';

class DharmasListPage extends StatelessWidget {
  const DharmasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DharmasCubit()..loadDharmas(),
      child: const _DharmasListView(),
    );
  }
}

class _DharmasListView extends StatefulWidget {
  const _DharmasListView();

  @override
  State<_DharmasListView> createState() => _DharmasListViewState();
}

class _DharmasListViewState extends State<_DharmasListView> {
  final TextEditingController _searchController = TextEditingController();

  String _firstSlokaPreview(DharmaItemView item) {
    final first = item.slokas.isNotEmpty ? item.slokas.first.text.trim() : '';
    if (first.isEmpty) {
      return item.title.length > 10
          ? '${item.title.substring(0, 10)}...'
          : item.title;
    }
    return first.length > 10 ? '${first.substring(0, 10)}...' : first;
  }

  String _categoryOf(DharmaItemView item, DharmasState state) {
    final name = state.categoryById[item.id]?.trim();
    if (name == null || name.isEmpty) {
      return 'Others';
    }
    return name;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ശ്രീനാരായണ ധർമ്മം')),
      body: BlocBuilder<DharmasCubit, DharmasState>(
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
                    const Text('Failed to load dharmas'),
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

          final query = _searchController.text.trim().toLowerCase();
          final filtered = state.items.where((item) {
            if (query.isEmpty) {
              return true;
            }
            final title = item.title.toLowerCase();
            final description = item.description.toLowerCase();
            final firstSloka = _firstSlokaPreview(item).toLowerCase();
            final category = _categoryOf(item, state).toLowerCase();
            return title.contains(query) ||
                description.contains(query) ||
                firstSloka.contains(query) ||
                category.contains(query);
          }).toList();

          final grouped = <String, List<DharmaItemView>>{};
          for (final item in filtered) {
            final category = _categoryOf(item, state);
            grouped.putIfAbsent(category, () => <DharmaItemView>[]).add(item);
          }

          final sections = grouped.entries.toList()
            ..sort(
              (a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()),
            );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search dharmas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
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
                          query.isEmpty
                              ? 'No dharmas available'
                              : 'No dharmas found',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: sections.length,
                        itemBuilder: (context, sectionIndex) {
                          final section = sections[sectionIndex];
                          final category = section.key;
                          final items = section.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                        ),
                                  ),
                                ),
                                ...items.asMap().entries.map((entry) {
                                  final item = entry.value;
                                  final slokaCount = item.slokas.length;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: entry.key == items.length - 1
                                          ? 0
                                          : 10,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        await Navigator.pushNamed(
                                          context,
                                          RouteNames.dharmaDetail,
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
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(
                                              context,
                                            ).dividerColor,
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
                                                    _firstSlokaPreview(item),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20,
                                                        ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '$slokaCount ${slokaCount == 1 ? 'sloka' : 'slokas'}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
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
