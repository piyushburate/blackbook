import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/cubits/theme/theme_cubit.dart';
import 'package:blackbook/core/router/app_router.dart';
import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:blackbook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blackbook/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:blackbook/features/auth/domain/usecases/complete_registration.dart';
import 'package:blackbook/features/auth/domain/usecases/current_user.dart';
import 'package:blackbook/features/auth/domain/usecases/send_otp.dart';
import 'package:blackbook/features/auth/domain/usecases/user_google_sign_in.dart';
import 'package:blackbook/features/auth/domain/usecases/user_log_in.dart';
import 'package:blackbook/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blackbook/features/auth/domain/usecases/verify_otp.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/features/dashboard/data/datasources/avatar_remote_data_source.dart';
import 'package:blackbook/features/dashboard/data/datasources/exam_remote_data_source.dart';
import 'package:blackbook/features/dashboard/data/datasources/qset_remote_data_source.dart';
import 'package:blackbook/features/dashboard/data/datasources/test_remote_data_source.dart';
import 'package:blackbook/features/dashboard/data/repositories/avatar_repository_impl.dart';
import 'package:blackbook/features/dashboard/data/repositories/exam_repository_impl.dart';
import 'package:blackbook/features/dashboard/data/repositories/qset_repository_impl.dart';
import 'package:blackbook/features/dashboard/data/repositories/test_repository_impl.dart';
import 'package:blackbook/features/dashboard/domain/repositories/avatar_repository.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:blackbook/features/dashboard/domain/repositories/qset_repository.dart';
import 'package:blackbook/features/dashboard/domain/repositories/test_repository.dart';
import 'package:blackbook/features/dashboard/domain/usecases/add_test_attempt.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_exam.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_qset_attempted_questions.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_qset.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_subject.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_test.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_test_attempt.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_avatars.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_exams.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_test_attempts.dart';
import 'package:blackbook/features/dashboard/domain/usecases/save_qset_attempted_question.dart';
import 'package:blackbook/features/dashboard/domain/usecases/select_exam.dart';
import 'package:blackbook/features/dashboard/domain/usecases/set_user_avatar.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/test/test_cubit.dart';
import 'package:blackbook/features/settings/data/datasources/profile_remote_data_source.dart';
import 'package:blackbook/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:blackbook/features/settings/domain/repositories/profile_repository.dart';
import 'package:blackbook/features/settings/domain/usecases/change_password.dart';
import 'package:blackbook/features/settings/domain/usecases/update_personal_details.dart';
import 'package:blackbook/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => GoogleSignIn(
        params: GoogleSignInParams(
          clientId: dotenv.env['GOOGLE_SIGN_IN_WEB_CLIENT_ID'],
          clientSecret: dotenv.env['GOOGLE_SIGN_IN_WEB_CLIENT_SECRET'],
        ),
      ));

  // core
  await _initTheme();
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton(() => AppRouter());

  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.dark
    ..radius = 10
    ..indicatorColor = AppPallete.whiteColor
    ..progressColor = AppPallete.whiteColor
    ..backgroundColor = Colors.white.withAlpha(0)
    ..textColor = AppPallete.whiteColor
    ..userInteractions = false
    ..dismissOnTap = false;
}

Future<void> _initTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final themeIndex = prefs.getInt('themeMode') ?? ThemeMode.light.index;
  serviceLocator
      .registerLazySingleton(() => ThemeCubit(ThemeMode.values[themeIndex]));
}

