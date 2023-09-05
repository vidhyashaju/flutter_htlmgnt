import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt_sm/room_details.dart';
import 'package:hostel_mgmt_sm/send_complaint.dart';
import 'package:hostel_mgmt_sm/send_feedback.dart';
import 'package:hostel_mgmt_sm/view_notification.dart';
import 'package:http/http.dart';

class StudentHome extends StatefulWidget {
  StudentHome({Key? key, this.username, this.stuId}) : super(key: key);
  String? username, stuId;

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  List roomDetails = [];
  List mealsMenu = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRoomDetails();
    fetchMealsMenu();
  }

  String url1 = "http://192.168.1.64/regal/";

  Future<void> fetchMealsMenu() async {
    String url = "http://192.168.1.64/regal/API/fetchmealsmenu.php";
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      setState(() {
        mealsMenu = json.decode(res.body);
      });
    }
    print(mealsMenu);
  }

  Future<void> fetchRoomDetails() async {
    String url = "http://192.168.1.64/regal/roomdetails.php";
    Response res = await get(Uri.parse(url));
    if (res.statusCode == 200) {
      setState(() {
        roomDetails = json.decode(res.body);
      });
    }

    print((roomDetails));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${widget.username}"), actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout))
      ]),
      body: ListView(shrinkWrap: true, children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purpleAccent,
            ),
            width: 300,
            height: 50,
            child: Center(
                child: Text(
              "AVILABLE ROOMS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))),
        ListView.builder(
            shrinkWrap: true,
            itemCount: roomDetails.length,
            itemBuilder: (context, index) {
              var roomNo = roomDetails[index]['roomno'];
              var roomType = roomDetails[index]['roomtype'];
              var amount = roomDetails[index]['fee'];
              var img = roomDetails[index]['photo'];
              return Card(
                shape: StadiumBorder(),
                color: Colors.purpleAccent,
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoomDetail(
                                    roomNo: roomNo,
                                    roomType: roomType,
                                    amount: amount,
                                    img: img,
                                    username: widget.username,
                                    stuId: widget.stuId,
                                    // stuId: widget.stuId
                                  )));
                    },
                    title: Column(
                      children: [
                        Text("Room No :${roomNo}"),
                        Text("Room Type : ${roomType}"),
                        Text("Amount Per Month :${amount}")
                      ],
                    ),
                    leading: Container(
                      width: 100,
                      height: 100,
                      child: Image(
                        image: NetworkImage(
                            "${url1!.split("API/").first.toString()}image/${img}"),
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      ),
                    )),
              );
            }),
        SizedBox(height: 25),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purpleAccent,
            ),
            width: 300,
            height: 50,
            child: Center(
                child: Text(
              "FOOD MENU",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))),
        SizedBox(height: 25),
        Table(
            border: TableBorder.all(
                color: Colors.purpleAccent, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(
                children: [
                  TableCell(child: Text("Day")),
                  TableCell(child: Text("Breakfast")),
                  TableCell(child: Text("Lunch")),
                  TableCell(child: Text("Dinner")),
                ],
              ),
              for (var menu in mealsMenu)
                TableRow(children: [
                  TableCell(child: Text(menu['day'])),
                  TableCell(child: Text(menu['breakfast'])),
                  TableCell(child: Text(menu['lunch'])),
                  TableCell(child: Text(menu['dinner'])),
                ]),
            ]),
        SizedBox(height: 25),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewNotification(stuId: widget.stuId)));
              },
              child: Text("View Notification"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.purpleAccent))),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendFeedback(
                              stuId: widget.stuId,
                            )));
              },
              child: Text("Send Feedback"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.purpleAccent))),
        ]),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SendComplaint(stuId: widget.stuId)));
            },
            child: Text("Send Complaints"),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(StadiumBorder()),
                backgroundColor:
                    MaterialStateProperty.all(Colors.purpleAccent))),
      ]),
    );
  }
}
