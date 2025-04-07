import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ixber_proj/bloc/user_profile_cubit.dart';
import 'package:ixber_proj/pages/home_page.dart';
import 'package:ixber_proj/pages/settings_page.dart';
import 'package:ixber_proj/pages/stats_page.dart';
import 'package:ixber_proj/pages/workouts_page.dart';

import '../ui_kit/app_colors.dart';
import '../ui_kit/app_styles.dart';
import '../utils/constants.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    HomePage(),
    StatsPage(),
    WorkoutsPage(),
    BlocProvider(
      create: (context) => UserProfileCubit(),
      child: SettingsPage(),
),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
           children: [
             _pages[_currentPage],
             Align(
               alignment: Alignment.bottomCenter,
               child: Padding(
                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.w),
                 child: Container(
                   padding: EdgeInsets.all(4.w),
                   width: MediaQuery.of(context).size.width,
                   height: 62.w,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(31.r),
                     color: AppColors.white,
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: List.generate(
                         AppConstants.bottomNavBarElems.length,
                             (int index) => _BottomNavBarBtn(
                                 text: AppConstants.bottomNavBarElems[index].$1,
                                 imagePath: AppConstants.bottomNavBarElems[index].$2,
                                 isSelected: _currentPage == index,
                                 onPressed: () {
                                   setState(() {
                                     _currentPage = index;
                                   });
                                 })),
                   ),
                 ),
               ),
             )
           ],
          )),
    );
  }
}

class _BottomNavBarBtn extends StatelessWidget {
  String text;
  String imagePath;
  bool isSelected;
  void Function() onPressed;

  _BottomNavBarBtn({
    super.key,
    required this.text,
    required this.imagePath,
    this.isSelected = false,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: AppConstants.duration200,
        height: 54.w,
        decoration: isSelected ? BoxDecoration(
            borderRadius: BorderRadius.circular(27.r),
            color: AppColors.primary
        ) : null,
        child: isSelected ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
          child: Row(
            children: [
              SvgPicture.asset(imagePath),
              SizedBox(width: 6,),
              Text(text, style: AppStyles.quicksandW500White(16.sp),)
            ],
          ),
        ) : Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: SvgPicture.asset(imagePath, colorFilter: ColorFilter.mode(
                isSelected ? AppColors.white : AppColors.text2, BlendMode.srcIn),),),
        ),
      ),
    );
  }
}