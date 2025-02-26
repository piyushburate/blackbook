import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/entities/test.dart';

class Exam {
  final String id;
  final String name;
  final List<Subject> subjects;
  final List<Test> tests;

  int get chaptersCount {
    int count = 0;
    for (var subject in subjects) {
      count += subject.chaptersCount;
    }
    return count;
  }

  int get questionsCount {
    int count = 0;
    for (var subject in subjects) {
      count += subject.questionsCount;
    }
    return count;
  }

  const Exam({
    required this.id,
    required this.name,
    required this.subjects,
    required this.tests,
  });
}
