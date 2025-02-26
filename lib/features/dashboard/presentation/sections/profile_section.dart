import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/constants/app_images.dart';
import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfileSection extends StatelessWidget {
  final AuthUser authUser;
  ProfileSection({super.key, required this.authUser});
  final List<(IconData iconData, String label)> settingList = [
    (Icons.manage_accounts_outlined, 'Account Settings'),
    (Icons.notifications_none_outlined, 'Notification Settings'),
    (Icons.color_lens_outlined, 'App Theme'),
    (Icons.share_outlined, 'Share Out App'),
    (Icons.lock_outlined, 'Privacy Policy'),
    (Icons.assignment_outlined, 'Terms of Service'),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        SliverAppBar(
          pinned: true,
          centerTitle: true,
          toolbarHeight: 200,
          title: buildProfileSection(),
        ),
        SliverGap(12),
        SliverList.list(
          children: [
            ...List.generate(
              settingList.length,
              (index) {
                return buildSettingTile(
                  title: settingList[index].$2,
                  icon: settingList[index].$1,
                );
              },
            ),
            buildSettingTile(
              title: 'Log Out',
              icon: Icons.logout_outlined,
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you really want to log out ?'),
                      actions: [
                        AppButton(
                          text: 'Yes',
                          trailing: Icon(Icons.check),
                          backgroundColor: AppPallete.errorColor,
                          foregroundColor: AppPallete.whiteColor,
                          onPressed: () {
                            context.read<AppUserCubit>().logOut();
                            context.pop();
                          },
                        ),
                        AppButton(
                          text: 'No',
                          trailing: Icon(Icons.close),
                          backgroundColor: AppPallete.normalTextColor,
                          foregroundColor: AppPallete.whiteColor,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Widget buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: const AssetImage(AppImages.profileAvatar),
          child: Transform.translate(
            offset: const Offset(35, 45),
            child: IconButton.filled(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade300.withAlpha(180),
                foregroundColor: Colors.grey.shade800,
                shape: const CircleBorder(side: BorderSide()),
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
    );
  }

  Widget buildSettingTile(
      {required String title, required IconData icon, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: ListTile(
        onTap: onTap ?? () {},
        leading: Icon(icon, size: 20),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppPallete.darkTextColor,
          ),
        ),
      ),
    );
  }
}
