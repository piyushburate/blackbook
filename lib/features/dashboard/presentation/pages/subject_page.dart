import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/common/entities/qset.dart';
import '../../../../core/common/entities/subject.dart';
import '../../../../core/common/pages/error_page.dart';
import '../../../../core/common/widgets/app_loader.dart';
import '../cubits/exam/exam_cubit.dart';

class SubjectPage extends StatefulWidget {
  final String id;
  const SubjectPage(this.id, {super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  Subject? subject;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSubject();
    });
  }

  void fetchSubject([bool showLoading = true]) async {
    if (!loading && showLoading) {
      setState(() => loading = true);
    }
    final subject =
        await GetIt.instance<ExamCubit>().getSubjectFromId(widget.id);
    if (subject != null) {
      this.subject = subject;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return AppLoader();
    }
    if (subject == null) {
      return ErrorPage(
        title: 'Error!',
        subtitle: 'No Subject Found!',
        onRetry: fetchSubject,
      );
    }
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          shrinkWrap: true,
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
            buildQsetList(subject!.qsets),
          ],
        ),
      ),
    );
  }

  Widget buildQsetList(List<Qset> qsets) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverList.separated(
        itemCount: qsets.length,
        separatorBuilder: (context, index) => Gap(12),
        itemBuilder: (context, index) {
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              onTap: () => openQsetPage(qsets[index]),
              title: Text(
                qsets[index].title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${qsets[index].questions.length} Questions',
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
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject!.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${subject!.chaptersCount} Chapters, ${subject!.questionsCount} Questions',
          maxLines: 2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }

  void openQsetPage(Qset qset) async {
    await context.push('/qset/${qset.id}');
    fetchSubject(false);
  }
}
