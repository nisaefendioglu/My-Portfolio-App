import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nisa's Portfolio",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFFF559F),
                  Color(0xFFCF5CCF),
                  Color(0xFFFF57AC),
                  Color(0xFFFF6D91),
                  Color(0xFFFF8D7E),
                  Color(0xFFB6BAA6),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(110.0),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Color(0xFFb936b9),
                backgroundImage: AssetImage("assets/me.png"),
              )),
          Center(
            child: Text(
              "Hi There 👋 \nMy name is Nisa Efendioğlu, \nI’m Software Developer. ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 320.0),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SnakeButton(
                    child: Text(
                      "Github",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onTap: () => launch('https://github.com/nisaefendioglu'),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 380.0),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SnakeButton(
                    child: Text(
                      "Blog",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onTap: () => launch('https://nisaefendioglu.blog'),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(top: 440.0),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SnakeButton(
                    child: Text(
                      "LinkedIn",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    onTap: () =>
                        launch('https://www.linkedin.com/in/nisaefendioglu/'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SnakeButton extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color snakeColor;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback onTap;

  const SnakeButton({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
    this.borderWidth = 5.0,
    this.borderColor = Colors.white,
    this.snakeColor = Colors.purple,
    required this.onTap,
  }) : super(key: key);

  @override
  _SnakeButtonState createState() => _SnakeButtonState();
}

class _SnakeButtonState extends State<SnakeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: CustomPaint(
        painter: _SnakePainter(
          animation: _controller,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          snakeColor: widget.snakeColor,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _SnakePainter extends CustomPainter {
  final Animation animation;
  final Color snakeColor;
  final Color borderColor;
  final double borderWidth;
  _SnakePainter({
    required this.animation,
    required this.snakeColor,
    required this.borderColor,
    required this.borderWidth,
  }) : super(
          repaint: animation,
        );

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          snakeColor,
          Colors.transparent,
        ],
        stops: [
          0.1,
          1.0,
        ],
        startAngle: 0.0,
        endAngle: vector.radians(180),
        transform: GradientRotation(vector.radians(360.0 * animation.value)),
      ).createShader(rect);

    final path = Path.combine(
      PathOperation.intersect,
      Path()..addRect(rect),
      Path()
        ..addRect(
          rect.deflate(borderWidth),
        ),
    );
    canvas.drawRect(
      rect.deflate(borderWidth / 2),
      Paint()
        ..color = borderColor
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke,
    );
    path.addRect(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
