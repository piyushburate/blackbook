import 'package:blackbook/core/common/cubits/theme/theme_cubit.dart';
import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/common/entities/test_result.dart';
import 'package:blackbook/core/common/widgets/app_latex_viewer.dart';
import 'package:blackbook/core/theme/app_theme.dart';
import 'package:blackbook/core/utils/numeric_extension.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/test_result_question_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class TestResultView extends StatefulWidget {
  final TestAttempt attempt;
  const TestResultView(this.attempt, {super.key});

  @override
  State<TestResultView> createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  late final TestResult result;

  @override
  void initState() {
    super.initState();

    result = TestResult(widget.attempt);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            buildAppBar(),
            buildHeaderCard(),
            buildScoreCard(),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Your Answers',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            buildYourAnswersList(),
          ],
        ),
      ),
    );
  }

  Widget buildYourAnswersList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.separated(
        itemCount: widget.attempt.test.questions.length,
        separatorBuilder: (context, index) => Gap(10),
        itemBuilder: (context, index) {
          final question = widget.attempt.test.questions[index];
          final attemptedIndex = widget.attempt.answers
              .indexWhere((e) => e.question.id == question.id);
          TestAttemptedQuestion? attemptedQuestion;
          bool isCorrect = false;
          if (attemptedIndex != -1) {
            attemptedQuestion = widget.attempt.answers[attemptedIndex];
            isCorrect = attemptedQuestion.isCorrect();
          }
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              onTap: () {
                showTestQuestionView(
                  question: question,
                  selectedOption: attemptedQuestion?.selectedOption,
                );
              },
              title: AppLatexViewer(
                question.title,
                maxLines: 2,
              ),
              trailing: (attemptedQuestion == null)
                  ? null
                  : Material(
                      color: isCorrect ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isCorrect ? Icons.check : Icons.close,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget buildScoreCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
            ]),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildScoreLabel(
                    label: 'Time Taken',
                    value: result.timeTaken,
                    icon: Icon(Icons.timer_outlined, size: 16),
                  ),
                  VerticalDivider(),
                  buildScoreLabel(
                    label: 'Marks Obtained',
                    value: '${result.marksObtained} / ${result.totalMarks}',
                    icon: Icon(Icons.checklist_rounded, size: 18),
                  ),
                ],
              ),
            ),
            Gap(10),
            Divider(),
            Gap(10),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildScoreLabel(
                    label: 'Correct',
                    value: result.questionsCorrect.toTwoDigitString(),
                  ),
                  VerticalDivider(),
                  buildScoreLabel(
                    label: 'Wrong',
                    value: result.questionsWrong.toTwoDigitString(),
                  ),
                  VerticalDivider(),
                  buildScoreLabel(
                    label: 'Skipped',
                    value: result.questionsSkipped.toTwoDigitString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScoreLabel({
    required String label,
    required String value,
    Icon? icon,
  }) {
    return Column(
      spacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color:
                    Theme.of(context).extension<AppColors>()?.normalTextColor,
              ),
        ),
        Row(
          spacing: 8,
          children: [
            if (icon != null) icon,
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildHeaderCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
            ]),
        child: Column(
          children: [
            Text(
              'You have scored',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Gap(10),
            Text(
              '${result.percentage.toPointerAsFixed(2)} %',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'Result',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        IconButton(
          onPressed: context.pop,
          icon: Icon(Icons.close),
          iconSize: 20,
        ),
        Gap(20),
      ],
    );
  }

  void showTestQuestionView({
    required TestQuestion question,
    QuestionOption? selectedOption,
  }) {
    GetIt.instance<ThemeCubit>().handleSystemUiOverlayStyle(
      showDialog(
        context: context,
        builder: (context) {
          return TestResultQuestionCard(
            question: question,
            selectedOption: selectedOption,
          );
        },
      ),
    );
  }
}
