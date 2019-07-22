// To parse this JSON data, do
//
//     final routesResponse = routesResponseFromJson(jsonString);

import 'dart:convert';

RoutesResponse routesResponseFromJson(String str) => RoutesResponse.fromJson(json.decode(str));

String routesResponseToJson(RoutesResponse data) => json.encode(data.toJson());

class RoutesResponse {
  int rateLimit;
  int expiresIn;
  String apiLatestVersion;
  DateTime generatedOn;
  Map<String, List<Route>> data;
  String apiVersion;

  RoutesResponse({
    this.rateLimit,
    this.expiresIn,
    this.apiLatestVersion,
    this.generatedOn,
    this.data,
    this.apiVersion,
  });

  factory RoutesResponse.fromJson(Map<String, dynamic> json) => new RoutesResponse(
    rateLimit: json["rate_limit"],
    expiresIn: json["expires_in"],
    apiLatestVersion: json["api_latest_version"],
    generatedOn: DateTime.parse(json["generated_on"]),
    data: new Map.from(json["data"]).map((k, v) => new MapEntry<String, List<Route>>(k, new List<Route>.from(v.map((x) => Route.fromJson(x))))),
    apiVersion: json["api_version"],
  );

  Map<String, dynamic> toJson() => {
    "rate_limit": rateLimit,
    "expires_in": expiresIn,
    "api_latest_version": apiLatestVersion,
    "generated_on": generatedOn.toIso8601String(),
    "data": new Map.from(data).map((k, v) => new MapEntry<String, dynamic>(k, new List<dynamic>.from(v.map((x) => x.toJson())))),
    "api_version": apiVersion,
  };
}

class Route {
  String description;
  ShortName shortName;
  String routeId;
  String color;
  List<List<String>> segments;
  bool isActive;
  int agencyId;
  TextColor textColor;
  String longName;
  String url;
  bool isHidden;
  Type type;
  List<String> stops;

  Route({
    this.description,
    this.shortName,
    this.routeId,
    this.color,
    this.segments,
    this.isActive,
    this.agencyId,
    this.textColor,
    this.longName,
    this.url,
    this.isHidden,
    this.type,
    this.stops,
  });

  factory Route.fromJson(Map<String, dynamic> json) => new Route(
    description: json["description"],
    shortName: shortNameValues.map[json["short_name"]],
    routeId: json["route_id"],
    color: json["color"],
    segments: new List<List<String>>.from(json["segments"].map((x) => new List<String>.from(x.map((x) => x)))),
    isActive: json["is_active"],
    agencyId: json["agency_id"],
    textColor: textColorValues.map[json["text_color"]],
    longName: json["long_name"],
    url: json["url"],
    isHidden: json["is_hidden"],
    type: typeValues.map[json["type"]],
    stops: new List<String>.from(json["stops"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "short_name": shortNameValues.reverse[shortName],
    "route_id": routeId,
    "color": color,
    "segments": new List<dynamic>.from(segments.map((x) => new List<dynamic>.from(x.map((x) => x)))),
    "is_active": isActive,
    "agency_id": agencyId,
    "text_color": textColorValues.reverse[textColor],
    "long_name": longName,
    "url": url,
    "is_hidden": isHidden,
    "type": typeValues.reverse[type],
    "stops": new List<dynamic>.from(stops.map((x) => x)),
  };
}

enum ShortName { EMPTY, TEMP }

final shortNameValues = new EnumValues({
  "": ShortName.EMPTY,
  "TEMP": ShortName.TEMP
});

enum TextColor { FFFFFF, THE_000000 }

final textColorValues = new EnumValues({
  "FFFFFF": TextColor.FFFFFF,
  "000000": TextColor.THE_000000
});

enum Type { BUS }

final typeValues = new EnumValues({
  "bus": Type.BUS
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
