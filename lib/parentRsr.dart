import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
class ParentRegister extends StatefulWidget {
   ParentRegister({Key? key}) : super(key: key);

  @override
  State<ParentRegister> createState() => _ParentRegisterState();
}

class _ParentRegisterState extends State<ParentRegister> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userName.dispose();
    pwd.dispose();
    phone.dispose();
    address.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }
   TextEditingController userName = TextEditingController();

   TextEditingController pwd = TextEditingController();

   TextEditingController address=TextEditingController();

   TextEditingController phone=TextEditingController();
   var fmKey=GlobalKey<FormState>();
  List nameList =[];
  String? selectedName;


  Future<List?> parentRegister(String username, pwd, address, phone) async {
    if(selectedName!=null) {
      String url = "http://192.168.1.40/regal/API/parent.php";
      Response res = await post(Uri.parse(url), body: {
        "stu_name":selectedName,
        "name": username,
        "pwd": pwd,
        "address": address,
        "phone": phone,
      });
      if(res.statusCode==200){
        print("Success");
      }
      else{
        print("Failed");
      }
    }
    else{
      print("Please select a student name");
    }
   }
  getName() async {
    String url = "http://192.168.1.40/regal/API/stuid.php";
    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        nameList = data;
      });
    }
    else {
      print("failed");
    }
    print(nameList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: fmKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: Text("Select name"),
               ),
               SizedBox(width: 10),
               DropdownButton(
                   hint: Text("select name"),
                   value: selectedName,
                   onChanged: (val) {
                     setState(() {
                       selectedName = val!;
                     });

                   },
                   items: nameList.map((name) {
                     return DropdownMenuItem<String>(value:name['stu_name'] ,
                         child: Text(name['stu_name']));

                   }).toList()),


             ]),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: userName,
                validator: (value){
                  if(value!.isEmpty)
                    {
                      return "UserName required";
                    }
                },
                decoration: InputDecoration(
                    hintText: "username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: pwd,
                obscureText: true,
                validator: (value){
                  if(value!.length<6)
                  {
                    return "Password too short";
                  }
                },

                decoration: InputDecoration(
                    hintText: "pwd",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                maxLines: 5,
                controller: address,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return "Address required";
                  }
                },

                decoration: InputDecoration(
                    hintText: "address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: phone,
                validator: (value){
                  if((value!.length)<10)
                  {
                    return "Phone Number must contain 10 digit";
                  }
                },

                decoration: InputDecoration(
                    hintText: "phone",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder()),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.purpleAccent)),
                onPressed: () {
                  bool val=fmKey.currentState!.validate();
                  if(val==true)
                    {
                      parentRegister(userName.text, pwd.text, address.text, phone.text);
                      userName.clear();
                      pwd.clear();
                      address.clear();
                      phone.clear();

                    }
                  },
                child: Text("REGISTER",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
          ]),
        ),
      ),
    );
  }
}
