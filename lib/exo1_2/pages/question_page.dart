import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp2/exo1_2/cubit/question_cubit.dart';
import 'package:tp2/exo1_2/cubit/question_state.dart';
import 'package:tp2/exo1_2/data/model/question_model.dart';

class QuestionPage extends StatelessWidget {
  int _score;
  bool _userResponse;

  QuestionPage([this._score = 0, this._userResponse = false]);

  void incrScore() {
    _score++;
  }

  bool checkResponse(QuestionLoaded state) {
    if(state.questionModel.response == _userResponse) {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Question/Réponse"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                if (state is QuestionInitial) {
                  BlocProvider.of<QuestionCubit>(context).fetchQuestion();
                  print("initial");
                  return Text("initial");
                }
                else if (state is QuestionLoading) {
                  print("loading");
                  return Text("loading");
                }
                else if (state is QuestionLoaded) {
                  print("loaded");
                  return quizzWidget(context, state);
                }
                else if (state is QuestionFinished) {
                  return resultsWidget(context, state);
                }
                else {
                  return Text("error");
                }
              },
            ),
          ),
        )

    );
  }

  Column quizzWidget(BuildContext context, QuestionLoaded state) {
    String? imgPath = state.questionModel.imagePath ?? "images/question.jpg";
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
            'Question ${state.questionNumber}/${state.nbQuestions}',
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
                image: AssetImage(imgPath!),
                height: 300,
                width: 300,
              ),

              Container(
                constraints: const BoxConstraints(minHeight: 100),
                margin: const EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                ),
                child: Center(
                  child: Text(
                    state.questionModel.questionText.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

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
                      if (checkResponse(state)) {
                        incrScore();
                      }
                      context.read<QuestionCubit>().fetchQuestion();
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

  Column resultsWidget(BuildContext context, QuestionFinished state) {
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
            '$_score/${state.nbQuestions}',
            style: const TextStyle(
                fontSize: 25
            ),
          ),
        ),
        Center(
          child: Image(
            height: 50,
            width: 50,
            image: _score > state.nbQuestions/2 ? const AssetImage('images/good.png') : const AssetImage('images/bad.png'),
          ),
        ),
        Center(
          child: TextButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
            ),
            onPressed: () {
              reset();

            },
            child: const Text("Recommencer", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
          ),
        )
      ],
    );
  }
}