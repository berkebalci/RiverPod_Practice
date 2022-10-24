import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sign_in extends StatefulWidget {
  Sign_in({Key? key}) : super(key: key);

  @override
  State<Sign_in> createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: controller),
        actions: [
          IconButton(
              onPressed: () {
                createusername(name: controller.text);
              },
              icon: Icon(Icons.published_with_changes_rounded))
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: []),
    );
  }
  //TODO 1.https://stackoverflow.com/questions/20433867/git-ahead-behind-info-between-master-and-branch
  //TODO 2.https://stackoverflow.com/questions/41283955/github-keeps-saying-this-branch-is-x-commits-ahead-y-commits-behind
  //TODO Ultimate riverpod makalesi
  //TODO Riverpod with firebase
  Future createusername({required String name}) async{


  }
}
