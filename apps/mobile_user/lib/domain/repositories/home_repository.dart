abstract class HomeRepository {
  Future<String?> getProfileName();

  Future<List<Map<String, dynamic>>> getContentTypes();
}
