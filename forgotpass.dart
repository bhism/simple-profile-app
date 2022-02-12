import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginscreen.dart';

class Forgotpass extends StatefulWidget {
  @override
  _ForgotpassState createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  final TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Forgot\n"
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
              SizedBox(
                height: 30,
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
                  enabled: true,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 30,
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
                          builder: (context) => LoginScreen(),
                        ),
                      );
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
                      Forgotpassword(emailController.text);
                    },
                    child: Text(
                      "send",
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

  void Forgotpassword(String email) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()))
            })
        .catchError((e) {
      print(e);
    });
  }
}
