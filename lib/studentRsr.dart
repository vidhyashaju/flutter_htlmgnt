import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
class StudentRegister extends StatefulWidget {
  StudentRegister({Key? key}) : super(key: key);

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userName.dispose();
    pwd.dispose();
    email.dispose();
    course.dispose();
    dob.dispose();
  }

  String gender = '';
  TextEditingController userName = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController photoed = TextEditingController();
  String? datePic;
  File? image;

  getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        image = File(photo.path);
      });
    }
    else {
      return null;
    }
  }

  Future<List?> studentRegister(String username, pwd, email, course,
      gender, dob, File image) async {
    String url = "http://192.168.1.39/regal/API/student.php";
    var request = MultipartRequest('POST', Uri.parse(url));
    request.fields['stu_name'] = username;
    request.fields['pwd'] = pwd;
    request.fields['stu_email'] = email;
    request.fields['course'] = course;
    request.fields['gender'] = gender;
    request.fields['dob'] = dob;
    request.files.add(MultipartFile.fromBytes(
        "image", File(image!.path).readAsBytesSync(), filename: image!.path));
    var response = await request.send();
    if (response.statusCode == 200) {
      print("success");
    }
    else {
      print("failed");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: userName,
                decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: pwd,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(value: 'male', groupValue: gender, onChanged: (val) {
                  setState(() {
                    gender = val!;
                  });
                }),
                Text("Male", style: TextStyle(fontSize: 15),),
                Radio(value: 'female', groupValue: gender, onChanged: (val) {
                  setState(() {
                    gender = val!;
                  });
                }),
                Text("Female", style: TextStyle(fontSize: 15),),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: dob,
                      decoration: InputDecoration(
                          hintText: "DOB",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                TextButton(onPressed: () async {
                  var date = await showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1980),
                      lastDate: DateTime.now());
                  setState(() {
                    datePic = DateFormat('dd/MM/yy').format(date!);
                  });
                  dob.text = datePic.toString();
                }, child: Icon(Icons.calendar_month_rounded)),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: photoed,
                        decoration: InputDecoration(
                            hintText: "Upload Photo",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ),
                  image != null ? Image.file(image!, height: 100) : Text(
                      "no image selected"),
                  TextButton(onPressed: () {
                    getImage();
                  }, child: Icon(Icons.camera_alt_rounded)),
                ]),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: course,
                decoration: InputDecoration(
                    hintText: "Course",
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
                  studentRegister(
                      userName.text,
                      pwd.text,
                      email.text,
                      course.text,
                      gender,
                      dob.text,
                      image!);
                  userName.clear();
                  pwd.clear();
                  email.clear();
                  course.clear();
                  dob.clear();
                },
                child: Text("REGISTER",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),)),
          ]),
        ),
      ),
    );
  }
}
