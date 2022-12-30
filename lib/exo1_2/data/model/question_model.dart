class QuestionModel {
  String? questionText;
  bool? response;
  String? imagePath;

  QuestionModel({
    this.questionText,
    this.response,
    this.imagePath
  });

  static final empty = QuestionModel (
    questionText: '',
    response: false,
    imagePath: '',
  );

  QuestionModel copyWith({
    String? questionText,
    bool? response,
    String? imagePath,
  }) {
    return QuestionModel(
      questionText: questionText ?? this.questionText,
      response: response ?? this.response,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}