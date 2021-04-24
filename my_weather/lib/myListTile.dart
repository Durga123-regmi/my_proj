import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  var title;
  var subTitle;
  var imagePath;
  double opacity;
  double pictureOpacity;

  MyListTile({this.title, this.subTitle, this.imagePath,this.opacity,this.pictureOpacity});
  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
          height: 100,
          width: 400,
          decoration: BoxDecoration(color: Colors.white54),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    widget.title,
                    style: TextStyle(
                        color: Colors.redAccent[200],
                        fontSize: 29,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    widget.subTitle.toString(),
                    style: TextStyle(
                        color: Colors.red[100],
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Opacity(
                      
                      opacity: 0.7,
                      child: Image.asset(
                        'image/${widget.imagePath}.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
