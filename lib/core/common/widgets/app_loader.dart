import 'package:blackbook/core/constants/app_gifs.dart';
import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Image.asset(AppGifs.booksStackLoading),
      ),
    );
  }
}
