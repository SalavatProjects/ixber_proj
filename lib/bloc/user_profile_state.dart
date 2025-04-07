part of 'user_profile_cubit.dart';

class UserProfileState extends Equatable {
  const UserProfileState({
    this.id,
    this.goalType = '',
    this.age = 0,
    this.weight = 0,
    this.height = 0,
    this.gender = '',
    this.calories = 0,
    this.fitnessLevel = '',
    this.foodEnergyUnit = '',
  });

  final int? id;
  final String goalType;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final int calories;
  final String fitnessLevel;
  final String foodEnergyUnit;

  factory UserProfileState.fromIsarModel(UserProfile userProfile) {
    return UserProfileState(
      id: userProfile.id,
      goalType: userProfile.goalType ?? '',
      age: userProfile.age ?? 0,
      weight: userProfile.weight ?? 0,
      height: userProfile.height ?? 0,
      gender: userProfile.gender ?? '',
      calories: userProfile.calories ?? 0,
      fitnessLevel: userProfile.fitnessLevel ?? '',
      foodEnergyUnit: userProfile.foodEnergyUnit ?? '',
    );
  }

  @override
  List<Object?> get props => [id, goalType, age, weight, height, gender, calories, fitnessLevel, foodEnergyUnit];

  UserProfileState copyWith({
    int? id,
    String? goalType,
    int? age,
    double? weight,
    double? height,
    String? gender,
    int? calories,
    String? fitnessLevel,
    String? foodEnergyUnit,
  }) {
    return UserProfileState(
      id: id ?? this.id,
      goalType: goalType ?? this.goalType,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      calories: calories ?? this.calories,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      foodEnergyUnit: foodEnergyUnit ?? this.foodEnergyUnit,
    );
  }

  UserProfile toIsarModel() {
    return UserProfile()
      ..goalType = goalType
      ..age = age
      ..weight = weight
      ..height = height
      ..gender = gender
      ..calories = calories
      ..fitnessLevel = fitnessLevel
      ..foodEnergyUnit = foodEnergyUnit;
  }
}
