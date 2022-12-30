import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp2/exo1_2/cubit/question_state.dart';
import 'package:tp2/exo1_2/data/question_repository.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final QuestionRepository _questionRepository;
  int index = 0;
  late int nbQuestions;

  QuestionCubit(this._questionRepository) : super(QuestionInitial()) {
    print("Cubit initialized");
    nbQuestions = _questionRepository.questions.length;
  }

  Future<void> fetchQuestion() async {
    emit(QuestionLoading());
    if (index >= _questionRepository.questions.length) {
      print("$index==${_questionRepository.questions.length}");
      emit(QuestionFinished(nbQuestions));
      return;
    }

    try {
      final questionFetched = await _questionRepository.fetchQuestion(index);
      print("{text:${questionFetched.questionText}, response:${questionFetched.response}, imagePath:${questionFetched.imagePath}}");
      ++index;
      emit(QuestionLoaded(questionFetched, index, nbQuestions));
    } on Exception {
      print("failure");
      emit(QuestionError("Question not loaded !"));
    }
  }
}
