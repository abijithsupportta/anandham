import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:anandham_user/presentation/blocs/krithis/krithi_detail_cubit.dart';
import 'package:anandham_user/presentation/blocs/krithis/krithi_detail_state.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_cubit.dart';
import 'package:anandham_user/presentation/blocs/saved/saved_state.dart';

class KrithiDetailPage extends StatelessWidget {
  final Map<String, dynamic> krithi;

  const KrithiDetailPage({super.key, required this.krithi});

  @override
  Widget build(BuildContext context) {
    SavedCubit? existingSavedCubit;
    try {
      existingSavedCubit = context.read<SavedCubit>();
    } catch (_) {
      existingSavedCubit = null;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => KrithiDetailCubit()),
        if (existingSavedCubit != null)
          BlocProvider.value(value: existingSavedCubit)
        else
          BlocProvider(create: (_) => SavedCubit()..loadSaved()),
      ],
      child: _KrithiDetailView(krithi: krithi),
    );
  }
}

class _KrithiDetailView extends StatefulWidget {
  final Map<String, dynamic> krithi;

  const _KrithiDetailView({required this.krithi});

  @override
  State<_KrithiDetailView> createState() => _KrithiDetailViewState();
}

class _KrithiDetailViewState extends State<_KrithiDetailView> {
  late YoutubePlayerController _youtubeController;
  bool _youtubeReady = false;

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget _sectionCard(BuildContext context, String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context, title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final youtubeUrl = widget.krithi['youtube_url'] as String? ?? '';
    final cubit = context.read<KrithiDetailCubit>();
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
    final title = widget.krithi['title'] as String? ?? 'Krithi';
    final description = widget.krithi['description'] as String? ?? '';
    final id = widget.krithi['id'] as String? ?? '';

    final copyPayload = description.trim().isEmpty
        ? title
        : (StringBuffer()
                ..writeln(title)
                ..writeln('')
                ..writeln(description))
              .toString();

    return BlocBuilder<KrithiDetailCubit, KrithiDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ഗുരുദേവകൃതി'),
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
                    context.read<KrithiDetailCubit>().increaseFontSize(),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                tooltip: 'Decrease font size',
                onPressed: () =>
                    context.read<KrithiDetailCubit>().decreaseFontSize(),
              ),
              BlocBuilder<SavedCubit, SavedState>(
                builder: (context, savedState) {
                  final isSaved = savedState.savedIds.contains(id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    ),
                    tooltip: isSaved ? 'Unsave' : 'Save',
                    onPressed: () async {
                      await context.read<SavedCubit>().toggleSaved(id);
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontSize: state.fontSize + 8,
                                    fontWeight: FontWeight.w800,
                                    height: 1.3,
                                  ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded),
                            tooltip: 'Copy krithi',
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: copyPayload),
                              );
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Krithi copied'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontSize: state.fontSize, height: 1.7),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_youtubeReady) ...[
                  _sectionCard(
                    context,
                    'Video',
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
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
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
