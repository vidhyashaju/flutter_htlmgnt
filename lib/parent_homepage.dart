import 'package:flutter/material.dart';

class ParentHome extends StatelessWidget {
   ParentHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(appBar: AppBar(),
      body: Center(child: Text("wecome Parent")),);
  }
}
