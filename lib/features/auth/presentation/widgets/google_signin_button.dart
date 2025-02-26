import 'package:blackbook/core/constants/app_images.dart';
import 'package:flutter/material.dart';

class GoogleSigninButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const GoogleSigninButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(46),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(width: 1, color: Colors.grey.shade600),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Image.asset(AppImages.googleLogo, width: 24),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
