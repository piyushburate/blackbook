import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/test/test_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class TestStartSection extends StatefulWidget {
  final TestStart testStartState;
  const TestStartSection(this.testStartState, {super.key});

  @override
  State<TestStartSection> createState() => _TestStartSectionState();
}

class _TestStartSectionState extends State<TestStartSection> {
  Test get test => widget.testStartState.test;

  void startTest() {
    context.read<TestCubit>().startTest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Start Test'),
          toolbarHeight: 50,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeadbar(),
              Gap(20),
              buildTestDetails(context),
              Gap(20),
              Divider(),
              Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Before you start',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  GptMarkdown(
                    """- You must complete this test in one session - make sure internet is reliable.
- Marks awarded for a correct answer. Negative marking will be there for wronganswer.
- Result will be shown after the test is completed.
- Correct answer will be provided for each question with explanation.""",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(150),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: AppButton(
            text: 'Start Test',
            trailing: Icon(Icons.arrow_forward),
            onPressed: startTest,
          ),
        ),
      ),
    );
  }

  Widget buildTestDetails(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailItem(
          title: test.totalQuestions.toString(),
          subtitle: 'Multiple Choice Questions',
          icon: Icons.list,
        ),
        buildDetailItem(
          title: '${test.totalTime} Mins',
          subtitle: 'Total Test Time',
          icon: Icons.timer_outlined,
        ),
        buildDetailItem(
          title: "${getMarkingSystem()} Marks",
          subtitle: 'Per Question',
          icon: Icons.checklist,
        ),
      ],
    );
  }

  String getMarkingSystem() {
    final subjects = test.exam.subjects;
    List<int> marks = List<int>.generate(
      subjects.length,
      (index) => subjects[index].marks,
    ).toSet().toList();
    return marks.join('/');
  }

  Widget buildDetailItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      spacing: 12,
      children: [
        Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(width: 1),
          ),
          child: SizedBox.square(
            dimension: 50,
            child: Icon(icon),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              subtitle,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildHeadbar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          test.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
