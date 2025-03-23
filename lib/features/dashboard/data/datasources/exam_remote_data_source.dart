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
  Future<Exam> getExamFromId(String id);
  Future<Subject> getSubjectFromId(String id);
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final sp.SupabaseClient supabaseClient;
  final AppUserCubit appUserCubit;

  const ExamRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.appUserCubit,
  });

  final examQuery =
      'id, name, subjects(id, name, qsets(id, qset_questions(id))), tests(*, exam:exams(id), test_questions(id))';

  @override
  Future<List<Exam>> listExams() async {
    final examsData = await supabaseClient
        .from('exams')
        .select(examQuery)
        .order('created_at');
    List<Exam> result = List.generate(examsData.length, (index) {
      return ExamModel.fromJson(examsData[index]);
    });
    return result;
  }

  @override
  Future<Exam> selectUserExam(Exam exam) async {
    final currentSession = supabaseClient.auth.currentSession;
    if (currentSession == null) {
      throw ServerException('User not authorized!');
    }

    await supabaseClient.from('users').update({
      'selected_exam': exam.id,
    }).eq('id', currentSession.user.id);
    return await getExamFromId(exam.id);
  }

  @override
  Future<Exam> getExamFromId(String id) async {
    final examData = await supabaseClient
        .from('exams')
        .select(examQuery)
        .eq('id', id)
        .order('created_at', referencedTable: 'subjects')
        .order('created_at', referencedTable: 'tests')
        .single();
    final result = ExamModel.fromJson(examData);
    return result;
  }

  @override
  Future<Subject> getSubjectFromId(String id) async {
    final subjectData = await supabaseClient
        .from('subjects')
        .select(
            '*, qsets(*, subject(id, name), qset_questions(id)), exam:exams(id, name)')
        .eq('id', id)
        .single();
    final result = SubjectModel.fromJson(subjectData);
    return result;
  }
}
