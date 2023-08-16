import 'package:flutter/material.dart';
import 'login.dart';
import 'package:hostel_mgmt_sm/parentRsr.dart';
void main()
{
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title:'Hostel Management System' ,
      home:Login() );
  }
}
