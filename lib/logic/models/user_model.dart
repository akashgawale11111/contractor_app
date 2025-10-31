
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
    Map<String, dynamic> data = json;
    if (json['data'] is Map<String, dynamic>) {
      data = json['data'];
    }

    Labour? labour;
    Supervisor? supervisor;
    var userType = data['user_type'] ?? data['userType'];

    if (data['user'] is Map<String, dynamic>) {
      if (userType == 'labour') {
        labour = Labour.fromJson(data['user']);
      } else if (userType == 'supervisor') {
        supervisor = Supervisor.fromJson(data['user']);
      }
    } else if (data['labour'] is Map<String, dynamic>) {
      labour = Labour.fromJson(data['labour']);
    } else if (data['supervisor'] is Map<String, dynamic>) {
      supervisor = Supervisor.fromJson(data['supervisor']);
    }

    return UserData(
      status: data['status'],
      statusCode: data['status_code'] ?? data['statusCode'],
      message: data['message'],
      userType: userType,
      labour: labour,
      supervisor: supervisor,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    data['user_type'] = userType;
    if (labour != null) data['user'] = labour!.toJson();
    if (supervisor != null) data['user'] = supervisor!.toJson();
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
  String? fullName;
  String? email;
  String? phoneNumber;
  String? dailyWage;
  String? status;
  String? skillLevel;
  String? specialization;
  String? imageUrl;
  int? projectId;
  int? supervisorId;

  Labour({
    this.id,
    this.labourId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dailyWage,
    this.status,
    this.skillLevel,
    this.specialization,
    this.imageUrl,
    this.projectId,
    this.supervisorId,
  });

  factory Labour.fromJson(Map<String, dynamic> json) {
    return Labour(
      id: json['id'],
      labourId: json['labour_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      dailyWage: json['daily_wage'],
      status: json['status'],
      skillLevel: json['skill_level'],
      specialization: json['specialization'],
      imageUrl: json['image_url'],
      projectId: json['project_id'],
      supervisorId: json['supervisor_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'labour_id': labourId,
        'first_name': firstName,
        'last_name': lastName,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'daily_wage': dailyWage,
        'status': status,
        'skill_level': skillLevel,
        'specialization': specialization,
        'image_url': imageUrl,
        'project_id': projectId,
        'supervisor_id': supervisorId,
      };
}

class Supervisor {
  int? id;
  int? userId;
  String? supervisorName;
  String? loginId;
  String? photo;
  String? imageUrl;
  String? email;
  String? name;
  String? role;
  String? supervisorType;
  String? phone;
  String? address;
  String? status;

  Supervisor({
    this.id,
    this.userId,
    this.supervisorName,
    this.loginId,
    this.photo,
    this.imageUrl,
    this.email,
    this.name,
    this.role,
    this.supervisorType,
    this.phone,
    this.address,
    this.status,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id: json['id'],
      userId: json['user_id'],
      supervisorName: json['supervisor_name'],
      loginId: json['login_id'],
      photo: json['photo'],
      imageUrl: json['image_url'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      supervisorType: json['supervisor_type'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'supervisor_name': supervisorName,
        'login_id': loginId,
        'photo': photo,
        'image_url': imageUrl,
        'email': email,
        'name': name,
        'role': role,
        'supervisor_type': supervisorType,
        'phone': phone,
        'address': address,
        'status': status,
      };
}
