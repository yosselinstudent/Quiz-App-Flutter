import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/clases/quiz.dart';
import 'package:quiz_app/pages/resolve.page.dart';

import '../clases/question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int totalquestions=5;
  int totaloptions=4;
  int questionIndex=0;
  int progressIndex=0;
  Quiz quiz=Quiz(name: 'Quiz de Capitales', questions: []);
  Future<void> readJson() async{
    final String response= await rootBundle.loadString('/paises.json');
    final List<dynamic> data=await json.decode(response);
    List<int> optionList= List<int>.generate(data.length,(i)=>i);
    List<int>questionAdded=[];
    while (true) {
      optionList.shuffle();
      int answer =optionList[0];
      if (questionAdded.contains(answer)) continue;
      questionAdded.add(answer);
      List<String> otherOptions=[];
      for (var option in optionList.sublist(1,totaloptions)) {
        otherOptions.add(data[option]['capital']);
      }
      Questions question =Questions.fromJson(data[answer]);
      question.addOptions(otherOptions);
      quiz.questions.add(question);

      if(quiz.questions.length>=totalquestions)break;
    }
    setState(() {
      
    });
  }
  @override
  void initState() {
    super.initState();
    readJson();
  }

  void _optionSelected(String selected){
      quiz.questions[questionIndex].selected=selected;
      if(selected==quiz.questions[questionIndex].answer){
        quiz.questions[questionIndex].correct=true;
        quiz.rigth+=1;
      }
      progressIndex+=1;
      if (questionIndex<totalquestions-1) {
        questionIndex+=1;
      }else{
        showDialog(
          barrierDismissible: false,
          context: context, 
          builder: (BuildContext context) => _buildResultDialog(context));
      }
      setState(() {
        
      });
  }

  Widget _buildResultDialog(BuildContext context){
    return AlertDialog(
      title: Text("Resultados",style: Theme.of(context).textTheme.displayLarge,),
      backgroundColor: Theme.of(context).primaryColorDark,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Preguntas Totales: $totalquestions",style: Theme.of(context).textTheme.bodyLarge,),
          Text("Correctas: ${quiz.rigth}",style: Theme.of(context).textTheme.bodyLarge,),
          Text("Icorrectas: ${(totalquestions-quiz.rigth)}",style: Theme.of(context).textTheme.bodyLarge,),
          Text("Porcentaje: ${quiz.percent}%",style: Theme.of(context).textTheme.bodyLarge,),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: ((context)=>ResultsPage(quiz: quiz,))
              )
            );
          }, 
          child: Text("Ver Respuestas",style: Theme.of(context).textTheme.bodyLarge,),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text(quiz.name),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: LinearProgressIndicator(
                color: Colors.amber.shade800,
                value:progressIndex/totalquestions ,
                minHeight: 20,
              )
            )
          ),
          ConstrainedBox(
            constraints:const BoxConstraints(maxHeight: 450),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
              child:quiz.questions.isNotEmpty? Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Text(quiz.questions[questionIndex].question,style: Theme.of(context).textTheme.displayLarge,),
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: totaloptions,
                        itemBuilder: (_,index){
                          return Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.indigo.shade100,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15)
                                ),
                              ),
                              leading: Text('${index+1}',style: Theme.of(context).textTheme.bodyLarge,),
                              title: Text(quiz.questions[questionIndex].options[index],style: Theme.of(context).textTheme.bodyLarge,),
                              onTap: (){
                                _optionSelected(quiz.questions[questionIndex].options[index]);
                              },
                            ),
                          );
                        }
                      ),
                    )
                  ],
                ),
              ):const CircularProgressIndicator(backgroundColor: Colors.white,),
            ),
          ),
          TextButton(
            onPressed: (){
              _optionSelected("Skipped");
            }, 
            child: Text("Skip",style: Theme.of(context).textTheme.bodyLarge,)
          )
        ],
      ),
    );
  }
}