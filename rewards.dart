import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      home: MyWidget(),
    ),
  );
}

int _id = 0;
int count = 0;
int y;



class MyCustomCard extends StatelessWidget {
  MyCustomCard({this.colors, this.id});

  final MaterialColor colors;
  final id;

  Widget build(BuildContext context) {
    if (colors == Colors.blue && id == _id) {
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

    String x = y.toString();
    Random random = new Random();
    int z = random.nextInt(2);
    if (z == 1) {
      return new Container(
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Image.network(
                'https://i.ibb.co/wMV5ZgY/win.png',
                height: 150,
              ),
              Text('You have won \$  ' + x),
            ],
          ));
    }
    return new Container(
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: Center(child: Text('Better Luck Next Time !')));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => new MyHomePageState();

  Function(String) callback;

  MyHomePage(this.callback);
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
          child: new AnimatedBuilder(
            child: new MyCustomCard(
              colors: Colors.orange,
              id: i,
            ),
            animation: _backScale,
            builder: (BuildContext context, Widget child) {
              final Matrix4 transform = new Matrix4.identity()
                ..scale(1.0, _backScale.value, 1.0);

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
              Random random = new Random();
              y = random.nextInt(50);
              print('This id is tapped');
              print(sid);
              widget.callback(y.toString());
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
    return f(0);
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  String amount = '0';

  callback(newAmount) {
        setState(() {
          amount = newAmount;
        });
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: Column(children: <Widget>[
      Container(
        color: Colors.yellow[700],
        height: 200,
        child: Stack(children: <Widget>[
          Image.network(
            'https://i.ibb.co/Y08RLT9/win2.png',
            fit: BoxFit.fill,
          ),
          Row(
            children: <Widget>[
              Center(
                child: Text(
                  '  Your Rewards \n   ',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Text('You have won $amount')
            ],
          )
        ]),
      ),
      Expanded(
        child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
              MyHomePage(callback),
            ]),
      ),
    ])));
  }
}
