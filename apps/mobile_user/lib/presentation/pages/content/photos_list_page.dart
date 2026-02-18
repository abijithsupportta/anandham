import 'dart:async';
import 'dart:io';

import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/data/repositories/local_content_repository.dart';
import 'package:anandham_user/data/services/content_sync_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotosListPage extends StatefulWidget {
  const PhotosListPage({super.key});

  @override
  State<PhotosListPage> createState() => _PhotosListPageState();
}

class _PhotosListPageState extends State<PhotosListPage> {
  final LocalContentRepository _localRepository = sl<LocalContentRepository>();
  final ContentSyncService _syncService = sl<ContentSyncService>();

  List<Map<String, dynamic>> _items = const [];
  final Map<int, int> _currentImageIndex = {};
  Set<String> _likedPhotoIds = const {};
  Map<String, int> _likeCounts = const {};
  Set<String> _likeInProgressIds = const {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadLikesForPhotos(List<Map<String, dynamic>> items) async {
    final photoIds = items
        .map((item) => item['id'] as String?)
        .whereType<String>()
        .where((id) => id.trim().isNotEmpty)
        .toList();

    if (photoIds.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _likedPhotoIds = const {};
        _likeCounts = const {};
      });
      return;
    }

    try {
      final rows = await SupabaseConfig.client
          .from('guru_photo_likes')
          .select('guru_photo_id, user_id')
          .inFilter('guru_photo_id', photoIds);

      final data = (rows as List<dynamic>).cast<Map<String, dynamic>>();
      final currentUserId = SupabaseConfig.currentUser?.id;
      final counts = <String, int>{};
      final likedByMe = <String>{};

      for (final row in data) {
        final photoId = row['guru_photo_id'] as String?;
        final userId = row['user_id'] as String?;
        if (photoId == null || photoId.isEmpty) {
          continue;
        }

        counts[photoId] = (counts[photoId] ?? 0) + 1;
        if (currentUserId != null && userId == currentUserId) {
          likedByMe.add(photoId);
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _likeCounts = counts;
        _likedPhotoIds = likedByMe;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        final fallback = <String, int>{};
        for (final id in photoIds) {
          fallback[id] = _likeCounts[id] ?? 0;
        }
        _likeCounts = fallback;
      });
    }
  }

  Future<void> _likePhoto(String photoId, String title) async {
    if (photoId.isEmpty) {
      return;
    }

    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to love photos.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_likeInProgressIds.contains(photoId)) {
      return;
    }

    if (_likedPhotoIds.contains(photoId)) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You already loved this photo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final previousLiked = _likedPhotoIds;
    final previousCounts = _likeCounts;

    setState(() {
      _likedPhotoIds = {..._likedPhotoIds, photoId};
      _likeCounts = {..._likeCounts, photoId: (_likeCounts[photoId] ?? 0) + 1};
      _likeInProgressIds = {..._likeInProgressIds, photoId};
    });

    try {
      await SupabaseConfig.client.from('guru_photo_likes').upsert({
        'user_id': userId,
        'guru_photo_id': photoId,
      }, onConflict: 'user_id,guru_photo_id');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You loved "$title"'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _likedPhotoIds = previousLiked;
        _likeCounts = previousCounts;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to save your like now. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _likeInProgressIds = {..._likeInProgressIds}..remove(photoId);
        });
      }
    }
  }

  Future<void> _loadPhotos() async {
    setState(() {
      _isLoading = _items.isEmpty;
      _errorMessage = null;
    });

    try {
      final hasCached = _items.isNotEmpty;
      if (!hasCached) {
        try {
          await _syncService.syncGuruPhotos();
        } catch (_) {}
      }

      final localItems = await _localRepository.getGuruPhotos();
      if (!mounted) {
        return;
      }

      setState(() {
        _items = localItems;
        _isLoading = false;
        _errorMessage = null;
      });
      await _loadLikesForPhotos(localItems);

      if (hasCached || localItems.isNotEmpty) {
        unawaited(_refreshInBackground());
      }
    } catch (_) {
      final localItems = await _localRepository.getGuruPhotos();
      if (!mounted) {
        return;
      }

      setState(() {
        _items = localItems;
        _isLoading = false;
        _errorMessage = localItems.isEmpty ? 'Failed to load photos' : null;
      });
      await _loadLikesForPhotos(localItems);
    }
  }

  Future<void> _refreshInBackground() async {
    try {
      await _syncService.syncGuruPhotos();
      final refreshed = await _localRepository.getGuruPhotos();
      if (!mounted) {
        return;
      }
      setState(() {
        _items = refreshed;
        _errorMessage = null;
      });
      await _loadLikesForPhotos(refreshed);
    } catch (_) {}
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      }

      status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied && mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Permission required'),
            content: const Text(
              'Please enable storage/photos permission in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }

      return false;
    }

    final status = await Permission.photos.request();
    return status.isGranted;
  }

  String _sanitizeBaseName(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\w\s-]'), '_').trim();
    return cleaned.isEmpty ? 'image' : cleaned;
  }

  Future<void> _downloadAllImages(List<String> imageUrls, String title) async {
    if (imageUrls.isEmpty) {
      return;
    }

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      return;
    }

    try {
      final dio = Dio();
      final directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      final base = _sanitizeBaseName(title);
      final stamp = DateTime.now().millisecondsSinceEpoch;

      for (var i = 0; i < imageUrls.length; i++) {
        final path = '${directory.path}/${base}_${i + 1}_$stamp.jpg';
        await dio.download(imageUrls[i], path);
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${imageUrls.length} image(s) downloaded')),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ചിത്രങ്ങൾ')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _items.isEmpty
          ? const Center(child: Text('No photos available'))
          : RefreshIndicator(
              onRefresh: _loadPhotos,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                itemCount: _items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final photoId = (item['id'] as String?) ?? '';
                  final title = (item['title'] as String?) ?? '';
                  final description = (item['description'] as String?) ?? '';
                  final imageUrl = (item['image_url'] as String?) ?? '';
                  final isLiked = _likedPhotoIds.contains(photoId);
                  final likesCount = _likeCounts[photoId] ?? 0;
                  final images =
                      (item['images'] as List<dynamic>?)
                          ?.cast<String>()
                          .where((url) => url.trim().isNotEmpty)
                          .toList() ??
                      [];
                  final displayImages = images.isNotEmpty
                      ? images
                      : (imageUrl.trim().isNotEmpty
                            ? <String>[imageUrl]
                            : const <String>[]);

                  _currentImageIndex[index] ??= 0;

                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                          ),
                        ),
                        if (displayImages.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: displayImages.length == 1
                                        ? Image.network(
                                            displayImages.first,
                                            fit: BoxFit.cover,
                                          )
                                        : PageView.builder(
                                            itemCount: displayImages.length,
                                            onPageChanged: (pageIndex) {
                                              setState(() {
                                                _currentImageIndex[index] =
                                                    pageIndex;
                                              });
                                            },
                                            itemBuilder: (context, imageIndex) {
                                              return Image.network(
                                                displayImages[imageIndex],
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                  ),
                                  if (displayImages.length > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 2,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          displayImages.length,
                                          (dotIndex) => Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  _currentImageIndex[index] ==
                                                      dotIndex
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                  : Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        if (description.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: displayImages.isEmpty
                                      ? null
                                      : () => _downloadAllImages(
                                          displayImages,
                                          title,
                                        ),
                                  icon: const Icon(Icons.download, size: 20),
                                  label: Text(
                                    displayImages.length > 1
                                        ? 'Download (${displayImages.length})'
                                        : 'Download',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: photoId.isEmpty
                                      ? null
                                      : () => _likePhoto(photoId, title),
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: isLiked ? Colors.red : null,
                                  ),
                                  label: Text(
                                    isLiked
                                        ? 'Loved ($likesCount)'
                                        : 'Love ($likesCount)',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
