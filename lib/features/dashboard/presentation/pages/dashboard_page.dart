import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/core/common/widgets/svg_icon.dart';
import 'package:blackbook/core/constants/app_icons.dart';
import 'package:blackbook/features/dashboard/presentation/sections/exam_section.dart';
import 'package:blackbook/features/dashboard/presentation/sections/history_section.dart';
import 'package:blackbook/features/dashboard/presentation/sections/home_section.dart';
import 'package:blackbook/features/dashboard/presentation/sections/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late PageController _pageController;
  late int pageIndex;
  AuthUser? authUser;

  List<String> pageList = [
    AppIcons.home,
    AppIcons.book,
    AppIcons.notes,
    AppIcons.profileCircled,
  ];

  @override
  void initState() {
    pageIndex = 1;
    _pageController = PageController(initialPage: pageIndex);
    setAuthUser();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setAuthUser([AppUserAuthorized? appUserState]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = appUserState ?? context.read<AppUserCubit>().state;
      if (state is AppUserAuthorized) {
        authUser = state.authUser;
        setState(() {});

        if (state.authUser.selectedExam == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            goToSection(1);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserAuthorized) {
          setAuthUser(state);
        } else {
          context.go('/auth/login');
        }
      },
      child: PopScope(
        canPop: pageIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          goToSection(0);
        },
        child: (authUser == null)
            ? AppLoader()
            : SafeArea(
                child: Scaffold(
                  body: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (value) => setState(() => pageIndex = value),
                    itemCount: pageList.length,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return HomeSection(authUser: authUser!);
                        case 1:
                          return ExamSection(authUser: authUser!);
                        case 2:
                          return HistorySection();
                        case 3:
                          return ProfileSection(authUser: authUser!);
                        default:
                          return Center(child: SvgIcon(pageList[index]));
                      }
                    },
                  ),
                  bottomNavigationBar: buildBottombar(),
                ),
              ),
      ),
    );
  }

  Widget buildBottombar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.fromLTRB(4, 4, 4, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            pageList.length,
            (index) {
              return IconButton(
                onPressed: () => goToSection(index),
                icon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgIcon(
                    pageList[index],
                    color: (index == pageIndex)
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void goToSection(int index) {
    _pageController.jumpToPage(index);
  }
}
