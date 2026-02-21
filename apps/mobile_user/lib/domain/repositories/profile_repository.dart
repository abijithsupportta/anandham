abstract class ProfileRepository {
  Future<Map<String, dynamic>> fetchCurrentProfile();

  Future<void> updateCurrentProfile(Map<String, dynamic> payload);
}
