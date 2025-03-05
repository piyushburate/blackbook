import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/models/attempted_question_model.dart';
import 'package:blackbook/core/common/models/qset_model.dart';
import 'package:blackbook/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

abstract interface class QsetRemoteDataSource {
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

class QsetRemoteDataSourceImpl implements QsetRemoteDataSource {
  final sp.SupabaseClient supabaseClient;

  const QsetRemoteDataSourceImpl(this.supabaseClient);

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
          .eq('user', authUser.id)
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
