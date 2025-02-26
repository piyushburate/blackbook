import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/router/app_router.dart';
import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:blackbook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blackbook/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:blackbook/features/auth/domain/usecases/complete_registration.dart';
import 'package:blackbook/features/auth/domain/usecases/current_user.dart';
import 'package:blackbook/features/auth/domain/usecases/send_otp.dart';
import 'package:blackbook/features/auth/domain/usecases/user_log_in.dart';
import 'package:blackbook/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blackbook/features/auth/domain/usecases/verify_otp.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/features/dashboard/data/datasources/exam_remote_data_source.dart';
import 'package:blackbook/features/dashboard/data/repositories/exam_repository_impl.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_qset_attempted_questions.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_qset.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_subject.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_exams.dart';
import 'package:blackbook/features/dashboard/domain/usecases/save_qset_attempted_question.dart';
import 'package:blackbook/features/dashboard/domain/usecases/select_exam.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  if (supabase.client.auth.currentSession == null) {
    await supabase.client.auth.signInWithPassword(
      email: 'buratepiyush@gmail.com',
      password: 'Piyush@815',
    );
  }

  // core
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

void _initAuth() {
  serviceLocator
    // DataSources
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<ExamRemoteDataSource>(
      () => ExamRemoteDataSourceImpl(
        appUserCubit: serviceLocator(),
        supabaseClient: serviceLocator(),
      ),
    )
    // Repositories
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<ExamRepository>(
      () => ExamRepositoryImpl(serviceLocator()),
    )
    // UseCases
    ..registerFactory<UserSignUp>(
      () => UserSignUp(serviceLocator()),
    )
    ..registerFactory<UserLogIn>(
      () => UserLogIn(serviceLocator()),
    )
    ..registerFactory<SendOtp>(
      () => SendOtp(serviceLocator()),
    )
    ..registerFactory<VerifyOtp>(
      () => VerifyOtp(serviceLocator()),
    )
    ..registerFactory<CompleteRegistration>(
      () => CompleteRegistration(serviceLocator()),
    )
    ..registerFactory<CurrentUser>(
      () => CurrentUser(serviceLocator()),
    )
    ..registerFactory<ListExams>(
      () => ListExams(serviceLocator()),
    )
    ..registerFactory<SelectExam>(
      () => SelectExam(serviceLocator()),
    )
    ..registerFactory<GetSubject>(
      () => GetSubject(serviceLocator()),
    )
    ..registerFactory<GetQset>(
      () => GetQset(serviceLocator()),
    )
    ..registerFactory<SaveQsetAttemptedQuestion>(
      () => SaveQsetAttemptedQuestion(serviceLocator()),
    )
    ..registerFactory<GetQsetAttemptedQuestions>(
      () => GetQsetAttemptedQuestions(serviceLocator()),
    )
    // Bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        appUserCubit: serviceLocator(),
        userSignUp: serviceLocator(),
        userLogIn: serviceLocator(),
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
        getSubject: serviceLocator(),
        getQset: serviceLocator(),
        saveAttemptedQuestion: serviceLocator(),
        getAttemptedQuestions: serviceLocator(),
      ),
    );
}
