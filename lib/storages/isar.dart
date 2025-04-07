import 'package:isar/isar.dart';
import 'package:ixber_proj/storages/models/diet.dart';
import 'models/food.dart';
import 'models/user_profile.dart';
import 'package:path_provider/path_provider.dart';

abstract class AppIsarDatabase {
  static late final Isar _instance;

  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    return _instance = await Isar.open(
        [UserProfileSchema, FoodSchema, DietSchema],
        directory: dir.path);
  }

  static Future<UserProfile?> getUserProfile() async {
    return await _instance.writeTxn(
        () async => await _instance.userProfiles.where().findFirst()
    );
  }

  static Future<void> createUserProfile(UserProfile userProfile) async {
    await _instance.writeTxn(() async => await _instance.userProfiles.put(userProfile));
  }

  static Future<void> updateUserProfile(UserProfile newUserProfile) async {
    await _instance.writeTxn(() async {
      final userProfile = await _instance.userProfiles.where().findFirst();
      if (userProfile != null) {
        userProfile
          ..goalType = newUserProfile.goalType
          ..age = newUserProfile.age
          ..weight = newUserProfile.weight
          ..height = newUserProfile.height
          ..gender = newUserProfile.gender
          ..calories = newUserProfile.calories
          ..fitnessLevel = newUserProfile.fitnessLevel
          ..foodEnergyUnit = newUserProfile.foodEnergyUnit;
        return await _instance.userProfiles.put(userProfile);
      }
    });
  }

  static Future<List<Diet>> getDiets() async {
    return await _instance.writeTxn(
        () async => await _instance.diets.where().findAll(),
    );
  }

  static Future<void> addDiet(Diet diet) async {
    await _instance.writeTxn(() async => await _instance.diets.put(diet));
  }

  static Future<void> updateDiet(int id, Diet newDiet) async {
    await _instance.writeTxn(() async {
      final diet = await _instance.diets.get(id);
      if (diet != null) {
        diet
          ..foodList = newDiet.foodList
          ..type = newDiet.type
          ..date = newDiet.date;
        return await _instance.diets.put(diet);
      }
    });
  }

  static Future<void> removeDiet(int id) async {
    await _instance.writeTxn(() async => await _instance.diets.delete(id));
  }

  static Future<List<Food>> getFoods() async {
    return await _instance.writeTxn(
        () async => await _instance.foods.where().findAll(),
    );
  }

  static Future<void> addFood(Food food) async {
    await _instance.writeTxn(() async => await _instance.foods.put(food));
  }
}