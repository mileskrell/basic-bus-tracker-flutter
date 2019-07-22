import 'package:basic_bus_tracker_flutter/repo/repository.dart';
import 'package:flutter/material.dart';

import 'package:basic_bus_tracker_flutter/model/bus_models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = "Basic Bus Tracker";
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: BusTracker(),
      ),
    );
  }
}

class BusTracker extends StatefulWidget {
  @override
  BusTrackerState createState() => BusTrackerState();
}

class BusTrackerState extends State<BusTracker> {
  var routes = <BusRoute>[];

  BusTrackerState() {
    loadRoutes();
  }

  void loadRoutes() async {
    var newRoutes = await fetchRoutes();
    setState(() {
      routes = newRoutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (routes.length > 0) {
      return PageView(
        children: routes
            .map((route) => Center(
                    child: Text(
                  route.routeName,
                  style: TextStyle(
                      fontSize: 22, color: Color(int.parse(route.routeColor))),
                )))
            .toList(),
      );
    } else {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.all(8)),
          Text("Loading routes...", style: TextStyle(fontSize: 22))
        ],
      ));
    }
  }
}
