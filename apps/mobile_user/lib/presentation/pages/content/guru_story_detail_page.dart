import 'package:anandham_user/presentation/blocs/guru_stories/guru_story_detail_cubit.dart';
import 'package:anandham_user/presentation/blocs/guru_stories/guru_story_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuruStoryDetailPage extends StatelessWidget {
  final String storyId;

  const GuruStoryDetailPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuruStoryDetailCubit()..loadStory(storyId),
      child: _GuruStoryDetailView(storyId: storyId),
    );
  }
}

class _GuruStoryDetailView extends StatefulWidget {
  final String storyId;

  const _GuruStoryDetailView({required this.storyId});

  @override
  State<_GuruStoryDetailView> createState() => _GuruStoryDetailViewState();
}

class _GuruStoryDetailViewState extends State<_GuruStoryDetailView> {
  double _fontSize = 18;

  void _increaseFontSize() {
    setState(() {
      _fontSize = (_fontSize + 2).clamp(18, 36);
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize = (_fontSize - 2).clamp(18, 36);
    });
  }

  Widget _metaCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: _fontSize - 2),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guru Story'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease font size',
            onPressed: _decreaseFontSize,
          ),
          Center(
            child: Text(
              _fontSize.toStringAsFixed(0),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Increase font size',
            onPressed: _increaseFontSize,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<GuruStoryDetailCubit, GuruStoryDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null || state.story == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Failed to load guru story'),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage ?? 'Please try again',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => context
                            .read<GuruStoryDetailCubit>()
                            .loadStory(widget.storyId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final story = state.story!;
            final title = (story['title'] as String? ?? '').trim();
            final body = (story['body'] as String? ?? '').trim();
            final author = (story['author_name'] as String? ?? '').trim();
            final referenceBook = (story['reference_book'] as String? ?? '')
                .trim();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: _fontSize + 8,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Text(
                    body,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: _fontSize,
                      height: 1.65,
                    ),
                  ),
                ),
                if (author.isNotEmpty)
                  _metaCard(
                    context: context,
                    label: 'Author',
                    value: author,
                    icon: Icons.person_rounded,
                  ),
                if (referenceBook.isNotEmpty)
                  _metaCard(
                    context: context,
                    label: 'Book Reference',
                    value: referenceBook,
                    icon: Icons.menu_book_rounded,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
