import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class ViewAttendance extends StatefulWidget {
   ViewAttendance({Key? key,this.username,this.stuId}) : super(key: key);
 String? username,stuId;
  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}
class _ViewAttendanceState extends State<ViewAttendance> {
  List attendanceDetails=[];
   Future<void> fetchAttendance(String? stuId) async {
     String url="http://192.168.1.64/regal/API/fetchattendancedetail.php";
     Response response = await post(
         Uri.parse(url), body: {"sid": widget.stuId});
     print(response.body) ;
     Response res=await get(Uri.parse(url));
     if(res.statusCode==200)
       {
         setState(() {
           try{
           attendanceDetails=json.decode(response.body);
           }catch(e){print("error:$e");}
         });
       }
     print(attendanceDetails);
   }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.stuId);
   // sendStuId(widget.stuId);
    fetchAttendance(widget.stuId);
  }

   @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
    body: ListView.builder(
      itemCount: attendanceDetails.length,
    itemBuilder: (context, index) {
        print(attendanceDetails);
    final record = attendanceDetails[index];
    return Container(margin: EdgeInsets.all(80),
      padding: EdgeInsets.all(5),
      child: ListTile(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      style: ListTileStyle.list,
      tileColor: Colors.purpleAccent,
      title:Column(
        children: [
          Text('Student Name: ${record['stu_name']}',style: TextStyle(fontSize: 20)),
          Text('Status: ${record['status']}',style: TextStyle(fontSize: 20)),
          Text('Remark: ${record['remark']}',style: TextStyle(fontSize: 20)),
          Text('Date: ${record['date']}',style: TextStyle(fontSize: 20)),

        ],
      )),

    );}
    ),

    );
  }
}
