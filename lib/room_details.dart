import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt_sm/fee_payment.dart';
import 'package:http/http.dart';

class RoomDetail extends StatefulWidget {
  const RoomDetail({
    Key? key,
    required this.roomNo,
    required this.roomType,
    required this.amount,
    required this.img,
    required this.username,
    required this.stuId,
  }) : super(key: key);
  final String? roomNo;
  final String? roomType;
  final String? amount;
  final String? img;
  final String? username;
  final String? stuId;

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  // List roomDetails=[];
  String url1 = "http://192.168.1.64/regal/";

  Future<void> bookRoom() async {
    String url = "http://192.168.1.64/regal/API/bookroom.php";
    var response = await post(Uri.parse(url), body: {
      "roomno": widget.roomNo,
      "type": widget.roomType,
      "fee": widget.amount,
      "stuId": widget.stuId
    });
    if (response.statusCode == 200) {
      print("success");
    } else {
      print("failed");
    }
  }

  Future<void> checkRoomBookStatus(String? roomNo) async {
    String url = "http://192.168.1.64/regal/API/checkstatus.php";
    Response response =
        await post(Uri.parse(url), body: {"roomNo": widget.roomNo});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      final String? message = data['message'];
      final String? status = data['status'];
      print(status);
      if (message == 'success') {
        handlePayment(status!);
      } else {
        print("error");
      }
    }
  }

  void handlePayment(String status) {
    if (status == 'Approve') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FeePayment(stuId: widget.stuId)));
    } else if (status == 'pending') {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(" Message"),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.purpleAccent,
              content: Text(
                "Not Approved From Admin !!!!",
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK",
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Room No: ${widget.roomNo!}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent)),
          Text("Room Type: ${widget.roomType!}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent)),
          Text("Amount Per Month: ${widget.amount!}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent)),
          Image(
            image: NetworkImage(
                "${url1!.split("API/").first.toString()}image/${widget.img}"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    bookRoom();
                  },
                  child: Text("Book Now",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple))),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    //  sendRoomNo(widget.roomNo);
                    checkRoomBookStatus(widget.roomNo);
                  },
                  child: Text("Payment",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(StadiumBorder()),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.purple)))
            ],
          ),
        ]));
  }
}
