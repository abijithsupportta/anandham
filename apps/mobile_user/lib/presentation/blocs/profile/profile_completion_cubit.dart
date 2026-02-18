import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_core/anandham_core.dart';
import 'profile_completion_state.dart';

class ProfileCompletionCubit extends Cubit<ProfileCompletionState> {
  ProfileCompletionCubit() : super(const ProfileCompletionState.initial());

  // Fields that determine profile completion
  static const List<String> _requiredFields = [
    'full_name',
    'phone_number',
    'phone_country_code',
    'house_name',
    'address',
    'city',
    'state',
    'pincode',
  ];

  Future<void> loadProfileCompletion() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Please sign in to view profile',
          ),
        );
        return;
      }

      final rows = await SupabaseConfig.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .limit(1);

      if (rows.isEmpty) {
        emit(
          state.copyWith(
            isLoading: false,
            completionPercentage: 0.0,
            missingFields: _requiredFields,
          ),
        );
        return;
      }

      final profileData = Map<String, dynamic>.from(rows.first);
      final missingFields = _calculateMissingFields(profileData);
      final completionPercentage = _calculateCompletion(profileData);

      emit(
        state.copyWith(
          isLoading: false,
          profileData: profileData,
          completionPercentage: completionPercentage,
          missingFields: missingFields,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load profile: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneCountryCode,
    String? phoneNumber,
    String? houseName,
    String? address,
    String? city,
    String? stateName,
    String? pincode,
    bool? isSndpMember,
    String? sndpUnionName,
    String? sndpBranchNumber,
    String? sndpTempleName,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = SupabaseConfig.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Please sign in to update profile',
          ),
        );
        return;
      }

      final updateData = <String, dynamic>{};

      if (fullName != null) {
        updateData['full_name'] = fullName;
      }
      if (phoneCountryCode != null) {
        updateData['phone_country_code'] = phoneCountryCode;
      }
      if (phoneNumber != null) {
        updateData['phone_number'] = phoneNumber;
      }
      if (houseName != null) {
        updateData['house_name'] = houseName;
      }
      if (address != null) {
        updateData['address'] = address;
      }
      if (city != null) {
        updateData['city'] = city;
      }
      if (stateName != null) {
        updateData['state'] = stateName;
      }
      if (pincode != null) {
        updateData['pincode'] = pincode;
      }
      if (isSndpMember != null) {
        updateData['is_sndp_member'] = isSndpMember;
      }
      if (sndpUnionName != null) {
        updateData['sndp_union_name'] = sndpUnionName;
      }
      if (sndpBranchNumber != null) {
        updateData['sndp_branch_number'] = sndpBranchNumber;
      }
      if (sndpTempleName != null) {
        updateData['sndp_temple_name'] = sndpTempleName;
      }

      await SupabaseConfig.client
          .from('profiles')
          .update(updateData)
          .eq('id', user.id);

      await loadProfileCompletion();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update profile: ${e.toString()}',
        ),
      );
    }
  }

  List<String> _calculateMissingFields(Map<String, dynamic> profileData) {
    final missing = <String>[];

    for (final field in _requiredFields) {
      final value = profileData[field];
      if (value == null || (value is String && value.trim().isEmpty)) {
        missing.add(field);
      }
    }

    return missing;
  }

  double _calculateCompletion(Map<String, dynamic> profileData) {
    final missingCount = _calculateMissingFields(profileData).length;
    final completedCount = _requiredFields.length - missingCount;
    return (completedCount / _requiredFields.length) * 100;
  }
}
