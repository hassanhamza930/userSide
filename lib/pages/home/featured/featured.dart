import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userside/pages/home/featured/components/automatedCategories.dart';

import 'components/components.dart';
import 'package:userside/pages/home/featured/components/celebrityContainer.dart';
import 'package:userside/pages/home/featured/components/featuredVibeContainer.dart';
import 'package:userside/pages/home/featuredVideoPlayer/featuredVideoPlayer.dart';
import 'package:userside/pages/home/search/search.dart';
import 'package:userside/pages/home/trending/trending.dart';
import 'package:userside/util/styles.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";import 'package:flutter/cupertino.dart';







class Featured extends StatefulWidget {
  @override
  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bluebackground.png",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 10,bottom: 50),
              // padding: EdgeInsets.only(bottom:100),
              child: Center(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context){
                                  return Search();
                                })
                            );
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(3),
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0))),
                              child: Center(
                                child: TextField(
                                  enabled: false,
                                  style: TextStyle(color: Colors.white, fontFamily: 'Avenir'),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    enabled: true,
                                    labelText: 'Search',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Avenir'),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsetsDirectional.only(start: 20.0),
                                  ),
                                  onChanged: (_onChanged) {
                                    print(_onChanged);
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,CupertinoPageRoute(builder: (context){
                                return Trending();
                              }));
                            },
                            child: Image.asset(
                                "assets/categories.png",
                              fit: BoxFit.contain,
                              height: 30,
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    featuredVibes(),
                    banner(),
                    // bigBanner(context: context),
                    SizedBox(height: 20,),
                    StreamBuilder(
                      stream:FirebaseFirestore.instance.collection("appSettings").doc("images").snapshots(),
                      builder: (context,appImagesSnap) {
                        if(appImagesSnap.hasData){
                          DocumentSnapshot doc=appImagesSnap.data;
                          Map adsData=doc.data();

                          return StreamBuilder(
                              stream: FirebaseFirestore.instance.collection("appSettings").doc("categories").snapshots(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  var data=snapshot.data["categories"];
                                  int elLength=data.length;
                                  List<Widget> listData=[];

                                  for(int i=0;i<elLength;i++){
                                    listData.add(
                                        categoryRow(context: context,categoryData: data[i]["celebrities"],categoryName: data[i]["name"])
                                    );
                                  }

                                  var totalAds=adsData["banner"].length;
                                  var current=0;

                                  var i=0;
                                  var loop=true;
                                  while(loop){
                                    if(i<listData.length){
                                      if(i%4==0 && i!=0){
                                        if(current==totalAds){
                                          listData.insert(i, bigBanner(context: context,index:0));
                                          current=0;
                                        }
                                        else{
                                          listData.insert(i, bigBanner(context: context,index: current));
                                        }
                                        current+=1;
                                      }
                                      i++;
                                    }
                                    else{
                                      loop=false;
                                    }

                                  }


                                  return ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: listData,
                                  );

                                }
                                else{
                                  return Container();
                                }
                              }
                          );
                        }
                        else{
                          return Container();
                        }
                      }
                    ),
                    FutureBuilder(
                      future: automatedCategories(context: context),
                      builder: (context,future) {
                        if(future.hasData){
                          var automatedCategoriesList=future.data;
                          return ListView(
                            children: automatedCategoriesList,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          );
                        }
                        else{
                          return Center(
                            child: Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()
                            ),
                          );
                        }
                      }
                    ),
                    SizedBox(height: 50,),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
