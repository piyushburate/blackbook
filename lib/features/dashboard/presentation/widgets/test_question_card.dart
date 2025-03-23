import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/widgets/app_latex_viewer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_theme.dart';

class TestQuestionCard extends StatelessWidget {
  final TestQuestion question;
  final int index;
  final int length;
  final QuestionOption? selectedOption;
  final void Function(QuestionOption? option)? onOptionSeleted;
  const TestQuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.length,
    required this.selectedOption,
    this.onOptionSeleted,
  });

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
                'Question ${index + 1} of $length',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(140),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Gap(8),
              AppLatexViewer(question.title),
              Gap(15),
              if (question.reference?.isNotEmpty == true)
                AppLatexViewer(
                  question.reference?.trim() ?? '',
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
              question.options.length,
              (optionIndex) {
                final bool isSelected = selectedOption?.index == optionIndex;
                return Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    onTap: () {
                      final option = isSelected
                          ? null
                          : QuestionOption.values[optionIndex];
                      // setState(() {});
                      if (onOptionSeleted != null) {
                        onOptionSeleted!(option);
                      }
                    },
                    selected: isSelected,
                    tileColor: Colors.transparent,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    selectedTileColor:
                        Theme.of(context).colorScheme.primary.withAlpha(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        width: 2,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .extension<AppColors>()!
                                .borderLightColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    trailing: isSelected ? Icon(Icons.check) : null,
                    titleTextStyle: Theme.of(context).textTheme.titleSmall,
                    title: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${QuestionOption.values[optionIndex].name}.'),
                        Expanded(
                          child: AppLatexViewer(
                              question.options[optionIndex].trim()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
