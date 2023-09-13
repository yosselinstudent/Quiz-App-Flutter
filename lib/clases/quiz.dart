import 'package:quiz_app/clases/question.dart';

class Quiz {
  String name;
  List<Questions> questions;
  int rigth=0;
  Quiz({
    required this.name,
    required this.questions,
  });

  double get percent =>(rigth/questions.length)*100;
}