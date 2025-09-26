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

  Labour(
      {this.id,
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
      this.imageUrl});

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
}
