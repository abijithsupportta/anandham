import 'package:anandham_user/domain/repositories/home_repository.dart';

class GetProfileNameUseCase {
  final HomeRepository _repository;

  GetProfileNameUseCase(this._repository);

  Future<String?> call() {
    return _repository.getProfileName();
  }
}
