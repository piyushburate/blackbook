import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/pages/error_page.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is AppUserInitial) {
          return AppLoader();
        }
        if (state is! AppUserAuthorized) {
          return ErrorPage();
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Account Settings'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 12,
                children: [
                  buildListTile(
                    title: 'Email Address',
                    subtitle: state.authUser.email,
                    icon: Icons.email_outlined,
                  ),
                  Divider(),
                  buildListTile(
                    title: 'Edit Personal Details',
                    icon: Icons.account_circle_outlined,
                    onTap: () => context.push(
                        '/settings/account_settings/edit_personal_details'),
                  ),
                  buildListTile(
                    title: 'Change Password',
                    icon: Icons.lock_outlined,
                    onTap: () => context
                        .push('/settings/account_settings/change_password'),
                  ),
                  Divider(),
                  buildListTile(
                    title: 'Delete Account',
                    icon: Icons.delete_outlined,
                    backgroundColor:
                        Theme.of(context).colorScheme.error.withAlpha(15),
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    Color? backgroundColor,
    Color? foregroundColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      tileColor: backgroundColor,
      iconColor: foregroundColor,
      textColor: foregroundColor,
      leading: Icon(icon, size: 18),
      title: Text(title),
      subtitle: (subtitle == null)
          ? null
          : Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: (onTap == null)
          ? null
          : Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }
}
