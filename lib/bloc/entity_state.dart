part of 'entity_cubit.dart';

class EntityState extends Equatable {
  const EntityState({
    this.userProfile = const UserProfileState(),
    this.diets = const [],
    this.foods = const [],
  });


  final UserProfileState userProfile;
  final List<DietState> diets;
  final List<FoodState> foods;

  @override
  // TODO: implement props
  List<Object?> get props => [userProfile, diets, foods];

  EntityState copyWith({
    UserProfileState? userProfile,
    List<DietState>? diets,
    List<FoodState>? foods,
  }) {
    return EntityState(
      userProfile: userProfile ?? this.userProfile,
      diets: diets ?? this.diets,
      foods: foods ?? this.foods
    );
  }
}
