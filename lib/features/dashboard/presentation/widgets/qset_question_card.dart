import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/widgets/app_latex_viewer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_theme.dart';

class QsetQuestionCard extends StatefulWidget {
  final QsetQuestion question;
  final int index;
  final int length;
  final QsetAttemptedQuestion? attempt;
  final QuestionOption? selectedOption;
  final void Function(QuestionOption? option)? onOptionSeleted;
  const QsetQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.length,
    required this.attempt,
    required this.selectedOption,
    this.onOptionSeleted,
  });

  @override
  State<QsetQuestionCard> createState() => _QsetQuestionCardState();
}

class _QsetQuestionCardState extends State<QsetQuestionCard> {
  bool showExplanation = true;

  bool get isChecked => widget.attempt != null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${widget.index + 1} of ${widget.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(8),
              AppLatexViewer(widget.question.title),
              Gap(15),
              if (widget.question.reference?.isNotEmpty == true)
                AppLatexViewer(
                  widget.question.reference?.trim() ?? '',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(120),
                      ),
                ),
            ],
          ),
          Gap(20),
          Column(
            spacing: 12,
            children: List.generate(
              widget.question.options.length,
              (optionIndex) {
                final bool isSelected =
                    widget.selectedOption?.index == optionIndex;
                final bool isCorrect = widget.question
                    .isCorrect(QuestionOption.values[optionIndex]);
                return Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    onTap: () {
                      if (isChecked) return;
                      final option = isSelected
                          ? null
                          : QuestionOption.values[optionIndex];
                      // setState(() {});
                      if (widget.onOptionSeleted != null) {
                        widget.onOptionSeleted!(option);
                      }
                    },
                    selected: isSelected,
                    tileColor: Colors.transparent,
                    selectedColor: (isChecked && isCorrect)
                        ? Colors.green.shade800
                        : !(isChecked && isSelected)
                            ? isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade800
                            : Colors.red.shade800,
                    selectedTileColor: isChecked
                        ? isCorrect
                            ? Colors.green.withAlpha(10)
                            : Theme.of(context).colorScheme.error.withAlpha(10)
                        : Theme.of(context).colorScheme.primary.withAlpha(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        width: 2,
                        color: (isChecked && isCorrect)
                            ? Colors.green
                            : !(isChecked && isSelected)
                                ? isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .extension<AppColors>()!
                                        .borderLightColor
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
          if (isChecked && (widget.question.explanation?.isNotEmpty ?? false))
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
                    child: AppLatexViewer(widget.question.explanation ?? ''),
                  ),
                Gap(20),
              ],
            ),
        ],
      ),
    );
  }
}
