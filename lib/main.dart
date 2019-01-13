import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String nama = '';
  String gambar = '';

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    setState(() {
      nama = user.displayName;
      gambar = user.photoUrl;
    });

    _alertDialog();

    print("Nama User : ${user.displayName}");
    return user;
  }

  void _alertDialog() {
    AlertDialog alertDialog = AlertDialog(
      content: Container(
        height: 200,
        child: Column(
          children: <Widget>[
            Text(
              'Anda Sudah Login',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            Divider(),
            ClipOval(
              child: Image.network(gambar),
            ),
            Text(
              'Anda Login Sebagai $nama',
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
            ),
            RaisedButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  void _signOut(){
    googleSignIn.signOut();
    _alertOut();
  }

  void _alertOut(){
    AlertDialog alertDialog = AlertDialog(
      content: Container(
        height: 100,
        child: Column(
          children: <Widget>[
            Text(
              'Anda Sudah Logout',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 20),
            ),
            RaisedButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Login'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () => _signIn().then((FirebaseUser user) => print(user)),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.developer_board),
                    Text(
                      'Login With Google',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),

              RaisedButton(
                onPressed: () => _signOut(),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.developer_board),
                    Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
