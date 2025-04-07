import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/ext/int_ext.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/ui_kit/widgets/back_btn.dart';
import 'package:ixber_proj/utils/constants.dart';

import '../bloc/entity_cubit.dart';

class TrainingScreen extends StatelessWidget {
  String name;

  TrainingScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackBtn(),
                    Text('Training', style: AppStyles.quicksandW600Text(28.sp),),
                    SizedBox(width: 52.w,)
                  ],
                ),
                SizedBox(height: 16.w,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppConstants.workoutsDescription[name]!.$2)
                  ),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 22.w),
                            child: Image.asset(AppConstants.workoutsDescription[name]!.$3, height: 180.w, fit: BoxFit.fitHeight,),
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180.w,
                                child: Text(AppConstants.workoutsDescription[name]!.$1, style: AppStyles.quicksandW500Text(18.sp).copyWith(color: AppColors.lightGrey),)),
                            SizedBox(height: 8.w,),
                            Text(name, style: AppStyles.quicksandW700Text(44.sp).copyWith(color: AppColors.white),),
                            Spacer(),
                            IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.w),
                                    border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                                    color: AppColors.white
                                ),
                                child: Center(
                                  child: Text('Plan a workout', style: AppStyles.quicksandW600Primary(16.sp),),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8.w,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 20.w,
                      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                        color: AppColors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlocSelector<EntityCubit, EntityState, UserProfileState>(
                                selector: (state) => state.userProfile,
                                builder: (context, userProfile) {
                                  String measure = 'kcal';
                                  if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]){
                                    measure = 'kJ';
                                  }
                                  return Text('Calories ($measure)', style: AppStyles.quicksandW500Text2(14.sp),);
                                },
                              ),
                              SvgPicture.asset('assets/icons/calories.svg', width: 14.w, fit: BoxFit.fitWidth,)
                            ],
                          ),
                          SizedBox(height: 24.w,),
                          BlocSelector<EntityCubit, EntityState, UserProfileState>(
                            selector: (state) => state.userProfile,
                            builder: (context, userProfile) {
                              int calories = AppConstants.workoutsDescription[name]!.$4;
                              String measure = 'kcal';
                              if (userProfile.foodEnergyUnit == AppConstants.foodEnergyUnits[1]){
                                calories = calories.toKj();
                                measure = 'kJ';
                              }
                              return RichText(
                              text: TextSpan(
                                text: calories.toString(),
                                style: AppStyles.quicksandW600Text(22.sp),
                                children: [
                                  TextSpan(
                                    text: ' $measure',
                                    style: AppStyles.quicksandW600Text2(22.sp)
                                  )
                                ]
                              ),
                          );
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 20.w,
                      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                        color: AppColors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Time', style: AppStyles.quicksandW500Text2(14.sp),),
                              SvgPicture.asset('assets/icons/clock.svg', width: 14.w, fit: BoxFit.fitWidth,)
                            ],
                          ),
                          SizedBox(height: 24.w,),
                          RichText(
                            text: TextSpan(
                                text: AppConstants.workoutsDescription[name]!.$5.toString(),
                                style: AppStyles.quicksandW600Text(22.sp),
                                children: [
                                  TextSpan(
                                      text: ' min',
                                      style: AppStyles.quicksandW600Text2(22.sp)
                                  )
                                ]
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),
                SizedBox(height: 16.w,),
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              AppConstants.workoutsDescription[name]!.$6.length,
                              (int index) =>
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8.w),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(6.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                                        color: AppColors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12.r),
                                            child: SizedBox(
                                              width: 110.w,
                                              height: 72.w,
                                              child: Image.asset(AppConstants.workoutsDescription[name]!.$6[index].$2, fit: BoxFit.cover,),
                                            ),
                                          ),
                                          SizedBox(width: 16.w,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(AppConstants.workoutsDescription[name]!.$6[index].$1, style: AppStyles.quicksandW500Text(20.sp),),
                                              SizedBox(height: 16.w,),
                                              Text('Set 1 - 4 Reps', style: AppStyles.quicksandW500Text2(16.sp),)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        )
                    )
                )
              ],
            ),
          )),
    );
  }
}
