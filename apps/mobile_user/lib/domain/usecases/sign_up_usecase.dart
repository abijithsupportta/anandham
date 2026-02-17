import 'package:dartz/dartz.dart';
import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/entities/app_user.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String fullName,
    required String email,
    required String password,
    required String phoneCountryCode,
    required String phoneNumber,
    required String address,
    required String houseName,
    required String city,
    required String stateName,
    required String pincode,
    required bool isSndpMember,
    String? sndpUnionName,
    String? sndpBranchNumber,
    String? sndpTempleName,
  }) {
    return _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
      phoneCountryCode: phoneCountryCode,
      phoneNumber: phoneNumber,
      address: address,
      houseName: houseName,
      city: city,
      stateName: stateName,
      pincode: pincode,
      isSndpMember: isSndpMember,
      sndpUnionName: sndpUnionName,
      sndpBranchNumber: sndpBranchNumber,
      sndpTempleName: sndpTempleName,
    );
  }
}
