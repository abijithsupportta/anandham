import 'package:flutter/material.dart';
import 'package:anandham_core/anandham_core.dart';

class DharmasListPage extends StatelessWidget {
  const DharmasListPage({super.key});

  Future<List<Map<String, dynamic>>> _loadDharmas() async {
    final rows = await SupabaseConfig.client
        .from('dharmas')
        .select('id, title, description')
        .eq('status', 'published')
        .eq('is_deleted', false)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Text('No items available')
          else
            ...items.map((item) {
              final itemTitle = (item['title'] as String?) ?? '';
              final itemDescription = (item['description'] as String?) ?? '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (itemDescription.trim().isNotEmpty)
                      Text(
                        itemDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ശ്രീനാരായണ ധർമ്മം')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadDharmas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load dharmam data'));
          }

          final dharmas = snapshot.data ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionCard(
                context,
                title: 'ശ്രീനാരായണ ധർമ്മം',
                subtitle: 'Dharmas and teachings',
                items: dharmas,
              ),
            ],
          );
        },
      ),
    );
  }
}
