import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_button.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String label;
  final String? positiveActionLabel;
  final String? negativeActionLabel;
  final bool showNegativeAction;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.label,
    this.positiveActionLabel,
    this.negativeActionLabel,
    this.showNegativeAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap(20),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
          ),
          Gap(20),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (showNegativeAction)
          AppButton(
            isDense: true,
            text: negativeActionLabel ?? 'No',
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            onPressed: () => context.pop(false),
          ),
        AppButton(
          isDense: true,
          text: positiveActionLabel ?? 'Yes',
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => context.pop(true),
        ),
      ],
    );
  }
}
