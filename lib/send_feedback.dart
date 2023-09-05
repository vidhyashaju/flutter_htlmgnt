import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SendFeedback extends StatefulWidget {
  SendFeedback({Key? key, required this.stuId}) : super(key: key);
  String? stuId;

  @override
  State<SendFeedback> createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<SendFeedback> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    feedback.dispose();
  }
  TextEditingController feedback = TextEditingController();
  Future<void>sendFeedback(String? stuId)async{
    String url="http://192.168.1.64/regal/API/sendfeedback.php";
    Response response=await post(Uri.parse(url),body: {"feedback":feedback.text,"stuId":widget.stuId});
    if(response.statusCode==200){
      print("Feedback send successfully");
    }
    else
      {
        print("Feedback send failed");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(20)),
            height: 200,
            width: 250,
            child: Column(children: [
              SizedBox(height: 20),
              Text(
                "Enter Your Feedback",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: feedback,
                  decoration: InputDecoration(
                    hintText: "Enter Your Feedback",
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    sendFeedback(widget.stuId);
                    feedback.clear();
                  },
                  child: Text("Send",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purpleAccent)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.white)))
            ]),
          ),
        ),
      ]),
    );
  }
}
