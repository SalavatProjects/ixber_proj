import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../app_colors.dart';

class NutrientsCard extends StatelessWidget {
  String measure;
  double proteinWeightGr;
  double carbsWeightGr;
  double fatWeightGr;

  NutrientsCard({
    super.key,
    required this.measure,
    required this.proteinWeightGr,
    required this.carbsWeightGr,
    required this.fatWeightGr,
  });

  @override
  Widget build(BuildContext context) {
    final double totalNutrientsWeightGr = proteinWeightGr + carbsWeightGr + fatWeightGr;
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
              Text('Nutrients', style: AppStyles.quicksandW500Text2(14.sp),),
              SvgPicture.asset('assets/icons/nutrients.svg')
            ],
          ),
          SizedBox(height: 16.w,),
          _NutrientProgress(
              measure: measure,
              color: AppColors.blueLight,
              name: 'Protein',
              weightGr: proteinWeightGr,
              totalWeightGr: totalNutrientsWeightGr),
          _NutrientProgress(
              measure: measure,
              color: AppColors.pink,
              name: 'Carbs',
              weightGr: carbsWeightGr,
              totalWeightGr: totalNutrientsWeightGr),
          _NutrientProgress(
              measure: measure,
              color: AppColors.orange,
              name: 'Fat',
              weightGr: fatWeightGr,
              totalWeightGr: totalNutrientsWeightGr),
        ],
      ),
    );
  }
}

class _NutrientProgress extends StatelessWidget {
  String measure;
  Color color;
  String name;
  double weightGr;
  double totalWeightGr;

  _NutrientProgress({
    super.key,
    required this.measure,
    required this.color,
    required this.name,
    required this.weightGr,
    required this.totalWeightGr,
  });

  @override
  Widget build(BuildContext context) {
    final double progressIndicatorWidth = 130.w;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
            text: '$name ',
            style:  AppStyles.quicksandW600Text(16.sp).copyWith(color: color),
            children: [
              TextSpan(
                text: weightGr.round().toString(),
                style: AppStyles.quicksandW500Text(14.sp),
              ),
              TextSpan(
                text: '/${totalWeightGr.round()}$measure',
                style: AppStyles.quicksandW500Text2(14.sp)
              )
            ]
        )
        ),
        SizedBox(height: 4.w,),
        Stack(
          children: [
            Container(
              width: progressIndicatorWidth,
              height: 8.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: color.withValues(alpha: 0.3)
              ),
            ),
            Container(
              width: (weightGr / totalWeightGr) * progressIndicatorWidth,
              height: 8.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: color
              ),
            )
          ],
        ),
        SizedBox(height: 7.w,),
      ],
    );
  }
}
