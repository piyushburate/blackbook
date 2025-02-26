import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class QsetPage extends StatefulWidget {
  final Qset qset;
  final List<QsetAttemptedQuestion> attemptedQuestions;
  const QsetPage(
      {super.key, required this.qset, required this.attemptedQuestions});

  @override
  State<QsetPage> createState() => _QsetPageState();
}

class _QsetPageState extends State<QsetPage> {
  final List<String> questionTypes = ['All', 'Unsolved', 'Solved'];
  int selectedQuestionType = 0;
  Qset get qset => widget.qset;
  late List<QsetAttemptedQuestion?> attempts;

  @override
  void initState() {
    super.initState();
    attempts = List.generate(
      widget.qset.questions.length,
      (index) {
        final attemptIndex = widget.attemptedQuestions.indexWhere(
          (element) => element.question.id == qset.questions[index].id,
        );
        if (attemptIndex != -1) {
          return widget.attemptedQuestions[attemptIndex];
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
            SliverGap(12),
            SliverToBoxAdapter(child: buildQestionTypeTablist()),
            buildQuestionList(qset.questions),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionList(List<Question> questions) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      sliver: SliverList.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final attempt = attempts[index];
          final question = questions[index];
          if (selectedQuestionType == 1 && attempt != null) {
            return SizedBox();
          }
          if (selectedQuestionType == 2 && attempt == null) {
            return SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => context.push(
                '/qset/${qset.id}/practice',
                extra: questions[index].id,
              ),
              leading: Text('${index + 1}.'),
              trailing: (attempt == null)
                  ? Icon(Icons.arrow_forward_ios_rounded, size: 12)
                  : question.isCorrect(attempt.selectedOption)
                      ? Icon(Icons.check, color: Colors.green)
                      : Icon(Icons.close, color: Colors.red),
              horizontalTitleGap: 0,
              title: Text(
                question.title.trim(),
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildQestionTypeTablist() {
    return Choice<int>.inline(
      value: ChoiceSingle.value(selectedQuestionType),
      itemCount: questionTypes.length,
      onChanged: ChoiceSingle.onChanged(
        (value) {
          if (value != null) {
            selectedQuestionType = value;
            setState(() {});
          }
        },
      ),
      itemBuilder: (state, i) {
        return ChoiceChip(
          selected: state.selected(i),
          onSelected: state.onSelected(i),
          label: Text(questionTypes[i]),
        );
      },
      listBuilder: ChoiceList.createScrollable(
        spacing: 12,
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      groupItemBuilder: (header, body) {
        return body;
      },
    );
  }

  Widget buildTitlebar() {
    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          qset.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${qset.questions.length} Questions',
          maxLines: 2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
