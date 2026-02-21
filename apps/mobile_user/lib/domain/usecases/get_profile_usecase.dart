import 'package:anandham_user/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Map<String, dynamic>> call() {
    return _repository.fetchCurrentProfile();
  }
}
