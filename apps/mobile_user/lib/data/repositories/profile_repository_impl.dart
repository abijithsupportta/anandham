import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Map<String, dynamic>> fetchCurrentProfile() async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return const <String, dynamic>{};
    }

    final List<dynamic> rows = await SupabaseConfig.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .limit(1);

    if (rows.isEmpty) {
      return const <String, dynamic>{};
    }

    return Map<String, dynamic>.from(rows.first as Map<String, dynamic>);
  }

  @override
  Future<void> updateCurrentProfile(Map<String, dynamic> payload) async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      return;
    }

    final current = await fetchCurrentProfile();
    final availableColumns = current.keys.map((key) => key.toString()).toSet();

    final filteredPayload = availableColumns.isEmpty
        ? payload
        : Map<String, dynamic>.fromEntries(
            payload.entries.where(
              (entry) => availableColumns.contains(entry.key),
            ),
          );

    try {
      await SupabaseConfig.client
          .from('profiles')
          .update(
            filteredPayload.isEmpty
                ? {'full_name': payload['full_name'] ?? ''}
                : filteredPayload,
          )
          .eq('id', user.id);
    } catch (_) {
      await SupabaseConfig.client
          .from('profiles')
          .update({'full_name': payload['full_name'] ?? ''})
          .eq('id', user.id);
    }
  }
}
