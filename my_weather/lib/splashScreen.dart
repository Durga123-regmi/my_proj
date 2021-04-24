import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  AnimationController _controller;
  Animation<double> _positionAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _sizeAnimation;
  Animation _curve;

  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1));
    _curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _sizeAnimation = Tween<double>(begin: 1, end: 80.0).animate(_curve);
    _positionAnimation = Tween<double>(begin: -2.0, end: 0.0).animate(_curve);
    _sizeAnimation = Tween<double>(begin: 16, end: 50).animate(_curve);


    _controller.addListener(() {
      if (_controller.isCompleted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    _controller.forward();
  }

  void dispose() {
     _controller.dispose();
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.redAccent[200],
        body: Center(
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: 0.7,
                      child: physicalModel(
                          Colors.greenAccent[200],
                          Container(
                            height: 200,
                            width: 200,
                            child:
                                Image.asset('image/w1.gif', fit: BoxFit.fill),
                          ),
                          15),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: 0.3,
                          child: physicalModel(
                              Colors.deepPurple[200],
                              Container(
                                height: 200,
                                width: 100,
                                child: Image.asset(
                                  'image/w2.gif',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              10),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: Opacity(
                        opacity: 0.3,
                        child: physicalModel(
                            Colors.yellow[200],
                            Container(
                              height: 200,
                              width: 100,
                              child: Image.asset(
                                'image/w3.gif',
                                fit: BoxFit.fill,
                              ),
                            ),
                            5),
                      )),
                    ],
                  ),
                  Expanded(
                    child: Opacity(
                      opacity: 0.9,
                      child: physicalModel(
                          Colors.black26,
                          Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'image/w4.gif',
                              fit: BoxFit.fill,
                            ),
                          ),
                          5),
                    ),
                  )
                ],
              ),
              Opacity(
                opacity: 0.3,
                child: Align(
                  alignment: Alignment.center,
                  child: PhysicalModel(
                    elevation: 5,
                    color: Colors.transparent,
                    
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent
                     
                          
                          ),
                      height: 300,
                      width: 400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Align(
                      alignment: Alignment(_positionAnimation.value, 0),
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 700),
                        child: Card(
                          elevation: 5.0,
                          color: Colors.white10,
                          child: Text(
                            'Weather-mania',
                            style: TextStyle(
                                fontSize: _sizeAnimation.value,
                                color: Colors.white54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget physicalModel(Color color, Widget child, double elevation) {
    return PhysicalModel(
      color: color,
      shape: BoxShape.rectangle,
      shadowColor: color,
      elevation: elevation,
      child: child,
    );
  }
}
