import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onTap,
    required this.text,
    this.margin,
    this.color,
    this.textColor,
    this.borderColor,
    super.key,
  });

  final String text;
  final EdgeInsets? margin;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 60.0),
      width: MediaQuery.of(context).size.width,
      height: 52,
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor != null ? borderColor! : Colors.transparent,
        ),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
