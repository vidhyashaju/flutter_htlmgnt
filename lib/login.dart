import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt_sm/parentRsr.dart';
import 'package:hostel_mgmt_sm/parent_homepage.dart';
import 'package:hostel_mgmt_sm/studentRsr.dart';
import 'package:hostel_mgmt_sm/student_homepage.dart';
import 'package:http/http.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userName.dispose();
    pwd.dispose();
  }

  TextEditingController userName=TextEditingController();

  TextEditingController pwd=TextEditingController();

  String userType='';

  Future<void> login() async {
    String url = "http://192.168.1.40/regal/API/login.php";
    var response = await post(
        Uri.parse(url), body: {"username": userName.text, "pwd": pwd.text});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final String? userType = data['type'];
      final String status=data['message'];
      final String? stuId=data['stu_id'];
      print(status);
      print(userType);
      print(data);
      print(stuId);
      if (status == 'success') {
          handleUserType(userType!,stuId!);
       // });
      }
      else if (status == 'failed'){
         handlePendingUser(status);
      }
      }
  }
  void handlePendingUser(String status)
  {
    showDialog(context: context, builder: (context){
      return AlertDialog(title: Text("Error Message"),
      content: Text("Not Approved Yet"),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("OK")),
      ],);
    });
  }
  void handleUserType( String userType, String stuId){
    if(userType=='student')
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentHome(stuId: stuId,)));
      }
    else if(userType=='parent')
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ParentHome()));
      }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text("HOSTEL MANAGAMENT SYSTEM",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            Container(
              height: 300,
              width: 600,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/hostel.jpg'),
                      fit: BoxFit.fitWidth)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: userName,
                        decoration: InputDecoration(
                          hintText: "UserName",
                          hintStyle: TextStyle(color: Colors.purpleAccent),
                        ),
                      ),
                      TextFormField(
                          controller: pwd,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle:
                              TextStyle(color: Colors.purpleAccent))),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("SELECT"),
                                          content: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  StudentRegister()));
                                                    },
                                                    child: Text(
                                                      "Student",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all(
                                                            StadiumBorder()),
                                                        backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                            .purpleAccent))),
                                                SizedBox(width: 10),
                                                OutlinedButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all(
                                                            StadiumBorder()),
                                                        backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                            .purpleAccent)),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                  ParentRegister()));
                                                    },
                                                    child: Text(
                                                      "Parent",
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white),
                                                    )),
                                              ]),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors
                                                          .purpleAccent),
                                                )),
                                          ],
                                        );
                                      });
                                },
                                child: Text("REGISTER",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        StadiumBorder()),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        Colors.purple))),
                            SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  login();
                                  userName.clear();
                                  pwd.clear();
                                //  Navigator.push(context, MaterialPageRoute(builder:(context)=>StudentHome()));
                                },
                                child: Text("LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        StadiumBorder()),
                                    backgroundColor:
                                    MaterialStateProperty.all(
                                        Colors.purple))),
                          ]),
                    ]),
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}


