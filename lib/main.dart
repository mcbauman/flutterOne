// import 'dart:html';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCB-APP1',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color.fromARGB(255, 100, 100, 100),
      ),
      home: const MyHomePage(title: 'Kalika'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(controller: controller, children: const [
        DetailPage(headline: "Today", daysInPast: 0),
        DetailPage(headline: "Yesterday", daysInPast: 1)
      ]),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.headline, required this.daysInPast})
      : super(key: key);

  final String headline;
  final int daysInPast;
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 32, 8, 8),
        child: Column(
          children: [
            Text(
              widget.headline,
              style: const TextStyle(color: Colors.white70, fontSize: 25),
            ),
            TrackingElement(
                color: const Color.fromARGB(255, 255, 104, 104),
                icon: Icons.directions_run,
                unit: "min",
                daysInPast: widget.daysInPast,
                goal: 60),
            TrackingElement(
                color: const Color.fromARGB(255, 255, 255, 104),
                icon: Icons.water_drop_outlined,
                unit: "liter",
                daysInPast: widget.daysInPast,
                goal: 5),
            TrackingElement(
                color: const Color.fromARGB(255, 104, 255, 104),
                icon: Icons.lunch_dining_outlined,
                unit: "kcal",
                daysInPast: widget.daysInPast,
                goal: 1500),
            TrackingElement(
                color: const Color.fromARGB(255, 104, 104, 255),
                icon: Icons.bed_outlined,
                unit: "hours",
                daysInPast: widget.daysInPast,
                goal: 8)
          ],
        ));
  }
}

class TrackingElement extends StatefulWidget {
  const TrackingElement(
      {Key? key,
      required this.color,
      required this.icon,
      required this.unit,
      required this.daysInPast,
      required this.goal})
      : super(key: key);

  final String unit;
  final int goal;
  final IconData icon;
  final Color color;
  final int daysInPast;
  @override
  State<TrackingElement> createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _counter = 0;
  var now = DateTime.now();
  String _strorageKey = "";

  void _increment() async {
    setState(() {
      _counter += 1;
    });
    (await _prefs).setInt(_strorageKey, _counter);
  }

  @override
  void initState() {
    super.initState();
    _strorageKey =
        "${now.year}-${now.month}-${now.day - widget.daysInPast} ${widget.unit}";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prefs.then((prefs) {
      setState(() {
        _counter = prefs.getInt(_strorageKey) ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: _increment,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 64, 0, 8),
              child: Row(
                children: <Widget>[
                  Icon(widget.icon,
                      color: const Color.fromARGB(255, 255, 104, 104),
                      size: 40),
                  Text(
                      //_strorageKey,
                      "$_counter/${widget.goal} ${widget.unit}",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 20)),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: _counter / widget.goal,
              color: widget.color,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            )
          ],
        ));
  }
}
