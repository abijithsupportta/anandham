import 'package:anandham_user/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<void> call(Map<String, dynamic> payload) {
    return _repository.updateCurrentProfile(payload);
  }
}
