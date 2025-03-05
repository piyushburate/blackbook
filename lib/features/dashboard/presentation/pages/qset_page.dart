import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/widgets/app_latex_viewer.dart';
import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/pages/error_page.dart';
import '../../../../core/common/widgets/app_loader.dart';
import '../cubits/exam/exam_cubit.dart';

class QsetPage extends StatefulWidget {
  final String id;
  const QsetPage(this.id, {super.key});

  @override
  State<QsetPage> createState() => _QsetPageState();
}

class _QsetPageState extends State<QsetPage> {
  Qset? qset;
  bool loading = true;

  final List<String> questionTypes = ['All', 'Unsolved', 'Solved'];
  int selectedQuestionType = 0;
  List<QsetAttemptedQuestion?> attempts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchQset();
    });
  }

  void fetchQset() async {
    if (!loading) {
      setState(() => loading = true);
    }
    final qset = await GetIt.instance<ExamCubit>().getQsetFromId(widget.id);
    if (qset != null) {
      this.qset = qset;
      await fetchAttemptedQuestions(qset);
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> fetchAttemptedQuestions(Qset qset) async {
    final attemptedQuestions =
        await GetIt.instance<ExamCubit>().getQsetAttemptedQuestions(qset);
    attempts = List.generate(
      qset.questions.length,
      (index) {
        final attemptIndex = attemptedQuestions.indexWhere(
          (element) => element.question.id == qset.questions[index].id,
        );
        if (attemptIndex != -1) {
          return attemptedQuestions[attemptIndex];
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return AppLoader();
    }
    if (qset == null) {
      return ErrorPage(
        title: 'Error!',
        subtitle: 'No Subject Found!',
        onRetry: fetchQset,
      );
    }
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              title: buildTitlebar(),
              titleSpacing: 4,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                  iconSize: 20,
                ),
                Gap(20),
              ],
            ),
            SliverGap(12),
            SliverToBoxAdapter(child: buildQestionTypeTablist()),
            buildQuestionList(qset!.questions),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionList(List<Question> questions) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverList.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final attempt = attempts[index];
          final question = questions[index];
          if (selectedQuestionType == 1 && attempt != null) {
            return SizedBox();
          }
          if (selectedQuestionType == 2 && attempt == null) {
            return SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
                onTap: () => context.push(
                  '/qset/${qset!.id}/practice',
                  extra: questions[index].id,
                ),
                trailing: (attempt == null)
                    ? Icon(Icons.arrow_forward_ios_rounded, size: 12)
                    : question.isCorrect(attempt.selectedOption)
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                horizontalTitleGap: 8,
                leading: Text('${index + 1}.',
                    style: Theme.of(context).textTheme.titleMedium),
                title: AppLatexViewer(
                  question.title,
                  maxLines: 3,
                ),
              ),
            ).animate(delay: (index * 100).ms).slideX().fade(),
          );
        },
      ),
    );
  }

  Widget buildQestionTypeTablist() {
    return Choice<int>.inline(
      value: ChoiceSingle.value(selectedQuestionType),
      itemCount: questionTypes.length,
      onChanged: ChoiceSingle.onChanged(
        (value) {
          if (value != null) {
            selectedQuestionType = value;
            setState(() {});
          }
        },
      ),
      itemBuilder: (state, i) {
        return ChoiceChip(
          selected: state.selected(i),
          onSelected: state.onSelected(i),
          label: Text(questionTypes[i]),
        );
      },
      listBuilder: ChoiceList.createScrollable(
        spacing: 12,
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      groupItemBuilder: (header, body) {
        return body;
      },
    );
  }

  Widget buildTitlebar() {
    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          qset!.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${qset!.questions.length} Questions',
          maxLines: 2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
