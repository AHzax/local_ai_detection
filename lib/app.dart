import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_ai_detection/core/constants/app_colors.dart';
import 'package:local_ai_detection/core/gen/fonts.gen.dart';
import 'package:local_ai_detection/features/splash/presentation/bloc/splash_bloc.dart';

import 'features/splash/presentation/pages/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashBloc()..add(const InitEvent())),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
            fontFamily: FontFamily.manrope,
            appBarTheme: const AppBarTheme(centerTitle: true),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
