import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/pages/error_page.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/features/auth/presentation/pages/complete_registration_page.dart';
import 'package:blackbook/features/auth/presentation/pages/login_page.dart';
import 'package:blackbook/features/auth/presentation/pages/signup_page.dart';
import 'package:blackbook/features/auth/presentation/pages/verify_otp_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/dashboard/dashboard_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/practice_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/qset_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/subject_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/test/test_page.dart';
import 'package:blackbook/features/dashboard/presentation/pages/test/test_result_page.dart';
import 'package:blackbook/features/settings/presentation/pages/account_settings_page.dart';
import 'package:blackbook/features/settings/presentation/pages/change_password_page.dart';
import 'package:blackbook/features/settings/presentation/pages/edit_personal_details_page.dart';
import 'package:blackbook/features/settings/presentation/pages/set_app_theme_page.dart';
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
    errorBuilder: (context, state) => ErrorPage(),
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
          return SubjectPage(state.pathParameters['id'] ?? '');
        },
      ),
      GoRoute(
        path: '/qset/:id',
        builder: (context, state) {
          return QsetPage(state.pathParameters['id'] ?? '');
        },
      ),
      GoRoute(
        path: '/qset/:id/practice',
        builder: (context, state) {
          return PracticePage(
            state.pathParameters['id'] ?? '',
            initialQuestionId: state.extra.toString(),
          );
        },
      ),
      GoRoute(
        path: '/test/:id',
        builder: (context, state) {
          return TestPage(state.pathParameters['id'] ?? '');
        },
      ),
      GoRoute(
        path: '/test/result/:id',
        builder: (context, state) {
          return TestResultPage(state.pathParameters['id'] ?? '');
        },
      ),
      GoRoute(
        path: '/settings/app_theme',
        builder: (context, state) {
          return SetAppThemePage();
        },
      ),
      GoRoute(
        path: '/settings/account_settings',
        builder: (context, state) {
          return AccountSettingsPage();
        },
      ),
      GoRoute(
        path: '/settings/account_settings/edit_personal_details',
        builder: (context, state) {
          return EditPersonalDetailsPage();
        },
      ),
      GoRoute(
        path: '/settings/account_settings/change_password',
        builder: (context, state) {
          return ChangePasswordPage();
        },
      ),
    ],
  );

  String get currentpath => router.state.uri.path;
}
