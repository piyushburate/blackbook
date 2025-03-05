import 'package:blackbook/features/dashboard/presentation/cubits/page_timer/page_timer_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/qset_question_card.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/timebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';

import '../../../../core/common/entities/attempted_question.dart';
import '../../../../core/common/entities/qset.dart';
import '../../../../core/common/entities/question.dart';
import '../../../../core/common/pages/error_page.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_loader.dart';
import '../cubits/exam/exam_cubit.dart';

class PracticePage extends StatefulWidget {
  final String id;
  final String? initialQuestionId;
  const PracticePage(this.id, {super.key, this.initialQuestionId});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final _pageCtrl = PageController();
  Qset? qset;
  bool? loading;
  int currentPage = 0;
  late List<QsetAttemptedQuestion?> attempts;
  late List<QuestionOption?> answers;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchQset();
    });
  }

  void fetchQset() async {
    if (loading != null) {
      setState(() => loading = true);
    }
    final data = await context.read<ExamCubit>().getQsetFromId(widget.id);

    if (data != null) {
      qset = data;
      if (widget.initialQuestionId != null && qset != null) {
        answers = List.generate(qset!.questions.length, (index) => null);
        attempts = List.generate(qset!.questions.length, (index) => null);
        final index =
            qset!.questions.indexWhere((e) => e.id == widget.initialQuestionId);
        if (index > 0 && index < qset!.questions.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _pageCtrl.jumpToPage(index);
            currentPage = index;
          });
        }
      }
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading == null) {
      return AppLoader();
    }
    if (qset == null) {
      return ErrorPage(
        onRetry: fetchQset,
      );
    }
    if (qset!.questions.isEmpty) {
      return ErrorPage(
        title: 'No questions found',
        onRetry: fetchQset,
      );
    }

    return BlocProvider<PageTimerCubit>(
      create: (context) => PageTimerCubit(
        length: qset!.questions.length,
      ),
      child: BlocBuilder<PageTimerCubit, int>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(qset!.title),
                titleSpacing: 0,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert, size: 18),
                  ),
                  const Gap(12),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Timebar(
                      timer: context.read<PageTimerCubit>().timer,
                    ),
                  ),
                ),
              ),
              body: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageCtrl,
                itemCount: qset!.questions.length,
                onPageChanged: (value) => _onPageChanged(value, context),
                itemBuilder: (context, index) {
                  return QsetQuestionCard(
                    question: qset!.questions[index],
                    index: index,
                    length: qset!.questions.length,
                    attempt: attempts[index],
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
                    Expanded(
                      child: BlocBuilder<PageTimerCubit, int>(
                        builder: (context, state) {
                          return AppButton(
                            text: 'Check Answer',
                            onPressed: (answers[currentPage] == null ||
                                    attempts[currentPage] != null)
                                ? null
                                : () => checkAnswer(context),
                          );
                        },
                      ),
                    ),
                    SizedBox.square(
                      dimension: 50,
                      child: IconButton.outlined(
                        iconSize: 18,
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: (currentPage < (qset!.questions.length - 1))
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
    );
  }

  void _onPageChanged(int value, BuildContext context) {
    final newPage = _pageCtrl.page?.round();
    if (newPage != null && newPage != currentPage) {
      setState(() {
        currentPage = value;
      });
      context
          .read<PageTimerCubit>()
          .changeIndex(value, (attempts[currentPage] == null));
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

  void checkAnswer(BuildContext context) async {
    EasyLoading.show();
    context.read<PageTimerCubit>().saveTimer();
    final attemptedQuestion =
        await context.read<ExamCubit>().saveQsetAttemptedQuestion(
              question: qset!.questions[currentPage],
              option: answers[currentPage]!,
              time: context.read<PageTimerCubit>().timers[currentPage] ?? -1,
            );
    if (attemptedQuestion != null) {
      attempts[currentPage] = attemptedQuestion;
    }
    EasyLoading.dismiss();
    setState(() {});
  }
}
