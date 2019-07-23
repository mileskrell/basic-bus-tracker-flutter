import 'package:basic_bus_tracker_flutter/repo/repository.dart';
import 'package:flutter/material.dart';

import 'package:basic_bus_tracker_flutter/model/bus_models.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<MyApp> {
  final title = "Basic Bus Tracker";
  Color primaryColor = Colors.blue;
  Color accentColor = Colors.blueAccent;
  final indicatorColor = Colors.white;

  var colorChangeCallback;

  AppState() {
    colorChangeCallback = (String newColor) {
      setState(() {
        primaryColor = Color(int.parse(newColor));
        accentColor = Color(int.parse(newColor));
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        indicatorColor: indicatorColor,
      ),
      home: BusTracker(title, colorChangeCallback),
    );
  }
}

class BusTracker extends StatefulWidget {
  final String title;

  final void Function(String) colorChangeCallback;

  BusTracker(this.title, this.colorChangeCallback);

  @override
  BusTrackerState createState() => BusTrackerState();
}

class BusTrackerState extends State<BusTracker> with TickerProviderStateMixin {
  List<BusRoute> _routes;
  TabController _tabController;

  BusTrackerState() {
    initialLoadRoutes();
  }

  Future<Null> initialLoadRoutes() async {
    await loadRoutes();
  }

  Future<Null> loadRoutes() async {
    var newRoutes = await fetchRoutes();
    setState(() {
      // Dispose old TabController
      // TODO Is this necessary?
      _tabController?.dispose();

      // Save new routes
      _routes = newRoutes;

      // Create new TabController
      _tabController = TabController(length: newRoutes.length, vsync: this)
        ..addListener(() {
          // When current tab changes, send the route color to
          widget.colorChangeCallback(_routes[_tabController.index].routeColor);
        });

      // Set status bar color to color of currently-selected tab immediately
      widget.colorChangeCallback(_routes[_tabController.index].routeColor);
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_routes == null) {
      return Scaffold(
          appBar: AppBar(title: Text(widget.title)),
          body: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(padding: EdgeInsets.all(8)),
              Text("Loading predictions...", style: TextStyle(fontSize: 22))
            ],
          )));
    }

    if (_routes.length > 0) {
      var tabs = _routes
          .map((route) => ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: route.stops.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Text(
                        route.stops[index].stopName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      Text("estimates here")
                    ],
                  );
                },
              ))
          .toList();

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _routes
                  .map((route) => Tab(
                        text: route.routeName,
                      ))
                  .toList()),
        ),
        body: TabBarView(children: tabs, controller: _tabController),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: Text("No predictions reported!\nTry again in a few minutes.",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 22))),
    );
  }
}
