import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/timebar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PracticePage extends StatefulWidget {
  final Qset qset;
  final String? initialQuestionId;
  const PracticePage(this.qset, {super.key, this.initialQuestionId});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late final StopWatchTimer _stopWatchTimer;
  int? currentTime;

  late final PageController _pageController;
  int currentQuestionIndex = 0;
  List<String> optionLeadings = ['A', 'B', 'C', 'D'];
  Qset get qset => widget.qset;
  List<QsetQuestion> get questions => qset.questions;
  late List<QuestionOption?> answers;
  late List<int> timers;
  late List<QsetAttemptedQuestion?> attempts;
  bool? showExplanation;

  @override
  void initState() {
    super.initState();
    answers = List.generate(questions.length, (index) => null);
    timers = List.generate(questions.length, (index) => -1);
    attempts = List.generate(questions.length, (index) => null);
    if (widget.initialQuestionId != null) {
      final index = questions
          .indexWhere((element) => element.id == widget.initialQuestionId);
      if (index > 0) {
        currentQuestionIndex = index;
      }
    }
    _pageController = PageController(initialPage: currentQuestionIndex);

    _stopWatchTimer = StopWatchTimer(
      refreshTime: 1000,
      onChangeRawSecond: (time) {
        currentTime = time;
        setState(() {});
      },
    );
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(qset.title),
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
              child: TimerBar(
                currentTime: currentTime ?? 0,
              ),
            ),
          ),
        ),
        body: buildQuestions(questions),
        bottomNavigationBar: Container(
          height: 70,
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox.square(
                dimension: 50,
                child: IconButton.outlined(
                  iconSize: 18,
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: (currentQuestionIndex > 0) ? prevBtnClick : null,
                ),
              ),
              Expanded(
                child: AppButton(
                  text: 'Check Answer',
                  onPressed: (answers[currentQuestionIndex] == null ||
                          attempts[currentQuestionIndex] != null)
                      ? null
                      : () async {
                          _stopWatchTimer.onStopTimer();
                          timers[currentQuestionIndex] = currentTime ?? -1;

                          final attemptedQuestion = await context
                              .read<ExamCubit>()
                              .saveQsetAttemptedQuestion(
                                question: questions[currentQuestionIndex],
                                option: answers[currentQuestionIndex]!,
                                time: timers[currentQuestionIndex],
                              );
                          if (attemptedQuestion != null) {
                            attempts[currentQuestionIndex] = attemptedQuestion;
                          }
                          setState(() {});
                        },
                ),
              ),
              SizedBox.square(
                dimension: 50,
                child: IconButton.outlined(
                  iconSize: 18,
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: (currentQuestionIndex < (questions.length - 1))
                      ? nextBtnClick
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestions(List<Question> questions) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (value) {
        setState(() {
          timers[currentQuestionIndex] = currentTime ?? 0;
          _stopWatchTimer.onResetTimer();
          currentTime = 0;
          currentQuestionIndex = value;
          _stopWatchTimer.setPresetSecondTime(
            timers[currentQuestionIndex],
            add: false,
          );
          if (attempts[currentQuestionIndex] == null) {
            _stopWatchTimer.onStartTimer();
          }
        });
      },
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (context, questionIndex) {
        return SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              buildQuestionCard(questionIndex),
            ],
          ),
        );
      },
    );
  }

  Widget buildQuestionCard(int questionIndex) {
    final question = questions[questionIndex];
    final bool isChecked = attempts[questionIndex] != null;
    bool isExpanded = showExplanation ?? false;
    if (showExplanation == null) {
      isExpanded = !(question.isCorrect(
          attempts[questionIndex]?.selectedOption ?? QuestionOption.none));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question ${questionIndex + 1} of ${questions.length}',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  question.title.trim(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppPallete.darkTextColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            spacing: 12,
            children: List.generate(
              question.options.length,
              (optionIndex) {
                final bool isSelected =
                    answers[questionIndex]?.index == optionIndex;
                final bool isCorrect =
                    question.isCorrect(QuestionOption.values[optionIndex]);
                return ListTile(
                  onTap: () {
                    if (isChecked) return;
                    if (currentQuestionIndex == questionIndex) {
                      if (answers[questionIndex]?.index == optionIndex) {
                        answers[questionIndex] = null;
                      } else {
                        answers[questionIndex] =
                            QuestionOption.values[optionIndex];
                      }
                    }
                    setState(() {});
                  },
                  selected: isSelected,
                  tileColor: Colors.transparent,
                  selectedColor: (isChecked && isCorrect)
                      ? Colors.green.shade800
                      : !(isChecked && isSelected)
                          ? isSelected
                              ? AppPallete.primaryColor
                              : Colors.grey.shade800
                          : Colors.red.shade800,
                  selectedTileColor: isChecked
                      ? isCorrect
                          ? Colors.green.withAlpha(10)
                          : AppPallete.errorColor.withAlpha(10)
                      : AppPallete.primaryColor.withAlpha(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      width: 2,
                      color: (isChecked && isCorrect)
                          ? Colors.green
                          : !(isChecked && isSelected)
                              ? isSelected
                                  ? AppPallete.primaryColor
                                  : AppPallete.borderLightColor
                              : Colors.red,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  trailing: (isChecked && isCorrect)
                      ? Icon(Icons.check, color: Colors.green)
                      : !(isChecked && isSelected)
                          ? isSelected
                              ? Icon(Icons.check)
                              : null
                          : Icon(Icons.close),
                  titleTextStyle:
                      Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: (isCorrect && isChecked)
                                ? Colors.green.shade800
                                : null,
                          ),
                  title: Row(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${optionLeadings[optionIndex]}.'),
                      Expanded(
                        child: Text(question.options[optionIndex].trim()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isChecked && question.explanation != null)
            Column(
              spacing: 10,
              children: [
                GestureDetector(
                  onTap: () {
                    showExplanation = !isExpanded;
                    setState(() {});
                  },
                  child: Row(
                    spacing: 3,
                    children: [
                      Text(
                        'Show Explanation',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                      ),
                    ],
                  ),
                ),
                if (isExpanded) Text(question.explanation ?? ''),
              ],
            ),
        ],
      ),
    );
  }

  void prevBtnClick() {
    _pageController.previousPage(
      duration: Durations.medium4,
      curve: Curves.easeInOut,
    );
  }

  void nextBtnClick() {
    _pageController.nextPage(
      duration: Durations.medium4,
      curve: Curves.easeInOut,
    );
  }

  void onTimeUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Time Up!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(50),
                  SizedBox(
                    height: 45,
                    child: FilledButton(
                      onPressed: () {
                        // context.pop();
                        Navigator.of(context, rootNavigator: true).pop();
                        context.replace('/mock-test/result');
                      },
                      child: const Text('View Result'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
