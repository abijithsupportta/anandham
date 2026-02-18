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
    String? phoneCountryCode,
    String? phoneNumber,
    String? address,
    String? houseName,
    String? city,
    String? stateName,
    String? pincode,
    bool isSndpMember = false,
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
