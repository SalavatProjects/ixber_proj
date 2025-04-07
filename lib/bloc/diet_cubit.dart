import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../storages/models/diet.dart';

part 'diet_state.dart';

class DietCubit extends Cubit<DietState> {
  DietCubit({DietState? diet}) : super(diet ?? const DietState());

  /*void updateFoodList(String value) {
    emit(state.copyWith(foodList: value));
  }*/

  void addFood(String value) {
    emit(state.copyWith(foodList: List.from(state.foodList)..add(value)));
  }

  void removeFood(String value) {
    emit(state.copyWith(foodList: List.from(state.foodList)..remove(value)));
  }

  void updateType(String value) {
    emit(state.copyWith(type: value));
  }

  void updateDate(DateTime value) {
    emit(state.copyWith(date: value));
  }

  void clearData() {
    emit(const DietState());
  }
}
