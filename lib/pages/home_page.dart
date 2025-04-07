import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/bloc/diet_cubit.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/ext/int_ext.dart';
import 'package:ixber_proj/pages/food_screen.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/ui_kit/widgets/circular_calory_indicator.dart';
import 'package:ixber_proj/ui_kit/widgets/nutrients_card.dart';
import 'package:ixber_proj/ui_kit/widgets/vitamins_card.dart';
import 'package:ixber_proj/utils/constants.dart';
import 'package:intl/intl.dart';

import '../bloc/entity_cubit.dart';
import '../bloc/food_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  bool _isDateInCurrentWeek(DateTime date) {
    final now = DateUtils.dateOnly(DateTime.now());
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek);
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<EntityCubit, EntityState, UserProfileState>(
              selector: (state) => state.userProfile,
              builder: (context, userProfile) {
                String text = '';
                if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[0]) {
                  text = 'Calories';
                } else if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                  text = 'Joules';
                }
                return Text('$text Today', style: AppStyles.quicksandW600Text(28.sp),);
              },
            ),
            SizedBox(height: 24.w,),
            BlocSelector<EntityCubit, EntityState, List<DietState>>(
              selector: (state) => state.diets,
              builder: (context, diets) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(AppConstants.weekDays.length, 
                          (int index) {
                            // bool isCurrentWeekDay = diets.any((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now()));
                            bool isDietExist = diets.any((e) => (_isDateInCurrentWeek(e.date!) && e.date!.weekday - 1 == index));
                            return Column(
                              children: [
                                Text(
                                  AppConstants.weekDays[index],
                                  style: AppStyles.quicksandW500Text2(16.sp),
                                ),
                                SizedBox(height: 8.w,),
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: DateTime.now().weekday - 1 == index ?
                                    Border.all(width: 2, color: AppColors.primary)
                                        : Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.04)),
                                    color: AppColors.blueLight2
                                  ),
                                  child: isDietExist ?
                                      Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/mark_2.svg',
                                          width: 18.w,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )
                                      : SizedBox.shrink(),
                                )
                              ],
                            );
                          }),
                );
              },
            ),
            SizedBox(height: 16.w,),
            BlocBuilder<EntityCubit, EntityState>(
            builder: (context, state) {
              final double myHeight = 286.w;
              int userCalories = state.userProfile.calories;
              String title = 'Calories (kcal)';
              String measure = 'g';
              String vitaminMeasure = 'mg';
              List<DietState> currentDayDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now())).toList();
              if (currentDayDiets.isNotEmpty) {
                int calories = 0;
                double protein = 0;
                double carbs = 0;
                double fat = 0;
                int vitaminC = 0;
                int vitaminA = 0;
                int vitaminD = 0;
                int vitaminB = 0;
                for (var dietByType in currentDayDiets) {
                  for (var food in dietByType.foodList) {
                    calories += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).calories);
                    protein += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).protein);
                    carbs += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).carbs);
                    fat += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).fat);
                    vitaminC += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).C);
                    vitaminA += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).A);
                    vitaminD += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).D);
                    vitaminB += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).B);
                  }
                }
                if (state.userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                  calories = calories.toKj();
                  userCalories = userCalories.toKj();
                  title = 'Joules (kJ)';
                }
                if (calories > userCalories) {
                  calories = userCalories;
                }
                return SizedBox(
                  height: myHeight,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularCaloryIndicator(
                            title: title,
                              currentCalory: calories,
                              totalCalory: userCalories),
                          NutrientsCard(
                            measure: measure,
                              proteinWeightGr: protein,
                              carbsWeightGr: carbs,
                              fatWeightGr: fat)
                        ],
                      ),
                      SizedBox(height: 8.w,),
                      VitaminsCard(
                        measure: vitaminMeasure,
                        vitaminCMg: vitaminC,
                        vitaminAMg: vitaminA,
                        vitaminDMg: vitaminD,
                        vitaminBMg: vitaminB,)
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: myHeight,
                  child: Center(
                    child: Text('No data for this day yet', style: AppStyles.quicksandW500Text2(14.sp),),
                  ),
                );
              }
            },
          ),
            BlocBuilder<EntityCubit, EntityState>(
              builder: (context, state) {
                String measure = 'kcal';
                return Column(
                          children: List.generate(
                              AppConstants.dietTypes.length,
                                  (int index) {
                                final DietState? currentDiet = state.diets.firstWhereOrNull((e) => (
                                DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now())
                                    && e.type == AppConstants.dietTypes[index].$1
                                ));
                                int calories = currentDiet?.foodList.map((item) => AppConstants.productsCompositionFor100g[item]!.$1).sum ?? 0;
                                if (state.userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                                  calories = calories.toKj();
                                  measure = 'kJ';
                                }
                                return _DietTypeCard(
                                      name: AppConstants.dietTypes[index].$1,
                                      measure: measure,
                                      iconPath: AppConstants.dietTypes[index].$2,
                                      color: AppConstants.dietTypes[index].$3,
                                      kcal: calories,
                                      onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (BuildContext context) => 
                                            BlocProvider(
                                              create: (context) => DietCubit(diet: currentDiet),
                                              child: FoodScreen(dietType: AppConstants.dietTypes[index].$1,),
                                            ))
                                      ));
                              }
                          ),
                        );
              },
            ),
            BlocBuilder<EntityCubit, EntityState>(
                builder: (context, state) {
                  final List<DietState> currentDayDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now())).toList();
                  int totalFoodCalories = 0;
                  for (var diet in currentDayDiets) {
                    totalFoodCalories += diet.foodList.map((e) => AppConstants.productsCompositionFor100g[e]!.$1).sum;
                  }
                  int userCalories = state.userProfile.calories;
                  String text = 'Calories';
                  if (state.userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                    totalFoodCalories = totalFoodCalories.toKj();
                    userCalories = userCalories.toKj();
                    text = 'Joules';
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.greenLight.withValues(alpha: 0.15)
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/workout.svg', 
                                  width: 22.w, 
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(AppColors.greenLight, BlendMode.srcIn),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w,),
                            Text('$text burned', style: AppStyles.quicksandW500Text2(18.sp),)
                          ],
                        ),
                        Text(
                          ((userCalories - totalFoodCalories) < 0 ? 0 :
                            userCalories - totalFoodCalories
                          ).toString(),
                          style: AppStyles.quicksandW500Text(20.sp).copyWith(color: AppColors.greenLight),
                        )
                      ],
                    ),
                  );
                },
              ),
            SizedBox(height: 90.w,),
          ],
        ),
      ),
    );
  }
}

class _DietTypeCard extends StatelessWidget {
  String name;
  String measure;
  String iconPath;
  Color color;
  int kcal;
  void Function() onPressed;

  _DietTypeCard({
    super.key,
    required this.name,
    required this.measure,
    required this.iconPath,
    required this.color,
    required this.kcal,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.15)
                  ),
                  child: Center(
                    child: SvgPicture.asset(iconPath, width: 22.w, fit: BoxFit.fitWidth,),
                  ),
                ),
                SizedBox(width: 12.w,),
                Text(name, style: AppStyles.quicksandW500Text2(18.sp),)
              ],
            ),
            Row(
              children: [
                RichText(text: TextSpan(
                  text: kcal.toString(),
                  style: AppStyles.quicksandW500Text(16.sp),
                  children: [
                    TextSpan(
                      text: ' $measure',
                      style: AppStyles.quicksandW500Text2(16.sp)
                    )
                  ]
                )
                ),
                SizedBox(width: 12.w,),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onPressed,
                  child: SizedBox(
                    width: 34.w,
                    height: 34.w,
                    child: Center(
                        child: SvgPicture.asset('assets/icons/plus.svg', width: 20.w, fit: BoxFit.fitWidth,)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
