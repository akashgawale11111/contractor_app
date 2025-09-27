import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/logic/models/user_model.dart';
import 'package:contractor_app/ui_screens/home/nav_bar.dart/navbar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Example: provider that gives Labour data
// (Replace with your actual provider)
//final labourProvider = Provider<Labour?>((ref) => null);

// PROFILE SCREEN as ConsumerWidget
class Profile2 extends ConsumerWidget {
  const Profile2({super.key});

  Widget infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? "")),
        ],
      ),
    );
  }

   @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);

    return userDataAsync.when(
      data: (userModel) {
        final labour = userModel.labour;
        if (labour == null) {
          return const Scaffold(
            body: Center(child: Text('No user data available')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("User Profile")),
          bottomNavigationBar: const Navbar2(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (labour.imageUrl != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(labour.imageUrl!),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image loading error
                    },
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
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

}

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final userDataAsync = ref.watch(userDataProvider);

  //   return userDataAsync.when(
  //     data: (userModel) {
  //       final labour = userModel.labour;
  //       if (labour == null) {
  //         return const Scaffold(
  //           body: Center(child: Text('No user data available')),
  //         );
  //       }

  //       return Scaffold(
  //         appBar: AppBar(title: const Text("User Profile")),
  //         bottomNavigationBar: const Navbar2(),
  //         body: SingleChildScrollView(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             children: [
  //               if (labour.imageUrl != null)
  //                 CircleAvatar(
  //                   radius: 50,
  //                   backgroundImage: NetworkImage(labour.imageUrl!),
  //                   onBackgroundImageError: (exception, stackTrace) {
  //                     // Handle image loading error
  //                   },
  //                 ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 "${labour.firstName ?? ''} ${labour.lastName ?? ''}",
  //                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 20),
  //               infoRow("UID", labour.labourId),
  //               infoRow("Email", labour.email),
  //               infoRow("Phone", labour.phoneNumber),
  //               infoRow("Age", labour.age?.toString()),
  //               infoRow("Gender", labour.gender),
  //               infoRow("DOB", labour.dateOfBirth),
  //               infoRow("Address", labour.address),
  //               infoRow("City", labour.city),
  //               infoRow("State", labour.state),
  //               infoRow("Pincode", labour.pincode),
  //               infoRow("Aadhar", labour.aadharNumber),
  //               infoRow("PAN", labour.panCardNumber),
  //               infoRow("Govt Reg. No", labour.governmentRegistrationNumber),
  //               infoRow("Skill Level", labour.skillLevel),
  //               infoRow("Specialization", labour.specialization),
  //               infoRow("Daily Wage", labour.dailyWage),
  //               infoRow("Status", labour.status),
  //               infoRow("Created At", labour.createdAt),
  //               infoRow("Updated At", labour.updatedAt),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     loading: () => const Scaffold(
  //       body: Center(child: CircularProgressIndicator()),
  //     ),
  //     error: (error, stack) => Scaffold(
  //       body: Center(child: Text('Error: $error')),
  //     ),
  //   );
  // }


