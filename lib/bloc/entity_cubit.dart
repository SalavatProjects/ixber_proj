import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ixber_proj/bloc/diet_cubit.dart';
import 'package:ixber_proj/bloc/food_cubit.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/storages/isar.dart';
import 'package:ixber_proj/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

part 'entity_state.dart';

class EntityCubit extends Cubit<EntityState> {
  EntityCubit() : super(const EntityState());

  Future<void> getUserProfile() async {
    if (await AppIsarDatabase.getUserProfile() == null) {
      await _createUserProfile(UserProfileState().copyWith(
        goalType: AppConstants.goalTypes[0],
        gender: AppConstants.genders[0],
        calories: AppConstants.defaultCalories,
        fitnessLevel: AppConstants.fitnessLevels[0].$1,
        foodEnergyUnit: AppConstants.foodEnergyUnits[0],
      ));
    }
    final userProfile = await AppIsarDatabase.getUserProfile();
    emit(state.copyWith(userProfile: userProfile != null ? UserProfileState.fromIsarModel(userProfile) : UserProfileState()));
  }

  Future<void> getDiets() async {
    final diets = await AppIsarDatabase.getDiets();
    emit(state.copyWith(diets: diets.map((e) => DietState.fromIsarModel(e)).toList()));
  }

  Future<void> getFoods() async {
    List<FoodState> constantFoods = [];
      for (var food in AppConstants.products) {
        constantFoods.add(FoodState(
          name: food,
          calories: AppConstants.productsCompositionFor100g[food]!.$1,
          protein: AppConstants.productsCompositionFor100g[food]!.$2,
          carbs: AppConstants.productsCompositionFor100g[food]!.$3,
          fat: AppConstants.productsCompositionFor100g[food]!.$4,
          C: AppConstants.productsCompositionFor100g[food]!.$5,
          A: AppConstants.productsCompositionFor100g[food]!.$6,
          D: AppConstants.productsCompositionFor100g[food]!.$7,
          B: AppConstants.productsCompositionFor100g[food]!.$8
        ));
      }

    final foods = await AppIsarDatabase.getFoods();
    emit(state.copyWith(foods: (constantFoods + foods.map((e) => FoodState.fromIsarModel(e)).toList()).sorted((a,b) => a.name.compareTo(b.name))));
  }

  Future<void> _createUserProfile(UserProfileState userProfile) async {
    await AppIsarDatabase.createUserProfile(userProfile.toIsarModel());
    await getUserProfile();
  }

  Future<void> updateUserProfile(UserProfileState userProfile) async {
    await AppIsarDatabase.updateUserProfile(userProfile.toIsarModel());
    await getUserProfile();
  }

  Future<void> addDiet(DietState diet) async {
    await AppIsarDatabase.addDiet(diet.toIsarModel());
    await getDiets();
  }

  Future<void> updateDiet(int id, DietState diet) async {
    await AppIsarDatabase.updateDiet(id, diet.toIsarModel());
    await getDiets();
  }

  Future<void> removeDiet(int id) async {
    await AppIsarDatabase.removeDiet(id);
    await getDiets();
  }

  Future<void> addFood(FoodState food) async {
    await AppIsarDatabase.addFood(food.toIsarModel());
    await getFoods();
  }
}
