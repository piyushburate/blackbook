import 'package:blackbook/core/common/cubits/theme/theme_cubit.dart';
import 'package:blackbook/core/common/dialogs/confirm_dialog.dart';
import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/models/test_attempt_model.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/test/test_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/test_page_timer/test_page_timer_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/test_question_card.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/timebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/common/entities/question.dart';

class TestRunningSection extends StatefulWidget {
  final TestRunning testRunningState;
  const TestRunningSection(this.testRunningState, {super.key});

  @override
  State<TestRunningSection> createState() => _TestRunningSectionState();
}

class _TestRunningSectionState extends State<TestRunningSection> {
  Test get test => widget.testRunningState.test;
  BuildContext? pageTimerContext;
  final _pageCtrl = PageController();
  int currentPage = 0;
  late List<QuestionOption?> answers;

  @override
  void initState() {
    super.initState();
    answers = List.generate(test.questions.length, (index) => null);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) showExitDialog();
      },
      child: BlocProvider<TestPageTimerCubit>(
        create: (context) => TestPageTimerCubit(
          maxTime: test.totalTime,
          onTimeUp: onSubmit,
        ),
        child: BlocBuilder<TestPageTimerCubit, int>(
          builder: (context, state) {
            pageTimerContext ??= context;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(test.title),
                  titleSpacing: 0,
                  actions: [
                    AppButton(
                      isDense: true,
                      text: 'Submit',
                      onPressed: onSubmit,
                    ),
                    const Gap(12),
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(40),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Timebar(
                        timer: context.read<TestPageTimerCubit>().timer,
                        maxTime: test.totalTime * 60,
                      ),
                    ),
                  ),
                ),
                body: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageCtrl,
                  itemCount: test.questions.length,
                  onPageChanged: (value) => _onPageChanged(value, context),
                  itemBuilder: (context, index) {
                    return TestQuestionCard(
                      question: test.questions[index],
                      index: index,
                      length: test.questions.length,
                      selectedOption: answers[index],
                      onOptionSeleted: (option) {
                        setState(() {
                          answers[index] = option;
                        });
                      },
                    );
                  },
                ),
                bottomNavigationBar: Container(
                  height: 70,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox.square(
                        dimension: 50,
                        child: IconButton.outlined(
                          iconSize: 18,
                          icon: Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: (currentPage > 0) ? prevBtnClick : null,
                        ),
                      ),
                      SizedBox.square(
                        dimension: 50,
                        child: IconButton.outlined(
                          iconSize: 18,
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: (currentPage < (test.questions.length - 1))
                              ? nextBtnClick
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onPageChanged(int value, BuildContext context) {
    final newPage = _pageCtrl.page?.round();
    if (newPage != null && newPage != currentPage) {
      setState(() {
        currentPage = value;
      });
    }
  }

  void prevBtnClick() {
    _pageCtrl.previousPage(
      duration: Durations.medium4,
      curve: Curves.easeInOut,
    );
  }

  void nextBtnClick() {
    _pageCtrl.nextPage(
      duration: Durations.medium4,
      curve: Curves.easeInOut,
    );
  }

  void showSubmitDialog() async {
    final confirm =
        await GetIt.instance<ThemeCubit>().handleSystemUiOverlayStyle(
      showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          title: 'Are you sure?',
          label: 'Do you want to submit the test',
        ),
      ),
    );
    if (confirm == true) {
      onSubmit();
    }
  }

  void showExitDialog() async {
    final confirm =
        await GetIt.instance<ThemeCubit>().handleSystemUiOverlayStyle(
      showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
          title: 'Are you sure?',
          label: 'Do you want to cancel the test',
        ),
      ),
    );
    if (confirm == true) {
      context.pop();
    }
  }

  void onSubmit() async {
    pageTimerContext!.read<TestPageTimerCubit>().stopTimer();
    final time = pageTimerContext!.read<TestPageTimerCubit>().time;
    final List<TestAttemptedQuestion> attemptedQuestion = [];
    for (var i = 0; i < answers.length; i++) {
      final answer = answers[i];
      if (answer != null) {
        attemptedQuestion.add(TestAttemptedQuestion(
          selectedOption: answer,
          testAttempt: TestAttemptModel.fromJson({}),
          question: test.questions[i],
        ));
      }
    }

    context.read<TestCubit>().submitTestAttempt(
          test: test,
          time: time,
          attemptedQuestions: attemptedQuestion,
        );
  }
}
