import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_ai_detection/core/gen/assets.gen.dart';
import 'package:local_ai_detection/features/splash/presentation/bloc/splash_bloc.dart';

import '../../../registration/presentation/pages/registration_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashInitial) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => RegistrationScreen(),
              ),
            );
            return;
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Assets.svgs.background.svg(),
            Transform.scale(
              scale: 0.4.sp,
              child: Assets.images.logo.image(),
            ),
          ],
        ),
      ),
    );
  }
}
