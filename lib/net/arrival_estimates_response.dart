// To parse this JSON data, do
//
//     final arrivalEstimatesResponse = arrivalEstimatesResponseFromJson(jsonString);

import 'dart:convert';

ArrivalEstimatesResponse arrivalEstimatesResponseFromJson(String str) => ArrivalEstimatesResponse.fromJson(json.decode(str));

String arrivalEstimatesResponseToJson(ArrivalEstimatesResponse data) => json.encode(data.toJson());

class ArrivalEstimatesResponse {
  int rateLimit;
  int expiresIn;
  String apiLatestVersion;
  DateTime generatedOn;
  List<PredictionListBundle> data;
  String apiVersion;

  ArrivalEstimatesResponse({
    this.rateLimit,
    this.expiresIn,
    this.apiLatestVersion,
    this.generatedOn,
    this.data,
    this.apiVersion,
  });

  factory ArrivalEstimatesResponse.fromJson(Map<String, dynamic> json) => new ArrivalEstimatesResponse(
    rateLimit: json["rate_limit"],
    expiresIn: json["expires_in"],
    apiLatestVersion: json["api_latest_version"],
    generatedOn: DateTime.parse(json["generated_on"]),
    data: new List<PredictionListBundle>.from(json["data"].map((x) => PredictionListBundle.fromJson(x))),
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

class PredictionListBundle {
  List<Arrival> arrivals;
  String agencyId;
  String stopId;

  PredictionListBundle({
    this.arrivals,
    this.agencyId,
    this.stopId,
  });

  factory PredictionListBundle.fromJson(Map<String, dynamic> json) => new PredictionListBundle(
    arrivals: new List<Arrival>.from(json["arrivals"].map((x) => Arrival.fromJson(x))),
    agencyId: json["agency_id"],
    stopId: json["stop_id"],
  );

  Map<String, dynamic> toJson() => {
    "arrivals": new List<dynamic>.from(arrivals.map((x) => x.toJson())),
    "agency_id": agencyId,
    "stop_id": stopId,
  };
}

class Arrival {
  String routeId;
  String vehicleId;
  DateTime arrivalAt;
  Type type;

  Arrival({
    this.routeId,
    this.vehicleId,
    this.arrivalAt,
    this.type,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) => new Arrival(
    routeId: json["route_id"],
    vehicleId: json["vehicle_id"],
    arrivalAt: DateTime.parse(json["arrival_at"]),
    type: typeValues.map[json["type"]],
  );

  Map<String, dynamic> toJson() => {
    "route_id": routeId,
    "vehicle_id": vehicleId,
    "arrival_at": arrivalAt.toIso8601String(),
    "type": typeValues.reverse[type],
  };
}

enum Type { VEHICLE_BASED }

final typeValues = new EnumValues({
  "vehicle-based": Type.VEHICLE_BASED
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
