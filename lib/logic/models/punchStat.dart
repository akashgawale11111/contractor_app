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
        ? new Attendance.fromJson(json['attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
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
    id = json['id'];
    labourId = json['labour_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    hoursWorked = json['hours_worked'];
    wage = json['wage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    projectId = json['project_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['labour_id'] = this.labourId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['hours_worked'] = this.hoursWorked;
    data['wage'] = this.wage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['project_id'] = this.projectId;
    data['status'] = this.status;
    return data;
  }
}
