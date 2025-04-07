import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ixber_proj/bloc/entity_cubit.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/pages/add_profile_screen.dart';
import 'package:ixber_proj/pages/bottom_nav_bar_screen.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';
import 'package:ixber_proj/ui_kit/app_styles.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/onboarding_background.png', fit: BoxFit.fitWidth,),
          SafeArea(child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60.w,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/Union.svg'),
                        SizedBox(width: 8.w,),
                        Text('Ixber', style: AppStyles.leagueSpartanW600White(48.sp),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/images/yoga.png', fit: BoxFit.fitWidth,),
                  ),
                  SizedBox(height: 24.w,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text('Welcome to Ixber!',
                      style: AppStyles.leagueSpartanW600White(40.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.w,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text('Track calories, log food, and manage workouts easily. Start your healthy journey now!',
                      style: AppStyles.leagueSpartanW400Text(20.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  BlocSelector<EntityCubit, EntityState, UserProfileState?>(
                    selector: (state) => state.userProfile,
                    builder: (context, userProfile) {
                        return CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) =>
                                  BlocProvider(
                                create: (context) => UserProfileCubit(profile: userProfile),
                                child: AddProfileScreen(),
                              ))
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 54.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.r),
                                color: AppColors.primary,
                              ),
                              child: Center(
                                child: Text('Set up Profile', style: AppStyles.quicksandW600White(18.sp),),
                              ),
                            ));
                      },
                    ),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) => BottomNavBarScreen())
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 54.w,
                        child: Center(
                          child: Text('Track Calories', style: AppStyles.quicksandW600Text(18.sp),),
                        ),
                      ),)
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
