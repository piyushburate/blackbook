import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/init_dependencies.dart';
import 'package:blackbook/core/router/app_router.dart';
import 'package:blackbook/core/theme/app_theme.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ExamCubit>(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    AppTheme.setLightStatusBarTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BLACKBOOK',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routerConfig: serviceLocator<AppRouter>().router,
      builder: EasyLoading.init(),
    );
  }
}
