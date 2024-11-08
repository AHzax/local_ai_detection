import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_ai_detection/core/constants/app_colors.dart';
import 'package:local_ai_detection/core/utils/widgets/buttons.dart';
import 'package:local_ai_detection/features/home/presentation/pages/home_screen.dart';

import '../../../../core/gen/assets.gen.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController vehicalNoField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Assets.svgs.background.svg(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Driver Fatigue\nMonitoring System",
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 51.sp),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.outline,
                            blurRadius: 7,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 50),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 10.sp),
                            const Text(
                              "Create your new account, we are glad that you joined us",
                              style: TextStyle(
                                color: AppColors.hint,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30.sp),
                            TextFormField(
                              controller: vehicalNoField,
                              onFieldSubmitted: (e) {
                                print(e);
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your vehicle number',
                                labelText: 'Vehicle No',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            CustomButton(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    nameController: vehicalNoField!.text == ""
                                        ? ""
                                        : vehicalNoField.text,
                                  ),
                                ),
                              ),
                              text: "Confirm",
                              margin: EdgeInsets.only(top: 16.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
