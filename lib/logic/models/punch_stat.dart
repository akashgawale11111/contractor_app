class PunchModel {
  bool? status;
  int? statusCode;
  String? message;
  Attendance? attendance;

  PunchModel({this.status, this.statusCode, this.message, this.attendance});

  PunchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    attendance = json['attendance'] != null
        ? Attendance.fromJson(json['attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    if (attendance != null) {
      data['attendance'] = attendance!.toJson();
    }
    return data;
  }
}

class Attendance {
  int? id;
  int? labourId;
  String? checkIn;
  String? checkOut;
  String? hoursWorked;
  String? wage;
  String? createdAt;
  String? updatedAt;
  int? projectId;
  String? status;

  Attendance(
      {this.id,
      this.labourId,
      this.checkIn,
      this.checkOut,
      this.hoursWorked,
      this.wage,
      this.createdAt,
      this.updatedAt,
      this.projectId,
      this.status});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    labourId = int.tryParse(json['labour_id'].toString());
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    hoursWorked = json['hours_worked'];
    wage = json['wage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    projectId = int.tryParse(json['project_id'].toString());
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['labour_id'] = labourId;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['hours_worked'] = hoursWorked;
    data['wage'] = wage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['project_id'] = projectId;
    data['status'] = status;
    return data;
  }
}
