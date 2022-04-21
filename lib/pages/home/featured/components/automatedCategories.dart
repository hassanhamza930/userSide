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

class automatedCategories extends StatefulWidget {
  @override
  _automatedCategoriesState createState() => _automatedCategoriesState();
}

class _automatedCategoriesState extends State<automatedCategories> {
  @override
  Widget build(BuildContext context) {
    List<Widget> automatedCategoriesList = [];


    var totalAds=0;

    for (var i = 0; i < categories.length; i++) {


      automatedCategoriesList.add(
          StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("celebrities")
              .where("interests", arrayContains: "${categories[i]}")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> docs = snapshot.data.docs;
              var celebs = [];
              docs.forEach((element) {
                var data = element.id;
                celebs.add(data);
              });

              if (celebs.length > 0) {
                totalAds=totalAds+1;
                return categoryRow(
                    context: context,
                    categoryData: celebs,
                    categoryName: "${categories[i]}");
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          })
      );

    }


    var i=0;
    var loop=true;
    while(loop){
      if(i<9){
        print("Adding ads");
        if(i%3==0){
          automatedCategoriesList.insert(i, bigBanner(context: context));
        }
        i++;
      }
      else{
        loop=false;
      }
    }



    return ListView(
      children: automatedCategoriesList,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );

  }
}
