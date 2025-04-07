import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/ext/int_ext.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc/diet_cubit.dart';
import '../bloc/entity_cubit.dart';
import '../bloc/food_cubit.dart';
import '../ui_kit/widgets/circular_calory_indicator.dart';
import '../ui_kit/widgets/nutrients_card.dart';
import '../ui_kit/widgets/vitamins_card.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final List<String> _periods = ['Yesterday', 'Today', 'Week', 'Month'];
  int _currentPeriod = 1;
  final List<String> _hours = ['8 AM', '10 AM', '12 PM', '2 PM', '4 PM', '6 PM', '8 AM '];

  bool _isDateInCurrentWeek(DateTime date) {
    final now = DateUtils.dateOnly(DateTime.now());
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return !date.isBefore(startOfWeek) && date.isBefore(endOfWeek);
  }

  bool _isDateInCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  List<int> _generateRandomParts(int total, int count) {
    final random = Random();
    final numbers = List<int>.filled(count, 0);
    int remaining = total;

    for (int i = 0; i < count - 1; i++) {
      numbers[i] = 1 + random.nextInt(remaining - (count - i - 1));
      remaining -= numbers[i];
    }
    numbers[count - 1] = remaining;

    numbers.shuffle(); // Для более случайного распределения
    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    return Text('$text ${_periods[_currentPeriod]}', style: AppStyles.quicksandW600Text(28.sp),);
                  },
                ),
                BlocBuilder<EntityCubit, EntityState>(
                builder: (context, state) {
                  return CupertinoButton(
                    onPressed: () async {
                      List<DietState> currentPeriodDiets = [];
                      switch (_currentPeriod) {
                        case 0: currentPeriodDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now().subtract(Duration(days: 1)))).toList();
                        case 1: currentPeriodDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now())).toList();
                        case 2: currentPeriodDiets = state.diets.where((e) => _isDateInCurrentWeek(DateUtils.dateOnly(e.date!))).toList();
                        case 3: currentPeriodDiets = state.diets.where((e) => _isDateInCurrentMonth(DateUtils.dateOnly(e.date!))).toList();
                      }
                      final int totalUserCalories = (state.userProfile.calories) * currentPeriodDiets.map((e) => e.date).toSet().length;
                      int calories = 0;
                      double protein = 0;
                      double carbs = 0;
                      double fat = 0;
                      for (var diet in currentPeriodDiets) {
                        for (var food in diet.foodList) {
                          calories += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).calories);
                          protein += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).protein);
                          carbs += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).carbs);
                          fat += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).fat);
                        }
                      }
                      String calsMeasure = 'kcal';
                      if (state.userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                        calories = calories.toKj();
                        calsMeasure = 'kJ';
                      }
                      await Share.share('''Cals/Protein/Fat/Carbs for ${_periods[_currentPeriod].toLowerCase()}:
  Calories: ${calories.toString()} $calsMeasure
  Protein: ${protein.round().toString()} g
  Fat: ${fat.round().toString()} g
  Carbs: ${carbs.round().toString()} g''');
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                        color: AppColors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/share.svg', width: 18.w, fit: BoxFit.fitWidth,),
                      ),
                    ));
                  },
                )
              ],
            ),
            SizedBox(height: 8.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_periods.length,
                      (int index) =>
                CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _currentPeriod = index;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
                      decoration: _currentPeriod == index ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.primary
                      ) : null,
                      child: Text(_periods[index],
                        style: AppStyles.quicksandW600Text2(14.sp).copyWith(
                            color: _currentPeriod == index ? AppColors.white : AppColors.text2),),
                    )
                )
              ),
            ),
            SizedBox(height: 16.w,),
            BlocBuilder<EntityCubit, EntityState>(
              builder: (context, state) {
                final double myHeight = 286.w;
                List<DietState> currentPeriodDiets = [];
                String title = 'Calories (kcal)';
                String measure = 'g';
                String vitaminMeasure = 'mg';
                switch (_currentPeriod) {
                  case 0: currentPeriodDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now().subtract(Duration(days: 1)))).toList();
                  case 1: currentPeriodDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now())).toList();
                  case 2: currentPeriodDiets = state.diets.where((e) => _isDateInCurrentWeek(DateUtils.dateOnly(e.date!))).toList();
                  case 3: currentPeriodDiets = state.diets.where((e) => _isDateInCurrentMonth(DateUtils.dateOnly(e.date!))).toList();
                }
                int totalUserCalories = (state.userProfile.calories) * currentPeriodDiets.map((e) => e.date).toSet().length;
                int calories = 0;
                double protein = 0;
                double carbs = 0;
                double fat = 0;
                int vitaminC = 0;
                int vitaminA = 0;
                int vitaminD = 0;
                int vitaminB = 0;
                for (var diet in currentPeriodDiets) {
                  for (var food in diet.foodList) {
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
                  totalUserCalories = totalUserCalories.toKj();
                  title = 'Joules (kJ)';

                }
                if (calories > totalUserCalories) {
                  calories = totalUserCalories;
                }
                return SizedBox(
                  height: myHeight,
                  child: currentPeriodDiets.isNotEmpty ?
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularCaloryIndicator(
                            title: title,
                              currentCalory: calories,
                              totalCalory: totalUserCalories),
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
                  )
                      :
                  Center(
                    child: Text('No data for this period yet', style: AppStyles.quicksandW500Text2(14.sp),),
                  ),
                );
              },
            ),
            SizedBox(height: 8.w,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                color: AppColors.white
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recommendations', style: AppStyles.quicksandW500Text2(16.sp),),
                      SvgPicture.asset('assets/icons/star.svg', width: 20.w, fit: BoxFit.fitWidth,),
                    ],
                  ),
                  SizedBox(height: 16.w,),
                  SizedBox(
                    height: 146.w,
                    child: ListView.builder(
                        itemCount: AppConstants.recommendations.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Container(
                          width: 233.w,
                          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.04))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.recommendations[index].$1, style: AppStyles.quicksandW600Text(18.sp),),
                                  CupertinoButton(
                                      onPressed: () async {
                                        if (!await launchUrl(Uri.parse('https://www.google.com/'))) {
                                          throw Exception('Could not launch url!');
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        width: 38.w,
                                        height: 38.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.24))
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset('assets/icons/right_up.svg', width: 22.w, fit: BoxFit.fitWidth,),
                                        ),
                                      )
                                  )
                                ],
                              ),
                              SizedBox(height: 8.w,),
                              Text(AppConstants.recommendations[index].$2,
                                style: AppStyles.quicksandW500Text2(16.sp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              )
                            ],
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.w,),
            BlocBuilder<EntityCubit, EntityState>(
            builder: (context, state) {
              List<DietState> currentPeriodDiets = [];
              switch (_currentPeriod) {
                case 0: currentPeriodDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now().subtract(Duration(days: 1)))).toList();
                case 1: currentPeriodDiets = state.diets.where((e) => DateUtils.dateOnly(e.date!) == DateUtils.dateOnly(DateTime.now())).toList();
                case 2: currentPeriodDiets = state.diets.where((e) => _isDateInCurrentWeek(DateUtils.dateOnly(e.date!))).toList();
                case 3: currentPeriodDiets = state.diets.where((e) => _isDateInCurrentMonth(DateUtils.dateOnly(e.date!))).toList();
              }
              final int totalUserCalories = (state.userProfile.calories) * currentPeriodDiets.map((e) => e.date).toSet().length;
              int eatedCalories = 0;
              for (var diet in currentPeriodDiets) {
                for (var food in diet.foodList) {
                  eatedCalories += (state.foods.firstWhere((e) => e.name == food, orElse: () => FoodState()).calories);
                }
              }
              if (eatedCalories > totalUserCalories) {
                eatedCalories = totalUserCalories;
              }
              int caloriesBurned = totalUserCalories - eatedCalories;
              final List<int> burnedCaloriesByHours = caloriesBurned > 50 ? _generateRandomParts(caloriesBurned, _hours.length) : [];
              int caloriesBurnedForText = caloriesBurned;
              String measure = 'kcal';
              if (state.userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                caloriesBurnedForText = caloriesBurnedForText.toKj();
                measure = 'kJ';
              }
              return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                color: AppColors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calorie burning', style: AppStyles.quicksandW500Text2(16.sp),),
                      SvgPicture.asset('assets/icons/calorie_burning.svg', width: 16.w, fit: BoxFit.fitWidth,)
                    ],
                  ),
                  SizedBox(height: 16.w,),
                  RichText(
                      text: TextSpan(
                        text: caloriesBurnedForText.toString(),
                        style: AppStyles.quicksandW600Text(24.sp),
                        children: [
                          TextSpan(
                            text: ' $measure',
                            style: AppStyles.quicksandW600Text2(24.sp)
                          )
                        ]
                      )
                  ),
                  SizedBox(height: 8.w,),
                  burnedCaloriesByHours.isNotEmpty ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        _hours.length,
                            (int index) =>
                      _CaloriesMeasureColumn(
                          totalCalory: caloriesBurned,
                          currentCalory: burnedCaloriesByHours[index],
                          text: _hours[index],
                    ),
                  ),
                  ) :
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40.w,
                        child: Center(
                          child: Text('No data for this period yet', style: AppStyles.quicksandW500Text2(14.sp),),
                        ),
                      )
                ],
              ),
            );
              },
            ),
            SizedBox(height: 90.w,)
          ],
        ),
    ),
    );
  }
}

class _CaloriesMeasureColumn extends StatelessWidget {
  int totalCalory;
  int currentCalory;
  String text;

  _CaloriesMeasureColumn({
    super.key,
    required this.totalCalory,
    required this.currentCalory,
    required this.text,
  });

  final double _columnHeight = 120.w;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.w,),
        SizedBox(
          width: 8.w,
          height: _columnHeight,
          child: Stack(
            children: [
               Container(
                 height: _columnHeight,
                 width: 8.w,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4.r),
                   color: AppColors.primary.withValues(alpha: 0.15)
                 ),
               ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: _columnHeight * (currentCalory / totalCalory),
                  width: 8.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: AppColors.primary
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(text, style: AppStyles.quicksandW500Text2(14.sp),)
      ],
    );
  }
}
