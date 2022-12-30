import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp2/exo1_2/cubit/question_cubit.dart';
import 'package:tp2/exo1_2/data/question_repository.dart';
import 'package:tp2/exo1_2/pages/question_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocProvider(
        create: (context) => QuestionCubit(QuestionRepository()),
        child: QuestionPage(),
      ),
    );
  }
}