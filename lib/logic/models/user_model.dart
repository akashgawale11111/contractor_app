import 'dart:convert';

class UserData {
  bool? status;
  int? statusCode;
  String? message;
  String? userType;
  Labour? labour;
  Supervisor? supervisor;

  UserData({
    this.status,
    this.statusCode,
    this.message,
    this.userType,
    this.labour,
    this.supervisor,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> payload = json;
    if (json['data'] is Map<String, dynamic>) {
      payload = json['data'];
    }
    if (payload['user'] is Map<String, dynamic>) {
      payload = payload['user'];
    }

    return UserData(
      status: payload['status'],
      statusCode: payload['status_code'] ?? payload['statusCode'],
      message: payload['message'],
      userType: payload['user_type'] ?? payload['userType'],
      labour:
          payload['labour'] != null ? Labour.fromJson(payload['labour']) : null,
      supervisor: payload['supervisor'] != null
          ? Supervisor.fromJson(payload['supervisor'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    data['user_type'] = userType;
    if (labour != null) data['labour'] = labour!.toJson();
    if (supervisor != null) data['supervisor'] = supervisor!.toJson();
    return data;
  }

  bool get isLabour => labour != null;
  bool get isSupervisor => supervisor != null;
}

class Labour {
  int? id;
  String? labourId;
  String? firstName;
  String? lastName;
  String? email;
  String? imageUrl; // added image URL

  Labour({
    this.id,
    this.labourId,
    this.firstName,
    this.lastName,
    this.email,
    this.imageUrl, // initialize image URL
  });

  factory Labour.fromJson(Map<String, dynamic> json) {
    return Labour(
      id: json['id'],
      labourId: json['labour_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      imageUrl: json['image_url'], // parse image URL
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'labour_id': labourId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'image_url': imageUrl, // include in JSON
      };
}

class Supervisor {
  int? id;
  String? supervisorName;
  String? loginId;
  String? photo;

  Supervisor({
    this.id,
    this.supervisorName,
    this.loginId,
    this.photo,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id: json['id'],
      supervisorName: json['supervisor_name'],
      loginId: json['login_id'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'supervisor_name': supervisorName,
        'login_id': loginId,
        'photo': photo,
      };
}
