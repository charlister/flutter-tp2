import 'package:flutter/cupertino.dart';
import 'package:tp2/exo1_1/model/question.dart';

import '../repository/question_repository.dart';

class QuestionProvider extends ChangeNotifier {
  int _questionNumber;
  final QuestionRepository _questionRepository = QuestionRepository();

  QuestionProvider([this._questionNumber = 0]);

  // getters
  QuestionRepository get questionRepository => _questionRepository;

  int get questionNumber => _questionNumber; // setters

  // others
  void nextQuestion() {
    _questionNumber++;
    notifyListeners();
  }

  Question currentQuestion() => _questionRepository.questions[_questionNumber];

  void reset() {
    _questionNumber = 0;
    notifyListeners();
  }
}