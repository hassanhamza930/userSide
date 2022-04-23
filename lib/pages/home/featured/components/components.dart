import 'package:userside/pages/home/trending/trending.dart';
import 'package:userside/util/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";import '../../../../util/components.dart';
import 'featuredVibeContainer.dart';
import 'celebrityContainer.dart';
import "featuredVibeContainer.dart";
import 'package:flutter/cupertino.dart';

var currentPage=0;



class featuredVibes extends StatefulWidget {

  @override
  _featuredVibesState createState() => _featuredVibesState();
}

class _featuredVibesState extends State<featuredVibes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: 20, left: 15, right: 15, bottom: 20,
      ),
      color: Color.fromRGBO(0, 22, 64, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "Featured Vibes",
                  textAlign: TextAlign.left,
                  style: medium(color: Colors.white)
              ),
              Text(
                  "View All",
                  textAlign: TextAlign.left,
                  style: small(color: Colors.orange)
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("requests").where("type",isEqualTo: "videoRequest").where("private",isEqualTo: false).where("status",isEqualTo: "complete").snapshots(),
              builder: (context, snapshot) {

                if(snapshot.hasData){
                  List<DocumentSnapshot> data=snapshot.data.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context,index){

                      Map currentDocData=data[index].data();
                      var reqId=data[index].id;


                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("celebrities").doc(currentDocData["celebrity"]).snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){

                            Map celebData=snapshot.data.data();
                            return Row(
                              children: [
                                FeaturedVibeContainer(reqId: reqId,celebData:celebData,reqData: currentDocData,vidId:currentDocData["vidSrc"],imgSrc:celebData["imgSrc"],name:celebData["fullName"] ),
                                SizedBox(width: 10,)
                              ],
                            );

                          }

                          else{
                            return Container();
                          }

                        }
                      );
                    },
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                  );
                }
                else{
                  return Container();
                }

              }
            ),
          ),
        ],
      ),
    );
  }
}







class banner extends StatefulWidget {
  @override
  _bannerState createState() => _bannerState();
}

class _bannerState extends State<banner> {
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("appSettings").doc("images").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          var data=snapshot.data.data();
          List bannerImages=data["bannerImages"];
          List<Widget> bannerImagesSorted=[];
          List<Widget> tickerList=[];
          bannerImages.asMap().forEach((index,element) {

            bannerImagesSorted.add(
              Container(
                  child: Image.network(
                    "${element}",
                    width: width ,
                    fit: BoxFit.contain,
                  )
              ),
            );

            tickerList.add(
              Container(
                margin: EdgeInsets.only(right:5),
                  child: Icon(Icons.circle,color: currentPage==index?Colors.orange:Colors.white,size: 12,)
              ),
            );


          });


          print("printing banner images");
          print(bannerImages);

          return Column(
            children: [
              Container(
                height: height*0.23,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 10,bottom: 5),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (page){
                    setState(() {
                      currentPage=page;
                    });
                  },
                  children: bannerImagesSorted
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tickerList
              )
            ],
          );
        }
        else{
          return Container();
        }
      }
    );
  }
}



categoryRow({@required BuildContext context,@required List categoryData,@required String categoryName}){
  return Container(
    padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                categoryName,
                textAlign: TextAlign.left,
                style: medium(color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context){
                      return Trending();
                    })
                );
              },
              child: Text(
                "View All",
                textAlign: TextAlign.left,
                style: small(color: Colors.orange),
              ),
            ),
          ],
        ),
        Container(
          height: 280,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categoryData.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.only(right:10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("celebrities").doc("${categoryData[index]}").snapshots(),
                  builder: (context, snapshot) {

                    if(snapshot.hasData){
                      DocumentSnapshot doc=snapshot.data;
                      Map data=doc.data();
                      if(data!=null){
                        return celebrityContainer( celebId:categoryData[index],celebData:data);
                      }
                      else{
                        return Container();
                      }
                    }
                    else{
                      return Container();
                    }

                  }
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}


bigBanner({BuildContext context,index=0}){
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection("appSettings").doc("images").snapshots(),
    builder: (context, snapshot) {

      if(snapshot.hasData){
        var data=snapshot.data.data();
        return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top:10),
            child: Image.network("${data["banner"][index]}",fit: BoxFit.contain,)
        );
      }
      else{
        return Container();
      }

    }
  );
}