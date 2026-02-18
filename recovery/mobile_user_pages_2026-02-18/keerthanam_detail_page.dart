import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_detail_cubit.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_detail_state.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/keerthanams/keerthanam_saved_state.dart';

class KeerthanamDetailPage extends StatelessWidget {
  final Map<String, dynamic> keerthanam;

  const KeerthanamDetailPage({super.key, required this.keerthanam});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KeerthanamDetailCubit(),
      child: _KeerthanamDetailView(keerthanam: keerthanam),
    );
  }
}

class _KeerthanamDetailView extends StatefulWidget {
  final Map<String, dynamic> keerthanam;

  const _KeerthanamDetailView({required this.keerthanam});

  @override
  State<_KeerthanamDetailView> createState() => _KeerthanamDetailViewState();
}

class _KeerthanamDetailViewState extends State<_KeerthanamDetailView> {
  late YoutubePlayerController _youtubeController;
  bool _youtubeReady = false;

  @override
  void initState() {
    super.initState();
    final youtubeUrl = widget.keerthanam['youtube_url'] as String? ?? '';
    final cubit = context.read<KeerthanamDetailCubit>();
    cubit.initVideo(youtubeUrl);
    final videoId = cubit.state.videoId;
    if (videoId != null && videoId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
        ),
      );
      _youtubeReady = true;
    }
  }

  @override
  void dispose() {
    if (_youtubeReady) {
      _youtubeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.keerthanam['title'] as String? ?? 'Keerthanam';
    final authorName = widget.keerthanam['author_name'] as String? ?? '';
    final description = widget.keerthanam['description'] as String? ?? '';
    final id = widget.keerthanam['id'] as String? ?? '';

    return BlocBuilder<KeerthanamDetailCubit, KeerthanamDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ഗുരുദേവകീർത്തനം'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    '${state.fontSize.toStringAsFixed(0)}pt',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Increase font size',
                onPressed: () =>
                    context.read<KeerthanamDetailCubit>().increaseFontSize(),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                tooltip: 'Decrease font size',
                onPressed: () =>
                    context.read<KeerthanamDetailCubit>().decreaseFontSize(),
              ),
              BlocBuilder<KeerthanamSavedCubit, KeerthanamSavedState>(
                builder: (context, savedState) {
                  final isSaved = savedState.savedIds.contains(id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    ),
                    tooltip: isSaved ? 'Unsave' : 'Save',
                    onPressed: () async {
                      await context.read<KeerthanamSavedCubit>().toggleSaved(
                        id,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                if (authorName.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    authorName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (description.isNotEmpty) ...[
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: state.fontSize,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (_youtubeReady)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black,
                        child: YoutubePlayer(
                          controller: _youtubeController,
                          showVideoProgressIndicator: true,
                          onReady: () {
                            debugPrint('YouTube player ready');
                          },
                          onEnded: (_) {
                            debugPrint('YouTube video ended');
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
