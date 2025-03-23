import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/features/dashboard/domain/usecases/add_test_attempt.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_test.dart';
import 'package:blackbook/features/dashboard/domain/usecases/get_test_attempt.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_test_attempts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../core/common/entities/test.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  final GetTest _getTest;
  final ListTestAttempts _listTestAttempts;
  final GetTestAttempt _getTestAttempt;
  final AddTestAttempt _addTestAttempt;
  TestCubit({
    required GetTest getTest,
    required ListTestAttempts listTestAttempts,
    required GetTestAttempt getTestAttempt,
    required AddTestAttempt addTestAttempt,
  })  : _getTest = getTest,
        _listTestAttempts = listTestAttempts,
        _getTestAttempt = getTestAttempt,
        _addTestAttempt = addTestAttempt,
        super(TestInitial());

  void loadTest(String id) async {
    emit(TestInitial());
    final test = await getTestFromId(id);
    if (test != null) {
      emit(TestStart(test));
    } else {
      emit(TestError());
    }
  }

  void startTest() {
    final state = this.state;
    if (state is TestStart) {
      emit(TestRunning(state.test));
    }
  }

  Future<Test?> getTestFromId(String id) async {
    Test? result;
    final response = await _getTest(GetTestParams(id));
    response.fold(
      (failure) => EasyLoading.showToast(failure.message.toString()),
      (test) => result = test,
    );
    return result;
  }

  Future<List<TestAttempt>> listTestAttempts(String examId) async {
    List<TestAttempt> result = [];
    final response = await _listTestAttempts(ListTestAttemptsParams(examId));
    response.fold(
      (failure) => EasyLoading.showToast(failure.message.toString()),
      (attempts) => result = attempts,
    );
    return result;
  }

  Future<TestAttempt?> getTestAttempt(String id) async {
    TestAttempt? result;
    final response = await _getTestAttempt(GetTestAttemptParams(id));
    response.fold(
      (failure) => EasyLoading.showToast(failure.message.toString()),
      (attempt) => result = attempt,
    );
    return result;
  }

  void submitTestAttempt({
    required Test test,
    required int time,
    required List<TestAttemptedQuestion> attemptedQuestions,
  }) async {
    final response = await _addTestAttempt(AddTestAttemptParams(
      test: test,
      time: time,
      attemptedQuestions: attemptedQuestions,
    ));
    response.fold(
      (failure) => EasyLoading.showToast(failure.message.toString()),
      (testAttempt) {
        emit(TestSubmitted(test, testAttempt));
      },
    );
  }

  void cancelTest() {
    emit(TestInitial());
  }
}
