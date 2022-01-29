import 'package:userside/pages/home/celebrityProfile/celebrityProfilePage.dart';
import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";import 'package:flutter/cupertino.dart';


class celebrityContainer extends StatefulWidget {
  celebrityContainer({this.celebData,this.celebId});

  final Map celebData;
  final String celebId;

  @override
  _celebrityContainerState createState() => _celebrityContainerState();
}

class _celebrityContainerState extends State<celebrityContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return celebrityProfilePage(id: widget.celebId,);
          })
        );
      },
      child: Container(
        margin: EdgeInsets.only(top:20),
        decoration: BoxDecoration(
            color: Color.fromRGBO(24, 48, 93, 1),
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 180,
                height: 200,
                child: Image.network(
                  widget.celebData["imgSrc"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        widget.celebData["fullName"],
                        // overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontFamily: "Avenir",
                          fontSize: 18,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "More Info",
                        style: TextStyle(
                          fontFamily: "Avenir",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
