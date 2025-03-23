import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/widgets/app_latex_viewer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class TestResultQuestionCard extends StatefulWidget {
  final TestQuestion question;
  final QuestionOption? selectedOption;
  const TestResultQuestionCard({
    super.key,
    required this.question,
    required this.selectedOption,
  });

  @override
  State<TestResultQuestionCard> createState() => _TestResultQuestionCardState();
}

class _TestResultQuestionCardState extends State<TestResultQuestionCard> {
  bool showExplanation = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 380),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question Review',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    iconSize: 30,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Gap(10),
              AppLatexViewer(widget.question.title),
              Gap(15),
              Column(
                spacing: 12,
                children: List.generate(
                  widget.question.options.length,
                  (optionIndex) {
                    final bool isSelected =
                        widget.selectedOption?.index == optionIndex;
                    final isCorrect =
                        widget.question.answer.index == optionIndex;
                    return Material(
                      type: MaterialType.transparency,
                      child: ListTile(
                        selected: isSelected,
                        tileColor: Colors.transparent,
                        selectedColor: isCorrect
                            ? Colors.green.shade800
                            : isSelected
                                ? Theme.of(context).colorScheme.error
                                : Colors.grey.shade800,
                        selectedTileColor: isCorrect
                            ? Colors.green.withAlpha(10)
                            : Theme.of(context).colorScheme.error.withAlpha(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                            width: 2,
                            color: isCorrect
                                ? Colors.green
                                : isSelected
                                    ? Colors.red
                                    : Theme.of(context)
                                        .extension<AppColors>()!
                                        .borderLightColor,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        trailing: isCorrect
                            ? Icon(Icons.check, color: Colors.green)
                            : isSelected
                                ? Icon(Icons.close)
                                : null,
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              color: isCorrect ? Colors.green.shade800 : null,
                            ),
                        title: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${QuestionOption.values[optionIndex].name}.'),
                            Expanded(
                              child: AppLatexViewer(
                                  widget.question.options[optionIndex].trim()),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gap(20),
              if (widget.question.explanation?.isNotEmpty ?? false)
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showExplanation = !showExplanation;
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
                            showExplanation
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                          ),
                        ],
                      ),
                    ),
                    if (showExplanation)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child:
                            AppLatexViewer(widget.question.explanation ?? ''),
                      ),
                    Gap(20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
