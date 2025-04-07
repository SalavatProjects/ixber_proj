import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ixber_proj/bloc/entity_cubit.dart';
import 'package:ixber_proj/pages/onboarding_screen.dart';
import 'package:ixber_proj/storages/isar.dart';
import 'package:ixber_proj/ui_kit/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppIsarDatabase.init();
  runApp(BlocProvider(
    create: (context) => EntityCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: context.read<EntityCubit>().getUserProfile(),
          builder: (context, snapshot) {
            return FutureBuilder(
              future: context.read<EntityCubit>().getDiets(),
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: context.read<EntityCubit>().getFoods(),
                  builder: (context, snapshot) {
                    return OnboardingScreen();
                  }
                );
              }
            );
          }
        ),
      ),
    );
  }
}

