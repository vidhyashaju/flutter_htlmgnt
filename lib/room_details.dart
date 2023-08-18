import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
class RoomDetail extends StatelessWidget {
  RoomDetail(
      {Key? key,
      required this.roomNo,
      required this.roomType,
      required this.amount,
      required this.img,
      required this.stuId})
      : super(key: key);
  final String? roomNo;
  final String? roomType;
  final String? amount;
  final String? img;
  final String? stuId;
  List rooDetails=[];
  String url1 = "http://192.168.1.40/regal/";
  Future<void>bookRoom()async{
    String url="http://192.168.1.40/regal/API/bookroom.php";
    var response=await post(Uri.parse(url),body:{ "roomno":roomNo,"type":roomType,"fee":amount,"stu_id":stuId});
    if(response.statusCode==200){
      print("success");
    }
    else
      {
        print("failed");
      }
  }
  Future<void>checkRoomBookStatus()async{
    String url="http://192.168.1.40/regal/API/checkstatus.php";
    Response res=await get(Uri.parse(url));
    if(res.statusCode==200){
      rooDetails=json.decode(res.body);
    }
    print(rooDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Room No: ${roomNo!}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent)),
          Text("Room Type: ${roomType!}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent)),
          Text("Amount Per Month: ${amount!}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent)),
          Image(
            image: NetworkImage(
                "${url1!.split("API/").first.toString()}image/$img"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    bookRoom();
                    checkRoomBookStatus();
                  },
                  child: Text("Book Now",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.purple))),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    checkRoomBookStatus();
                  },
                  child: Text("Payment",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor: MaterialStateProperty.all(Colors.purple)))
            ],
          ),
        ]));
  }
}
