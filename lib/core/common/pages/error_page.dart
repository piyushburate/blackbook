import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;
  const ErrorPage({
    super.key,
    this.title,
    this.subtitle,
    this.showBack = true,
    this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? '404',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle ?? 'Page not found!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gap(20),
            if (onRetry != null)
              AppButton(
                text: 'Retry',
                leading: Icon(Icons.refresh),
                backgroundColor: Theme.of(context).colorScheme.error,
                onPressed: onRetry,
              ),
            Gap(20),
            if (onBack != null || showBack)
              AppButton(
                text: 'Back',
                leading: Icon(Icons.arrow_back),
                backgroundColor: Colors.transparent,
                onPressed: onBack ?? () => context.pop(),
              ),
          ],
        ),
      ),
    );
  }
}
