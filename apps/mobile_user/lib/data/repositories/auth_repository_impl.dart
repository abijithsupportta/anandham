import 'package:dartz/dartz.dart';
import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/entities/app_user.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseAuthService.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null || user.email == null) {
        return const Left(
          AuthenticationFailure(message: 'Unable to sign in user.'),
        );
      }
      return Right(AppUser(id: user.id, email: user.email!));
    } on Exception catch (e) {
      return Left(AuthenticationFailure(message: e.toString()));
    } catch (_) {
      return const Left(
        UnexpectedFailure(message: 'Unexpected sign-in error occurred.'),
      );
    }
  }

  @override
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
  }) async {
    try {
      final response = await SupabaseAuthService.signUp(
        email: email,
        password: password,
        data: {
          'role': 'customer',
          'full_name': fullName,
          'phone_country_code': phoneCountryCode,
          'phone_number': phoneNumber,
          'address': address,
          'house_name': houseName,
          'city': city,
          'state': stateName,
          'pincode': pincode,
          'is_sndp_member': isSndpMember,
          'sndp_union_name': isSndpMember ? sndpUnionName : null,
          'sndp_branch_number': isSndpMember ? sndpBranchNumber : null,
          'sndp_temple_name': isSndpMember ? sndpTempleName : null,
        },
      );
      final user = response.user;
      if (user == null || user.email == null) {
        return const Left(
          AuthenticationFailure(message: 'Account created. Verify your email.'),
        );
      }

      await SupabaseConfig.client
          .from('profiles')
          .update({
            'full_name': fullName,
            'phone_country_code': phoneCountryCode,
            'phone_number': phoneNumber,
            'address': address,
            'house_name': houseName,
            'city': city,
            'state': stateName,
            'pincode': pincode,
            'is_sndp_member': isSndpMember,
            'sndp_union_name': isSndpMember ? sndpUnionName : null,
            'sndp_branch_number': isSndpMember ? sndpBranchNumber : null,
            'sndp_temple_name': isSndpMember ? sndpTempleName : null,
          })
          .eq('id', user.id);

      return Right(AppUser(id: user.id, email: user.email!));
    } on Exception catch (e) {
      return Left(AuthenticationFailure(message: e.toString()));
    } catch (_) {
      return const Left(
        UnexpectedFailure(message: 'Unexpected sign-up error occurred.'),
      );
    }
  }

  @override
  Future<Either<Failure, AppUser?>> currentUser() async {
    try {
      final user = SupabaseConfig.currentUser;
      if (user == null || user.email == null) {
        return const Right(null);
      }
      return Right(AppUser(id: user.id, email: user.email!));
    } catch (_) {
      return const Left(
        UnexpectedFailure(message: 'Failed to fetch current session.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await SupabaseAuthService.signOut();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(AuthenticationFailure(message: e.toString()));
    } catch (_) {
      return const Left(
        UnexpectedFailure(message: 'Unexpected sign-out error occurred.'),
      );
    }
  }
}
