class ProjectModel {
  List<TotalProjects>? totalProjects;
  bool? status;
  int? statusCode;
  String? message;

  ProjectModel(
      {this.totalProjects, this.status, this.statusCode, this.message});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    if (json['total_projects'] != null) {
      totalProjects = (json['total_projects'] as List)
          .map((v) => TotalProjects.fromJson(v))
          .toList();
    }
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (totalProjects != null) {
      data['total_projects'] =
          totalProjects!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
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
  String? imageUrl;

  TotalProjects(
      {this.id,
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
      this.imageUrl});

  TotalProjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    clientId = json['client_id'];
    location = json['location'];
    city = json['city'];
    address = json['address'];
    state = json['state'];
    pin = json['pin'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    estimatedCost = json['estimated_cost'];
    actualCost = json['actual_cost'];
    description = json['description'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['client_id'] = clientId;
    data['location'] = location;
    data['city'] = city;
    data['address'] = address;
    data['state'] = state;
    data['pin'] = pin;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['estimated_cost'] = estimatedCost;
    data['actual_cost'] = actualCost;
    data['description'] = description;
    data['photo'] = photo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
