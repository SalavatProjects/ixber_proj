import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  String? goalType;
  int? calories;
  int? age;
  double? weight;
  double? height;
  String? gender;
  String? fitnessLevel;
  String? foodEnergyUnit;
}