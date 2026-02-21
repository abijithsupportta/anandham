import 'package:anandham_user/core/di/injection_container.dart';
import 'package:anandham_user/domain/usecases/get_home_content_types_usecase.dart';
import 'package:anandham_user/domain/usecases/get_profile_name_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProfileNameUseCase _getProfileNameUseCase;
  final GetHomeContentTypesUseCase _getHomeContentTypesUseCase;

  HomeCubit({
    GetProfileNameUseCase? getProfileNameUseCase,
    GetHomeContentTypesUseCase? getHomeContentTypesUseCase,
  }) : _getProfileNameUseCase =
           getProfileNameUseCase ?? sl<GetProfileNameUseCase>(),
       _getHomeContentTypesUseCase =
           getHomeContentTypesUseCase ?? sl<GetHomeContentTypesUseCase>(),
       super(const HomeState.initial());

  Future<void> loadHome() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final profileName = await _getProfileNameUseCase();
      final contentTypes = await _getHomeContentTypesUseCase();
      emit(
        state.copyWith(
          isLoading: false,
          profileName: profileName,
          contentTypes: contentTypes,
          errorMessage: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load home content',
        ),
      );
    }
  }
}
