part of 'exam_cubit.dart';

@immutable
sealed class ExamState {}

final class ExamInitial extends ExamState {}

final class ExamLoading extends ExamState {}

final class ExamSelected extends ExamState {
  final Exam exam;

  ExamSelected(this.exam);
}

final class ExamFailure extends ExamState {
  final String message;

  ExamFailure(this.message);
}
