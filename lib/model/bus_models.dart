import 'dart:math';

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
  List<int> _minutesUntilArrivals;

  set arrivalEstimates(List<DateTime> estimates) {
    _minutesUntilArrivals = estimates
        .map((timestamp) => timestamp.difference(DateTime.now()))
        // inMinutes only returns whole minutes; this rounds
        // to the nearest minute instead
        .map((time) => ((time.inSeconds) / 60).round())
        // If we get times in the past for some reason, just round them up to 0
        .map((minutes) => max(minutes, 0))
        .toList();
  }

  BusStop([this.stopId]);

  String getArrivalEstimateString() {
    if (_minutesUntilArrivals.length == 0) {
      return "No estimated arrivals";
    }

    switch (_minutesUntilArrivals.length) {
      case 1:
        switch (_minutesUntilArrivals[0]) {
          case 0:
            return "Arriving now";
          case 1:
            return "Arriving in 1 minute";
        }
        // Interesting note: if I move the following statement to a "default"
        // case in the above nested switch, the analyzer produces a warning.
        // See https://github.com/dart-lang/sdk/issues/34598
        return "Arriving in ${_minutesUntilArrivals[0]} minutes";
      case 2:
        return "Arriving in ${_minutesUntilArrivals[0]} and ${_minutesUntilArrivals[1]} minutes";
    }

    var timesString = "Arriving in ";
    for (var i = 0; i < _minutesUntilArrivals.length - 1; i++) {
      timesString += _minutesUntilArrivals[i].toString() + ", ";
    }
    timesString +=
        "and ${_minutesUntilArrivals[_minutesUntilArrivals.length - 1]} minutes";

    return timesString;
  }

  int getTextColor() {
    if (_minutesUntilArrivals.length == 0) {
      return 0xff000000; // black
    }

    final minArrivalMinutes = _minutesUntilArrivals.reduce(min);

    if (minArrivalMinutes <= 5) {
      return 0xffdb4437; // red
    }
    if (minArrivalMinutes <= 10) {
      return 0xfff4b400; // yellow
    }
    return 0xff4285f4; // blue
  }
}
