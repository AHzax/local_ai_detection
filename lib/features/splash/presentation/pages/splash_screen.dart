import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_ai_detection/core/gen/assets.gen.dart';
import 'package:local_ai_detection/features/home/presentation/pages/home_screen.dart';
import 'package:local_ai_detection/features/splash/presentation/bloc/splash_bloc.dart';

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
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            return;
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [Icon(Icons.camera, size: 400)],
        ),
      ),
    );
  }
}
