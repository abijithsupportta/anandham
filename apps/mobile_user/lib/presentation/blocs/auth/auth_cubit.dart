import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/domain/usecases/get_current_user_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_in_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_out_usecase.dart';
import 'package:anandham_user/domain/usecases/sign_up_usecase.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthCubit({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthState.initial());

  Future<void> checkSession() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await _getCurrentUserUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: user != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
          user: user,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await _signInUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> signUp({
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
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await _signUpUseCase(
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
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          errorMessage: null,
        ),
      ),
    );
  }
}
