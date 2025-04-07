import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularCaloryIndicator extends StatelessWidget {
  String title;
  int currentCalory;
  int totalCalory;

  CircularCaloryIndicator({
    super.key,
    required this.title,
    required this.currentCalory,
    required this.totalCalory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 20.w,
      height: 164.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppStyles.quicksandW500Text2(14.sp),),
              SvgPicture.asset('assets/icons/calories.svg')
            ],
          ),
          SizedBox(height: 8.w,),
          Center(
            child: SizedBox(
                width: 110.w,
                height: 110.w,
                child: CircularPercentIndicator(
                  radius: 50.w,
                  percent: currentCalory / totalCalory,
                  lineWidth: 10.w,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  progressColor: AppColors.primary,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: SizedBox(
                    height: 60.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentCalory.toString(), style: AppStyles.quicksandW700Black(currentCalory.toString().length > 4 ? 14.sp : 18.sp),),
                        Text('of', style: AppStyles.quicksandW500TabIconColor(16.sp),),
                        Text(totalCalory.toString(), style: AppStyles.quicksandW500InputColor(totalCalory.toString().length > 4 ? 14.sp : 18.sp),)
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
