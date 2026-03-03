import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/domain/repositories/blogs_repository.dart';

class BlogsRepositoryImpl implements BlogsRepository {
  @override
  Future<List<Map<String, dynamic>>> fetchPage({
    required int from,
    required int to,
  }) async {
    final request = SupabaseConfig.client
        .from('blogs')
        .select(
          'id, title, excerpt, cover_images, published_at, created_at, '
          'author:authors(name)',
        )
        .eq('status', 'published')
        .eq('is_deleted', false);

    final rows = await request
        .order('published_at', ascending: false, nullsFirst: false)
        .order('created_at', ascending: false)
        .range(from, to);

    return (rows as List<dynamic>)
        .map((item) => Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();
  }
}
