import 'package:tp2/exo1_2/data/model/question_model.dart';

class QuestionRepository {
  List<QuestionModel> questions;

  QuestionRepository() : questions = QuestionData().questions;

  Future<QuestionModel> fetchQuestion(int index) async {
    // return Future.delayed(
    //     const Duration(
    //         seconds: 1),
    //         () {
    //       return questions[index];
    //     }
    // );
    final question = questions[index];
    return QuestionModel (
      questionText: question.questionText,
      response: question.response,
      imagePath: question.imagePath,
    );
  }
}

class QuestionData {
  final _questions = <QuestionModel>[
    QuestionModel(
        questionText: "Le Kilimandjaro est le plus haut sommet au monde.",
        response: false,
        imagePath: "images/montagnes.jpg"
    ),
    QuestionModel(
        questionText: "Les méduses sont apparues après les dinosaures.",
        response: false,
        imagePath: "images/meduses.jpg"
    ),
    QuestionModel(
        questionText: "L'Inde est le second pays à posséder la plus grande population au monde.",
        response: true,
        imagePath: "images/inde.jpg"
    ),
  ];

  get questions => _questions;
}