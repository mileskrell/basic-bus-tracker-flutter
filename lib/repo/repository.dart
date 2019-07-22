import 'package:basic_bus_tracker_flutter/net/transloc_service.dart';
import 'package:basic_bus_tracker_flutter/model/bus_models.dart';

// Translated from https://github.com/mileskrell/basic-bus-tracker-react-native/blob/master/src/repo/repository.js

Future<List<BusRoute>> fetchRoutes() async {
  // First we look at the arrival estimates to figure out which routes are actually active
  final arrivalEstimates = await fetchTransLocArrivalEstimates();

  var returnMeRoutes = arrivalEstimates
      // flat map to a list of arrival estimate objects
      .expand((predictionListBundle) => predictionListBundle.arrivals)
      // map each of those objects to the route ID the object says it's for
      .map((arrivalBundle) => arrivalBundle.routeId)
      // filter out duplicate route IDs
      .toSet()
      // map each route ID to an object. Later we'll also add the route's name, color, and stop predictions.
      .map((routeId) => BusRoute(routeId))
      .toList();

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  final rutgersRoutes = await fetchTransLocRoutes();

  // For each route, add the route's name, color, and associated stop IDs.
  returnMeRoutes.forEach((activeRoute) {
    final thisRouteInfoList = rutgersRoutes
        .where((rutgersRoute) => rutgersRoute.routeId == activeRoute.routeId);
    if (thisRouteInfoList.length > 0) {
      final thisRouteInfo = thisRouteInfoList.toList()[0];
      activeRoute.routeName = thisRouteInfo.longName;
      // I think this is the only difference from the JS version;
      // in that one I added "#" instead of "0xFF".
      activeRoute.routeColor = "0xFF" + thisRouteInfo.color;
      activeRoute.stops =
          thisRouteInfo.stops.map((stop) => BusStop(stop)).toList();
    }
  });

  // Next we'll remove the routes that...don't have names? That's why we needed that
  // "thisRouteInfoList.length > 0" check above - there are apparently predictions for
  // routes that...don't exist? Idk, but ok.
  returnMeRoutes =
      returnMeRoutes.where((route) => route.routeName != null).toList();

  // Next we'll add the predictions to our data
  returnMeRoutes.forEach((returningRoute) {
    final returningRouteId = returningRoute.routeId;
    returningRoute.stops.forEach((returningStop) {
      final returningStopId = returningStop.stopId;
      returningStop.arrivalEstimates = arrivalEstimates
          // Make sure stop ID matches
          .where((predictionListBundle) =>
              predictionListBundle.stopId == returningStopId)
          // Flat map so we have a list of arrival bundles
          .expand((predictionListBundle) => predictionListBundle.arrivals)
          // Make sure route ID matches
          .where((arrivalBundle) => arrivalBundle.routeId == returningRouteId)
          // Map each bundle to the arrival estimate it contains
          .map((arrivalBundle) => arrivalBundle.arrivalAt)
          .toList();
    });
  });

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  // Finally, we'll get the names of all the stops
  final rutgersStops = await fetchTransLocStops();

  returnMeRoutes.forEach((route) {
    route.stops.forEach((stop) {
      stop.stopName = rutgersStops
          .where((rutgersStop) => rutgersStop.stopId == stop.stopId)
          .toList()[0]
          .name;
    });
  });

  // Sort routes alphabetically
  returnMeRoutes.sort((routeA, routeB) {
    return routeA.routeName.compareTo(routeB.routeName);
  });

  // Move certain routes to the front if present:
  moveRouteToFront(returnMeRoutes, "Summer 2");
  moveRouteToFront(returnMeRoutes, "Summer 1");
  // Hopefully I got the winter break capitalization right
  moveRouteToFront(returnMeRoutes, "Winter Break 2");
  moveRouteToFront(returnMeRoutes, "Winter Break 1");
  moveRouteToFront(returnMeRoutes, "Weekend 2");
  moveRouteToFront(returnMeRoutes, "Weekend 1");
  moveRouteToFront(returnMeRoutes, "Route All Campuses");

  return returnMeRoutes;
}

/**
 * Move a route to the front of a routes object
 *
 * @param routes routes object to modify
 * @param routeName name of route to move to front
 */
void moveRouteToFront(List<BusRoute> routes, routeName) {
  var routeIndex =
      routes.map((route) => route.routeName).toList().indexOf(routeName);

  if (routeIndex != -1) {
    routes.insert(0, routes.removeAt(routeIndex));
  }
}
