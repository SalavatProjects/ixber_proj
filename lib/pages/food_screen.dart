import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/bloc/entity_cubit.dart';
import 'package:ixber_proj/ext/int_ext.dart';
import 'package:ixber_proj/pages/add_food_screen.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/ui_kit/widgets/back_btn.dart';
import 'package:ixber_proj/utils/constants.dart';

import '../bloc/diet_cubit.dart';
import '../bloc/food_cubit.dart';

class FoodScreen extends StatefulWidget {
  String dietType;

  FoodScreen({
    super.key,
    required this.dietType,
  });

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final TextEditingController _searchEditingController = TextEditingController();
  List<FoodState> _currentFoods = [];

  @override
  void initState() {
    super.initState();
    context.read<DietCubit>().updateDate(DateUtils.dateOnly(DateTime.now()));
    context.read<DietCubit>().updateType(widget.dietType);
  }

  @override
  void dispose() {
    super.dispose();
    _searchEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DietCubit, DietState>(
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (state.id != null) {
              if (state.foodList.isNotEmpty) {
                context.read<EntityCubit>().updateDiet(state.id!, state);
              } else {
                context.read<EntityCubit>().removeDiet(state.id!);
              }
            } else {
              if (state.foodList.isNotEmpty) {
                context.read<EntityCubit>().addDiet(state);
              }
            }
          },
          child: Scaffold(
            body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BackBtn(),
                          SizedBox(width: 4.w,),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27.r),
                                  border: Border.all(
                                      width: 1, color: AppColors.black
                                      .withValues(alpha: 0.08))
                              ),
                              child: BlocSelector<EntityCubit, EntityState, List<FoodState>>(
                                selector: (state) => state.foods,
                                builder: (context, foods) {
                                  return TextFormField(
                                controller: _searchEditingController,
                                style: AppStyles.exoW500Text(18.sp),
                                decoration: InputDecoration(
                                  icon: SvgPicture.asset(
                                    'assets/icons/search.svg',
                                    width: 20.w, fit: BoxFit.fitWidth,),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _currentFoods = foods.where((e) => e.name.toLowerCase().startsWith(value)).toList();
                                  });
                                },
                              );
                              },
                            ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.w,),
                      BlocBuilder<EntityCubit, EntityState>(
                        builder: (context, state) {
                          if (_searchEditingController.text.isEmpty) {
                            _currentFoods = List.from(state.foods);
                          }
                          return Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                      _currentFoods.length,
                                      (int index) {
                                        int calories = _currentFoods[index].calories;
                                        String measure = 'kcal';
                                        if (state.userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                                          calories = calories.toKj();
                                          measure = 'kJ';
                                        }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_currentFoods[index].name, style: AppStyles.exoW500Text(20.sp),),
                                            SizedBox(height: 6.w,),
                                            RichText(
                                                text: TextSpan(
                                                    text: '100 grams ',
                                                    style: AppStyles.interW400Primary(14.sp),
                                                    children: [
                                                  TextSpan(
                                                      text: '- $calories $measure',
                                                      style: AppStyles.interW400Text2(14.sp))
                                                ])),
                                            SizedBox(height: 16.w,)
                                          ],
                                        ),
                                        BlocSelector<DietCubit, DietState,
                                            List<String>>(
                                          selector: (state) => state.foodList,
                                          builder: (context, foodList) {
                                            bool isContainFood =
                                                foodList.contains(_currentFoods[index].name);
                                            return GestureDetector(
                                              onTap: () {
                                                if (isContainFood) {
                                                  context.read<DietCubit>().removeFood(_currentFoods[index].name);
                                                } else {
                                                  context.read<DietCubit>().addFood(_currentFoods[index].name);
                                                }
                                              },
                                              child: Container(
                                                width: 32.w,
                                                height: 32.w,
                                                decoration: isContainFood
                                                    ? BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(8.r),
                                                        color: AppColors.primary)
                                                    : BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8.r),
                                                        border: Border.all(
                                                            width: 2,
                                                            color: AppColors.black.withValues(alpha: 0.12))),
                                                child: isContainFood
                                                    ? Center(
                                                        child: SvgPicture.asset('assets/icons/mark.svg'),)
                                                    : SizedBox.shrink(),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  }),
                                )),
                          );
                        },
                      ),
                      SizedBox(height: 16.w,),
                      Text('Can\'t find what you\'re looking for?', style: AppStyles.exoW400Text2(16.sp),),
                      SizedBox(height: 4.w,),
                      CupertinoButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => BlocProvider(
                                      create: (context) => FoodCubit(),
                                      child: AddFoodScreen(),
                                    )
                              )
                          ),
                          child: Container(
                            width: 190.w,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                              color: AppColors.white,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/plus.svg'),
                                SizedBox(width: 8.w,),
                                Text('Add a new food', style: AppStyles.exoW500Text(18.sp),)
                              ],
                            ),
                          )),
                    ],
                  ),
                )
            ),
          ),
        );
      },
    );
  }
}
