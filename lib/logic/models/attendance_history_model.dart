import 'dart:convert';

AttendanceHistoryResponse attendanceHistoryResponseFromJson(String str) =>
    AttendanceHistoryResponse.fromJson(json.decode(str));

String attendanceHistoryResponseToJson(AttendanceHistoryResponse data) =>
    json.encode(data.toJson());

class AttendanceHistoryResponse {
  final bool? status;
  final int? statusCode;
  final String? message;
  final User? user;
  final AttendanceData? data;

  AttendanceHistoryResponse({
    this.status,
    this.statusCode,
    this.message,
    this.user,
    this.data,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceHistoryResponse(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        data: json["data"] != null ? AttendanceData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "user": user?.toJson(),
        "data": data?.toJson(),
      };
}

class User {
  final String? type;
  final String? identifier;
  final String? name;

  User({
    this.type,
    this.identifier,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        type: json["type"],
        identifier: json["identifier"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "identifier": identifier,
        "name": name,
      };
}

class AttendanceData {
  final DateRange? dateRange;
  final Summary? summary;
  final List<AttendanceHistory>? attendanceHistory;

  AttendanceData({
    this.dateRange,
    this.summary,
    this.attendanceHistory,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        dateRange: json["date_range"] != null
            ? DateRange.fromJson(json["date_range"])
            : null,
        summary:
            json["summary"] != null ? Summary.fromJson(json["summary"]) : null,
        attendanceHistory: json["attendance_history"] != null
            ? List<AttendanceHistory>.from(json["attendance_history"]
                .map((x) => AttendanceHistory.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "date_range": dateRange?.toJson(),
        "summary": summary?.toJson(),
        "attendance_history":
            attendanceHistory?.map((x) => x.toJson()).toList(),
      };
}

class DateRange {
  final String? startDate;
  final String? endDate;

  DateRange({
    this.startDate,
    this.endDate,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) => DateRange(
        startDate: json["start_date"],
        endDate: json["end_date"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate,
        "end_date": endDate,
      };
}

class Summary {
  final int? totalRecords;
  final int? completedSessions;
  final int? activeSessions;
  final double? totalHoursWorked;
  final double? totalWage;

  Summary({
    this.totalRecords,
    this.completedSessions,
    this.activeSessions,
    this.totalHoursWorked,
    this.totalWage,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalRecords: json["total_records"],
        completedSessions: json["completed_sessions"],
        activeSessions: json["active_sessions"],
        totalHoursWorked:
            (json["total_hours_worked"] as num?)?.toDouble() ?? 0.0,
        totalWage: (json["total_wage"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
        "completed_sessions": completedSessions,
        "active_sessions": activeSessions,
        "total_hours_worked": totalHoursWorked,
        "total_wage": totalWage,
      };
}

class AttendanceHistory {
  final int? id;
  final String? userType;
  final int? userId;
  final String? userName;
  final int? projectId;
  final String? projectName;
  final PunchTime? punchIn;
  final PunchTime? punchOut;
  final String? hoursWorked;
  final String? wage;
  final String? status;
  final String? date;
  final String? approvalStatus;
  final String? approvedBy;
  final String? approvedAt;
  final String? createdAt;
  final String? updatedAt;

  AttendanceHistory({
    this.id,
    this.userType,
    this.userId,
    this.userName,
    this.projectId,
    this.projectName,
    this.punchIn,
    this.punchOut,
    this.hoursWorked,
    this.wage,
    this.status,
    this.date,
    this.approvalStatus,
    this.approvedBy,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) =>
      AttendanceHistory(
        id: json["id"],
        userType: json["user_type"],
        userId: json["user_id"],
        userName: json["user_name"],
        projectId: json["project_id"],
        projectName: json["project_name"],
        punchIn:
            json["punch_in"] != null ? PunchTime.fromJson(json["punch_in"]) : null,
        punchOut: json["punch_out"] != null
            ? PunchTime.fromJson(json["punch_out"])
            : null,
        hoursWorked: json["hours_worked"]?.toString(),
        wage: json["wage"]?.toString(),
        status: json["status"],
        date: json["date"],
        approvalStatus: json["approval_status"],
        approvedBy: json["approved_by"]?.toString(),
        approvedAt: json["approved_at"]?.toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "user_id": userId,
        "user_name": userName,
        "project_id": projectId,
        "project_name": projectName,
        "punch_in": punchIn?.toJson(),
        "punch_out": punchOut?.toJson(),
        "hours_worked": hoursWorked,
        "wage": wage,
        "status": status,
        "date": date,
        "approval_status": approvalStatus,
        "approved_by": approvedBy,
        "approved_at": approvedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class PunchTime {
  final String? datetime;
  final String? date;
  final String? time;
  final String? formatted;

  PunchTime({
    this.datetime,
    this.date,
    this.time,
    this.formatted,
  });

  factory PunchTime.fromJson(Map<String, dynamic> json) => PunchTime(
        datetime: json["datetime"],
        date: json["date"],
        time: json["time"],
        formatted: json["formatted"],
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime,
        "date": date,
        "time": time,
        "formatted": formatted,
      };
}
