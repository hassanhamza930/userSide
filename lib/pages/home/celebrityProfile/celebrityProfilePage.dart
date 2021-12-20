
import 'package:userside/pages/home/celebrityProfile/bookEvent/bookEvent.dart';
import 'package:userside/pages/home/celebrityProfile/components.dart';
import 'package:userside/pages/home/celebrityProfile/requestVideo/requestVideo.dart';
import 'package:userside/pages/home/celebrityProfile/sendMessage/celebrityChat.dart';
import 'package:userside/pages/home/featured/components/featuredVibeContainer.dart';
import 'package:userside/pages/home/featuredVideoPlayer/fanClub.dart';
import 'package:userside/pages/home/featuredVideoPlayer/featuredVideoPlayer.dart';
import 'package:userside/pages/home/home.dart' as Home;
import 'package:userside/pages/home/home.dart';
import 'package:userside/services/dynamicLinks.dart';
import 'package:userside/util/components.dart';
import 'package:userside/util/styles.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import "package:path_provider/path_provider.dart";
import "dart:io";


var demoVideosData=[
  "assets/celebProfile/demoVideo1.png",
  "assets/celebProfile/demoVideo2.png",
  "assets/celebProfile/demoVideo3.png"
];

var currentPage=0;

Future<String> getThumbnail({String url})async{
  print('called');
  final fileName = VideoThumbnail.thumbnailFile(
      video: "$url",
      thumbnailPath: (await getTemporaryDirectory()).path,
  imageFormat: ImageFormat.PNG,
  maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  quality: 100,
  );
  print('returned');
  return fileName;

}


class celebrityProfilePage extends StatefulWidget {

  final String id;
  celebrityProfilePage({@required this.id});

  @override
  _celebrityProfilePageState createState() => _celebrityProfilePageState();
}

