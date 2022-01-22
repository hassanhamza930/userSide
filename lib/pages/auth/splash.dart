// @dart=2.9

import 'package:userside/pages/auth/welcome.dart';
import 'package:userside/pages/home/celebrityProfile/celebrityProfilePage.dart';
import 'package:userside/pages/home/home.dart';
import 'package:userside/services/checkIfLogged.dart';
import 'package:userside/services/notification/notificationService.dart';
import 'package:userside/util/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:userside/util/styles.dart';

class Splash extends StatefulWidget {
  const Splash();

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String url = "";

  void initDynamicLinks() async {
    print("called link");

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data.link;

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      print("called link");

      final Uri deepLink = dynamicLink.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  handleDynamicLink(Uri url) async {
    print("handling dynamic link");
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));
    if (separatedString[1] == "post") {
      print("checking");
      var status = await checkIfLogged(context);

      print("shifting");
      await Future.delayed(Duration(seconds: 2), () async {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return celebrityProfilePage(id: separatedString[2]);
        }));
      });
    } else {
      print("nah");
    }
  }

  oneTime() async {
    await FirebaseMessagingInit(context);

    await Future.delayed(Duration(seconds: 2), () async {
      var status = await checkIfLogged(context);
      if (status == "Logged") {
        try {
          initDynamicLinks();

          var userDoc = await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser.uid.toString())
              .get();

          if (userDoc.exists) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return Home();
            }));
          }
          else {
            await FirebaseAuth.instance.signOut();
            showMessage(context: context, message: "You have been logged out, Your account may have been terminated. Please Contact Administrator");

            Future.delayed(Duration(seconds: 5),(){
              Navigator.pop(context);
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return welcome();
              }));

            });

          }
        } catch (e) {
          showErrorDialogue(context: context, message: "${e.toString()}");
        }
        ;
      } else {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return welcome();
        }));
      }
    });
  }

  @override
  void initState() {
    oneTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              color: Colors.blue,
              child: Image.asset(
                'assets/bluebackground.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "Personalized Celebrity Videos",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Avenir",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
