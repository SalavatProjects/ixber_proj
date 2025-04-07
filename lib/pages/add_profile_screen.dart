import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/bloc/entity_cubit.dart';
import 'package:ixber_proj/pages/bottom_nav_bar_screen.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/ui_kit/widgets/back_btn.dart';
import 'package:ixber_proj/utils/constants.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../bloc/user_profile_cubit.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _ageEditingController = TextEditingController();
  final TextEditingController _weightEditingController = TextEditingController();
  final TextEditingController _heightEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ageEditingController.text = context.read<UserProfileCubit>().state.age.toString();
    _weightEditingController.text = context.read<UserProfileCubit>().state.weight.toString();
    _heightEditingController.text = context.read<UserProfileCubit>().state.height.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _ageEditingController.dispose();
    _weightEditingController.dispose();
    _heightEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackBtn(),
                        Text('Set up profile', style: AppStyles.quicksandW600Text(28.sp),),
                        SizedBox(width: 52.w,)
                      ],
                    ),
                    SizedBox(height: 24.w,),
                    Text('Setting goals', style: AppStyles.quicksandW600Text2(18.sp),),
                    SizedBox(height: 8.w,),
                    BlocSelector<UserProfileCubit, UserProfileState, String>(
                    selector: (state) => state.goalType,
                    builder: (context, goalType) {
                      return PullDownButton(
                      buttonAnchor: PullDownMenuAnchor.start,
                        itemBuilder: (context) => List.generate(
                            AppConstants.goalTypes.length,
                                (int index) => PullDownMenuItem(
                                    onTap: () {
                                      context.read<UserProfileCubit>().updateGoalType(AppConstants.goalTypes[index]);
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
                                    Text(goalType,
                                      style: AppStyles.quicksandW500Text(16.sp),
                                    ),
                                    SvgPicture.asset('assets/icons/down.svg')
                                  ],
                                ),
                              ));
                        });
                        },
                      ),
                    SizedBox(height: 16.w,),
                    Text('Calories', style: AppStyles.quicksandW600Text2(18.sp),),
                    SizedBox(height: 16.w,),
                    BlocSelector<UserProfileCubit, UserProfileState, int>(
                    selector: (state) => state.calories,
                    builder: (context, calories) {
                      return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52.w,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r),
                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.1))
                      ),
                        child: Text(calories.toString(), style: AppStyles.quicksandW500Text(16.sp),),
                    );
                    },
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
                                  maxLength: 3,
                                  controller: _ageEditingController,
                                  style: AppStyles.quicksandW500Text(16.sp),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _ageEditingController.text = value;
                                      context.read<UserProfileCubit>().updateAge(int.parse(value));
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
                                    maxLength: 6,
                                    controller: _weightEditingController,
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
                                          context.read<UserProfileCubit>().updateWeight(double.parse(value));
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
                                maxLength: 6,
                                controller: _heightEditingController,
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
                                      context.read<UserProfileCubit>().updateHeight(double.parse(value));
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
                            BlocSelector<UserProfileCubit, UserProfileState, String>(
                            selector: (state) => state.gender,
                            builder: (context, gender) {
                              return PullDownButton(
                                buttonAnchor: PullDownMenuAnchor.center,
                                routeTheme: PullDownMenuRouteTheme(
                                  width: MediaQuery.of(context).size.width / 2 - 20.w
                                ),
                                  itemBuilder: (context) => List.generate(
                                      AppConstants.genders.length, (int index) =>
                                    PullDownMenuItem(
                                        onTap: () {
                                          context.read<UserProfileCubit>().updateGender(AppConstants.genders[index]);
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
                                          Text(gender,
                                          style: AppStyles.quicksandW500Text(16.sp),),
                                          SvgPicture.asset('assets/icons/down.svg')
                                        ],
                                      ),
                                    )
                                )
                              );
                            },
                          ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16.w,),
                    Text('Fitness level', style: AppStyles.quicksandW600Text2(18.sp),),
                    SizedBox(height: 8.w,),
                    BlocSelector<UserProfileCubit, UserProfileState, String>(
                    selector: (state) => state.fitnessLevel,
                    builder: (context, fitnessLevel) {
                      return Container(
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
                                context.read<UserProfileCubit>().updateFitnessLevel(AppConstants.fitnessLevels[index].$1);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3 - 16.w,
                                padding: EdgeInsets.all(8.w),
                                decoration:
                                AppConstants.fitnessLevels[index].$1 == fitnessLevel ?
                                BoxDecoration(
                                  borderRadius: BorderRadius.circular(27.r),
                                  color: AppConstants.fitnessLevels[index].$2.withValues(alpha: 0.15)
                                ) : null,
                                child: Center(
                                  child: Text(AppConstants.fitnessLevels[index].$1,
                                    style: AppConstants.fitnessLevels[index].$1 == fitnessLevel ?
                                    AppStyles.quicksandW600Text(16.sp).copyWith(color: AppConstants.fitnessLevels[index].$2)
                                    :
                                    AppStyles.quicksandW500Text2(16.sp),),
                                ),
                              ))
                        ),
                      ),
                    );
                    },
                  ),
                    SizedBox(height: 92.w,),
                    BlocBuilder<UserProfileCubit, UserProfileState>(
                    builder: (context, state) {
                      bool isDataFilled = false;
                      if (state.weight != 0 && state.height != 0) {
                        isDataFilled = true;
                      }
                      return CupertinoButton(
                      padding: EdgeInsets.zero,
                        onPressed: isDataFilled ? () {
                          context.read<EntityCubit>().updateUserProfile(state);
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => BottomNavBarScreen()));
                        } : null,
                        child: Opacity(
                          opacity: isDataFilled ? 1 : 0.5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 54.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27.r),
                              color: AppColors.primary
                            ),
                            child: Center(
                              child: Text('Track Calories', style: AppStyles.quicksandW600White(18.sp),),
                            ),
                          ),
                        ));
                        },
                      )
                  ],
                ),
              ),
          )
      ),
    );
  }
}
