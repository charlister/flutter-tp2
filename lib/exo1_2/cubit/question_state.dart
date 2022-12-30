import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tp2/exo1_2/data/model/question_model.dart';

abstract class QuestionState {
}

class QuestionInitial extends QuestionState {
  QuestionInitial();
}

class QuestionLoading extends QuestionState {
  QuestionLoading();
}

class QuestionLoaded extends QuestionState {
  QuestionModel questionModel;
  int questionNumber;
  int nbQuestions;


  QuestionLoaded(this.questionModel, this.questionNumber, this.nbQuestions);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QuestionLoaded && o.questionModel == questionModel;
  }

  @override
  int get hashCode => questionModel.hashCode;
}

class QuestionFinished extends QuestionState {
  int nbQuestions;
  QuestionFinished(this.nbQuestions);
}

class QuestionError extends QuestionState {
  final String message;

  QuestionError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QuestionError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}