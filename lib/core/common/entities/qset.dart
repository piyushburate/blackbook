import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/subject.dart';

class Qset {
  final String id;
  final String title;
  final Subject subject;
  final int time;
  final int marks;
  final int negativeMarks;
  final List<QsetQuestion> questions;

  Qset({
    required this.id,
    required this.title,
    required this.subject,
    required this.time,
    required this.marks,
    required this.negativeMarks,
    required this.questions,
  });
}
