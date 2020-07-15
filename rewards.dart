  
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new RealHome(),
    );
  }
}

int _id = 0;

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => new MyHomePageState();
}

class MyCustomCard extends StatelessWidget {
  MyCustomCard({this.colors, this.id});

  final MaterialColor colors;
  final id;

  Widget build(BuildContext context) {
    if (colors == Colors.orange && id == _id) {
      return new Container(
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: colors.shade50,
        ),
        child: Image.network(
          'https://i.ibb.co/YPjd3Fm/stractch-card.png',
          fit: BoxFit.contain,
        ),
      );
    }
    if (colors == Colors.blue && _id == id) {
      return new Container(
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: colors.shade50,
          ),
          child: Text('Hello'));
    }
  }
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _frontScale;
  Animation<double> _backScale;
  var sid;
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  f(int i) {
    return Stack(
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            setState(() {
              sid = i;
              _id = sid;
              if (_controller.isCompleted || _controller.velocity > 0)
                _controller.reverse();
              else
                _controller.forward();
            });
          },
          child: new AnimatedBuilder(
            child: new MyCustomCard(
              colors: Colors.orange,
              id: i,
            ),
            animation: _backScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(1.0, _backScale.value, 1.0);

              _id = i;

              return new Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: child,
              );
            },
          ),
        ),
        new GestureDetector(
          onTap: () {
            setState(() {
              sid = i;

              print('This id is tapped');
              print(sid);

              if (_controller.isCompleted || _controller.velocity > 0)
                _controller.reverse();
              else
                _controller.forward();
            });
          },
          child: new AnimatedBuilder(
            child: new MyCustomCard(
              colors: Colors.blue,
              id: i,
            ),
            animation: _frontScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(1.0, _frontScale.value, 1.0);
              _id = i;
              return new Transform(
                transform: transform,
                alignment: FractionalOffset.center,
                child: child,
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return f(0);
  }
}


class RealHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              MyHomePage(),
              MyHomePage(),
            ]),
      ),
    );
  }
}
