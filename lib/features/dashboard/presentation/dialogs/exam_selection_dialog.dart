import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/core/common/widgets/search_input_field.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class ExamSelectionDialog extends StatefulWidget {
  final bool isDissmissable;
  final void Function(Exam? selectedExam) close;
  const ExamSelectionDialog({
    super.key,
    this.isDissmissable = true,
    required this.close,
  });

  @override
  State<ExamSelectionDialog> createState() => _ExamSelectionDialogState();
}

class _ExamSelectionDialogState extends State<ExamSelectionDialog> {
  final _searchController = TextEditingController();
  List<Exam>? exams;
  String? searchQuery;
  @override
  void initState() {
    GetIt.instance<ExamCubit>().listExams().then((value) {
      setState(() {
        exams = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: !widget.isDissmissable,
            toolbarHeight: 70,
            titleSpacing: 25,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: Border(),
            title: Text(
              'Choose exam',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).extension<AppColors>()?.darkTextColor,
              ),
            ),
            actions: [
              if (widget.isDissmissable)
                IconButton(
                  onPressed: () => selectExam(null),
                  icon: Icon(Icons.close),
                ),
              if (widget.isDissmissable) Gap(20),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchInputField(
                  controller: _searchController,
                  hintText: "Search topic...",
                  onChanged: (value) {
                    searchQuery = value;
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          const SliverGap(20),
          (exams == null)
              ? SliverFillRemaining(child: AppLoader())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.list(
                    children: List.generate(
                      exams!.length,
                      (examIndex) {
                        final exam = exams![examIndex];
                        if (searchQuery != null && searchQuery != '') {
                          if (!exam.name
                              .toLowerCase()
                              .contains(searchQuery!.toLowerCase())) {
                            return SizedBox();
                          }
                        }
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: () => selectExam(exam),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                            ),
                            title: Text(
                              exam.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              '${exam.subjects.length} subjects, ${exam.questionsCount} questions',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(120),
                                  ),
                            ),
                          ),
                        ).animate(delay: (examIndex * 100).ms).slideX().fade();
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void selectExam(Exam? selectedExam) {
    widget.close(selectedExam);
    context.pop();
  }
}
