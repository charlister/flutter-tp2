import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2/exo1_1/provider/question_provider.dart';

class QuestionPage extends StatelessWidget {
  int _score;
  bool _userResponse;

  QuestionPage([this._score = 0, this._userResponse = false]);

  void incrScore() {
    _score++;
  }

  bool checkResponse(QuestionProvider questionProvider) {
    if(questionProvider.currentQuestion().response == _userResponse) {
      return true;
    }
    return false;
  }

  void reset() {
    _score = 0;
    _userResponse = false;
  }

  @override
  Widget build(BuildContext context) {
    QuestionProvider questionProvider = Provider.of<QuestionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question/Réponse"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: questionProvider.questionNumber < questionProvider.questionRepository.questions.length ? quizzWidget(context, questionProvider) : resultsWidget(context, questionProvider),
          ),
        ),
      ),
    );
  }

  Column quizzWidget(BuildContext context, QuestionProvider questionProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Numéro de question
        Container(
            margin: const EdgeInsets.only(
                top: 10,
                left: 10,
                bottom: 10
            ),
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Question ${questionProvider.questionNumber + 1}/${questionProvider.questionRepository.questions.length}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),

        const Divider(
          color: Color.fromARGB(100, 0, 0, 0),
          indent: 10,
          endIndent: 10,
        ),

        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image(
                image: AssetImage(questionProvider.currentQuestion().imagePath),
                height: 300,
                width: 300,
              ),
              buildQuestion(questionProvider.currentQuestion().questionText),
              Row( // pour les boutons
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
                  ),
                    onPressed: () {
                      _userResponse = true;
                    },
                    child: const Text("VRAI", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                  ),
                  TextButton(style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
                  ),
                    onPressed: () {
                      _userResponse = false;
                    },
                    child: const Text("FAUX", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                  ),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
                    ),
                    onPressed: () {
                      if (checkResponse(questionProvider)) {
                        incrScore();
                      }
                      questionProvider.nextQuestion();
                    },
                    child: const Text("SUIVANT", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Card buildQuestion(String question) {
    return Card(
      color: Colors.blue,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   colors: [Colors.lightBlue, Colors.blue],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              question,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column resultsWidget(BuildContext context, QuestionProvider questionProvider) {
    return Column( // Résultats
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            'Score :',
            style: TextStyle(
                fontSize: 25
            ),
          ),
        ),
        Center(
          child: Text(
            '$_score/${questionProvider.questionRepository.questions.length}',
            style: const TextStyle(
                fontSize: 25
            ),
          ),
        ),
        Center(
          child: Image(
            height: 50,
            width: 50,
            image: _score > _score/2 ? const AssetImage('images/good.png') : const AssetImage('images/bad.png'),
          ),
        ),
        Center(
          child: TextButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
            ),
            onPressed: () {
              reset();
              questionProvider.reset();
            },
            child: const Text("Recommencer", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
        )
      ],
    );
  }
}