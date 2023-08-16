import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt_sm/room_details.dart';
import 'package:http/http.dart';

class StudentHome extends StatefulWidget {
  StudentHome({Key? key,required this.stuId}) : super(key: key);
String stuId;

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  List roomDetails = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRoomDetails();
  }

  String url1 = "http://192.168.1.40/regal/";

  Future<void> fetchRoomDetails() async {
    String url = "http://192.168.1.40/regal/roomdetails.php";
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
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
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
                                      stuId:widget.stuId
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
        ],
      ),
    );
  }
}
