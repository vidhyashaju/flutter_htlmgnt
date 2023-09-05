import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
class ViewNotification extends StatefulWidget {
   ViewNotification({Key? key,required this.stuId}) : super(key: key);
  String? stuId;
  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
 List notification=[];
   Future<void> fetchNotification(String? stuId) async {
     String url = "http://192.168.1.64/regal/API/fetchNotification.php";
     Response response =
     await post(Uri.parse(url), body: {"stuId":widget.stuId});
     print(response.body);
     Response res = await get(Uri.parse(url));
     if (response.statusCode == 200) {
       setState(() {
         notification=json.decode(response.body);
       });
     }
   }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotification(widget.stuId);
  }
   @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: notification.length,
                itemBuilder: (context, index) {
                  final record = notification[index];
                  return Card(margin: EdgeInsets.all(20),
                    child: ListTile(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        style: ListTileStyle.list,
                        tileColor: Colors.purpleAccent,
                        title:Column(
                          children: [
                            Text('Notification : ${record['notification']}',style: TextStyle(fontSize: 20)),
                            Text('Date: ${record['date']}',style: TextStyle(fontSize: 20)),
                          ],
                        )),

                  );}
            ),
      ]),
    );
  }
}
