import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/common/models/test_attempt_model.dart';
import 'package:blackbook/core/common/models/test_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

abstract interface class TestRemoteDataSource {
  Future<Test> getTestFromId(String id);
  Future<List<TestAttempt>> listAttempts(String examId);
  Future<TestAttempt> getAttemptFromId(String id);
  Future<TestAttempt> addAttempt({
    required Test test,
    required int time,
    required List<TestAttemptedQuestion> attemptedQuestions,
  });
}

class TestRemoteDataSourceImpl implements TestRemoteDataSource {
  final sp.SupabaseClient supabaseClient;

  const TestRemoteDataSourceImpl(this.supabaseClient);

  final testAttemptQuery = '''
            *,
            test:tests(*, 
              exam:exams(id, name),
              test_questions(*,
                test:tests(id),
                subject:subjects(*, exam:exams(id, name))
              )
            ),
            user:users(id),
            answers:test_attempted_questions(
              selected_option,
              test_question:test_questions(*,
                test:tests(id),
                subject(*, exam:exam(id, name))
              )
            )
            ''';

  @override
  Future<Test> getTestFromId(String id) async {
    final testData = await supabaseClient
        .from('tests')
        .select(
            '*, exam:exams(id, name, subjects(*, exam:exams(id))), test_questions(*, test:tests(id), subject:subjects(id, name))')
        .eq('id', id)
        .order('created_at')
        .single();
    return TestModel.fromJson(testData);
  }

  @override
  Future<List<TestAttempt>> listAttempts(String examId) async {
    final userId = supabaseClient.auth.currentSession!.user.id;
    final attemptsData = await supabaseClient
        .from('test_attempts')
        .select(testAttemptQuery)
        .eq('test.exam.id', examId)
        .eq('user', userId)
        .order('created_at', ascending: true);
    List<TestAttempt> result = List.generate(attemptsData.length, (index) {
      return TestAttemptModel.fromJson(attemptsData[index]);
    });
    return result;
  }

  @override
  Future<TestAttempt> getAttemptFromId(String id) async {
    final attempt = await supabaseClient
        .from('test_attempts')
        .select(testAttemptQuery)
        .eq('id', id)
        .single();
    return TestAttemptModel.fromJson(attempt);
  }

  @override
  Future<TestAttempt> addAttempt({
    required Test test,
    required int time,
    required List<TestAttemptedQuestion> attemptedQuestions,
  }) async {
    final userId = supabaseClient.auth.currentSession!.user.id;
    List<Map<String, dynamic>> answers = List.generate(
      attemptedQuestions.length,
      (index) {
        return {
          'test_question_id': attemptedQuestions[index].question.id,
          'selected_option': attemptedQuestions[index].selectedOption.name,
        };
      },
    );

    final response =
        await supabaseClient.rpc('perform_test_submission', params: {
      'test_id': test.id,
      'user_id': userId,
      'ttime': time,
      'attempted_questions': answers,
    });
    if (response == null || response.toString().isEmpty) {
      throw 'Error Submitting Test';
    }
    final attempt = await getAttemptFromId(response.toString());
    return attempt;
  }
}
