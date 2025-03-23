import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/test/test_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/test_result_view.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/pages/error_page.dart';
import '../../../../../core/common/widgets/app_loader.dart';

class TestResultPage extends StatefulWidget {
  final String id;
  const TestResultPage(this.id, {super.key});

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  TestAttempt? attempt;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAttempt();
    });
  }

  void fetchAttempt() async {
    if (!loading) {
      setState(() => loading = true);
    }
    final attempt = await GetIt.instance<TestCubit>().getTestAttempt(widget.id);
    if (attempt != null) {
      this.attempt = attempt;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return AppLoader();
    }
    if (attempt == null) {
      return ErrorPage(
        title: 'Error!',
        subtitle: 'No Data Found!',
        onRetry: fetchAttempt,
        showBack: true,
      );
    }
    return TestResultView(attempt!);
  }
}
