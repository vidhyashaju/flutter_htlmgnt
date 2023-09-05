import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class FeePayment extends StatefulWidget {
  const FeePayment({Key? key,required this.stuId}) : super(key: key);
  final String? stuId;
  @override
  State<FeePayment> createState() => _FeePaymentState();
}

class _FeePaymentState extends State<FeePayment> {
  List bookedRoomDetails=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookedRoomDetails(widget.stuId);
  }
  Future<void>fetchBookedRoomDetails(String? stuId)async{
    String url="http://192.168.1.64/regal/API/fetchBookedroomDetails.php";
    Response res=await post(Uri.parse(url),body: {"stuId":widget.stuId});
    print(res.body);
    Response response=await get(Uri.parse(url));
    if(res.statusCode==200){
      setState(() {
        try{
          bookedRoomDetails=json.decode(res.body);
        }catch(e){print("error:$e");}
      });

    }
  }
  Future<void>confirmPayment(List bookedRoomDetails)async{
    String url="http://192.168.1.64/regal/API/confirmPayment.php";
    Response response=await post(Uri.parse(url),body:jsonEncode(bookedRoomDetails));
    if(response.statusCode==200){
      print(("data sent successfully"));
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
         ListView.builder(
           shrinkWrap: true,
            itemCount: bookedRoomDetails.length,
            itemBuilder: (context, index) {
              print(bookedRoomDetails);
              final record = bookedRoomDetails[index];
              return Container(margin: EdgeInsets.all(50),
                padding: EdgeInsets.all(5),
                child: ListTile(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    style: ListTileStyle.list,
                    tileColor: Colors.purpleAccent,
                    title:Column(
                      children: [
                        Text('Student Name: ${record['stuname']}',style: TextStyle(fontSize: 20)),
                        Text('Room No: ${record['roomno']}',style: TextStyle(fontSize: 20)),
                        Text('Room Type: ${record['type']}',style: TextStyle(fontSize: 20)),
                        Text('Rent: ${record['rent']}',style: TextStyle(fontSize: 20)),
                        Text('Booked Date: ${record['date']}',style: TextStyle(fontSize: 20)),
                      ],
                    )),

              );}
        ),
          ElevatedButton(style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
              backgroundColor:
              MaterialStateProperty.all(Colors.purpleAccent)),
              onPressed: (){
            confirmPayment(bookedRoomDetails);
          }, child: Text("Confirm",style: TextStyle(fontSize: 20),)),
      ],
      ),



    );
  }
}
