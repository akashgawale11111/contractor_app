import 'package:contractor_app/models/user_model.dart';
import 'package:flutter/material.dart';

// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  final Labour labour;

  const ProfileScreen({super.key, required this.labour});

  Widget infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (labour.imageUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(labour.imageUrl!),
              ),
            const SizedBox(height: 16),
            Text(
              "${labour.firstName ?? ''} ${labour.lastName ?? ''}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            infoRow("UID", labour.labourId),
            infoRow("Email", labour.email),
            infoRow("Phone", labour.phoneNumber),
            infoRow("Age", labour.age?.toString()),
            infoRow("Gender", labour.gender),
            infoRow("DOB", labour.dateOfBirth),
            infoRow("Address", labour.address),
            infoRow("City", labour.city),
            infoRow("State", labour.state),
            infoRow("Pincode", labour.pincode),
            infoRow("Aadhar", labour.aadharNumber),
            infoRow("PAN", labour.panCardNumber),
            infoRow("Govt Reg. No", labour.governmentRegistrationNumber),
            infoRow("Skill Level", labour.skillLevel),
            infoRow("Specialization", labour.specialization),
            infoRow("Daily Wage", labour.dailyWage),
            infoRow("Status", labour.status),
            infoRow("Created At", labour.createdAt),
            infoRow("Updated At", labour.updatedAt),
          ],
        ),
      ),
    );
  }
}