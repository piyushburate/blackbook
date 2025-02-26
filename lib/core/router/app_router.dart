import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/features/auth/presentation/pages/complete_registration_page.dart';
import 'package:blackbook/features/auth/presentation/pages/login_page.dart';
import 'package:blackbook/features/auth/presentation/pages/signup_page.dart';
import 'package:blackbook/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/practice_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/qset_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/subject_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      String? redirectUrl;
      final appUserState = context.read<AppUserCubit>().state;
      final paths = state.uri.pathSegments;

      if (appUserState is AppUserAuthorized) {
        if (paths.first == 'auth') {
          redirectUrl = '/dashboard';
        }
      } else if (appUserState is AppUserLoggedIn) {
        if (appUserState.authState is AuthSuccessUnverified) {
          redirectUrl = '/auth/verify-otp';
        } else if (appUserState.authState is! AuthSuccessComplete) {
          redirectUrl = '/auth/complete-registration';
        } else if (paths.first == 'auth') {
          redirectUrl = '/dashboard';
        }
      } else if (appUserState is AppUserLoggedOut) {
        if (paths.first != 'auth' ||
            !['/auth/login', '/auth/signup'].contains(state.uri.path)) {
          redirectUrl = '/auth/login';
        }
      }
      return redirectUrl;
    },
    routes: [
      GoRoute(
        path: '/auth/:page',
        builder: (context, state) {
          final page = state.pathParameters['page'] ?? '';
          if (page == 'signup') {
            return SignupPage();
          } else if (page == 'verify-otp') {
            return VerifyOtpPage();
          } else if (page == 'complete-registration') {
            return CompleteRegistrationPage();
          } else {
            return LoginPage();
          }
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardPage(),
      ),
      GoRoute(
        path: '/subject/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return FutureBuilder(
            future: context.read<ExamCubit>().getSubjetFromId(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return AppLoader();
              }
              if (snapshot.data != null) {
                return SubjectPage(snapshot.data!);
              }
              return SizedBox();
            },
          );
        },
      ),
      GoRoute(
        path: '/qset/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return FutureBuilder(
            future: context.read<ExamCubit>().getQsetFromId(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return AppLoader();
              }
              if (snapshot.data != null) {
                return FutureBuilder(
                    future: context
                        .read<ExamCubit>()
                        .getQsetAttemptedQuestions(snapshot.data!),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState != ConnectionState.done) {
                        return AppLoader();
                      }
                      if (snapshot2.data != null) {
                        return QsetPage(
                          qset: snapshot.data!,
                          attemptedQuestions: snapshot2.data!,
                        );
                      }
                      return SizedBox();
                    });
              }
              return SizedBox();
            },
          );
        },
      ),
      GoRoute(
        path: '/qset/:id/practice',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return FutureBuilder(
            future: context.read<ExamCubit>().getQsetFromId(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return AppLoader();
              }
              if (snapshot.data != null) {
                return PracticePage(
                  snapshot.data!,
                  initialQuestionId: state.extra.toString(),
                );
              }
              return SizedBox();
            },
          );
        },
      ),
    ],
  );

  String get currentpath => router.state.uri.path;
}
