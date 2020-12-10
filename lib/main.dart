import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';
// this is data from no heart beat bro
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}


class ZoomInOutAnimation extends StatefulWidget {


  @override
  ZoomInOutState createState() => ZoomInOutState();
}

class ZoomInOutState extends State<ZoomInOutAnimation>
    with TickerProviderStateMixin {
  AnimationController _breathingController;
  var _breathe = 0.0;
  AnimationController _angleController;
  var _angle = 0.0;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
      }
    });
    _breathingController.addListener(() {
      setState(() {
        _breathe = _breathingController.value;
      });
    });
    _breathingController.forward(from: 2.0);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _angleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _cut_factor = (10.0 * 2) as double;
    final size = 100.0 - _cut_factor * _breathe;
    return
    Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          width: size,
          height: size,
          child: Transform.rotate(
            angle: 0, //45 degree in radius
            child: Material(
                borderRadius: BorderRadius.circular(size / 3),
                child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.02,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.fill,
                    ))
            ),
          ),
        ),
      );

  }

}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("First Screen"),
        ),
        body: Stack(
          children: [
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS7ziH01h-PzYXrWg9lpsH6roPnrMxhz2V08A&usqp=CAU",
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("View Page"),
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false, // set to false
                        pageBuilder: (_, __, ___) => SecondPage(),
                      ),
                    );
                    // TransparentRoute(builder: (BuildContext context) => SecondPage());
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    /*   _controller =
    AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..repeat();*/

    _controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
        value: 1
    )
      ..repeat(reverse: true);
    _animation = CurvedAnimation(

      parent: _controller,
      curve: Curves.easeOut,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                  height: 120,
                  width: 120,
                  child: Center(
                      child: ZoomInOutAnimation())),
              Shimmer.fromColors(
                 period: Duration(milliseconds: 2500),                  baseColor: Colors.white,
                  highlightColor: Colors.white30,

                  child: Text("  Loading...",style:TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}


