import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/pages/training_screen.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';
import 'package:ixber_proj/utils/constants.dart';

class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Workouts', style: AppStyles.quicksandW600Text(28.sp),),
          SizedBox(height: 24.w,),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      AppConstants.workouts.length,
                          (int index) => _WorkoutCard(
                              goal: AppConstants.workoutsDescription[AppConstants.workouts[index]]!.$1,
                              name: AppConstants.workouts[index],
                              imagePath: AppConstants.workoutsDescription[AppConstants.workouts[index]]!.$3,
                              colors: AppConstants.workoutsDescription[AppConstants.workouts[index]]!.$2,
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (BuildContext context) => TrainingScreen(name: AppConstants.workouts[index])
                                  )
                              )
                          )
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  String goal;
  String name;
  String imagePath;
  List<Color> colors;
  void Function() onPressed;

  _WorkoutCard({
    super.key,
    required this.goal,
    required this.name,
    required this.imagePath,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.w),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors)
        ),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 22.w),
                  child: Image.asset(imagePath, height: 140.w, fit: BoxFit.fitHeight,),
                )),
            Padding(
                padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 140.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(goal, style: AppStyles.quicksandW500Text(14.sp).copyWith(color: AppColors.lightGrey),),
                            SizedBox(height: 4.w,),
                            Text(name, style: AppStyles.quicksandW700Text(32.sp).copyWith(color: AppColors.white),)
                          ],
                        ),
                      ),
                      CupertinoButton(
                          onPressed: onPressed,
                          padding: EdgeInsets.zero,
                          child: Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: AppColors.white.withValues(alpha: 0.24))
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/right_up.svg', 
                                width: 22.w, 
                                fit: BoxFit.fitWidth,
                                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                  Spacer(),
                  IntrinsicWidth(
                    child: CupertinoButton(
                        onPressed: onPressed,
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.w),
                            border: Border.all(width: 1, color: AppColors.black.withValues(alpha: 0.07)),
                            color: AppColors.white
                          ),
                          child: Center(
                            child: Text('Plan a workout', style: AppStyles.quicksandW600Primary(16.sp),),
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
