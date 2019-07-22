class BusRoute {
  String routeId;
  String routeName;
  String routeColor;
  List<BusStop> stops;

  BusRoute([this.routeId]);
}

class BusStop {
  String stopId;
  String stopName;
  List<DateTime> arrivalEstimates;

  BusStop([this.stopId]);
}
