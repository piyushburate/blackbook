import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/subject.dart';

class Qset {
  final String id;
  final String title;
  final Subject subject;

  final List<QsetQuestion> questions;

  Qset({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
  });
}
