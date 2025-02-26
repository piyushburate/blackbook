import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/subject.dart';

abstract class HomeSubject {
  final Subject selectedSubject;
  final List<Subject> subjects;

  Exam get exam => selectedSubject.exam;
  HomeSubject({
    required this.selectedSubject,
    required this.subjects,
  });
}
