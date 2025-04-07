import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';

class VitaminsCard extends StatelessWidget {
  String measure;
  int vitaminCMg;
  int vitaminAMg;
  int vitaminDMg;
  int vitaminBMg;

  VitaminsCard({
    super.key,
    required this.measure,
    required this.vitaminCMg,
    required this.vitaminAMg,
    required this.vitaminDMg,
    required this.vitaminBMg,
  });

  @override
  Widget build(BuildContext context) {
    final int totalMg = vitaminCMg + vitaminAMg + vitaminDMg + vitaminBMg;
    return Container(
      width: MediaQuery.of(context).size.width,
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
              Text('Vitamins', style: AppStyles.quicksandW500Text2(14.sp),),
              SvgPicture.asset('assets/icons/apple.svg')
            ],
          ),
          SizedBox(height: 16.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _VitaminsIndicator(measure: measure, color: AppColors.blue, name: 'C', mg: vitaminCMg, totalMg: totalMg),
              _VitaminsIndicator(measure: measure, color: AppColors.redDark, name: 'A', mg: vitaminAMg, totalMg: totalMg),
              _VitaminsIndicator(measure: measure, color: AppColors.orangeLight, name: 'D', mg: vitaminDMg, totalMg: totalMg),
              _VitaminsIndicator(measure: measure, color: AppColors.blue, name: 'B', mg: vitaminBMg, totalMg: totalMg),
            ],
          )
        ],
      ),
    );
  }
}

class _VitaminsIndicator extends StatelessWidget {
  String measure;
  Color color;
  String name;
  int mg;
  int totalMg;
  
  _VitaminsIndicator({
    super.key,
    required this.measure,
    required this.color,
    required this.name,
    required this.mg,
    required this.totalMg,
  });

  @override
  Widget build(BuildContext context) {
    final double myWidth = 64.w;
    return SizedBox(
      width: myWidth,
      child: Column(
        children: [
          Text(name, style: AppStyles.quicksandW600Text(18.sp),),
          SizedBox(height: 8.w,),
          Stack(
            children: [
              Container(
                width: myWidth,
                height: 6.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: color.withValues(alpha: 0.15)
                ),
              ),
              Container(
                width: totalMg != 0 ? (mg / totalMg) * myWidth : 0,
                height: 6.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: color,
                ),
              )
            ],
          ),
          SizedBox(height: 4.w,),
          RichText(
              text: TextSpan(
                text: mg.toString(),
                style: AppStyles.quicksandW700Text(14.sp),
                children: [
                  TextSpan(
                    text: ' $measure',
                    style: AppStyles.quicksandW500Text2(12.sp)
                  )
                ]
              )
          )
        ],
      ),
    );
  }
}
