import 'package:dartz/dartz.dart';
import 'package:anandham_core/anandham_core.dart';
import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/entities/app_user.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  bool _isNetworkError(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('socketexception') ||
        normalized.contains('failed host lookup') ||
        normalized.contains('network is unreachable') ||
        normalized.contains('connection closed') ||
        normalized.contains('timed out') ||
        normalized.contains('network request failed');
  }

  String _mapAuthErrorMessage(Object error, {required String action}) {
    final message = error.toString();
    final normalized = message.toLowerCase();

    if (_isNetworkError(message)) {
      if (action == 'signOut') {
        return 'No internet connection. Unable to sign out right now.';
      }
      return 'No internet connection. Please check your network and try again.';
    }

    if (normalized.contains('invalid login credentials')) {
      return 'Incorrect email or password. Please try again.';
    }

    if (normalized.contains('email not confirmed') ||
        normalized.contains('email not verified')) {
      return 'Please verify your email and then sign in.';
    }

    if (normalized.contains('user already registered') ||
        normalized.contains('already been registered')) {
      return 'An account with this email already exists. Please sign in.';
    }

    if (normalized.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }

    if (normalized.contains('password should be at least')) {
      return 'Password is too short. Use at least 6 characters.';
    }

    if (error is AuthException && error.message.trim().isNotEmpty) {
      return error.message.trim();
    }

    switch (action) {
      case 'signIn':
        return 'Unable to sign in. Please try again.';
      case 'signUp':
        return 'Unable to create account. Please try again.';
      case 'signOut':
        return 'Unable to sign out. Please try again.';
      default:
        return 'Authentication error occurred. Please try again.';
    }
  }

  Future<void> _updateProfileSafe(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    if (payload.isEmpty) {
      return;
    }

    try {
      await SupabaseConfig.client
          .from('profiles')
          .update(payload)
          .eq('id', userId);
      return;
    } catch (_) {
      final fallback = <String, dynamic>{};
      if (payload['full_name'] != null) {
        fallback['full_name'] = payload['full_name'];
      }
      if (fallback.isEmpty) {
        return;
      }
      await SupabaseConfig.client
          .from('profiles')
          .update(fallback)
          .eq('id', userId);
    }
  }

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
      return Left(
        AuthenticationFailure(
          message: _mapAuthErrorMessage(e, action: 'signIn'),
        ),
      );
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
          'full_name': fullName,
          if (trimmedPhone != null && trimmedPhone.isNotEmpty)
            'phone_country_code': phoneCountryCode,
          if (trimmedPhone != null && trimmedPhone.isNotEmpty)
            'phone_number': trimmedPhone,
          if (trimmedAddress != null && trimmedAddress.isNotEmpty)
            'address': trimmedAddress,
          if (trimmedHouse != null && trimmedHouse.isNotEmpty)
            'house_name': trimmedHouse,
          if (trimmedCity != null && trimmedCity.isNotEmpty)
            'city': trimmedCity,
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
          AuthenticationFailure(
            message:
                'Account created successfully. Please verify your email before signing in.',
          ),
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

      try {
        await _updateProfileSafe(user.id, updatePayload);
      } catch (_) {}

      return Right(AppUser(id: user.id, email: user.email!));
    } on Exception catch (e) {
      return Left(
        AuthenticationFailure(
          message: _mapAuthErrorMessage(e, action: 'signUp'),
        ),
      );
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
      return Left(
        AuthenticationFailure(
          message: _mapAuthErrorMessage(e, action: 'signOut'),
        ),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure(message: 'Unexpected sign-out error occurred.'),
      );
    }
  }
}
