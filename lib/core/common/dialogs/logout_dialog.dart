import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../cubits/app_user/app_user_cubit.dart';
import '../widgets/app_button.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
            'Are you sure?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap(20),
          Text(
            'Do you want to logout',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
          ),
          Gap(20),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        AppButton(
          isDense: true,
          text: 'No',
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        AppButton(
          isDense: true,
          text: 'Yes',
          backgroundColor: Theme.of(context).colorScheme.error,
          onPressed: () {
            context.read<AppUserCubit>().logOut();
            context.pop();
          },
        ),
      ],
    );
  }
}
