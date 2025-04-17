import 'package:flutter/material.dart';

import 'widgets/result_body.dart';

class ResultScreen extends StatelessWidget {
  final String totalQuestion,correctAnswer,finalScore,duration;
  const ResultScreen({super.key, required this.totalQuestion, required this.correctAnswer, required this.finalScore, required this.duration});

  @override
  Widget build(BuildContext context) {
    return  ResultBody(data: [totalQuestion,duration,correctAnswer,finalScore],);
  }
}
