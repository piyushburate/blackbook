import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? text;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderWidth;
  final Color? borderColor;
  final double? borderRadius;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: Size.fromHeight(46),
        backgroundColor: backgroundColor ?? AppPallete.primaryColor,
        foregroundColor: foregroundColor ?? Colors.white,
        iconColor: foregroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          side: BorderSide(
            width: borderWidth ?? 0,
            color: borderColor ?? Colors.transparent,
          ),
        ),
        elevation: 0,
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (leading != null) leading!,
          if (text != null) Text(text!),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
