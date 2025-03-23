import 'package:blackbook/features/dashboard/presentation/cubits/test/test_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/pages/test/sections/test_running_section.dart';
import 'package:blackbook/features/dashboard/presentation/pages/test/sections/test_start_section.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/test_result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/common/pages/error_page.dart';
import '../../../../../core/common/widgets/app_loader.dart';

class TestPage extends StatefulWidget {
  final String id;
  const TestPage(this.id, {super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTest();
    });
  }

  @override
  void dispose() {
    GetIt.instance<TestCubit>().cancelTest();
    super.dispose();
  }

  void fetchTest() async {
    context.read<TestCubit>().loadTest(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestCubit, TestState>(
      builder: (context, state) {
        if (state is TestError) {
          return ErrorPage(
            title: 'Error!',
            subtitle: 'No Test Found!',
            onRetry: fetchTest,
          );
        }
        if (state is TestLoaded) {
          if (state is TestStart) {
            return TestStartSection(state);
          }
          if (state is TestRunning) {
            return TestRunningSection(state);
          }
          if (state is TestSubmitted) {
            return TestResultView(state.attempt);
          }
        }
        return AppLoader();
      },
    );
  }
}
