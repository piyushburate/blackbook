import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? text;
  final Widget? child;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderWidth;
  final Color? borderColor;
  final double? borderRadius;
  final bool isDense;

  const AppButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.isDense = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        fixedSize: Size.fromHeight(isDense ? 38 : 46),
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        iconColor: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          side: BorderSide(
            width: borderWidth ?? 0,
            color: borderColor ?? Colors.transparent,
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (leading != null) leading!,
          if (child != null) child!,
          if (text != null && child == null)
            Text(
              text!,
              style: TextStyle(
                fontSize: isDense ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
