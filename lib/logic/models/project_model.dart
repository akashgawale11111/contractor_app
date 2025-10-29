class ProjectModel {
  final List<TotalProjects>? totalProjects;
  final bool? status;
  final int? statusCode;
  final String? message;

  ProjectModel({
    this.totalProjects,
    this.status,
    this.statusCode,
    this.message,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['total_projects'] ?? json['projects'] ?? [];
    final projectsList = (rawList is List)
        ? rawList.map((v) => TotalProjects.fromJson(v)).toList()
        : <TotalProjects>[];

    return ProjectModel(
      totalProjects: projectsList,
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
    );
  }
}

class TotalProjects {
  final int? id;
  final String? name;
  final int? clientId;
  final String? location;
  final String? city;
  final String? address;
  final String? state;
  final String? pin;
  final dynamic startDate;
  final dynamic endDate;
  final String? status;
  final String? estimatedCost;
  final String? actualCost;
  final String? description;
  final String? photo;
  final String? createdAt;
  final String? updatedAt;
  final String? projectImageUrl;

  /// ✅ Parsed coordinates
  final double? latitude;
  final double? longitude;

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
    this.latitude,
    this.longitude,
  });

  /// ✅ Extract lat/lng from "location": "20.002586,74.009016"
  static List<double>? _parseLatLng(String? location) {
    if (location == null || location.isEmpty) return null;
    try {
      // Case 1: direct "lat,lng"
      if (location.contains(",")) {
        final parts = location.split(",");
        if (parts.length == 2) {
          final lat = double.tryParse(parts[0].trim());
          final lng = double.tryParse(parts[1].trim());
          if (lat != null && lng != null) return [lat, lng];
        }
      }

      // Case 2: google maps link like "...?q=20.002586,74.009016"
      if (location.contains("q=")) {
        final uri = Uri.tryParse(location);
        final query = uri?.queryParameters["q"];
        if (query != null && query.contains(",")) {
          final parts = query.split(",");
          final lat = double.tryParse(parts[0].trim());
          final lng = double.tryParse(parts[1].trim());
          if (lat != null && lng != null) return [lat, lng];
        }
      }
    } catch (_) {}
    return null;
  }

  factory TotalProjects.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as String?;
    final coords = _parseLatLng(loc);

    return TotalProjects(
      id: json['id'],
      name: json['name'],
      clientId: json['client_id'],
      location: loc,
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
      latitude: coords != null ? coords[0] : null,
      longitude: coords != null ? coords[1] : null,
    );
  }
}
