import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadignWidget extends StatefulWidget {
  @override
  _LoadignWidgetState createState() => _LoadignWidgetState();
}

class _LoadignWidgetState extends State<LoadignWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _rotateAnimation;
  CurvedAnimation _curve;

  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _curve = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _rotateAnimation = Tween<double>(begin: 0, end: math.pi*2).animate(_curve);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Transform.rotate(
            angle: _rotateAnimation.value,
            child:   Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhysicalModel(
                elevation: 5,
                shape:BoxShape.circle,
                color: Colors.redAccent[100]
                ,
                
                
                shadowColor: Colors.white,
                child: Container(
                  height: 50,
                  width:50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 5.0,

                      color: Colors.white

                    ),
                    gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,
                    colors: [
                      Colors.red[200],
                      Colors.red[100],


                    ],
                    stops: [
                      0.5,
                      0.5

                    ]
                    ),
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
