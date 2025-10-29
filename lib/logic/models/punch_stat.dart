class PunchModel {
  final bool status;
  final int statusCode;
  final String message;
  final String userType;
  final Attendance attendance;

  PunchModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.userType,
    required this.attendance,
  });

  factory PunchModel.fromJson(Map<String, dynamic> json) {
    return PunchModel(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      userType: json['user_type'] ?? '',
      attendance: Attendance.fromJson(json['attendance'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "status_code": statusCode,
      "message": message,
      "user_type": userType,
      "attendance": attendance.toJson(),
    };
  }
}

class Attendance {
  final int? id;
  final int? labourId;
  final int? supervisorId;
  final int? projectId;
  final String? checkIn;
  final String? checkOut;
  final String? hoursWorked;
  final String? wage;
  final String? labourLocation;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Attendance({
    this.id,
    this.labourId,
    this.supervisorId,
    this.projectId,
    this.checkIn,
    this.checkOut,
    this.hoursWorked,
    this.wage,
    this.labourLocation,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      labourId: json['labour_id'],
      supervisorId: json['supervisor_id'],
      projectId: json['project_id'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      hoursWorked: json['hours_worked']?.toString(),
      wage: json['wage']?.toString(),
      labourLocation: json['labour_location'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "labour_id": labourId,
      "supervisor_id": supervisorId,
      "project_id": projectId,
      "check_in": checkIn,
      "check_out": checkOut,
      "hours_worked": hoursWorked,
      "wage": wage,
      "labour_location": labourLocation,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
