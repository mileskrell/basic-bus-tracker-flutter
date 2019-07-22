import 'package:basic_bus_tracker_flutter/net/arrival_estimates_response.dart';
import 'package:basic_bus_tracker_flutter/net/routes_response.dart';
import 'package:basic_bus_tracker_flutter/net/stops_response.dart';
import 'package:http/http.dart' as http;

const AUTHORITY = "transloc-api-1-2.p.rapidapi.com";
const TRANSLOC_KEY = "get ur own";
const AGENCY = "1323";

// a circle of 1,000 meters around (40.505, -74.445)
const GEO_AREA = "40.505,-74.445|4000";

const queryParams = {"agencies": AGENCY, "geo_area": GEO_AREA};

const headers = {
  "X-RapidAPI-Host": "transloc-api-1-2.p.rapidapi.com",
  "X-RapidAPI-Key": TRANSLOC_KEY
};

Future<List<PredictionListBundle>> fetchTransLocArrivalEstimates() async {
  var response = await http.get(
      Uri.https(AUTHORITY, "arrival-estimates.json", queryParams),
      headers: headers);
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return arrivalEstimatesResponseFromJson(response.body).data;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load arrival estimates response');
  }
}

Future<List<Route>> fetchTransLocRoutes() async {
  var response = await http.get(
      Uri.https(AUTHORITY, "routes.json", queryParams),
      headers: headers);
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return routesResponseFromJson(response.body).data[AGENCY];
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load routes response');
  }
}

Future<List<Stop>> fetchTransLocStops() async {
  var response = await http.get(
      Uri.https(AUTHORITY, "stops.json", queryParams),
      headers: headers);
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return stopsResponseFromJson(response.body).data;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load routes response');
  }
}
