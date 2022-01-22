// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:userside/pages/auth/Login.dart';
import 'package:userside/pages/auth/welcome.dart';
import 'package:userside/pages/auth/notificationPermission.dart';
import 'package:userside/pages/auth/signUp.dart';
import "package:userside/pages/auth/splash.dart";
import 'package:userside/pages/home/celebrityProfile/celebrityProfilePage.dart';
import 'package:userside/pages/home/search/search.dart';
import 'package:userside/services/checkIfLogged.dart';
import 'package:userside/util/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.signOut();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Splash()
    );
  }
}




















