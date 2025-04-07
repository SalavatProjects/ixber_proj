import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../storages/models/food.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit({FoodState? food}) : super(food ?? const FoodState());

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateCalories(int value) {
    emit(state.copyWith(calories: value));
  }

  void updateProtein(double value) {
    emit(state.copyWith(protein: value));
  }

  void updateCarbs(double value) {
    emit(state.copyWith(carbs: value));
  }

  void updateFat(double value) {
    emit(state.copyWith(fat: value));
  }

  /*void updateC(int value) {
    emit(state.copyWith(C: value));
  }

  void updateA(int value) {
    emit(state.copyWith(A: value));
  }

  void updateD(int value) {
    emit(state.copyWith(D: value));
  }

  void updateB(int value) {
    emit(state.copyWith(B: value));
  }*/

}
