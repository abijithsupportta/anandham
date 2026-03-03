import 'package:anandham_user/core/errors/failures.dart';
import 'package:anandham_user/domain/entities/app_user.dart';
import 'package:anandham_user/domain/repositories/auth_repository.dart';
import 'package:anandham_user/domain/usecases/get_current_user_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_in_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_out_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_up_usecase.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  Either<Failure, AppUser> signInResult = Right(
    const AppUser(id: 'u1', email: 'user@example.com'),
  );
  Either<Failure, AppUser> signUpResult = Right(
    const AppUser(id: 'u1', email: 'user@example.com'),
  );
  Either<Failure, AppUser?> currentUserResult = const Right(null);
  Either<Failure, Unit> signOutResult = const Right(unit);

  @override
  Future<Either<Failure, AppUser?>> currentUser() async => currentUserResult;

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    return signInResult;
  }

  @override
  Future<Either<Failure, Unit>> signOut() async => signOutResult;

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
    return signUpResult;
  }
}

void main() {
  group('AuthCubit', () {
    late _FakeAuthRepository fakeRepository;
    late AuthCubit cubit;

    setUp(() {
      fakeRepository = _FakeAuthRepository();
      cubit = AuthCubit(
        signInUseCase: SignInUseCase(fakeRepository),
        signUpUseCase: SignUpUseCase(fakeRepository),
        signOutUseCase: SignOutUseCase(fakeRepository),
        getCurrentUserUseCase: GetCurrentUserUseCase(fakeRepository),
      );
    });

    test('signIn sets authenticated state on success', () async {
      await cubit.signIn(email: 'user@example.com', password: 'secret123');

      expect(cubit.state.status, AuthStatus.authenticated);
      expect(cubit.state.user?.email, 'user@example.com');
      expect(cubit.state.errorMessage, isNull);
    });

    test(
      'checkSession sets unauthenticated state when no current user',
      () async {
        fakeRepository.currentUserResult = const Right(null);

        await cubit.checkSession();

        expect(cubit.state.status, AuthStatus.unauthenticated);
        expect(cubit.state.user, isNull);
      },
    );
  });
}
