import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editpage.dart';
import 'loginscreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var email = '';
  var mobile = '';
  var url = '';
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  void getdata() async {
    DocumentSnapshot userdoc = await ref.doc(user!.uid).get();
    setState(() {
      email = userdoc.get('email');
      mobile = userdoc.get('mobile');
      url = userdoc.get('url');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editpage(),
                  ),
                );
              },
              child: Container(
                width: 230,
                height: 230,
                margin: EdgeInsets.only(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      url,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'email : ' + email,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Text(
              'mobile : ' + mobile,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
