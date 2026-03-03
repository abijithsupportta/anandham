abstract class BlogsRepository {
  Future<List<Map<String, dynamic>>> fetchPage({
    required int from,
    required int to,
  });
}
