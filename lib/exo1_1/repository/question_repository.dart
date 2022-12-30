import '../model/question.dart';

class QuestionRepository {
  final _questions = <Question>[
    Question(
        questionText: "Le Kilimandjaro est le plus haut sommet au monde.",
        response: false,
        imagePath: "images/montagnes.jpg"
    ),
    Question(
        questionText: "Les méduses sont apparues après les dinosaures.",
        response: false,
        imagePath: "images/meduses.jpg"
    ),
    Question(
        questionText: "L'Inde est le second pays à posséder la plus grande population au monde.",
        response: true,
        imagePath: "images/inde.jpg"
    ),
  ];

  get questions => _questions;
}