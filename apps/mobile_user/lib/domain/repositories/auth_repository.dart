import 'package:dartz/dartz.dart';
import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signUp({
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
  });

  Future<Either<Failure, AppUser?>> currentUser();

  Future<Either<Failure, Unit>> signOut();
}
