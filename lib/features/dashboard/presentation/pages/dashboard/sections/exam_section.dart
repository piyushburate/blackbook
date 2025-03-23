import 'package:blackbook/core/common/cubits/theme/theme_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/common/pages/error_page.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/exam/exam_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/cubits/test/test_cubit.dart';
import 'package:blackbook/features/dashboard/presentation/dialogs/exam_selection_dialog.dart';
import 'package:blackbook/features/dashboard/presentation/dialogs/test_attempts_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
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
  List<TestAttempt>? testAttempts = [];
  bool loading = true;
  List<String> tabs = ['Subjects', 'Tests'];

  @override
  void initState() {
    final exam = widget.authUser.selectedExam;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (exam == null) {
        showExamSelectionDialog();
      } else {
        setSelectedExam(exam);
      }
    });
    super.initState();
  }

  void setSelectedExam(Exam exam, [bool showLoading = true]) async {
    if (!loading && showLoading) {
      setState(() => loading = true);
    }

    final result = await context.read<ExamCubit>().getExamFromId(exam.id);
    if (result != null) {
      selectedExam = result;
      testAttempts =
          await GetIt.instance<TestCubit>().listTestAttempts(selectedExam!.id);
    }
    setState(() {
      loading = false;
    });
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
      child: (loading)
          ? AppLoader()
          : (selectedExam == null)
              ? ErrorPage(
                  title: 'Error Occured!',
                  subtitle: 'Unable to get exam',
                  onRetry: showExamSelectionDialog,
                  showBack: false,
                )
              : DefaultTabController(
                  length: tabs.length,
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
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
          final attempts =
              testAttempts?.where((e) => e.test.id == test.id).toList() ?? [];
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              onTap: () => openTestPage(test),
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
                (attempts.isNotEmpty)
                    ? '${attempts.length} attempts'
                    : '${test.totalQuestions} Questions  |  ${test.totalTime} mins',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              trailing: Row(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (attempts.isNotEmpty)
                    IconButton(
                      onPressed: () =>
                          showTestAttemptsBottomsheetDialog(attempts),
                      icon: Icon(Icons.history, size: 18),
                    ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12),
                ],
              ),
            ),
          ).animate().slideX().fade();
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
              onTap: () => openSubjectPage(subjects[index]),
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
          ).animate().slideX().fade();
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

  void showTestAttemptsBottomsheetDialog(List<TestAttempt> attempts) {
    GetIt.instance<ThemeCubit>().handleSystemUiOverlayStyle(
      showModalBottomSheet(
        context: context,
        useSafeArea: false,
        builder: (context) => TestAttemptsDialog(attempts),
      ),
    );
  }

  void openSubjectPage(Subject subject) async {
    await context.push(
      '/subject/${subject.id}',
    );
    setSelectedExam(selectedExam!, false);
  }

  void openTestPage(Test test) async {
    await context.push(
      '/test/${test.id}',
    );
    setSelectedExam(selectedExam!, false);
  }
}
