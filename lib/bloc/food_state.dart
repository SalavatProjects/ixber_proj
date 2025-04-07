part of 'food_cubit.dart';

class FoodState extends Equatable {
  const FoodState({
    this.id,
    this.name = '',
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.C = 0,
    this.A = 0,
    this.D = 0,
    this.B = 0,
  });

  final int? id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int C;
  final int A;
  final int D;
  final int B;

  factory FoodState.fromIsarModel(Food food) {
    return FoodState(
      id: food.id,
      name: food.name ?? '',
      calories: food.calories ?? 0,
      protein: food.protein ?? 0,
      carbs: food.carbs ?? 0,
      fat: food.fat ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, calories, protein, carbs, fat, C, A, D, B];

  FoodState copyWith({
    int? id,
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    int? C,
    int? A,
    int? D,
    int? B,
  }) {
    return FoodState(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      C: C ?? this.C,
      A: A ?? this.A,
      D: D ?? this.D,
      B: B ?? this.B,
    );
  }

  Food toIsarModel() {
    return Food()
      ..name = name
      ..calories = calories
      ..protein = protein
      ..carbs = carbs
      ..fat = fat;
  }
}
