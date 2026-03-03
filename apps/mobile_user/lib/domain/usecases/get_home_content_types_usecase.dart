import 'package:anandham_user/domain/repositories/home_repository.dart';

class GetHomeContentTypesUseCase {
  final HomeRepository _repository;

  GetHomeContentTypesUseCase(this._repository);

  Future<List<Map<String, dynamic>>> call() {
    return _repository.getContentTypes();
  }
}
