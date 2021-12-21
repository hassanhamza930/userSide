import 'package:firebase_auth/firebase_auth.dart';
import 'package:userside/pages/auth/createNewPass.dart';
import 'package:userside/pages/home/home.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";import 'package:flutter/cupertino.dart';
import 'package:userside/util/components.dart';


var email=TextEditingController(text: "");


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
                "assets/forgotPassword/forgotPasswordBack.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.center,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Container(
                      width:MediaQuery.of(context).size.width*0.9,
                      child: Text(
                        "Forgot password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "AvenirBold",
                          fontSize: 34,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Container(
                      width:MediaQuery.of(context).size.width*0.89,
                      child: Text(
                        "Please enter your email address,\nYou will receive a link to create a\nnew password via email.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: "Avenir",
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100,),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(24.0))
                      ),
                      child: Center(
                        child: TextField(
                          style: TextStyle(
                              color:Colors.white,
                              fontFamily:'Avenir'
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white,fontFamily:'Avenir'),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsetsDirectional.only(start: 20.0),
                          ),
                          controller: email,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap: ()async{
                      showLoading(context: context);
                    try{
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text );
                      Navigator.pop(context);
                      showMessage(context: context, message: "Email for password reset is sent.");
                      print('sent');
                    }
                    catch(e){
                      Navigator.pop(context);
                      showMessage(context: context, message: e.message);
                    }
                    },
                    child: Center(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.orange,
                                ],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          width: MediaQuery.of(context).size.width * 0.9,
                          //height: 50,
                          child: Center(
                            child: Text(
                              "Send",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Avenir",
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left:20,top:40),
                alignment: Alignment.topLeft,
                child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
