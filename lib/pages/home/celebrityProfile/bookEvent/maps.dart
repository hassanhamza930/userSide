import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:userside/pages/home/celebrityProfile/bookEvent/bookEvent.dart';
import 'package:userside/util/components.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:userside/pages/home/celebrityProfile/bookEvent/bookEvent.dart' as bookEvent;
import 'package:location/location.dart';

var searchController=TextEditingController(text: "");
var initialPos=CameraPosition(target: bookEvent.markerList[0].position,zoom: 15);
GoogleMapController contr;


class maps extends StatefulWidget {
  @override
  _mapsState createState() => _mapsState();
}

class _mapsState extends State<maps> {



  getPos()async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return [_locationData.latitude,_locationData.longitude];
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(
            children: [
              FutureBuilder(
                future: getPos(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return GoogleMap(
                      mapType: MapType.normal,
                      mapToolbarEnabled: true,
                      compassEnabled: true,
                      initialCameraPosition: CameraPosition(target: LatLng(snapshot.data[0],snapshot.data[1]),zoom: 14),
                      onMapCreated: (GoogleMapController controller) async{
                        setState(() {
                          contr=controller;
                        });
                        // controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_locationData.latitude,_locationData.longitude))));
                      },
                      onTap: (cords){

                        setState(() {
                          currentLoc=cords;
                          markerList.add(Marker(position: currentLoc,markerId: MarkerId("${currentLoc.toString()}") ));
                          markerList.removeAt(0);
                        });

                      },
                      markers: markerList.toSet(),
                    );
                  }
                  else{
                    return Container();
                  }
                }
              ),
              Container(
                height: height,
                width: width,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: authButton(text: "Done", color: Colors.white, bg: Colors.orange, onPress: (){
                      Navigator.pop(context);
                    }, context: context,thin: true),

                  ),
                ),
              ),
              Container(
                  color: Colors.black.withOpacity(0.2),
                  width: width,
                  height: height*0.3,
                  padding: EdgeInsets.all(5),
                  child:Center(
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search,color: Colors.black,),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                filled: true
                              ),
                              controller: searchController,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: FutureBuilder(
                              future: http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${searchController.text}&key=AIzaSyCGvQ64K_6CXy7Djzc-DF0W7CHCrJq393A")),
                              builder: (context2,snapshot){
                                if(snapshot.hasData){
                                  http.Response response=snapshot.data;
                                  List predictions=jsonDecode(response.body)["predictions"];
                                  predictions.forEach((element) {
                                    print(element["description"]);
                                  });


                                  return ListView.builder(
                                      itemCount: predictions.length,
                                      itemBuilder: (context,index){



                                          return GestureDetector(
                                            onTap: ()async{
                                              var placeId=predictions[index]["place_id"];
                                              http.Response resp=await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyCGvQ64K_6CXy7Djzc-DF0W7CHCrJq393A&place_id=${placeId}"));
                                              Map geometry=jsonDecode(resp.body);
                                              print('response');//["result"]["geometry"];
                                              print("  "*999);//["result"]["geometry"];
                                              var location=geometry["result"]["geometry"]["location"];
                                              contr.animateCamera(CameraUpdate.newLatLngZoom(LatLng(location["lat"], location["lng"]), 20));
                                              setState(() {

                                                markerList.add(Marker(position: LatLng(location["lat"],location["lng"]),markerId: MarkerId("${location["lat"].toString()}") ));
                                                markerList.removeAt(0);

                                              });

                                            },
                                            child: Container(
                                              color: Colors.white,
                                              margin: EdgeInsets.only(top:5),
                                              padding: EdgeInsets.all(5),
                                              width: width*0.8,
                                              height: 50,
                                              child: Text("${predictions[index]["description"]}",overflow: TextOverflow.fade,),
                                            ),
                                          );


                                      }
                                  );
                                }
                                else{
                                  return Container();
                                }
                              }
                              ),
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
