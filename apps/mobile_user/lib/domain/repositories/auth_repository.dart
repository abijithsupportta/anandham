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
  });

  Future<Either<Failure, AppUser?>> currentUser();

  Future<Either<Failure, Unit>> signOut();
}
