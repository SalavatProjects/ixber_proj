import 'package:bloc/bloc.dart';
import 'package:ixber_proj/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:ixber_proj/storages/models/user_profile.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({UserProfileState? profile}) : super(profile ?? const UserProfileState());

  void _updateCalories() {
    if (state.gender == AppConstants.genders[0]) {
      emit(state.copyWith(calories: (10 * state.weight +6.25 * (state.height * 100) - 5 + 5).toInt()));
    } else if (state.gender == AppConstants.genders[1]) {
      emit(state.copyWith(calories: (10 * state.weight + 6.25 * (state.height * 100) - 5 - 161).toInt()));
    }
  }

  void updateGoalType(String value) {
    emit(state.copyWith(goalType: value));
  }

  void updateAge(int value) {
    emit(state.copyWith(age: value));
  }

  void updateWeight(double value) {
    emit(state.copyWith(weight: value));
    _updateCalories();
  }

  void updateHeight(double value) {
    emit(state.copyWith(height: value));
    _updateCalories();
  }

  void updateGender(String value) {
    emit(state.copyWith(gender: value));
    _updateCalories();
  }

  void updateFitnessLevel(String value) {
    emit(state.copyWith(fitnessLevel: value));
  }
}
