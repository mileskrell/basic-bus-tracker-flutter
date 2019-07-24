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

  var _refreshing = true;

  BusTrackerState() {
    loadRoutes();
  }

  Future<Null> loadRoutes() async {
    // This check, combined with the fact that "refreshing" is initially true,
    // prevents setState from being called immediately upon state creation,
    // which would cause an error (setState would be called before
    // the widget was mounted, it seems).
    if (!_refreshing) {
      setState(() {
        _refreshing = true;
      });
    }

    var newRoutes = await fetchRoutes();

    // If the route the user had been viewing is also contained in the new data,
    // store its new position; otherwise, store -1.
    var newIndex = -1;
    if (_tabController != null && _routes.length > 0 && newRoutes.length > 0) {
      var oldRouteName = _routes[_tabController.index].routeName;
      newIndex = newRoutes.indexOf(
          newRoutes.where((route) => route.routeName == oldRouteName).first);
    }

    setState(() {
      // Save new routes
      _routes = newRoutes;

      if (newRoutes.length > 0) {
        // Create new TabController
        _tabController = TabController(length: newRoutes.length, vsync: this)
          ..addListener(() {
            // When current tab changes, send route color up to change colors
            widget
                .colorChangeCallback(_routes[_tabController.index].routeColor);
          })
        // Switch tabs to the route the user had been looking at (if still present)
          ..index = newIndex == -1 ? 0 : newIndex;

        // Set status bar color to color of currently-selected tab immediately
        widget.colorChangeCallback(_routes[_tabController.index].routeColor);
      }
    });

    setState(() {
      _refreshing = false;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Routes list is null upon state initialization (routes haven't been
    // fetched yet).
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

    // Routes are present; display them
    if (_routes.length > 0) {
      var tabs = _routes
          .map((route) => RefreshIndicator(
        onRefresh: loadRoutes,
        child: ListView.separated(
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
        ),
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

    // If refreshing (and the routes list is empty), show a loading indicator
    if (_refreshing) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: CircularProgressIndicator(
            value: null,
          ),
        ),
      );
    }

    // Otherwise, tell user that there were no predictions
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No predictions reported!\nTry again in a few minutes.",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
            ),
            IconButton(
              tooltip: "Refresh",
              icon: Icon(Icons.refresh),
              color: Colors.blueAccent,
              onPressed: loadRoutes,
            )
          ],
        ),
      ),
    );
  }
}
