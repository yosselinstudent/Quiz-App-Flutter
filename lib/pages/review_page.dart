import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/clases/question.dart';
import 'package:quiz_app/clases/quiz.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Quiz quiz= Quiz(name: 'Quiz de Capitales', questions: []);
  Future<void> readJson() async{
    final String response= await rootBundle.loadString('/paises.json');
    final List<dynamic> data=await json.decode(response);
    for (var item in data) {
      Questions question= Questions.fromJson(item);
      question.question+=question.country;
      quiz.questions.add(question);
    }
    setState(() {
      
    });
  }

  @override
  void initState() {
    
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
      ),
      body:quiz.questions.isNotEmpty ? Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.indigo.shade50,
                width: 1,
              )
            ),
            child: Center(
              child: Text(
                "Preguntas: ${quiz.questions.length}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quiz.questions.length,
              itemBuilder: (_,index){
                return Card(
                  color: Theme.of(context).primaryColorLight,
                  child: ListTile(
                    leading: Text("${index+1}"),
                    title: Text(quiz.questions[index].question),
                    trailing: Text(quiz.questions[index].answer),
                  ),
                );
              }
            )
          )
        ],
      ):const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      )
    );
  }
}