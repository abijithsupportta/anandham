import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_state.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_state.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SavedView();
  }
}

class _SavedView extends StatefulWidget {
  const _SavedView();

  @override
  State<_SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<_SavedView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SavedCubit>().loadSaved();
      context.read<KeerthanamSavedCubit>().loadSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.book), text: 'Krithis'),
                Tab(icon: Icon(Icons.music_note), text: 'Keerthanams'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Krithis Tab
                  BlocBuilder<SavedCubit, SavedState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.errorMessage != null) {
                        return Center(child: Text(state.errorMessage!));
                      }

                      if (state.items.isEmpty) {
                        return const Center(
                          child: Text('No saved krithis yet'),
                        );
                      }

                      return _buildSavedList(
                        context,
                        state.items,
                        RouteNames.krithiDetail,
                        (id) => context.read<SavedCubit>().removeSaved(id),
                      );
                    },
                  ),
                  // Keerthanams Tab
                  BlocBuilder<KeerthanamSavedCubit, KeerthanamSavedState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.errorMessage != null) {
                        return Center(child: Text(state.errorMessage!));
                      }

                      if (state.items.isEmpty) {
                        return const Center(
                          child: Text('No saved keerthanams yet'),
                        );
                      }

                      return _buildSavedList(
                        context,
                        state.items,
                        RouteNames.keerthanamDetail,
                        (id) => context
                            .read<KeerthanamSavedCubit>()
                            .removeSaved(id),
                        showAuthor: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedList(
    BuildContext context,
    List<Map<String, dynamic>> items,
    String detailRoute,
    Function(String) onRemove, {
    bool showAuthor = false,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final id = item['id'] as String;
        final title = (item['title'] as String?) ?? '';
        final author = (item['author_name'] as String?) ?? '';

        return InkWell(
          onTap: () async {
            await Navigator.pushNamed(context, detailRoute, arguments: item);
            if (!context.mounted) {
              return;
            }
            if (detailRoute == RouteNames.krithiDetail) {
              await context.read<SavedCubit>().loadSaved();
            } else {
              await context.read<KeerthanamSavedCubit>().loadSaved();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.length > 50
                            ? '${title.substring(0, 50)}...'
                            : title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (showAuthor && author.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          author,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () async {
                    await onRemove(id);
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.bookmark,
                      color: Theme.of(context).colorScheme.primary,
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
  }
}
