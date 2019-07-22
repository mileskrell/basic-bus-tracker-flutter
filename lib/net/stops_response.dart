// To parse this JSON data, do
//
//     final stopsResponse = stopsResponseFromJson(jsonString);

import 'dart:convert';

StopsResponse stopsResponseFromJson(String str) => StopsResponse.fromJson(json.decode(str));

String stopsResponseToJson(StopsResponse data) => json.encode(data.toJson());

class StopsResponse {
  int rateLimit;
  int expiresIn;
  String apiLatestVersion;
  DateTime generatedOn;
  List<Stop> data;
  String apiVersion;

  StopsResponse({
    this.rateLimit,
    this.expiresIn,
    this.apiLatestVersion,
    this.generatedOn,
    this.data,
    this.apiVersion,
  });

  factory StopsResponse.fromJson(Map<String, dynamic> json) => new StopsResponse(
    rateLimit: json["rate_limit"],
    expiresIn: json["expires_in"],
    apiLatestVersion: json["api_latest_version"],
    generatedOn: DateTime.parse(json["generated_on"]),
    data: new List<Stop>.from(json["data"].map((x) => Stop.fromJson(x))),
    apiVersion: json["api_version"],
  );

  Map<String, dynamic> toJson() => {
    "rate_limit": rateLimit,
    "expires_in": expiresIn,
    "api_latest_version": apiLatestVersion,
    "generated_on": generatedOn.toIso8601String(),
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
    "api_version": apiVersion,
  };
}

class Stop {
  String code;
  Description description;
  String url;
  dynamic parentStationId;
  List<String> agencyIds;
  dynamic stationId;
  LocationType locationType;
  Location location;
  String stopId;
  List<String> routes;
  String name;

  Stop({
    this.code,
    this.description,
    this.url,
    this.parentStationId,
    this.agencyIds,
    this.stationId,
    this.locationType,
    this.location,
    this.stopId,
    this.routes,
    this.name,
  });

  factory Stop.fromJson(Map<String, dynamic> json) => new Stop(
    code: json["code"],
    description: descriptionValues.map[json["description"]],
    url: json["url"],
    parentStationId: json["parent_station_id"],
    agencyIds: new List<String>.from(json["agency_ids"].map((x) => x)),
    stationId: json["station_id"],
    locationType: locationTypeValues.map[json["location_type"]],
    location: Location.fromJson(json["location"]),
    stopId: json["stop_id"],
    routes: new List<String>.from(json["routes"].map((x) => x)),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": descriptionValues.reverse[description],
    "url": url,
    "parent_station_id": parentStationId,
    "agency_ids": new List<dynamic>.from(agencyIds.map((x) => x)),
    "station_id": stationId,
    "location_type": locationTypeValues.reverse[locationType],
    "location": location.toJson(),
    "stop_id": stopId,
    "routes": new List<dynamic>.from(routes.map((x) => x)),
    "name": name,
  };
}

enum Description { EMPTY, WE_ASSIGNED_CODE }

final descriptionValues = new EnumValues({
  "": Description.EMPTY,
  "we assigned code": Description.WE_ASSIGNED_CODE
});

class Location {
  double lat;
  double lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => new Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

enum LocationType { STOP }

final locationTypeValues = new EnumValues({
  "stop": LocationType.STOP
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
