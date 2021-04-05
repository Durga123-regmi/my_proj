import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  AnimationController _controller;
  Animation<double> _animation;
  Animation<Color> _colorAnimation;
  Animation<double> _sizeAnimation;
  Animation _curve;

  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _sizeAnimation = Tween<double>(begin: 1, end: 80.0).animate(_curve);

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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
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
                          child: Image.asset('image/w1.gif', fit: BoxFit.fill),
                        ),
                        15),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        opacity: 0.7,
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
                      opacity: 0.7,
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
                    opacity: 0.7,
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
              child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: AssetImage('image/s.png'), fit: BoxFit.fill)),
                    height: 500,
                    width: 400,
                    ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Container(
                      height: _sizeAnimation.value,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(25, 40),
                              topRight: Radius.elliptical(
                                25,
                                40,
                              ))),
                      child: Center(
                          child: AnimatedOpacity(
                        opacity: _opacity,
                        duration: Duration(milliseconds:700),
                        child: Text(
                          'Wheather-mania',
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                    );
                  },
                ),
              ),
            )
          ],
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
