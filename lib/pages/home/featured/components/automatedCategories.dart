import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:userside/pages/home/featured/components/components.dart';


var categories = [
  "Music Stars",
  "Film Stars",
  "Sports Stars",
  "Television Stars",
  "Radio Stars",
  "International Stars",
  "Veterans",
  "Comedy Stars",
  "Social Media Stars",
  "Reality TV Stars",
  "Dance Stars",
  "Influencers",
  "Entrepreneurs",
  "Entertainers",
  "Creators",
  "Lifestyle & Fashion Stars",
  "Models",
  "Motivational Leaders",
  "Political & Religious Leaders",
];





Future<List<Widget>> automatedCategories({@required BuildContext context})async{
  List<Widget> automatedCategoriesList = [];


  List<Widget> finalList=[];

  for (var i = 0; i < categories.length; i++) {

    var data= await FirebaseFirestore.instance.collection("celebrities").where("interests", arrayContains: "${categories[i]}").get();

    var categData=[];
    for(int i=0;i<data.docs.length;i++){
      categData.add(data.docs[i].id);
    }


    if (data.docs.length > 0) {
      finalList.add(
          categoryRow(
              context: context,
              categoryData: categData,
              categoryName: "${categories[i]}")
      );
    }

  }

  DocumentSnapshot imageDoc=await FirebaseFirestore.instance.collection("appSettings").doc("images").get();
  Map imageData=imageDoc.data();
  var imageLength=imageData["banner"].length;


  var bannerIndex=0;
  var i=0;
  var loop=true;
  while(loop){

    if(i<finalList.length){
      print("Adding ads");
      if(i%3==0){
        if(bannerIndex==imageLength){
          finalList.insert(i, bigBanner(context: context,index:0));
          bannerIndex=0;
        }
        else{
          finalList.insert(i, bigBanner(context: context,index:bannerIndex));
          bannerIndex+=1;
        }
      }

      i++;
    }

    else{
      loop=false;
    }

  }

  return finalList;



}













