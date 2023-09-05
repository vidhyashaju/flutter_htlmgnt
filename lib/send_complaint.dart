import 'package:flutter/material.dart';
import 'package:http/http.dart';
class SendComplaint extends StatefulWidget {
   SendComplaint({Key? key,required this.stuId}) : super(key: key);
  String? stuId;
  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    complaint.dispose();
  }
  TextEditingController complaint=TextEditingController();
  Future<void>sendComplaints(String? stuId)async{
    String url="http://192.168.1.64/regal/API/sendComplaints.php";
    Response response=await post(Uri.parse(url),body: {"complaint":complaint.text,"stuId":widget.stuId});
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
    return  Scaffold(appBar: AppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Container(
          decoration: BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(20)),
          height: 200,
          width: 250,
          child: Column(children: [
            SizedBox(height: 20),
            Text(
              "Enter Your Complaints",
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: complaint,
                decoration: InputDecoration(
                  hintText: "Enter Your Complaints....",
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  sendComplaints(widget.stuId);
                  complaint.clear();
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
      ]),);
  }
}
