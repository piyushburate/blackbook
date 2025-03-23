import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_exam.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_qset_attempted_questions.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_qset.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_subject.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_exams.dart';
import 'package:blackbook/features/dashboard/domain/usecases/save_qset_attempted_question.dart';
import 'package:blackbook/features/dashboard/domain/usecases/select_exam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final AppUserCubit _appUserCubit;
  final ListExams _listExams;
  final SelectExam _selectExam;
  final GetExam _getExam;
  final GetSubject _getSubject;
  final GetQset _getQset;
  final SaveQsetAttemptedQuestion _saveAttemptedQuestion;
  final GetQsetAttemptedQuestions _getAttemptedQuestions;
  ExamCubit({
    required AppUserCubit appUserCubit,
    required ListExams listExams,
    required SelectExam selectExam,
    required GetExam getExam,
    required GetSubject getSubject,
    required GetQset getQset,
    required SaveQsetAttemptedQuestion saveAttemptedQuestion,
    required GetQsetAttemptedQuestions getAttemptedQuestions,
  })  : _appUserCubit = appUserCubit,
        _listExams = listExams,
        _selectExam = selectExam,
        _getExam = getExam,
        _getSubject = getSubject,
        _getQset = getQset,
        _saveAttemptedQuestion = saveAttemptedQuestion,
        _getAttemptedQuestions = getAttemptedQuestions,
        super(ExamInitial());

  Future<List<Exam>> listExams() async {
    List<Exam> result = [];
    final response = await _listExams(NoParams());
    response.fold(
      (failure) {},
      (exams) => result = exams,
    );
    return result;
  }

  void selectUserExam(Exam exam) async {
    final currentState = state;
    emit(ExamLoading());
    final response = await _selectExam(SelectExamParams(exam));
    response.fold(
      (failure) {
        if (currentState is! ExamSelected) {
          emit(ExamFailure(failure.message));
        } else {
          EasyLoading.showError(failure.message);
          emit(currentState);
        }
      },
      (newExam) {
        GetIt.instance<AppUserCubit>().updateExam(newExam);
        emit(ExamSelected(newExam));
      },
    );
  }

  Future<Exam?> getExamFromId(String id) async {
    Exam? result;
    final response = await _getExam(GetExamParams(id));
    response.fold(
      (failure) {
        EasyLoading.showToast(failure.message.toString());
      },
      (exam) => result = exam,
    );
    return result;
  }

  Future<Subject?> getSubjectFromId(String id) async {
    Subject? result;
    final response = await _getSubject(GetSubjectParams(id));
    response.fold(
      (failure) {
        EasyLoading.showToast(failure.message.toString());
      },
      (subject) => result = subject,
    );
    return result;
  }

  Future<Qset?> getQsetFromId(String id) async {
    Qset? result;
    final response = await _getQset(GetQsetParams(id));
    response.fold(
      (failure) {
        EasyLoading.showToast(failure.message.toString());
      },
      (qset) => result = qset,
    );
    return result;
  }

  Future<QsetAttemptedQuestion?> saveQsetAttemptedQuestion({
    required QsetQuestion question,
    required QuestionOption option,
    required int time,
  }) async {
    QsetAttemptedQuestion? result;
    final appUserState = _appUserCubit.state;
    if (appUserState is AppUserAuthorized) {
      final response =
          await _saveAttemptedQuestion(SaveQsetAttemptedQuestionParams(
        authUser: appUserState.authUser,
        question: question,
        option: option,
        time: time,
      ));
      response.fold(
        (failure) {
          EasyLoading.showToast(failure.message.toString());
        },
        (attemptedQuestion) => result = attemptedQuestion,
      );
    }
    return result;
  }

  Future<List<QsetAttemptedQuestion>> getQsetAttemptedQuestions(
      Qset qset) async {
    List<QsetAttemptedQuestion> result = [];
    final appUserState = _appUserCubit.state;
    if (appUserState is AppUserAuthorized) {
      final response =
          await _getAttemptedQuestions(GetQsetAttemptedQuestionsParams(
        authUser: appUserState.authUser,
        qset: qset,
      ));
      response.fold(
        (failure) {
          EasyLoading.showToast(failure.message.toString());
        },
        (attemptedQuestionList) => result = attemptedQuestionList,
      );
    }
    return result;
  }
}
