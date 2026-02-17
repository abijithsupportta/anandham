import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _contentTypesCacheKey = 'home_content_types_cache';
  static const String _profileNameCacheKey = 'home_profile_name_cache';

  late Future<List<_ContentTypeItem>> _contentTypesFuture;
  late Future<String?> _profileNameFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _contentTypesFuture = _loadContentTypes();
      _profileNameFuture = _loadProfileName();
    });
  }

  Future<String?> _loadProfileName() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedName = prefs.getString(_profileNameCacheKey);
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return cachedName;
    }

    try {
      final List<dynamic> rows = await SupabaseConfig.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .limit(1);

      if (rows.isEmpty) {
        return cachedName;
      }

      final name = (rows.first as Map<String, dynamic>)['full_name'] as String?;
      final trimmedName = name?.trim();
      if (trimmedName == null || trimmedName.isEmpty) {
        return cachedName;
      }

      await prefs.setString(_profileNameCacheKey, trimmedName);
      return trimmedName;
    } catch (_) {
      return cachedName;
    }
  }

  Future<List<_ContentTypeItem>> _loadContentTypes() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final rows = await SupabaseConfig.client
          .from('content_types')
          .select(
            'name, display_name, description, icon, color, table_name, display_order, is_active',
          )
          .eq('is_active', true)
          .order('display_order', ascending: true);

      final list = (rows as List<dynamic>);
      await prefs.setString(_contentTypesCacheKey, jsonEncode(list));

      return list
          .map((raw) => _ContentTypeItem.fromMap(raw as Map<String, dynamic>))
          .toList();
    } catch (_) {
      final cached = prefs.getString(_contentTypesCacheKey);
      if (cached == null || cached.trim().isEmpty) {
        return [];
      }

      try {
        final decoded = jsonDecode(cached) as List<dynamic>;
        return decoded
            .map((raw) => _ContentTypeItem.fromMap(raw as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return [];
      }
    }
  }

  String _localizedTitle(_ContentTypeItem item) {
    switch (item.name) {
      case 'guru_krithis':
        return 'ഗുരുദേവകൃതികൾ';
      case 'guru_dharmas':
        return 'ശ്രീനാരായണ ധർമ്മം';
      case 'guru_keerthanams':
        return 'ഗുരുദേവകീർത്തനം';
      case 'guru_photos':
        return 'ചിത്രങ്ങൾ';
      default:
        return item.displayName;
    }
  }

  List<_ContentTypeItem> _prepareVisibleContentTypes(
    List<_ContentTypeItem> all,
  ) {
    final hiddenNames = {'blogs'};

    final filtered = all
        .where((item) => !hiddenNames.contains(item.name))
        .toList();

    filtered.sort(
      (a, b) => _contentOrder(a.name).compareTo(_contentOrder(b.name)),
    );

    return filtered;
  }

  int _contentOrder(String name) {
    switch (name) {
      case 'guru_krithis':
        return 1;
      case 'guru_dharmas':
        return 2;
      case 'guru_keerthanams':
        return 3;
      case 'guru_photos':
        return 4;
      default:
        return 50;
    }
  }

  Color _hexToColor(String? hex) {
    if (hex == null || hex.trim().isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }

    final normalized = hex.replaceAll('#', '');
    final withAlpha = normalized.length == 6 ? 'FF$normalized' : normalized;
    return Color(int.parse(withAlpha, radix: 16));
  }

  String? _routeForContent(String name) {
    switch (name) {
      case 'guru_krithis':
        return RouteNames.krithisList;
      case 'guru_dharmas':
        return RouteNames.dharmasList;
      case 'guru_keerthanams':
        return RouteNames.keerthanamsList;
      case 'guru_photos':
        return RouteNames.photosList;
      default:
        return null;
    }
  }

  String _iconFor(_ContentTypeItem item) {
    if (item.name == 'guru_krithis') {
      return '📚';
    }
    return item.icon;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        onRefresh: () async {
          _refreshData();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/web-logo.png',
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Anandham',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<String?>(
                    future: _profileNameFuture,
                    builder: (context, snapshot) {
                      final name = snapshot.data?.trim();
                      final greetingText = (name != null && name.isNotEmpty)
                          ? '${Helpers.getGreeting()}, $name!'
                          : '${Helpers.getGreeting()}!';

                      return Center(
                        child: Text(
                          greetingText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
            // Content Items - Expanded Sliver
            FutureBuilder<List<_ContentTypeItem>>(
              future: _contentTypesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Unable to load content types',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final allContentTypes = snapshot.data ?? <_ContentTypeItem>[];
                final contentTypes = _prepareVisibleContentTypes(
                  allContentTypes,
                );

                if (contentTypes.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'No content types available',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      // Add separator between items
                      if (index % 2 == 1) {
                        return const SizedBox(height: 14);
                      }

                      final itemIndex = index ~/ 2;
                      final item = contentTypes[itemIndex];
                      final accent = _hexToColor(item.colorHex);
                      final targetRoute = _routeForContent(item.name);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: targetRoute == null
                              ? null
                              : () {
                                  Navigator.pushNamed(context, targetRoute);
                                },
                          borderRadius: BorderRadius.circular(18),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  accent.withValues(alpha: 0.12),
                                  accent.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: accent.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(
                                    alpha: isDark ? 0.1 : 0.08,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon Container
                                  Container(
                                    width: 56,
                                    height: 56,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: accent.withValues(alpha: 0.25),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      _iconFor(item),
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Title and Description
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _localizedTitle(item),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: accent,
                                              ),
                                        ),
                                        if (item.description.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            item.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                  height: 1.3,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Chevron Icon
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.chevron_right_rounded,
                                      color: accent,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: contentTypes.length * 2 - 1),
                  ),
                );
              },
            ),
            // Bottom padding
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentTypeItem {
  final String name;
  final String displayName;
  final String description;
  final String icon;
  final String? colorHex;

  const _ContentTypeItem({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.colorHex,
  });

  factory _ContentTypeItem.fromMap(Map<String, dynamic> map) {
    return _ContentTypeItem(
      name: map['name'] as String? ?? '',
      displayName: map['display_name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      icon: map['icon'] as String? ?? '📚',
      colorHex: map['color'] as String?,
    );
  }
}
