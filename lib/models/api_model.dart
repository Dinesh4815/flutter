

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    bool? hasMore;
    int? total;
    int? page;
    int? limit;
    int? totalPages;
    bool? success;
    String? message;
    dynamic searchString;
    List<Datum>? data;

    Post({
        this.hasMore,
        this.total,
        this.page,
        this.limit,
        this.totalPages,
        this.success,
        this.message,
        this.searchString,
        this.data,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        hasMore: json["has_more"],
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["total_pages"],
        success: json["success"],
        message: json["message"],
        searchString: json["search_string"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "has_more": hasMore,
        "total": total,
        "page": page,
        "limit": limit,
        "total_pages": totalPages,
        "success": success,
        "message": message,
        "search_string": searchString,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? title;
    double? area;
    LocationId? locationId;
    DateTime? createdAt;
    Geometry? geometry;

    Datum({
        this.id,
        this.title,
        this.area,
        this.locationId,
        this.createdAt,
        this.geometry,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        area: json["area"]?.toDouble(),
        locationId: json["location_id"] == null ? null : LocationId.fromJson(json["location_id"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "area": area,
        "location_id": locationId?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "geometry": geometry?.toJson(),
    };
}

class Geometry {
    Type? type;
    List<List<double>>? coordinates;

    Geometry({
        this.type,
        this.coordinates,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: typeValues.map[json["type"]]!,
        coordinates: json["coordinates"] == null ? [] : List<List<double>>.from(json["coordinates"]!.map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
    );

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}

enum Type {
    POLYGON
}

final typeValues = EnumValues({
    "Polygon": Type.POLYGON
});

class LocationId {
    String? id;
    String? title;
    List<double>? coordinates;

    LocationId({
        this.id,
        this.title,
        this.coordinates,
    });

    factory LocationId.fromJson(Map<String, dynamic> json) => LocationId(
        id: json["_id"],
        title: json["title"],
        coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
