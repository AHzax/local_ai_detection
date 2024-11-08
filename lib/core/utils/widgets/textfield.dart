import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../../gen/fonts.gen.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final bool? enabled;
  final String? labelText;
  final String? hintText;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String? value)? validator;
  final TextCapitalization? textCapitalization;
  final Widget? prefixIcon;
  final Color? labelCustomColor;
  final bool obscureText;
  final double borderRadius;
  final Color activeBorderColor;
  final Color borderColor;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.onTap,
    this.readOnly,
    this.enabled,
    this.maxLines,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.hintText,
    this.minLines,
    this.textCapitalization,
    this.inputFormatters,
    this.prefixIcon,
    this.labelCustomColor,
    this.obscureText = false,
    this.borderRadius = 10.0,
    this.activeBorderColor = AppColors.hint,
    this.borderColor = AppColors.outline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        onChanged: onChanged,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        controller: controller,
        inputFormatters: inputFormatters,
        onTap: onTap,
        validator: validator,
        readOnly: readOnly ?? false,
        minLines: minLines ?? 1,
        decoration: InputDecoration(
          prefixIcon: prefixIcon == null
              ? null
              : Transform.scale(
                  scale: 0.50,
                  child: prefixIcon,
                ),
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: activeBorderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: activeBorderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          filled: true,
          suffixIcon: suffixIcon,
          suffixIconColor: Colors.black,
          labelText: labelText,
          floatingLabelStyle: const TextStyle(fontSize: 12),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: AppColors.hint),
          labelStyle: TextStyle(
            fontFamily: FontFamily.manrope,
            fontWeight: FontWeight.bold,
            color: labelCustomColor,
          ),
        ),
      ),
    );
  }
}
