// ======== MODELS ========
class UserModel {
  bool? status;
  int? statusCode;
  String? message;
  Labour? labour;

  UserModel({this.status, this.statusCode, this.message, this.labour});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    labour = json['labour'] != null ? Labour.fromJson(json['labour']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.labour != null) {
      data['labour'] = this.labour!.toJson();
    }
    return data;
  }
}

class Labour {
  int? id;
  String? labourId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? age;
  String? gender;
  String? dateOfBirth;
  String? address;
  String? city;
  String? state;
  String? pincode;
  String? photograph;
  String? aadharNumber;
  String? panCardNumber;
  String? governmentRegistrationNumber;
  String? skillLevel;
  String? specialization;
  String? dailyWage;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Labour({
    this.id,
    this.labourId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.age,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.photograph,
    this.aadharNumber,
    this.panCardNumber,
    this.governmentRegistrationNumber,
    this.skillLevel,
    this.specialization,
    this.dailyWage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  Labour.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    labourId = json['labour_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    age = json['age'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    photograph = json['photograph'];
    aadharNumber = json['aadhar_number'];
    panCardNumber = json['pan_card_number'];
    governmentRegistrationNumber = json['government_registration_number'];
    skillLevel = json['skill_level'];
    specialization = json['specialization'];
    dailyWage = json['daily_wage'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['labour_id'] = this.labourId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['photograph'] = this.photograph;
    data['aadhar_number'] = this.aadharNumber;
    data['pan_card_number'] = this.panCardNumber;
    data['government_registration_number'] = this.governmentRegistrationNumber;
    data['skill_level'] = this.skillLevel;
    data['specialization'] = this.specialization;
    data['daily_wage'] = this.dailyWage;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}






// class UserData {
//   bool? _status;
//   int? _statusCode;
//   String? _message;
//   String? _userType;
//   Labour? _labour;
//   Supervisor? _supervisor;

//   UserData({
//     bool? status,
//     int? statusCode,
//     String? message,
//     String? userType,
//     Labour? labour,
//     Supervisor? supervisor,
//   })  : _status = status,
//         _statusCode = statusCode,
//         _message = message,
//         _userType = userType,
//         _labour = labour,
//         _supervisor = supervisor;

//   // ✅ Factory constructor for parsing from JSON
//   UserData.fromJson(Map<String, dynamic> json) {
//     _status = json['status'];
//     _statusCode = json['status_code'];
//     _message = json['message'];
//     _userType = json['user_type'];

//     if (json['labour'] != null) {
//       _labour = Labour.fromJson(json['labour']);
//     } else if (json['supervisor'] != null) {
//       _supervisor = Supervisor.fromJson(json['supervisor']);
//     }
//   }

//   // ✅ Convert back to JSON
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['status'] = _status;
//     data['status_code'] = _statusCode;
//     data['message'] = _message;
//     data['user_type'] = _userType;
//     if (_labour != null) {
//       data['labour'] = _labour!.toJson();
//     }
//     if (_supervisor != null) {
//       data['supervisor'] = _supervisor!.toJson();
//     }
//     return data;
//   }

//   // ✅ Getters
//   bool? get status => _status;
//   int? get statusCode => _statusCode;
//   String? get message => _message;
//   String? get userType => _userType;
//   Labour? get labour => _labour;
//   Supervisor? get supervisor => _supervisor;

//   // ✅ Setters (optional)
//   set status(bool? value) => _status = value;
//   set statusCode(int? value) => _statusCode = value;
//   set message(String? value) => _message = value;
//   set userType(String? value) => _userType = value;
//   set labour(Labour? value) => _labour = value;
//   set supervisor(Supervisor? value) => _supervisor = value;
// }

// class Labour {
//   int? _id;
//   String? _labourId;
//   String? _firstName;
//   String? _lastName;
//   String? _email;
//   String? _phoneNumber;
//   int? _age;
//   String? _gender;
//   String? _dateOfBirth;
//   String? _address;
//   String? _city;
//   String? _state;
//   String? _pincode;
//   String? _photograph;
//   String? _aadharNumber;
//   String? _panCardNumber;
//   String? _governmentRegistrationNumber;
//   String? _emergencyContact;
//   String? _emergencyContactName;
//   String? _skillLevel;
//   String? _specialization;
//   String? _dailyWage;
//   String? _status;
//   int? _projectId;
//   int? _supervisorId;
//   int? _createdBy;
//   String? _updatedBy;
//   String? _createdAt;
//   String? _updatedAt;
//   String? _imageUrl;

//   Labour({
//     int? id,
//     String? labourId,
//     String? firstName,
//     String? lastName,
//     String? email,
//     String? phoneNumber,
//     int? age,
//     String? gender,
//     String? dateOfBirth,
//     String? address,
//     String? city,
//     String? state,
//     String? pincode,
//     String? photograph,
//     String? aadharNumber,
//     String? panCardNumber,
//     String? governmentRegistrationNumber,
//     String? emergencyContact,
//     String? emergencyContactName,
//     String? skillLevel,
//     String? specialization,
//     String? dailyWage,
//     String? status,
//     int? projectId,
//     int? supervisorId,
//     int? createdBy,
//     String? updatedBy,
//     String? createdAt,
//     String? updatedAt,
//     String? imageUrl,
//   })  : _id = id,
//         _labourId = labourId,
//         _firstName = firstName,
//         _lastName = lastName,
//         _email = email,
//         _phoneNumber = phoneNumber,
//         _age = age,
//         _gender = gender,
//         _dateOfBirth = dateOfBirth,
//         _address = address,
//         _city = city,
//         _state = state,
//         _pincode = pincode,
//         _photograph = photograph,
//         _aadharNumber = aadharNumber,
//         _panCardNumber = panCardNumber,
//         _governmentRegistrationNumber = governmentRegistrationNumber,
//         _emergencyContact = emergencyContact,
//         _emergencyContactName = emergencyContactName,
//         _skillLevel = skillLevel,
//         _specialization = specialization,
//         _dailyWage = dailyWage,
//         _status = status,
//         _projectId = projectId,
//         _supervisorId = supervisorId,
//         _createdBy = createdBy,
//         _updatedBy = updatedBy,
//         _createdAt = createdAt,
//         _updatedAt = updatedAt,
//         _imageUrl = imageUrl;

//   Labour.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _labourId = json['labour_id'];
//     _firstName = json['first_name'];
//     _lastName = json['last_name'];
//     _email = json['email'];
//     _phoneNumber = json['phone_number'];
//     _age = json['age'];
//     _gender = json['gender'];
//     _dateOfBirth = json['date_of_birth'];
//     _address = json['address'];
//     _city = json['city'];
//     _state = json['state'];
//     _pincode = json['pincode'];
//     _photograph = json['photograph'];
//     _aadharNumber = json['aadhar_number'];
//     _panCardNumber = json['pan_card_number'];
//     _governmentRegistrationNumber = json['government_registration_number'];
//     _emergencyContact = json['emergency_contact'];
//     _emergencyContactName = json['emergency_contact_name'];
//     _skillLevel = json['skill_level'];
//     _specialization = json['specialization'];
//     _dailyWage = json['daily_wage'];
//     _status = json['status'];
//     _projectId = json['project_id'];
//     _supervisorId = json['supervisor_id'];
//     _createdBy = json['created_by'];
//     _updatedBy = json['updated_by'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _imageUrl = json['image_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = _id;
//     data['labour_id'] = _labourId;
//     data['first_name'] = _firstName;
//     data['last_name'] = _lastName;
//     data['email'] = _email;
//     data['phone_number'] = _phoneNumber;
//     data['age'] = _age;
//     data['gender'] = _gender;
//     data['date_of_birth'] = _dateOfBirth;
//     data['address'] = _address;
//     data['city'] = _city;
//     data['state'] = _state;
//     data['pincode'] = _pincode;
//     data['photograph'] = _photograph;
//     data['aadhar_number'] = _aadharNumber;
//     data['pan_card_number'] = _panCardNumber;
//     data['government_registration_number'] = _governmentRegistrationNumber;
//     data['emergency_contact'] = _emergencyContact;
//     data['emergency_contact_name'] = _emergencyContactName;
//     data['skill_level'] = _skillLevel;
//     data['specialization'] = _specialization;
//     data['daily_wage'] = _dailyWage;
//     data['status'] = _status;
//     data['project_id'] = _projectId;
//     data['supervisor_id'] = _supervisorId;
//     data['created_by'] = _createdBy;
//     data['updated_by'] = _updatedBy;
//     data['created_at'] = _createdAt;
//     data['updated_at'] = _updatedAt;
//     data['image_url'] = _imageUrl;
//     return data;
//   }
// }

// class Supervisor {
//   int? _id;
//   String? _supervisorName;
//   String? _loginId;
//   String? _photo;
//   int? _userId;
//   String? _createdAt;
//   String? _updatedAt;

//   Supervisor({
//     int? id,
//     String? supervisorName,
//     String? loginId,
//     String? photo,
//     int? userId,
//     String? createdAt,
//     String? updatedAt,
//   })  : _id = id,
//         _supervisorName = supervisorName,
//         _loginId = loginId,
//         _photo = photo,
//         _userId = userId,
//         _createdAt = createdAt,
//         _updatedAt = updatedAt;

//   Supervisor.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _supervisorName = json['supervisor_name'];
//     _loginId = json['login_id'];
//     _photo = json['photo'];
//     _userId = json['user_id'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = _id;
//     data['supervisor_name'] = _supervisorName;
//     data['login_id'] = _loginId;
//     data['photo'] = _photo;
//     data['user_id'] = _userId;
//     data['created_at'] = _createdAt;
//     data['updated_at'] = _updatedAt;
//     return data;
//   }

//   // Getters
//   int? get id => _id;
//   String? get supervisorName => _supervisorName;
//   String? get loginId => _loginId;
//   String? get photo => _photo;
//   int? get userId => _userId;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
// }
