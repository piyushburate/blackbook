import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/core/constants/app_images.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class AvatarSelectionDialog extends StatefulWidget {
  final Avatar? initialAvatar;
  const AvatarSelectionDialog({super.key, this.initialAvatar});

  @override
  State<AvatarSelectionDialog> createState() => _AvatarSelectionDialogState();
}

class _AvatarSelectionDialogState extends State<AvatarSelectionDialog> {
  Avatar? selectedAvatar;
  List<Avatar>? avatars;

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.initialAvatar;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAvatars();
    });
  }

  void fetchAvatars() async {
    final avatars = await context.read<DashboardCubit>().listAvatars();
    if (avatars.isNotEmpty) {
      setState(() {
        this.avatars = avatars;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 60,
            titleSpacing: 25,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: Border(),
            title: Text(
              'Select Avatar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).extension<AppColors>()?.darkTextColor,
              ),
            ),
            actions: [
              IconButton(
                onPressed: context.pop,
                icon: Icon(Icons.close),
              ),
              Gap(20),
            ],
          ),
          PinnedHeaderSliver(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Theme.of(context)
                        .extension<AppColors>()!
                        .borderNormalColor,
                  ),
                ),
              ),
              child: Column(
                spacing: 15,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image(
                        image: (selectedAvatar == null)
                            ? AssetImage(AppImages.profileAvatar)
                            : CachedNetworkImageProvider(selectedAvatar!.url),
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(AppImages.profileAvatar),
                      ),
                    ),
                  ),
                  Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        isDense: true,
                        text: 'Clear',
                        backgroundColor: Theme.of(context).colorScheme.error,
                        leading: Icon(Icons.remove_circle),
                        onPressed: (selectedAvatar == null)
                            ? null
                            : () => setState(() => selectedAvatar = null),
                      ),
                      AppButton(
                        isDense: true,
                        text: 'Save',
                        trailing: Icon(Icons.check),
                        onPressed: (selectedAvatar == widget.initialAvatar)
                            ? null
                            : setSelectedAvatar,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (avatars == null)
              ? SliverFillRemaining(child: AppLoader())
              : SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 1,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: avatars!.length,
                    itemBuilder: (context, index) {
                      final avatar = avatars![index];
                      final isSelected = avatar == selectedAvatar;
                      return GestureDetector(
                        onTap: () {
                          if (selectedAvatar != avatar) {
                            setState(() {
                              selectedAvatar = avatar;
                            });
                          }
                        },
                        child: ClipOval(
                          child: Material(
                            shape: !isSelected
                                ? null
                                : RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 3,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                            child: Padding(
                              padding: EdgeInsets.all(isSelected ? 10 : 0),
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                backgroundImage:
                                    CachedNetworkImageProvider(avatar.url),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  void setSelectedAvatar() async {
    final isUpdated =
        await context.read<DashboardCubit>().setUserAvatar(selectedAvatar);
    if (isUpdated) {
      EasyLoading.showSuccess(
        'Avatar Updated Successfully!',
        dismissOnTap: true,
      );
      GetIt.instance<AppUserCubit>().refreshState();
      // ignore: use_build_context_synchronously
      context.pop();
    } else {
      EasyLoading.showError(
        'Error saving avatar!',
        dismissOnTap: true,
      );
    }
  }
}
