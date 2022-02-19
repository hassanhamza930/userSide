import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:userside/pages/home/featured/components/components.dart';

var categories=[
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
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context,index){
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("celebrities").where("interests",arrayContains:"${categories[index]}").snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<DocumentSnapshot> docs=snapshot.data.docs;
              var celebs=[];
              docs.forEach((element) {
                var data=element.id;
                celebs.add(data);
              });
              if(celebs.length>0){
                return categoryRow(context: context, categoryData: celebs, categoryName: "${categories[index]}");
              }
              else{
                return Container();
              }
            }
            else{
              return Container();
            }
          }
        );
      },
    );
  }
}
