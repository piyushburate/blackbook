import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/dialogs/exam_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ExamSection extends StatefulWidget {
  final AuthUser authUser;
  const ExamSection({super.key, required this.authUser});

  @override
  State<ExamSection> createState() => _ExamSectionState();
}

class _ExamSectionState extends State<ExamSection> {
  int tabindex = 0;
  Exam? selectedExam;
  List<String> tabs = ['Subjects', 'Tests', 'Attempted'];

  @override
  void initState() {
    final exam = widget.authUser.selectedExam;
    if (exam == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showExamSelectionDialog();
      });
    } else {
      setSelectedExam(exam);
    }
    super.initState();
  }

  void setSelectedExam(Exam exam) {
    selectedExam = exam;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamCubit, ExamState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is ExamLoading) {
          EasyLoading.show();
        }
        if (state is ExamFailure) {
          EasyLoading.showError(state.message);
        }

        if (state is ExamSelected) {
          setSelectedExam(state.exam);
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            if (selectedExam != null)
              SliverAppBar(
                pinned: true,
                toolbarHeight: 70,
                title: buildTitlebar(),
                titleSpacing: 4,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                    iconSize: 18,
                  ),
                  Gap(20),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  onTap: (value) => setState(() => tabindex = value),
                  tabs: List.generate(
                      tabs.length, (index) => Tab(text: tabs[index])),
                ),
              ),
            if (selectedExam != null)
              SliverFillRemaining(
                fillOverscroll: false,
                hasScrollBody: true,
                child: TabBarView(
                  children: [
                    buildSubjectList(selectedExam!.subjects),
                    buildTestList(selectedExam!.tests),
                    buildTestList(selectedExam!.tests),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTestList(List<Test> tests) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ListView.separated(
        itemCount: tests.length,
        separatorBuilder: (context, index) => Gap(12),
        itemBuilder: (context, index) {
          final test = tests[index];
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              onTap: () {},
              title: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  test.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              subtitle: Text(
                '${test.totalQuestions} Questions  |  ${Duration(seconds: test.totalTime).inMinutes} mins\nAttempts 3',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12),
            ),
          ).animate(delay: (index * 100).ms).slideX().fade();
        },
      ),
    );
  }

  Widget buildSubjectList(List<Subject> subjects) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ListView.separated(
        itemCount: subjects.length,
        separatorBuilder: (context, index) => Gap(12),
        itemBuilder: (context, index) {
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              onTap: () => context.push('/subject/${subjects[index].id}'),
              title: Text(
                subjects[index].name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${subjects[index].chaptersCount} Chapters,  ${subjects[index].questionsCount} Questions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12),
            ),
          ).animate(delay: (index * 100).ms).slideX().fade();
        },
      ),
    );
  }

  Widget buildTitlebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => showExamSelectionDialog(),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedExam!.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${selectedExam!.subjects.length} Subjects,  ${selectedExam!.questionsCount} Questions',
            maxLines: 2,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
                ),
          ),
        )
      ],
    );
  }

  void showExamSelectionDialog() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: selectedExam != null,
      enableDrag: false,
      shape: Border(),
      barrierColor: Colors.transparent,
      builder: (context) => ExamSelectionDialog(
        isDissmissable: selectedExam != null,
        close: (selectedExam) {
          if (selectedExam != null) {
            context.read<ExamCubit>().selectUserExam(selectedExam);
          }
        },
      ),
    );
  }
}
