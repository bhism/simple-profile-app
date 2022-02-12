import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection('user');

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController mobileController = new TextEditingController();

  File? file;
  var url;
  ImagePicker image = ImagePicker();
  var error = null;

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  register(String email, String password) async {
    if (error == null) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() async {
        await uploadFile();
      });
    } else {
      print(error);
    }
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("Users")
          .child("/${emailController.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        uploadToFirestore();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  uploadToFirestore() {
    User? user = auth.currentUser;
    ref.doc(user!.uid).set({
      'email': emailController.text,
      'mobile': mobileController.text,
      'url': url,
    }).whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: file == null
                    ? IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 90,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      )
                    : Image.file(
                        file!,
                        fit: BoxFit.fill,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: confirmpassController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Confirm Password',
                ),
                onChanged: (value) {
                  if (confirmpassController.text != passwordController.text) {
                    setState(() {
                      error = 'error';
                    });
                  } else {
                    setState(() {
                      error = null;
                    });
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Mobile',
                  enabled: true,
                ),
                maxLength: 10,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    height: 40,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  MaterialButton(
                    height: 40,
                    onPressed: () {
                      register(emailController.text, passwordController.text);
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
