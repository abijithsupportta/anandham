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
  }) async {
    try {
      final trimmedPhone = phoneNumber?.trim();
      final trimmedAddress = address?.trim();
      final trimmedHouse = houseName?.trim();
      final trimmedCity = city?.trim();
      final trimmedState = stateName?.trim();
      final trimmedPincode = pincode?.trim();

      final response = await SupabaseAuthService.signUp(
        email: email,
        password: password,
        data: {
          'role': 'customer',
          'full_name': fullName,
          if (trimmedPhone != null && trimmedPhone.isNotEmpty)
            'phone_country_code': phoneCountryCode,
          if (trimmedPhone != null && trimmedPhone.isNotEmpty)
            'phone_number': trimmedPhone,
          if (trimmedAddress != null && trimmedAddress.isNotEmpty)
            'address': trimmedAddress,
          if (trimmedHouse != null && trimmedHouse.isNotEmpty)
            'house_name': trimmedHouse,
          if (trimmedCity != null && trimmedCity.isNotEmpty) 'city': trimmedCity,
          if (trimmedState != null && trimmedState.isNotEmpty)
            'state': trimmedState,
          if (trimmedPincode != null && trimmedPincode.isNotEmpty)
            'pincode': trimmedPincode,
          'is_sndp_member': isSndpMember,
          if (isSndpMember && sndpUnionName != null)
            'sndp_union_name': sndpUnionName,
          if (isSndpMember && sndpBranchNumber != null)
            'sndp_branch_number': sndpBranchNumber,
          if (isSndpMember && sndpTempleName != null)
            'sndp_temple_name': sndpTempleName,
        },
      );
      final user = response.user;
      if (user == null || user.email == null) {
        return const Left(
          AuthenticationFailure(message: 'Account created. Verify your email.'),
        );
      }

      final updatePayload = <String, dynamic>{
        'full_name': fullName,
        'is_sndp_member': isSndpMember,
      };

      if (trimmedPhone != null && trimmedPhone.isNotEmpty) {
        updatePayload['phone_country_code'] = phoneCountryCode;
        updatePayload['phone_number'] = trimmedPhone;
      }
      if (trimmedAddress != null && trimmedAddress.isNotEmpty) {
        updatePayload['address'] = trimmedAddress;
      }
      if (trimmedHouse != null && trimmedHouse.isNotEmpty) {
        updatePayload['house_name'] = trimmedHouse;
      }
      if (trimmedCity != null && trimmedCity.isNotEmpty) {
        updatePayload['city'] = trimmedCity;
      }
      if (trimmedState != null && trimmedState.isNotEmpty) {
        updatePayload['state'] = trimmedState;
      }
      if (trimmedPincode != null && trimmedPincode.isNotEmpty) {
        updatePayload['pincode'] = trimmedPincode;
      }
      if (isSndpMember && sndpUnionName != null) {
        updatePayload['sndp_union_name'] = sndpUnionName;
      }
      if (isSndpMember && sndpBranchNumber != null) {
        updatePayload['sndp_branch_number'] = sndpBranchNumber;
      }
      if (isSndpMember && sndpTempleName != null) {
        updatePayload['sndp_temple_name'] = sndpTempleName;
      }

      await SupabaseConfig.client
          .from('profiles')
          .update(updatePayload)
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
