part of 'diet_cubit.dart';

class DietState extends Equatable {
  const DietState({
    this.id,
    this.foodList = const [],
    this.type = '',
    this.date,
  });

  final int? id;
  final List<String> foodList;
  final String type;
  final DateTime? date;

  factory DietState.fromIsarModel(Diet diet) {
    return DietState(
      id: diet.id,
      foodList: diet.foodList ?? const [],
      type: diet.type ?? '',
      date: diet.date,
    );
  }

  @override
  List<Object?> get props => [id, foodList, type, date];

  DietState copyWith({
    int? id,
    List<String>? foodList,
    String? type,
    DateTime? date,
  }) {
    return DietState(
      id: id ?? this.id,
      foodList: foodList ?? this.foodList,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }

  Diet toIsarModel() {
    return Diet()
      ..foodList = foodList
      ..type = type
      ..date = date;
  }
}
