import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/theme/app_theme.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/widgets/exam_selection_dialog.dart';
import 'package:flutter/material.dart';
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
                toolbarHeight: 65,
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
            if (tabindex == 0 && selectedExam != null)
              buildSubjectList(selectedExam!.subjects),
            if (tabindex == 1 && selectedExam != null)
              buildTestList(selectedExam!.tests),
          ],
        ),
      ),
    );
  }

  Widget buildTestList(List<Test> tests) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverList.separated(
        itemCount: tests.length,
        separatorBuilder: (context, index) => Gap(12),
        itemBuilder: (context, index) {
          final test = tests[index];
          return ListTile(
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
          );
        },
      ),
    );
  }

  Widget buildSubjectList(List<Subject> subjects) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverList.separated(
        itemCount: subjects.length,
        separatorBuilder: (context, index) => Gap(12),
        itemBuilder: (context, index) {
          return ListTile(
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
          );
        },
      ),
    );
  }

  Widget buildTitlebar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => showExamSelectionDialog(),
            child: Row(
              spacing: 4,
              children: [
                Text(
                  selectedExam!.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
          Gap(6),
          Text(
            '${selectedExam!.subjects.length} Subjects,  ${selectedExam!.questionsCount} Questions',
            maxLines: 2,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }

  void showExamSelectionDialog() async {
    AppTheme.setLightStatusBarTheme();
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: selectedExam != null,
      enableDrag: selectedExam != null,
      shape: Border(),
      barrierColor: Colors.transparent,
      builder: (context) => ExamSelectionDialog(
        isDissmissable: selectedExam != null,
        close: (selectedExam) {
          AppTheme.setLightStatusBarTheme();
          if (selectedExam != null) {
            context.read<ExamCubit>().selectUserExam(selectedExam);
          }
        },
      ),
    );
  }
}
