import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'homepage.dart';

class editpage extends StatefulWidget {
  @override
  _editpageState createState() => _editpageState();
}

class _editpageState extends State<editpage> {
  String email = '';
  String mobile = '';
  String url = '';

  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  TextEditingController mobilet = TextEditingController();
  File? file;
  var urll;
  ImagePicker image = ImagePicker();

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
      backgroundColor: Colors.purpleAccent[100],
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
                height: 20,
              ),
              TextFormField(
                controller: mobilet,
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text(
                      "cancel",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  MaterialButton(
                    height: 40,
                    onPressed: () async {
                      await uploadFile();
                      await uploadToFirestore();
                    },
                    child: Text(
                      "done",
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

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    try {
      var imagefile =
          FirebaseStorage.instance.ref().child("Users").child("/${email}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      urll = await snapshot.ref.getDownloadURL();
      setState(() {
        url = urll;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  uploadToFirestore() async {
    await ref.doc(user!.uid).update({
      'email': email,
      'mobile': mobilet.text,
      'url': url,
    }).whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }
}
