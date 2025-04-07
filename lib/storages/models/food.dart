import 'package:isar/isar.dart';

part 'food.g.dart';

@collection
class Food {
  Id id = Isar.autoIncrement;

  String? name;
  int? calories;
  double? protein;
  double? carbs;
  double? fat;
}