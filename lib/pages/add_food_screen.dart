import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ixber_proj/bloc/food_cubit.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/ext/int_ext.dart';
import 'package:ixber_proj/ext/string_ext.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/ui_kit/widgets/back_btn.dart';
import 'package:ixber_proj/utils/constants.dart';

import '../bloc/entity_cubit.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // final TextEditingController _nameEditingController = TextEditingController();
  // final TextEditingController _caloryEditingController = TextEditingController();
  // final TextEditingController _proteinEditingController = TextEditingController();
  // final TextEditingController _carbsEditingController = TextEditingController();

  bool _isFoodAlreadyExist = false;

  /*@override
  void dispose() {
    super.dispose();
    _nameEditingController.dispose();
    _caloryEditingController.dispose();
    _proteinEditingController.dispose();
    _carbsEditingController.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackBtn(),
                    Text('Add a new food',
                      style: AppStyles.quicksandW600Text(24.sp),),
                    SizedBox(width: 52.w,)
                  ],
                ),
                SizedBox(height: 24.w,),
                Text('Food Name', style: AppStyles.quicksandW600Text2(18.sp),),
                SizedBox(height: 8.w,),
                BlocSelector<EntityCubit, EntityState, List<FoodState>>(
                  selector: (state) => state.foods,
                  builder: (context, foods) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                      ),
                      child: TextFormField(
                        style: AppStyles.quicksandW500Text(16.sp),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          if (foods.any((e) => e.name.toLowerCase() == value.toLowerCase())) {
                            setState(() {
                              _isFoodAlreadyExist = true;
                            });
                          } else {
                            setState(() {
                              _isFoodAlreadyExist = false;
                            });
                          }
                          context.read<FoodCubit>().updateName(value.capitalize());
                        },
                      ),
                    );
                  },
                ),
                _isFoodAlreadyExist ? 
                SizedBox(
                  height: 16.w,
                  child: Center(
                      child: Text('This food already exist!', style: AppStyles.quicksandW600Text(12.sp).copyWith(color: AppColors.red),)),
                ) 
                    :
                SizedBox(height: 16.w,),
                BlocSelector<EntityCubit, EntityState, UserProfileState>(
                    selector: (state) => state.userProfile,
                    builder: (context, userProfile) {
                      String text = 'Calories';
                      if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                        text = 'Joules';
                      }
                      return Text(text, style: AppStyles.quicksandW600Text2(18.sp),);
                    },
                  ),
                SizedBox(height: 8.w,),
                BlocSelector<EntityCubit, EntityState, UserProfileState>(
                selector: (state) => state.userProfile,
                builder: (context, userProfile) {
                  return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.r),
                    border:  Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                  ),
                  child: TextFormField(
                    initialValue: '0',
                    style: AppStyles.quicksandW500Text(16.sp),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[0]) {
                          context.read<FoodCubit>().updateCalories(int.parse(value));
                        } else if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]) {
                          context.read<FoodCubit>().updateCalories(int.parse(value).toKcal());
                        }

                      }
                    }
                  ),
                );
                },
              ),
                SizedBox(height: 8.w,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Protein', style: AppStyles.quicksandW600Text2(18.sp),),
                        SizedBox(height: 8.w,),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 20.w,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.r),
                              border:  Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                          ),
                          child: TextFormField(
                              maxLength: 6,
                              initialValue: '0.0',
                              style: AppStyles.quicksandW500Text(16.sp),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Разрешаем только числа и одну десятичную точку
                              ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  context.read<FoodCubit>().updateProtein(double.parse(value));
                                }
                              },
                            buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fat', style: AppStyles.quicksandW600Text2(18.sp),),
                        SizedBox(height: 8.w,),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 20.w,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.r),
                              border:  Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                          ),
                          child: TextFormField(
                              maxLength: 6,
                              initialValue: '0.0',
                              style: AppStyles.quicksandW500Text(16.sp),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Разрешаем только числа и одну десятичную точку
                              ],
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  context.read<FoodCubit>().updateFat(double.parse(value));
                                }
                              },
                            buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16.w,),
                Text('Carbohydrates', style: AppStyles.quicksandW600Text2(18.sp),),
                SizedBox(height: 8.w,),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20.w,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.r),
                      border:  Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                  ),
                  child: TextFormField(
                      maxLength: 6,
                      initialValue: '0.0',
                      style: AppStyles.quicksandW500Text(16.sp),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Разрешаем только числа и одну десятичную точку
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<FoodCubit>().updateCarbs(double.parse(value));
                        }
                      },
                    buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 210.w,),
                BlocBuilder<FoodCubit, FoodState>(
                    builder: (context, state) {
                      bool isDataCorrected = false;
                      if (!_isFoodAlreadyExist && state.name.isNotEmpty) {
                        isDataCorrected = true;
                      } else {
                        isDataCorrected = false;
                      }
                      return CupertinoButton(
                          onPressed: isDataCorrected ? () {
                            context.read<EntityCubit>().addFood(state);
                            Navigator.of(context).pop();
                          } : null,
                          padding: EdgeInsets.zero,
                          child: Opacity(
                              opacity: isDataCorrected ? 1 : 0.5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 54.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27.r),
                              color: AppColors.primary,
                            ),
                            child: Center(
                              child: Text('Track Calories', style: AppStyles.quicksandW600White(18.sp),),
                            ),
                          )));
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
