import 'package:blackbook/core/common/dialogs/update_dialog.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/constants/app_images.dart';
import 'package:blackbook/core/theme/app_theme.dart';
import 'package:blackbook/features/dashboard/presentation/dialogs/avatar_selection_dialog.dart';
import 'package:blackbook/core/common/dialogs/logout_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus_dialog/share_plus_dialog.dart';

class ProfileSection extends StatelessWidget {
  final AuthUser authUser;
  ProfileSection({super.key, required this.authUser});
  final List<(IconData iconData, String label)> settingList = [
    (Icons.manage_accounts_outlined, 'Account Settings'),
    (Icons.notifications_none_outlined, 'Notification Settings'),
    (Icons.color_lens_outlined, 'App Theme'),
    (Icons.share_outlined, 'Share Our App'),
    (Icons.lock_outlined, 'Privacy Policy'),
    (Icons.assignment_outlined, 'Terms of Service'),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: buildProfileSection(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList.list(
            children: [
              Divider(),
              Gap(20),
              buildSettingTile(
                title: 'Account Settings',
                icon: Icons.manage_accounts_outlined,
                onTap: () => context.push('/settings/account_settings'),
              ),
              buildSettingTile(
                title: 'Notification Settings',
                icon: Icons.notifications_none_outlined,
                onTap: () {},
              ),
              buildSettingTile(
                title: 'App Theme',
                icon: Icons.color_lens_outlined,
                onTap: () => context.push('/settings/app_theme'),
              ),
              Divider(),
              Gap(15),
              buildSettingTile(
                title: 'Share Our App',
                icon: Icons.share_outlined,
                onTap: () => shareApp(context),
              ),
              buildSettingTile(
                title: 'Privacy Policy',
                icon: Icons.lock_outlined,
                onTap: () {},
              ),
              buildSettingTile(
                title: 'Terms of Service',
                icon: Icons.assignment_outlined,
                onTap: () {},
              ),
              buildSettingTile(
                title: 'Check for Updates',
                icon: Icons.update_sharp,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateDialog(),
                  );
                },
              ),
              Divider(),
              Gap(15),
              buildSettingTile(
                title: 'Log Out',
                icon: Icons.logout_outlined,
                backgroundColor:
                    Theme.of(context).colorScheme.error.withAlpha(15),
                foregroundColor: Theme.of(context).colorScheme.error,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => LogoutDialog(),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProfileSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Material(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.5,
                color:
                    Theme.of(context).extension<AppColors>()!.borderNormalColor,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.surface,
              backgroundImage: (authUser.avatar == null)
                  ? AssetImage(AppImages.profileAvatar)
                  : CachedNetworkImageProvider(authUser.avatar!.url),
              child: Transform.translate(
                offset: const Offset(35, 45),
                child: IconButton.filled(
                  onPressed: () => openAvatarSelectionDialog(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade300.withAlpha(200),
                    foregroundColor: Colors.grey.shade800,
                    shape: const CircleBorder(side: BorderSide()),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
            ),
          ),
          Gap(12),
          Text(
            authUser.fullName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            authUser.educationLevel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettingTile({
    required String title,
    required IconData icon,
    Color? backgroundColor,
    Color? foregroundColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        tileColor: backgroundColor,
        iconColor: foregroundColor,
        textColor: foregroundColor,
        leading: Icon(icon, size: 18),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: onTap,
      ),
    );
  }

  void shareApp(BuildContext context) async {
    ShareDialog.share(
      context,
      dialogTitle: 'Share Our App',
      body:
          'https://play.google.com/store/apps/details?id=com.example.blackbook',
      platforms: SharePlatform.defaults,
    );
  }

  void openAvatarSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      shape: Border(),
      barrierColor: Colors.transparent,
      builder: (context) {
        return AvatarSelectionDialog(initialAvatar: authUser.avatar);
      },
    );
  }
}
