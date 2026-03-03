import 'package:anandham_user/domain/repositories/blogs_repository.dart';

class GetBlogsPageUseCase {
  final BlogsRepository _repository;

  GetBlogsPageUseCase(this._repository);

  Future<List<Map<String, dynamic>>> call({
    required int from,
    required int to,
  }) {
    return _repository.fetchPage(from: from, to: to);
  }
}
