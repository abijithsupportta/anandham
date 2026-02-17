import 'package:dartz/dartz.dart';
import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/entities/app_user.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, AppUser?>> call() {
    return _repository.currentUser();
  }
}
