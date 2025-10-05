class ProjectModel {
  List<TotalProjects>? totalProjects;
  bool? status;
  int? statusCode;
  String? message;

  ProjectModel({
    this.totalProjects,
    this.status,
    this.statusCode,
    this.message,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      totalProjects:
          json['total_projects'] != null
              ? (json['total_projects'] as List)
                  .map((v) => TotalProjects.fromJson(v))
                  .toList()
              : [],
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }
}

class TotalProjects {
  int? id;
  String? name;
  int? clientId;
  String? location;
  String? city;
  String? address;
  String? state;
  String? pin;
  dynamic startDate;
  dynamic endDate;
  String? status;
  String? estimatedCost;
  String? actualCost;
  String? description;
  String? photo;
  String? createdAt;
  String? updatedAt;
  String? projectImageUrl;

  TotalProjects({
    this.id,
    this.name,
    this.clientId,
    this.location,
    this.city,
    this.address,
    this.state,
    this.pin,
    this.startDate,
    this.endDate,
    this.status,
    this.estimatedCost,
    this.actualCost,
    this.description,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.projectImageUrl,
  });

  factory TotalProjects.fromJson(Map<String, dynamic> json) {
    return TotalProjects(
      id: json['id'],
      name: json['name'],
      clientId: json['client_id'],
      location: json['location'],
      city: json['city'],
      address: json['address'],
      state: json['state'],
      pin: json['pin'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      estimatedCost: json['estimated_cost'],
      actualCost: json['actual_cost'],
      description: json['description'],
      photo: json['photo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      projectImageUrl: json['image_url'],
    );
  }
}


// class ProjectModel {
//   List<TotalProjects>? totalProjects;
//   bool? status;
//   int? statusCode;
//   String? message;

//   ProjectModel({
//     this.totalProjects,
//     this.status,
//     this.statusCode,
//     this.message,
//   });

//   factory ProjectModel.fromJson(Map<String, dynamic> json) {
//     return ProjectModel(
//       totalProjects: json['total_projects'] != null
//           ? (json['total_projects'] as List)
//               .map((v) => TotalProjects.fromJson(v))
//               .toList()
//           : [],
//       status: json['status'],
//       statusCode: json['status_code'],
//       message: json['message'],
//     );
//   }
// }

// class TotalProjects {
//   int? id;
//   String? name;
//   int? clientId;
//   String? location;
//   String? city;
//   String? address;
//   String? state;
//   String? pin;
//   dynamic startDate;
//   dynamic endDate;
//   String? status;
//   String? estimatedCost;
//   String? actualCost;
//   String? description;
//   String? photo;
//   String? createdAt;
//   String? updatedAt;
//   String? projectImageUrl;

//   /// ✅ Added fields
//   double? latitude;
//   double? longitude;

//   TotalProjects({
//     this.id,
//     this.name,
//     this.clientId,
//     this.location,
//     this.city,
//     this.address,
//     this.state,
//     this.pin,
//     this.startDate,
//     this.endDate,
//     this.status,
//     this.estimatedCost,
//     this.actualCost,
//     this.description,
//     this.photo,
//     this.createdAt,
//     this.updatedAt,
//     this.projectImageUrl,
//     this.latitude,
//     this.longitude,
//   });

//   /// ✅ Lat/Lng parser
//   static List<double>? _parseLatLng(String? location) {
//     if (location == null) return null;
//     try {
//       // Case 1: Google Maps URL
//       if (location.contains("google.com") && location.contains("q=")) {
//         final uri = Uri.parse(location);
//         final qParam = uri.queryParameters["q"];
//         if (qParam != null && qParam.contains(",")) {
//           final parts = qParam.split(",");
//           final lat = double.tryParse(parts[0].trim());
//           final lng = double.tryParse(parts[1].trim());
//           if (lat != null && lng != null) return [lat, lng];
//         }
//       }

//       // Case 2: Direct "lat,lng"
//       if (location.contains(",")) {
//         final parts = location.split(",");
//         if (parts.length == 2) {
//           final lat = double.tryParse(parts[0].trim());
//           final lng = double.tryParse(parts[1].trim());
//           if (lat != null && lng != null) return [lat, lng];
//         }
//       }
//     } catch (_) {}
//     return null;
//   }

//   factory TotalProjects.fromJson(Map<String, dynamic> json) {
//     final loc = json['location'] as String?;
//     final coords = _parseLatLng(loc);

//     return TotalProjects(
//       id: json['id'],
//       name: json['name'],
//       clientId: json['client_id'],
//       location: loc,
//       city: json['city'],
//       address: json['address'],
//       state: json['state'],
//       pin: json['pin'],
//       startDate: json['start_date'],
//       endDate: json['end_date'],
//       status: json['status'],
//       estimatedCost: json['estimated_cost'],
//       actualCost: json['actual_cost'],
//       description: json['description'],
//       photo: json['photo'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       projectImageUrl: json['image_url'],
//       latitude: coords != null ? coords[0] : null,
//       longitude: coords != null ? coords[1] : null,
//     );
//   }
// }