void _initAuth() {
  serviceLocator
    // DataSources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
          supabaseClient: serviceLocator(), googleSignIn: serviceLocator()),
    )
    ..registerLazySingleton<ExamRemoteDataSource>(
      () => ExamRemoteDataSourceImpl(
        appUserCubit: serviceLocator(),
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerLazySingleton<QsetRemoteDataSource>(
      () => QsetRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<TestRemoteDataSource>(
      () => TestRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<AvatarRemoteDataSource>(
      () => AvatarRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(serviceLocator()),
    )
    // Repositories
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<ExamRepository>(
      () => ExamRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<QsetRepository>(
      () => QsetRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<TestRepository>(
      () => TestRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<AvatarRepository>(
      () => AvatarRepositoryImpl(serviceLocator()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(serviceLocator()),
    )
    // UseCases
    ..registerLazySingleton<UserSignUp>(
      () => UserSignUp(serviceLocator()),
    )
    ..registerLazySingleton<UserLogIn>(
      () => UserLogIn(serviceLocator()),
    )
    ..registerLazySingleton<UserGoogleSignIn>(
      () => UserGoogleSignIn(serviceLocator()),
    )
    ..registerLazySingleton<SendOtp>(
      () => SendOtp(serviceLocator()),
    )
    ..registerLazySingleton<VerifyOtp>(
      () => VerifyOtp(serviceLocator()),
    )
    ..registerLazySingleton<CompleteRegistration>(
      () => CompleteRegistration(serviceLocator()),
    )
    ..registerLazySingleton<CurrentUser>(
      () => CurrentUser(serviceLocator()),
    )
    ..registerLazySingleton<ListExams>(
      () => ListExams(serviceLocator()),
    )
    ..registerLazySingleton<SelectExam>(
      () => SelectExam(serviceLocator()),
    )
    ..registerLazySingleton<GetExam>(
      () => GetExam(serviceLocator()),
    )
    ..registerLazySingleton<GetSubject>(
      () => GetSubject(serviceLocator()),
    )
    ..registerLazySingleton<GetQset>(
      () => GetQset(serviceLocator()),
    )
    ..registerLazySingleton<SaveQsetAttemptedQuestion>(
      () => SaveQsetAttemptedQuestion(serviceLocator()),
    )
    ..registerLazySingleton<GetQsetAttemptedQuestions>(
      () => GetQsetAttemptedQuestions(serviceLocator()),
    )
    ..registerLazySingleton<GetTest>(
      () => GetTest(serviceLocator()),
    )
    ..registerLazySingleton<ListTestAttempts>(
      () => ListTestAttempts(serviceLocator()),
    )
    ..registerLazySingleton<GetTestAttempt>(
      () => GetTestAttempt(serviceLocator()),
    )
    ..registerLazySingleton<AddTestAttempt>(
      () => AddTestAttempt(serviceLocator()),
    )
    ..registerLazySingleton<ListAvatars>(
      () => ListAvatars(serviceLocator()),
    )
    ..registerLazySingleton<SetUserAvatar>(
      () => SetUserAvatar(serviceLocator()),
    )
    ..registerLazySingleton<UpdatePersonalDetails>(
      () => UpdatePersonalDetails(serviceLocator()),
    )
    ..registerLazySingleton<ChangePassword>(
      () => ChangePassword(serviceLocator()),
    )
    // Bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        appUserCubit: serviceLocator(),
        userSignUp: serviceLocator(),
        userLogIn: serviceLocator(),
        userGoogleSignIn: serviceLocator(),
        currentUser: serviceLocator(),
        sendOtp: serviceLocator(),
        verifyOtp: serviceLocator(),
        completeRegistration: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ExamCubit>(
      () => ExamCubit(
        appUserCubit: serviceLocator(),
        listExams: serviceLocator(),
        selectExam: serviceLocator(),
        getExam: serviceLocator(),
        getSubject: serviceLocator(),
        getQset: serviceLocator(),
        saveAttemptedQuestion: serviceLocator(),
        getAttemptedQuestions: serviceLocator(),
      ),
    )
    ..registerLazySingleton<TestCubit>(
      () => TestCubit(
        getTest: serviceLocator(),
        listTestAttempts: serviceLocator(),
        getTestAttempt: serviceLocator(),
        addTestAttempt: serviceLocator(),
      ),
    )
    ..registerLazySingleton<DashboardCubit>(
      () => DashboardCubit(
        listAvatars: serviceLocator(),
        setUserAvatar: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(
        updatePersonalDetails: serviceLocator(),
        changePassword: serviceLocator(),
      ),
    );
}
