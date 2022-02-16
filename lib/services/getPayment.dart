// ignore_for_file: file_names

import 'dart:convert';
import 'package:userside/pages/home/celebrityProfile/sendMessage/celebrityChat.dart';
import 'package:userside/pages/home/home.dart';
import 'package:userside/services/addChatMessage.dart';
import 'package:userside/services/addNotifications.dart';
import 'package:userside/services/addRequest.dart';
import 'package:userside/services/addToWallet.dart';
import 'package:userside/services/addTransaction.dart';
import 'package:userside/services/fetchUsersData.dart';
import 'package:userside/util/components.dart';
import 'package:userside/util/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';


getPaymentForDmRequest({
  @required String message,
  @required BuildContext context,
  @required int amount,
  @required String celebrity,
  @required String user,
  @required String slug,
  @required double discount
}) {

  showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.8,
              child: InAppWebView(
                onWebViewCreated: (_webViewController) {
                  _webViewController.addJavaScriptHandler(
                      handlerName: 'close',
                      callback: (args) async {
                        showLoading(context: context);

                        try {
                          Map userData = await getUserData(id: user);

                          await addTransaction(personId: FirebaseAuth.instance.currentUser.uid, message: "DM request", to: "letsvibe", from: user, amount: ((amount.toDouble()) / 100));

                          await addChatMessage(from: user, to: celebrity, message: messageText.text);

                          await addNotifications(type:"dm",target: "celebrity", message: "${userData["fullName"]} has requested a DM", String: String, from: user, to: celebrity);

                          await addDMRequest(message: message,context: context, celebrityId: celebrity,discount: discount, userId: user, type: "dm",amount:((amount.toDouble()) / 100));

                          messageText.value = TextEditingValue.empty;
                          Navigator.pop(context);
                          Navigator.pop(context);

                          currentTab = 1;
                          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                            return Home();
                          }));
                        } catch (e) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showErrorDialogue(context: context, message: e.toString());
                        }
                      });
                },
                initialUrlRequest: URLRequest(url: Uri.parse("https://paystack.com/pay/$slug")),
                initialOptions: InAppWebViewGroupOptions(
                    android: AndroidInAppWebViewOptions(
                        allowFileAccess: true, cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK, allowContentAccess: true)),
              ),
            ),
          ),
        );
      });
}




payout({@required String target,@required int amount, @required String number, @required String id , @required String provider })async{

  if(target=="celebrity"){
    Map data= await getCelebrityData(id: id);
    int wallet=data["wallet"].toInt();

    if(amount<50){
      return {"message":"Minimum withdrawl limit is 50GHS"};
    }


    if(wallet>=(amount)){

      try{
        var res=await http.get(Uri.parse("https://us-central1-funnel-887b0.cloudfunctions.net/sendPayment"),headers: {"amount":amount.toString(),"provider":provider,"number":number});
        var data=jsonDecode(res.body);
        print(data);

        if(data["status"]==true){


          await addTransaction(message: "Withdraw", to: FirebaseAuth.instance.currentUser.uid, from: FirebaseAuth.instance.currentUser.uid, amount: amount.toDouble());

          wallet=wallet-amount;
          await FirebaseFirestore.instance.collection("celebrities").doc(FirebaseAuth.instance.currentUser.uid).set(
              {
                "wallet":wallet
              },
              SetOptions(merge: true)
          );
          return data;

        }
        else{
          return data;
        }

      }
      catch(e){
        return {"message": "Error: Kindly Check all details."};
      }


    }
    else{
      return {"message": "Not Enough Funds to Withdraw."};
    }

  }
  else{

    Map data= await getUserData(id: id);
    int wallet=data["wallet"].toInt();

    if(amount<50){
      return {"message":"Minimum withdrawl limit is 50GHS"};
    }


    if(wallet>=(amount)){

      try{
        var res=await http.get(Uri.parse("https://us-central1-funnel-887b0.cloudfunctions.net/sendPayment"),headers: {"amount":amount.toString(),"provider":provider,"number":number});
        var data=jsonDecode(res.body);
        print(data);

        if(data["status"]==true){

          wallet=wallet-amount;
          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).set(
              {
                "wallet":wallet
              },
              SetOptions(merge: true)
          );

          await addTransaction(
              message: "Withdraw",
              to: "bank",
              from: FirebaseAuth.instance.currentUser.uid,
              amount: amount.toDouble(),
              personId: FirebaseAuth.instance.currentUser.uid
          );

          return data;

        }
        else{
          return data;
        }

      }
      catch(e){
        return {"message": "Error: Kindly Check all details."};
      }


    }
    else{
      return {"message": "Not Enough Funds to Withdraw."};
    }

  }


}







getPaymentForVideoRequest({@required BuildContext context, @required int amount, @required String celebrity, @required String user, @required String slug}){
  showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.8,
              child: InAppWebView(
                onWebViewCreated: (_webViewController) {
                  _webViewController.addJavaScriptHandler(
                      handlerName: 'close',
                      callback: (args) async {
                        showLoading(context: context);

                        try {
                          Map userData = await getUserData(id: user);

                          await addToWallet(amount: ((amount.toDouble()) / 100) * 0.7, id: celebrity, type: "celebrities");

                          await addTransaction(message: "Video Request", to: celebrity, from: user, amount: ((amount.toDouble()) / 100));

                          await addChatMessage(from: user, to: celebrity, message: messageText.text);

                          await addNotifications(type:"videoRequest",target: "celebrity", message: "${userData["fullName"]} has requested a video.", String: String, from: user, to: celebrity);

                          await addVideoRequest(context: context, celebrityId: celebrity, userId: user, type: "videoRequest",amount:((amount.toDouble()) / 100));

                          messageText.value = TextEditingValue.empty;
                          Navigator.pop(context);
                          Navigator.pop(context);

                          //  Add Transactions Here
                          // Add Wallet here.

                          currentTab = 1;
                          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
                            return Home();
                          }));
                        } catch (e) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showErrorDialogue(context: context, message: e.toString());
                        }
                      });
                },
                initialUrlRequest: URLRequest(url: Uri.parse("https://paystack.com/pay/$slug")),
                initialOptions: InAppWebViewGroupOptions(
                    android: AndroidInAppWebViewOptions(
                        allowFileAccess: true, cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK, allowContentAccess: true)),
              ),
            ),
          ),
        );
      });
}