import 'package:dartz/dartz.dart';
import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.signOut();
  }
}
