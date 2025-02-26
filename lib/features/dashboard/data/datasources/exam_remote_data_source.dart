import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/models/attempted_question_model.dart';
import 'package:blackbook/core/common/models/qset_model.dart';
import 'package:blackbook/core/common/models/subject_model.dart';
import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/common/models/exam_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

abstract interface class ExamRemoteDataSource {
  Future<List<Exam>> listExams();
  Future<Exam> selectUserExam(Exam exam);
  Future<Subject> getSubjectFromId(String id);
  Future<Qset> getQsetFromId(String id);
  Future<QsetAttemptedQuestion> saveQsetAttemptedQuestion(
    AuthUser authUser,
    QsetQuestion question,
    QuestionOption option,
    int time,
  );
  Future<List<QsetAttemptedQuestion>> getQsetAttemptedQuestions(
    AuthUser authUser,
    Qset qset,
  );
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final sp.SupabaseClient supabaseClient;
  final AppUserCubit appUserCubit;

  const ExamRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.appUserCubit,
  });

  @override
  Future<List<Exam>> listExams() async {
    try {
      final examsData = await supabaseClient
          .from('exams')
          .select(
              '*, subjects(id, name, exam:exams(*), qsets(id, qset_questions(id))), tests(*, exam:exams(id), test_questions(id)))')
          .order('created_at');
      List<Exam> result = List.generate(examsData.length, (index) {
        return ExamModel.fromJson(examsData[index]);
      });
      return result;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Exam> selectUserExam(Exam exam) async {
    try {
      final currentSession = supabaseClient.auth.currentSession;
      if (currentSession == null) {
        throw ServerException('User not authorized!');
      }

      final data = await supabaseClient
          .from('users')
          .update({
            'selected_exam': exam.id,
          })
          .eq('id', currentSession.user.id)
          .select(
              'selected_exam:exams(*, subjects(id, name, qsets(id, qset_questions(id))), tests(*, exam:exams(id), test_questions(id)))')
          .single();
      if (data['selected_exam'] != null) {
        return ExamModel.fromJson(data['selected_exam']);
      }
      throw ServerException('Error occured!');
    } on sp.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Subject> getSubjectFromId(String id) async {
    try {
      final subjectData = await supabaseClient
          .from('subjects')
          .select(
              '*, qsets(*, subject(id, name), qset_questions(id)), exam:exams(id, name)')
          .eq('id', id)
          .order('created_at');
      if (subjectData.isEmpty) {
        throw ServerException('Subject not found!');
      }
      final result = SubjectModel.fromJson(subjectData.first);
      return result;
    } on sp.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Qset> getQsetFromId(String id) async {
    try {
      final qsetData = await supabaseClient
          .from('qsets')
          .select(
              '*, subject(*, exam:exams(id, name)), qset_questions(*, qset:qsets(id))')
          .eq('id', id)
          .order('created_at');
      if (qsetData.isEmpty) {
        throw ServerException('Question set not found!');
      }
      final result = QsetModel.fromJson(qsetData.first);
      return result;
    } on sp.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<QsetAttemptedQuestion> saveQsetAttemptedQuestion(
    AuthUser authUser,
    QsetQuestion question,
    QuestionOption option,
    int time,
  ) async {
    try {
      final response = await supabaseClient
          .from('qset_attempted_questions')
          .upsert(
            {
              'user': authUser.id,
              'qset_question': question.id,
              'selected_option': option.name,
              'time': time,
            },
            onConflict: 'user, qset_question',
          )
          .select('selected_option, time')
          .single();
      return QsetAttemptedQuestionModel.fromJson(response);
    } on sp.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<QsetAttemptedQuestion>> getQsetAttemptedQuestions(
    AuthUser authUser,
    Qset qset,
  ) async {
    try {
      final response = await supabaseClient
          .from('qset_attempted_questions')
          .select(
              '*, user:users(id), qset_question:qset_questions(*, qset:qsets(id))')
          .eq('user.id', authUser.id)
          .eq('qset_question.qset.id', qset.id);
      List<QsetAttemptedQuestion> result =
          List.generate(response.length, (index) {
        return QsetAttemptedQuestionModel.fromJson(response[index]);
      });
      return result;
    } on sp.AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
