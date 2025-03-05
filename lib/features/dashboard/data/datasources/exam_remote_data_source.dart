import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/models/subject_model.dart';
import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/common/models/exam_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

abstract interface class ExamRemoteDataSource {
  Future<List<Exam>> listExams();
  Future<Exam> selectUserExam(Exam exam);
  Future<Subject> getSubjectFromId(String id);
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
}
