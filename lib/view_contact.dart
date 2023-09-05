import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ViewContact extends StatefulWidget {
  const ViewContact({Key? key}) : super(key: key);

  @override
  State<ViewContact> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  List contactDetails = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewContactDetails();
  }

  Future<void> viewContactDetails() async {
    String url = "http://192.168.1.64/regal/API/fetchContactDetails.php";
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        contactDetails = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          child: ListView(shrinkWrap: true, children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: contactDetails.length,
                itemBuilder: (context, index) {
                  final record = contactDetails[index];
                  return Card(
                    margin: EdgeInsets.all(20),
                    child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        style: ListTileStyle.list,
                        tileColor: Colors.purpleAccent,
                        title: Column(
                          children: [
                            Text('Hostel Name : ${record['hostelname']}',
                                style: TextStyle(fontSize: 20)),
                            Text('Address: ${record['address']}',
                                style: TextStyle(fontSize: 20)),
                            Text('Phone No: ${record['phone']}',
                                style: TextStyle(fontSize: 20)),
                            Text('Email: ${record['email']}',
                                style: TextStyle(fontSize: 20)),
                            Text('Warden Name: ${record['wardenname']}',
                                style: TextStyle(fontSize: 20)),
                            Text('Warden Phone No: ${record['wardenphone']}',
                                style: TextStyle(fontSize: 20)),
                            Text(
                                'Emergency Contact Number: ${record['emergencyno']}',
                                style: TextStyle(fontSize: 20,backgroundColor: Colors.cyan)),
                          ],
                        )),
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
