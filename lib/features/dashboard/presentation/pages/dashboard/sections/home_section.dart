import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/constants/app_images.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';

class HomeSection extends StatefulWidget {
  final AuthUser authUser;
  const HomeSection({super.key, required this.authUser});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamCubit, ExamState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is ExamLoading) {
          EasyLoading.show();
        }
        if (state is ExamFailure) {
          EasyLoading.showError(state.message);
        }
        if (state is! ExamSelected) {}
      },
      child: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        slivers: [
          SliverGap(12),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTitlebar(),
                buildSwiper(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitlebar() {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is! AppUserAuthorized) {
          return SizedBox();
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, ${state.authUser.firstName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Explore & learn with educational',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSwiper() {
    return SizedBox(
      height: 150,
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        child: Swiper(
          itemCount: 3,
          pagination: const SwiperPagination(),
          itemBuilder: (context, index) {
            return Image.asset(
              AppImages.homeBanner,
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}
