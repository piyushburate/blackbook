import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SubjectPage extends StatefulWidget {
  final Subject subject;
  const SubjectPage(this.subject, {super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  Subject get subject => widget.subject;

  @override
  Widget build(BuildContext context) {
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
            buildQsetList(subject.qsets),
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
          return ListTile(
            onTap: () => context.push('/qset/${qsets[index].id}'),
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
          );
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
          subject.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${subject.chaptersCount} Chapters, ${subject.questionsCount} Questions',
          maxLines: 2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }
}
