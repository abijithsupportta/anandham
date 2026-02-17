import 'package:anandham_core/anandham_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'keerthanams_list_state.dart';

class KeerthanamsListCubit extends Cubit<KeerthanamsListState> {
  KeerthanamsListCubit() : super(const KeerthanamsListState.initial());

  Future<void> loadKeerthanams() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final rows = await SupabaseConfig.client
          .from('guru_keerthanams')
          .select('id, title, description, author_name, youtube_url')
          .eq('status', 'published')
          .eq('is_deleted', false)
          .order('created_at', ascending: false);

      final items = (rows as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList();

      final filtered = _applyQuery(items, state.query);

      emit(
        state.copyWith(isLoading: false, items: items, filteredItems: filtered),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load keerthanams',
        ),
      );
    }
  }

  void updateQuery(String query) {
    final filtered = _applyQuery(state.items, query);
    emit(state.copyWith(query: query, filteredItems: filtered));
  }

  List<Map<String, dynamic>> _applyQuery(
    List<Map<String, dynamic>> items,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return items;
    }
    return items
        .where(
          (item) =>
              (item['title'] as String? ?? '').toLowerCase().contains(trimmed),
        )
        .toList();
  }
}