class _celebrityProfilePageState extends State<celebrityProfilePage> {
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;




    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("celebrities").doc(widget.id.toString()).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){

               DocumentSnapshot doc= snapshot.data;
               Map data=doc.data();
               

              return Stack(
                children: [
                  Image.asset(
                    "assets/bluebackground.png",
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                  ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: width ,
                            height: height*0.5,
                            child: PageView(
                              onPageChanged: (e){
                                setState(() {
                                  currentPage=e;
                                });
                              },
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 150,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 150,
                                      backgroundImage: NetworkImage("${data["imgSrc"]}"),
                                    ),
                                  ),
                                ),
                                data["vidSrc"]==""?
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white38,
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    height: 200,
                                    width: width*0.4,
                                    child: Center(child: Text("This celebrity has no video yet",style: small(color: Colors.black),textAlign: TextAlign.center,)),
                                  ),
                                ):
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                          decoration:BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)
                                              )
                                          ),
                                          width: width,
                                          height: height*0.5,
                                          child: InAppWebView(
                                            initialUrlRequest: URLRequest(url: Uri.parse(data["vidSrc"])),
                                            initialOptions: InAppWebViewGroupOptions(
                                                android: AndroidInAppWebViewOptions(
                                                    allowFileAccess: true,
                                                    cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK,
                                                    allowContentAccess: true
                                                )
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,CupertinoPageRoute(builder: (context){
                                return fanClub(celebId: widget.id,);
                              }));
                            },
                            child: Container(
                              width: width,
                              padding: EdgeInsets.only(top:20),
                              //padding: EdgeInsets.all(20),
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: width*0.5,
                                // padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)
                                            )
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "Join Fan Club",
                                          style: smallBold(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right:10),
                                      child: GestureDetector(
                                          onTap: ()async{
                                            //Add the Copy button here
                                            var link= await buildCelebIdDynamicLink(celebId: widget.id);
                                            await ClipboardManager.copyToClipBoard("${link}");
                                            print(link);
                                            print("copied");

                                            },
                                          child: Icon(Icons.share,color: Colors.white,)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle,color: currentPage==0?Colors.orange:Colors.white,size: 12,),
                          SizedBox(width: 5,),
                          Icon(Icons.circle,color: currentPage==1?Colors.orange:Colors.white,size: 12,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Container(
                          width: width * 0.9,
                          child: Text(
                            "${data["fullName"]}",
                            style: TextStyle(
                              fontSize: 34,
                              fontFamily: "AvenirBold",
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("requests").where("celebrity",isEqualTo:widget.id ).snapshots(),
                          builder: (context,snapshot){
                              if(snapshot.hasData){
                                QuerySnapshot doc=snapshot.data;
                                var docs=doc.docs;
                                var ratingAvg=0;
                                var total=0;

                                docs.forEach((element) {

                                    Map currentDocData=element.data();
                                    var currentReview=currentDocData["review"];

                                    if(currentReview!=null){
                                      total+=1;
                                      ratingAvg+=(currentReview["rating"]);
                                      ratingAvg=(ratingAvg/total).toInt();
                                    }


                                });

                                return rating(context: context,rating: ratingAvg.toDouble(),responseTime:( int.parse(data["dm"]["responseTime"]) ),reviews:total);
                              }
                              else{
                                return Container();
                              }
                          }
                          ),
                      SizedBox(height: 20,),
                      description(description: "${data["about"]==null?"No About":data["about"]}", context: context),
                      SizedBox(height: 20,),

                      data["eventBooking"]["hidden"]==true && data["dm"]["hidden"]==true && data["videoRequest"]["hidden"]==true?
                      Center(
                        child: Container(
                          width: width*0.9,
                          child: Text("This celebrity has no offerings at the moment",style: small(color: Colors.white,size: 14),),
                        ),
                      ):
                      Container(),

                      data["dm"]["hidden"]==false?celebButton(label: "Send DM ¢${data["dm"]["price"]}",context: context,color:Colors.orange,bg:Colors.white,icon:Icon(Icons.message,color: Colors.blue,),onpress: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context){
                          return celebrityChat(celebId: widget.id.toString(),);
                        }));
                      }):Container(),
                      data["videoRequest"]["hidden"]==false?celebButton(label: "Request Video ¢${data["videoRequest"]["price"]}",context: context,color:Colors.white,bg:Colors.orange,icon:Icon(Icons.videocam_sharp,color: Colors.blue,),onpress: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context){
                          return requestVideo( celebId: widget.id,);
                        }));
                      }):Container(),
                      data["eventBooking"]["hidden"]==false?celebButton(label: "Book for Event ¢${data["eventBooking"]["budgetFrom"]} to ¢${data["eventBooking"]["budgetTo"]} ", context: context, color: Colors.white, bg: Colors.orange, icon: FaIcon(FontAwesomeIcons.calendarCheck,color: Colors.blue,), onpress: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context){
                          return bookEvent(celebrity:widget.id);
                        }));
                      }):Container(),
                      SizedBox(height: 20,),
                      Center(
                        child:Container(
                          width: width*0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  "Some Videos",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Avenir",
                                      fontSize: 22
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) ,
                      ),
                      Center(
                        child: Container(
                          width: width*0.9,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection("requests").where("type",isEqualTo: "videoRequest").where("celebrity",isEqualTo: widget.id).where("private",isEqualTo: false).snapshots(),
                                      builder: (context, snapshot) {

                                        if(snapshot.hasData){
                                          List<DocumentSnapshot> data=snapshot.data.docs;
                                          print(data);
                                          return Center(
                                            child: Container(
                                              padding: EdgeInsets.all(20),
                                              child: GridView.builder(
                                                gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: width*0.7,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 10),
                                                primary: true,
                                                physics:  NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: data.length,
                                                itemBuilder: (context,index){
                                                  Map currentDocData=data[index].data();

                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore.instance.collection("celebrities").doc(currentDocData["celebrity"]).snapshots(),
                                                      builder: (context, snapshot) {
                                                        if(snapshot.hasData){

                                                          Map celebData=snapshot.data.data();
                                                          return Row(
                                                            children: [
                                                              FutureBuilder(
                                                                future: getThumbnail(url: currentDocData["vidSrc"]),
                                                                builder: (context, snapshot) {
                                                                  if(snapshot.hasData){
                                                                    print(snapshot.data);
                                                                    return GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.push(
                                                                            context,
                                                                            CupertinoPageRoute(builder:(context){
                                                                              return featuredVideoPlayer(reqData: currentDocData,celebData: celebData,vidId: currentDocData["vidSrc"],);
                                                                            })
                                                                        );
                                                                      },
                                                                      child: Container(
                                                                        child: Stack(
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child:Image.file(
                                                                                File.fromUri(Uri.file(snapshot.data)),
                                                                                height: 200,
                                                                                width: 135,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.all(5),
                                                                              height:179,
                                                                              width: 135,
                                                                              alignment: Alignment.bottomCenter,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Flexible(
                                                                                    child: Text(
                                                                                      celebData["fullName"],
                                                                                      overflow: TextOverflow.fade,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                          fontSize: 14,
                                                                                          fontFamily: "Avenir",
                                                                                          color: Colors.white
                                                                                      ),

                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  // return Image.file(
                                                                  //       File.fromUri(Uri.file(snapshot.data)),
                                                                  //     height: 200,
                                                                  //     fit: BoxFit.contain,
                                                                  //   );
                                                                    // return Image.asset(snapshot.data);
                                                                  }
                                                                  else{
                                                                    return Center(child: CircularProgressIndicator(color: Colors.white,));
                                                                  }
                                                                }
                                                              ),
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
                                              ),
                                            ),
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
                          ),
                        ),
                      ),
                      SizedBox(height: 200,)

                    ],
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
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: height,
                    width: width,
                    child: Container(
                      height: 70,
                      padding: EdgeInsets.only(bottom: 15, left: 5, right: 5, top: 10),
                      color: Color.fromRGBO(24, 48, 93, 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                print("one");
                                setState(() {
                                  Home.currentTab = 0;
                                });

                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                                  return Home.Home();
                                }));

                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Home.currentTab == 0
                                                ? Colors.orange
                                                : Colors.white,
                                            BlendMode.srcATop),
                                        child: Image.asset(
                                          "assets/bottom bar/simple/1.png",fit: BoxFit.contain,
                                          height: 25,
                                        )),
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontSize: 12,
                                        color: Home.currentTab == 0
                                            ? Colors.orange
                                            : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                print("one");
                                setState(() {
                                  Home.currentTab = 1;
                                });
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                                  return Home.Home();
                                }));

                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Home.currentTab == 1
                                                ? Colors.orange
                                                : Colors.white,
                                            BlendMode.srcATop),
                                        child: Image.asset(
                                          "assets/bottom bar/simple/2.png",
                                          fit: BoxFit.contain,
                                          height: 25,
                                        )
                                    ),
                                    Text(
                                      "Requests",
                                      style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontSize: 12,
                                        color: Home.currentTab == 1
                                            ? Colors.orange
                                            : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                print("one");
                                setState(() {
                                  Home.currentTab = 2;
                                });
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                                  return Home.Home();
                                }));

                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Home.currentTab == 2
                                                ? Colors.orange
                                                : Colors.white,
                                            BlendMode.srcATop),
                                        child: Image.asset(
                                          "assets/bottom bar/simple/3.png",
                                          fit: BoxFit.contain,
                                          height: 25,)),
                                    Text(
                                      "Notifications",
                                      style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontSize: 12,
                                        color: Home.currentTab == 2
                                            ? Colors.orange
                                            : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          GestureDetector(
                              onTap: () {
                                print("one");
                                setState(() {
                                  Home.currentTab = 3;
                                });
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context){
                                  return Home.Home();
                                }));

                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Home.currentTab == 3
                                                ? Colors.orange
                                                : Colors.white,
                                            BlendMode.srcATop),
                                        child: Image.asset(
                                          "assets/bottom bar/simple/4.png",
                                          fit: BoxFit.contain,
                                          height: 25,)),
                                    Text(
                                      "Profile",
                                      style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontSize: 12,
                                        color: Home.currentTab == 3
                                            ? Colors.orange
                                            : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            else{
              return Center(child: CircularProgressIndicator(color: Colors.blue,));
            }

          }
        ),
      ),
    );
  }
}
