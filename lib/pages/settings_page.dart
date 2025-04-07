import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../bloc/entity_cubit.dart';
import '../ui_kit/app_colors.dart';
import '../utils/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  int _updateCalories({
    required String gender,
    required double weight,
    required double height,
  }) {
    if (gender == AppConstants.genders[0]) {
      return (10 * weight +6.25 * (height * 100) - 5 + 5).toInt();
    } else if (gender == AppConstants.genders[1]) {
      return (10 * weight + 6.25 * (height * 100) - 5 - 161).toInt();
    } else {
      return 0;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: BlocSelector<EntityCubit, EntityState, UserProfileState>(
        selector: (state) => state.userProfile,
        builder: (context, userProfile) {
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppStyles.quicksandW600Text(28.sp),),
            SizedBox(height: 24.w,),
              Text('Setting goals', style: AppStyles.quicksandW600Text2(18.sp),),
              SizedBox(height: 8.w,),
                PullDownButton(
                      buttonAnchor: PullDownMenuAnchor.start,
                      itemBuilder: (context) => List.generate(
                          AppConstants.goalTypes.length,
                              (int index) => PullDownMenuItem(
                            onTap: () {
                              context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(goalType: AppConstants.goalTypes[index]));
                            },
                            title: AppConstants.goalTypes[index],
                            itemTheme: PullDownMenuItemTheme(
                                textStyle: AppStyles.quicksandW500Text2(16.sp)
                            ),
                          )),
                      buttonBuilder: (context, showMenu) {
                        return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: showMenu,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 52.w,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26.r),
                                  border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(userProfile.goalType,
                                    style: AppStyles.quicksandW500Text(16.sp),
                                  ),
                                  SvgPicture.asset('assets/icons/down.svg')
                                ],
                              ),
                            ));
                      }),
              SizedBox(height: 16.w,),
              Text('Calories', style: AppStyles.quicksandW600Text2(18.sp),),
              SizedBox(height: 16.w,),
              Container(
                    width: MediaQuery.of(context).size.width,
                    height: 52.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                    ),
                    child: Text(userProfile.calories.toString(), style: AppStyles.quicksandW500Text(16.sp),),
                  ),
              SizedBox(height: 16.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Age', style: AppStyles.quicksandW600Text2(18.sp),),
                      SizedBox(height: 8.w,),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 20.w,
                        height: 52.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.w),
                            border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                        ),
                        child: TextFormField(
                          initialValue: userProfile.age.toString(),
                          maxLength: 3,
                          style: AppStyles.quicksandW500Text(16.sp),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onChanged: (value)  {
                              context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(age: int.parse(value)));
                          },
                          buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weight', style: AppStyles.quicksandW600Text2(18.sp),),
                      SizedBox(height: 8.w,),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 20.w,
                        height: 52.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.w),
                            border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                        ),
                        child: TextFormField(
                          initialValue: userProfile.weight.toString(),
                          maxLength: 6,
                          style: AppStyles.quicksandW500Text(16.sp),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Разрешаем только числа и одну десятичную точку
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              suffixText: 'kg',
                              suffixStyle: AppStyles.quicksandW500Text(16.sp)
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(
                                    weight: double.parse(value),
                                    calories: _updateCalories(gender: userProfile.gender, weight: double.parse(value), height: userProfile.height)
                                ));
                              }
                            });
                          },
                          buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
                            return null;
                          },
                        ),
                      ),

                    ],
                  )
                ],
              ),
              SizedBox(height: 16.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Height', style: AppStyles.quicksandW600Text2(18.sp),),
                      SizedBox(height: 8.w,),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 20.w,
                        height: 52.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.w),
                            border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                        ),
                        child: TextFormField(
                          initialValue: userProfile.height.toString(),
                          maxLength: 6,
                          style: AppStyles.quicksandW500Text(16.sp),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Разрешаем только числа и одну десятичную точку
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              suffixText: 'm',
                              suffixStyle: AppStyles.quicksandW500Text(16.sp)
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(height: double.parse(value)));
                              }
                            });
                          },
                          buildCounter: (context, {required currentLength, required maxLength, required isFocused}) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender', style: AppStyles.quicksandW600Text2(18.sp),),
                      SizedBox(height: 8.w,),
                      PullDownButton(
                              buttonAnchor: PullDownMenuAnchor.center,
                              routeTheme: PullDownMenuRouteTheme(
                                  width: MediaQuery.of(context).size.width / 2 - 20.w
                              ),
                              itemBuilder: (context) => List.generate(
                                  AppConstants.genders.length, (int index) =>
                                  PullDownMenuItem(
                                    onTap: () {
                                      context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(gender: AppConstants.genders[index]));
                                    },
                                    title: AppConstants.genders[index],
                                    itemTheme: PullDownMenuItemTheme(
                                      textStyle: AppStyles.quicksandW500Text2(16.sp),
                                    ),
                                  )
                              ),
                              buttonBuilder: (context, showMenu) =>
                                  CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: showMenu,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width / 2 - 20.w,
                                        height: 52.w,
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(26.w),
                                            border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(userProfile.gender,
                                              style: AppStyles.quicksandW500Text(16.sp),),
                                            SvgPicture.asset('assets/icons/down.svg')
                                          ],
                                        ),
                                      )
                                  )
                          ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16.w,),
              Text('Fitness level', style: AppStyles.quicksandW600Text2(18.sp),),
              SizedBox(height: 8.w,),
              Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27.r),
                      border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          AppConstants.fitnessLevels.length,
                              (int index) =>
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(fitnessLevel: AppConstants.fitnessLevels[index].$1));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 3 - 16.w,
                                    padding: EdgeInsets.all(8.w),
                                    decoration:
                                    AppConstants.fitnessLevels[index].$1 == userProfile.fitnessLevel ?
                                    BoxDecoration(
                                        borderRadius: BorderRadius.circular(27.r),
                                        color: AppConstants.fitnessLevels[index].$2.withValues(alpha: 0.15)
                                    ) : null,
                                    child: Center(
                                      child: Text(AppConstants.fitnessLevels[index].$1,
                                        style: AppConstants.fitnessLevels[index].$1 == userProfile.fitnessLevel ?
                                        AppStyles.quicksandW600Text(16.sp).copyWith(color: AppConstants.fitnessLevels[index].$2)
                                            :
                                        AppStyles.quicksandW500Text2(16.sp),),
                                    ),
                                  ))
                      ),
                    ),
                  ),
            SizedBox(height: 16.w,),
            Text('Units of measurement', style: AppStyles.quicksandW600Text2(18.sp),),
            SizedBox(height: 8.w,),
            IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                  color: AppColors.white
                ),
                child: Row(
                  children: List.generate(
                      AppConstants.foodEnergyUnits.length,
                          (int index) => GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              context.read<EntityCubit>().updateUserProfile(userProfile.copyWith(foodEnergyUnit: AppConstants.foodEnergyUnits[index]));
                            },
                            child: Container(
                              width: 110.w,
                              height: 30.w,
                              decoration: userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[index] ?
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(18.r),
                                color: AppColors.primary.withValues(alpha: 0.15)
                              )
                              : null,
                              child: Center(
                                child: Text(AppConstants.foodEnergyUnits[index], style: AppStyles.quicksandW600Text(16.sp).copyWith(
                                    color: userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[index] ? AppColors.primary : AppColors.text2),),
                              ),
                            ),
                          )),
                ),
              ),
            ),
            SizedBox(height: 90.w,),
          ],
        );
        }
      ),
    ),
    );
  }
}

